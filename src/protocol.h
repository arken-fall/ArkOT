// Copyright 2024 Black Tek Server Authors. All rights reserved.
// Use of this source code is governed by the GPL-2.0 License that can be found in the LICENSE file.
// Modern transport behavior referenced from opentibiabr/canary (GPL-2.0), transport_codec.cpp.

#ifndef FS_PROTOCOL_H
#define FS_PROTOCOL_H

#include <zlib.h>
#include "connection.h"
#include "xtea.h"
#include "networkopcodes.h"
#include "protocolprofile.h"

class Protocol : public std::enable_shared_from_this<Protocol>
{
	public:
		// todo: use reference for connections
		explicit Protocol(Connection_ptr connection) : connection(connection) {}
		virtual ~Protocol() = default;

		// non-copyable
		Protocol(const Protocol&) = delete;
		Protocol& operator=(const Protocol&) = delete;

		virtual void parsePacket(NetworkMessage&) {}

		virtual void onSendMessage(const OutputMessage_ptr& msg) const;
		void onRecvMessage(NetworkMessage& msg);
		virtual void onRecvFirstMessage(NetworkMessage& msg) = 0;
		virtual void onConnect() {}

		bool isConnectionExpired() const {
			return connection.expired();
		}

		Connection_ptr getConnection() const {
			return connection.lock();
		}

		uint32_t getIP() const;

		// Connection has to frame inbound reads (outer length header) and skip
		// the right amount of first-packet header before it can hand the
		// message over, so the framing generation is public.
		[[nodiscard]] bool usesModernFraming() const {
			return transportGeneration == BlackTek::Network::TransportGeneration::Modern;
		}

		//Use this function for autosend messages only
		OutputMessage_ptr getOutputBuffer(int32_t size);

		OutputMessage_ptr& getCurrentBuffer() {
			return outputBuffer;
		}
		// todo: use reference for message maybe?
		void send(OutputMessage_ptr msg) const {
			if (auto connection = getConnection()) {
				connection->send(std::move(msg));
			}
		}

	protected:
		void disconnect() const {
			if (auto connection = getConnection()) {
				connection->close();
			}
		}

		void enableXTEAEncryption() {
			encryptionEnabled = true;
		}

		void setXTEAKey(const xtea::key& key) {
			this->key = xtea::expand_key(key);
		}

		void disableChecksum() {
			checksumEnabled = false;
		}

		void setTransportGeneration(BlackTek::Network::TransportGeneration generation) {
			transportGeneration = generation;
		}

		void setChecksumMode(BlackTek::Network::ChecksumMode mode) {
			checksumMode = mode;
		}

		static bool RSA_decrypt(NetworkMessage& msg);

		void setRawMessages(bool value) {
			rawMessages = value;
		}

		virtual void release() {}

	private:
		friend class Connection;

		// Deflates msg in place (raw deflate, no zlib header) when it pays off.
		// Returns false to send uncompressed.
		static bool compress(OutputMessage& msg);

		OutputMessage_ptr outputBuffer;

		const ConnectionWeak_ptr connection;
		xtea::round_keys key;
		// Outbound sequence has to advance inside const onSendMessage; it is
		// transport bookkeeping, not protocol state.
		mutable uint32_t serverSequence = 0;
		uint32_t clientSequence = 0;
		BlackTek::Network::TransportGeneration transportGeneration = BlackTek::Network::TransportGeneration::Legacy;
		BlackTek::Network::ChecksumMode checksumMode = BlackTek::Network::ChecksumMode::Adler32;
		bool encryptionEnabled = false;
		bool checksumEnabled = true;
		bool rawMessages = false;
};

#endif
