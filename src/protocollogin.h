// Copyright 2024 Black Tek Server Authors. All rights reserved.
// Use of this source code is governed by the GPL-2.0 License that can be found in the LICENSE file.

#ifndef FS_PROTOCOLLOGIN_H
#define FS_PROTOCOLLOGIN_H

#include "protocol.h"
#include "protocolprofile.h"

class NetworkMessage;
class OutputMessage;

class ProtocolLogin : public Protocol
{
	public:
		// static protocol information
		enum {server_sends_first = false};
		enum {protocol_identifier = 0x01};
		enum {use_checksum = true};
		static const char* protocol_name() {
			return "login protocol";
		}
		// todo: use reference on connection
		explicit ProtocolLogin(Connection_ptr connection) : Protocol(connection) {}

		void onRecvFirstMessage(NetworkMessage& msg) override;

	private:
		void disconnectClient(const std::string& message, uint16_t version);

		void getCharacterList(const std::string& accountName, const std::string& password, const std::string& token, uint16_t version);
};

// Same login protocol, listening on the port a 15.25 client hardcodes. The
// client opens with a plaintext world-name line and then frames everything the
// modern way, so the generation is fixed by the port rather than sniffed.
class ProtocolLoginModern final : public ProtocolLogin
{
	public:
		// static protocol information
		// server_sends_first is what makes ServicePort::onAccept take the
		// connection->accept(make_protocol(...)) branch, so Connection is already
		// holding this protocol when the very first byte arrives - which is the
		// only way requiresWorldLine() can be honoured at all. Nothing is actually
		// written first: ProtocolLogin does not override Protocol::onConnect, so
		// the posted onConnect() is a no-op. The flag means "the port decides which
		// protocol this is", exactly as ProtocolGameModern already uses it.
		enum {server_sends_first = true};
		// Inherited from ProtocolLogin and never consulted: a single-socket port
		// has one service, so ServicePort::make_protocol - the only reader of this
		// value - never runs. The client's 0x01 byte is consumed by the framing
		// layer instead, landing the cursor on the OS u16 that
		// ProtocolLogin::onRecvFirstMessage reads first.
		enum {protocol_identifier = 0x01};
		enum {use_checksum = true};
		static const char* protocol_name() {
			return "modern login protocol";
		}

		explicit ProtocolLoginModern(Connection_ptr connection) : ProtocolLogin(std::move(connection)) {
			setTransportGeneration(BlackTek::Network::TransportGeneration::Modern);
			setWorldLineRequired(true);
		}
};

#endif
