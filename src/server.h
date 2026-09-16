// Copyright 2024 Black Tek Server Authors. All rights reserved.
// Use of this source code is governed by the GPL-2.0 License that can be found in the LICENSE file.

#ifndef FS_SERVER_H
#define FS_SERVER_H

#include "connection.h"
#include "signals.h"
#include "console.h"

#include <expected>
#include <memory>
#include <string>
#include <utility>
#include <gtl/phmap.hpp>

class Protocol;

class ServiceBase
{
	public:
		virtual bool is_single_socket() const = 0;
		virtual bool is_checksummed() const = 0;
		virtual uint8_t get_protocol_identifier() const = 0;
		virtual const char* get_protocol_name() const = 0;

		virtual Protocol_ptr make_protocol(const Connection_ptr& c) const = 0;
};

template <typename ProtocolType>
class Service final : public ServiceBase
{
	public:
		bool is_single_socket() const override {
			return ProtocolType::server_sends_first;
		}
		bool is_checksummed() const override {
			return ProtocolType::use_checksum;
		}
		uint8_t get_protocol_identifier() const override {
			return ProtocolType::protocol_identifier;
		}
		const char* get_protocol_name() const override {
			return ProtocolType::protocol_name();
		}

		Protocol_ptr make_protocol(const Connection_ptr& c) const override {
			return std::make_shared<ProtocolType>(c);
		}
};

class ServicePort : public std::enable_shared_from_this<ServicePort>
{
	public:
		// Either the port is accepting, or the reason it is not, so a caller can
		// say what went wrong instead of only that something did.
		using BindResult = std::expected<void, std::string>;

		// What open() should do with a bind it could not complete. A listener
		// that was accepting once and then failed is worth reopening on a timer;
		// a bind that never succeeded at all is a permanent, silent outage if it
		// is only retried, so that case is reported back to the caller instead.
		enum class BindFailure : uint8_t
		{
			Report,
			Retry
		};

		explicit ServicePort(boost::asio::io_context& io_context) : io_context(io_context) {}
		~ServicePort();

		// non-copyable
		ServicePort(const ServicePort&) = delete;
		ServicePort& operator=(const ServicePort&) = delete;

		static void openAcceptor(const std::weak_ptr<ServicePort>& weak_service, uint16_t port);
		[[nodiscard]] BindResult open(uint16_t port, BindFailure onFailure = BindFailure::Retry);
		void close() const;
		bool is_single_socket() const;
		std::string get_protocol_names() const;

		bool add_service(const Service_ptr& new_svc);
		Protocol_ptr make_protocol(bool checksummed, NetworkMessage& msg, const Connection_ptr& connection) const;

		void onStopServer();
		void onAccept(const Connection_ptr& connection, const boost::system::error_code& error);

	private:
		void accept();

		boost::asio::io_context& io_context;
		std::unique_ptr<boost::asio::ip::tcp::acceptor> acceptor;
		std::vector<Service_ptr> services;

		uint16_t serverPort = 0;
		bool pendingStart = false;
};

class ServiceManager
{
	public:
		ServiceManager() = default;
		~ServiceManager();

		// non-copyable
		ServiceManager(const ServiceManager&) = delete;
		ServiceManager& operator=(const ServiceManager&) = delete;

		// Either the service is listening, or the reason it is not. Discarding
		// this is how a dead listener used to hide behind an ONLINE banner.
		using AddResult = std::expected<void, std::string>;

		void run();
		void stop();

		// Drops every listener registered so far. A boot that refuses after some
		// ports already bound would otherwise still satisfy is_running(), and be
		// announced as ONLINE. Only valid before run(), while nothing is yet
		// executing io_context handlers; stop() is the counterpart once running.
		void AbandonListeners();

		template <typename ProtocolType>
		[[nodiscard]] AddResult add(uint16_t port);

		bool is_running() const {
			return acceptors.empty() == false;
		}

	private:
		void die();

		gtl::node_hash_map<uint16_t, ServicePort_ptr> acceptors;

		boost::asio::io_context io_context;
		Signals signals{io_context};
		boost::asio::steady_timer death_timer { io_context };
		bool running = false;
};

template <typename ProtocolType>
ServiceManager::AddResult ServiceManager::add(uint16_t port)
{
	if (port == 0)
	{
		auto reason = fmt::format("no port provided for service {:s}, service disabled", ProtocolType::protocol_name());
		BlackTek::Console::Net::Error("ServiceManager::add: {:s}.", reason);
		return std::unexpected(std::move(reason));
	}

	ServicePort_ptr servicePort;

	auto foundServicePort = acceptors.find(port);

	if (foundServicePort == acceptors.end())
	{
		servicePort = std::make_shared<ServicePort>(io_context);

		// A startup bind is not retried: the listener would stay dead for the
		// whole run, so the reason travels back to the caller and the port is
		// never registered, keeping is_running() honest about what is accepting.
		if (auto bound = servicePort->open(port, ServicePort::BindFailure::Report); not bound)
		{
			return std::unexpected(std::move(bound.error()));
		}

		acceptors[port] = servicePort;
	}
	else
	{
		servicePort = foundServicePort->second;

		if (servicePort->is_single_socket() or ProtocolType::server_sends_first)
		{
			auto reason = fmt::format("{:s} and {:s} cannot use the same port {:d}", ProtocolType::protocol_name(), servicePort->get_protocol_names(), port);
			BlackTek::Console::Net::Error("ServiceManager::add: {:s}.", reason);
			return std::unexpected(std::move(reason));
		}
	}

	if (not servicePort->add_service(std::make_shared<Service<ProtocolType>>()))
	{
		auto reason = fmt::format("{:s} cannot share port {:d} with {:s}", ProtocolType::protocol_name(), port, servicePort->get_protocol_names());
		BlackTek::Console::Net::Error("ServiceManager::add: {:s}.", reason);
		return std::unexpected(std::move(reason));
	}

	return {};
}

#endif
