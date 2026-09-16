// Copyright 2024 Black Tek Server Authors. All rights reserved.
// Use of this source code is governed by the GPL-2.0 License that can be found in the LICENSE file.

#include "otpch.h"

#include "outputmessage.h"
#include "server.h"
#include "scheduler.h"
#include "configmanager.h"
#include "ban.h"
#include "console.h"

extern ConfigManager g_config;
Ban g_bans;

ServiceManager::~ServiceManager()
{
	stop();
}

void ServiceManager::die()
{
	io_context.stop();
}

void ServiceManager::run()
{
	assert(!running);
	running = true;
	io_context.run();
}

void ServiceManager::stop()
{
	if (!running) {
		return;
	}

	running = false;

	for (auto& servicePortIt : acceptors) {
		try {
			boost::asio::post(io_context, [servicePort = servicePortIt.second]() { servicePort->onStopServer(); });
		} catch (boost::system::system_error& e) {
			std::cout << "[ServiceManager::stop] Network Error: " << e.what() << std::endl;
		}
	}

	acceptors.clear();

	death_timer.expires_after(std::chrono::seconds(3));
	death_timer.async_wait([this](const boost::system::error_code&) { die(); });
}

void ServiceManager::AbandonListeners()
{
	// stop() has to post this work because the io_context is running by then.
	// Here the boot is still on the loader thread and run() has not been called,
	// so no handler can be executing and the acceptors can be closed directly.
	for (auto& servicePortIt : acceptors)
	{
		servicePortIt.second->onStopServer();
	}

	acceptors.clear();

	// Every listener that did bind left an accepting Connection parked in the
	// ConnectionManager singleton, built from this object's io_context. That
	// singleton is a function-local static, so it outlives main and would run
	// ~Connection() - and the socket/timer members' own destructors - against a
	// destroyed io_context. Release them here, while it is still alive, the same
	// way Game::shutdown() pairs stop() with closeAll().
	//
	// closeAll() is the right tool precisely because it shuts each socket down
	// directly instead of going through Connection::close(), which dispatches
	// onto the connection's strand: with run() never called, that work would
	// never execute and the objects would survive anyway.
	ConnectionManager::getInstance().closeAll();
}

ServicePort::~ServicePort()
{
	close();
}

bool ServicePort::is_single_socket() const
{
	return !services.empty() && services.front()->is_single_socket();
}

std::string ServicePort::get_protocol_names() const
{
	if (services.empty()) {
		return std::string();
	}

	std::string str = services.front()->get_protocol_name();
	for (size_t i = 1; i < services.size(); ++i) {
		str.push_back(',');
		str.push_back(' ');
		str.append(services[i]->get_protocol_name());
	}
	return str;
}

void ServicePort::accept()
{
	if (!acceptor) {
		return;
	}

	auto connection = ConnectionManager::getInstance().createConnection(io_context, shared_from_this());
	acceptor->async_accept(connection->getSocket(), [=, thisPtr = shared_from_this()](const boost::system::error_code& error) { thisPtr->onAccept(connection, error); });
}

void ServicePort::onAccept(const Connection_ptr& connection, const boost::system::error_code& error)
{
	if (!error) {
		if (services.empty()) {
			return;
		}

		boost::system::error_code noDelayError;
		connection->getSocket().set_option(boost::asio::ip::tcp::no_delay(true), noDelayError);

		auto remote_ip = connection->getIP();
		if (remote_ip != 0 && g_bans.acceptConnection(remote_ip)) {
			Service_ptr service = services.front();
			if (service->is_single_socket()) {
				connection->accept(service->make_protocol(connection));
			} else {
				connection->accept();
			}
		} else {
			connection->close(Connection::FORCE_CLOSE);
		}

		accept();
	} else if (error != boost::asio::error::operation_aborted) {
		if (!pendingStart) {
			close();
			pendingStart = true;
			g_scheduler.addEvent(createSchedulerTask(15000, [=, thisPtr = std::weak_ptr<ServicePort>(shared_from_this())]() { ServicePort::openAcceptor(thisPtr, serverPort); }));
		}
	}
}

Protocol_ptr ServicePort::make_protocol(bool checksummed, NetworkMessage& msg, const Connection_ptr& connection) const
{
	uint8_t protocolID = msg.getByte();
	for (auto& service : services) {
		if (protocolID != service->get_protocol_identifier()) {
			continue;
		}

		if ((checksummed && service->is_checksummed()) || !service->is_checksummed()) {
			return service->make_protocol(connection);
		}
	}
	return nullptr;
}

void ServicePort::onStopServer()
{
	close();
}

void ServicePort::openAcceptor(const std::weak_ptr<ServicePort>& weak_service, uint16_t port)
{
	if (auto service = weak_service.lock())
	{
		// This is the recovery path for a listener that was already accepting,
		// so open() logs the reason and reschedules itself; there is nothing
		// left here for a caller to act on.
		static_cast<void>(service->open(port, BindFailure::Retry));
	}
}

ServicePort::BindResult ServicePort::open(uint16_t port, BindFailure onFailure)
{
	close();

	serverPort = port;
	pendingStart = false;

	const bool useIPv6 = g_config.GetBoolean(ConfigManager::ENABLE_IPV6);
	const bool bindGlobal = g_config.GetBoolean(ConfigManager::BIND_ONLY_GLOBAL_ADDRESS);

	auto bindIPv4 = [&]()
	{
		if (bindGlobal)
		{
			acceptor.reset(new boost::asio::ip::tcp::acceptor(io_context, boost::asio::ip::tcp::endpoint(
			            boost::asio::ip::make_address(g_config.GetString(ConfigManager::IP)), serverPort)));
		}
		else
		{
			acceptor.reset(new boost::asio::ip::tcp::acceptor(io_context, boost::asio::ip::tcp::endpoint(
			            boost::asio::ip::address_v4::any(), serverPort)));
		}
	};

	try
	{
		if (useIPv6)
		{
			if (bindGlobal)
			{
				acceptor.reset(new boost::asio::ip::tcp::acceptor(io_context, boost::asio::ip::tcp::endpoint(
				            boost::asio::ip::make_address(g_config.GetString(ConfigManager::IPV6)), serverPort)));
			}
			else
			{
				acceptor.reset(new boost::asio::ip::tcp::acceptor(io_context, boost::asio::ip::tcp::endpoint(
				            boost::asio::ip::address_v6::any(), serverPort)));
				acceptor->set_option(boost::asio::ip::v6_only(false));
			}
		}
		else
		{
			bindIPv4();
		}

		acceptor->set_option(boost::asio::ip::tcp::no_delay(true));
		accept();
		return {};
	}
	catch (boost::system::system_error& e)
	{
		// set_option can throw after the bind itself succeeded, which leaves this
		// object still holding the port; an IPv4 fallback onto a port we have not
		// released would then fail against ourselves. Release it before retrying.
		acceptor.reset();

		std::string reason = fmt::format("{:d}: {:s}", e.code().value(), e.what());

		if (useIPv6 and g_config.GetBoolean(ConfigManager::IPV6_FALLBACK_TO_IPV4))
		{
			BlackTek::Console::Net::Warn("[ServicePort::open] IPv6 unavailable falling back to IPv4. Error Code {}: {}", e.code().value(), e.what());
			try
			{
				bindIPv4();
				acceptor->set_option(boost::asio::ip::tcp::no_delay(true));
				accept();
				return {};
			}
			catch (boost::system::system_error& e2)
			{
				acceptor.reset();
				reason = fmt::format("{:d}: {:s}", e2.code().value(), e2.what());
				BlackTek::Console::Net::Error("[ServicePort::open] Error: {}: {}", e2.code().value(), e2.what());
			}
		}
		else
		{
			BlackTek::Console::Net::Error("[ServicePort::open] Error: {}: {}", e.code().value(), e.what());
		}

		// Only a port that was accepting at some point earns the 15s reopen
		// cycle. A bind that never came up is handed back instead, so the boot
		// can refuse rather than loop forever behind an ONLINE banner.
		if (onFailure == BindFailure::Retry)
		{
			pendingStart = true;
			g_scheduler.addEvent(createSchedulerTask(15000, [=, thisPtr = std::weak_ptr<ServicePort>(shared_from_this())]() { ServicePort::openAcceptor(thisPtr, serverPort); }));
		}

		return std::unexpected(std::move(reason));
	}
}

void ServicePort::close() const
{
	if (acceptor && acceptor->is_open()) {
		boost::system::error_code error;
		acceptor->close(error);
	}
}

bool ServicePort::add_service(const Service_ptr& new_svc)
{
	if (std::any_of(services.begin(), services.end(), [](const Service_ptr& svc) {return svc->is_single_socket();})) {
		return false;
	}

	services.push_back(new_svc);
	return true;
}
