import Foundation

/// A delegate protocol for receiving WebSocket events.
protocol WebSocketClientDelegate: AnyObject, Sendable {
    @MainActor func webSocketDidConnect()
    @MainActor func webSocketDidDisconnect(error: Error?)
    @MainActor func webSocketDidReceiveMessage(_ message: Message)
    @MainActor func webSocketDidReceiveTypingIndicator(userID: String, conversationID: String, isTyping: Bool)
}

/// A WebSocket client for real-time chat messaging.
actor WebSocketClient {
    static let shared = WebSocketClient()

    private var webSocket: URLSessionWebSocketTask?
    private var session: URLSession?
    private var isConnected = false
    private var reconnectAttempts = 0
    private let maxReconnectAttempts = 5

    weak var delegate: WebSocketClientDelegate?

    private init() {}

    // MARK: - Connection

    func connect() async {
        guard !isConnected else { return }

        let token = await AuthManager.shared.accessToken
        guard let token else { return }

        var request = URLRequest(url: URL(string: Constants.API.websocketURL)!)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        session = URLSession(configuration: .default)
        webSocket = session?.webSocketTask(with: request)
        webSocket?.resume()

        isConnected = true
        reconnectAttempts = 0

        await delegate?.webSocketDidConnect()
        await receiveMessages()
    }

    func disconnect() {
        webSocket?.cancel(with: .goingAway, reason: nil)
        webSocket = nil
        isConnected = false
        session?.invalidateAndCancel()
        session = nil
    }

    // MARK: - Sending

    func sendMessage(_ content: String, conversationID: String) async throws {
        let payload: [String: String] = [
            "type": "message",
            "content": content,
            "conversationId": conversationID
        ]

        let data = try JSONSerialization.data(withJSONObject: payload)
        guard let jsonString = String(data: data, encoding: .utf8) else {
            throw APIError.encodingFailed(NSError(domain: "WebSocket", code: -1))
        }

        try await webSocket?.send(.string(jsonString))
    }

    func sendTypingIndicator(conversationID: String, isTyping: Bool) async throws {
        let payload: [String: Any] = [
            "type": "typing",
            "conversationId": conversationID,
            "isTyping": isTyping
        ]

        let data = try JSONSerialization.data(withJSONObject: payload)
        guard let jsonString = String(data: data, encoding: .utf8) else { return }

        try await webSocket?.send(.string(jsonString))
    }

    // MARK: - Receiving

    private func receiveMessages() async {
        guard let webSocket else { return }

        do {
            let result = try await webSocket.receive()
            switch result {
            case .string(let text):
                await handleTextMessage(text)
            case .data(let data):
                if let text = String(data: data, encoding: .utf8) {
                    await handleTextMessage(text)
                }
            @unknown default:
                break
            }

            // Continue receiving
            if isConnected {
                await receiveMessages()
            }
        } catch {
            isConnected = false
            await delegate?.webSocketDidDisconnect(error: error)
            await attemptReconnect()
        }
    }

    private func handleTextMessage(_ text: String) async {
        guard let data = text.data(using: .utf8),
              let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let type = json["type"] as? String else { return }

        switch type {
        case "message":
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            decoder.keyDecodingStrategy = .convertFromSnakeCase
            if let messageData = try? JSONSerialization.data(withJSONObject: json["data"] ?? json),
               let message = try? decoder.decode(Message.self, from: messageData) {
                await delegate?.webSocketDidReceiveMessage(message)
            }
        case "typing":
            if let userID = json["userId"] as? String,
               let conversationID = json["conversationId"] as? String,
               let isTyping = json["isTyping"] as? Bool {
                await delegate?.webSocketDidReceiveTypingIndicator(
                    userID: userID,
                    conversationID: conversationID,
                    isTyping: isTyping
                )
            }
        default:
            break
        }
    }

    // MARK: - Reconnection

    private func attemptReconnect() async {
        guard reconnectAttempts < maxReconnectAttempts else { return }
        reconnectAttempts += 1

        let delay = pow(2.0, Double(reconnectAttempts))
        try? await Task.sleep(for: .seconds(delay))

        await connect()
    }
}
