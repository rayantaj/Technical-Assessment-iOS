//
//  WebSocketManager.swift
//  Technical-Assessment
//
//  Created by Rayan Taj on 16/12/2024.
//

import Foundation

protocol WebSocketManagerDelegate: AnyObject {
    func webSocketDidConnect()
    func webSocketDidDisConnect()
    func webSocketDidReceiveMessage(_ message: String)
    func webSocketDidReceiveError(_ errorMessage: String)
}


class WebSocketManager {
    private var webSocketTask: URLSessionWebSocketTask?
    private let urlSession = URLSession(configuration: .default)
    private let webSocketURL: URL
    var connected: Bool = false
    
    weak var delegate: WebSocketManagerDelegate? // Add delegate property

    init(url: URL) {
        self.webSocketURL = url
    }

    func connect() {
        webSocketTask = urlSession.webSocketTask(with: webSocketURL)
        webSocketTask?.resume()
        self.connected = true
        delegate?.webSocketDidConnect()
        listenForMessages()
    }

    func disconnect() {
        webSocketTask?.cancel(with: .goingAway, reason: nil)
        self.connected = false
        delegate?.webSocketDidDisConnect()
    }

    func send(message: String) {
        let message = URLSessionWebSocketTask.Message.string(message)
        webSocketTask?.send(message) { error in
            if let error = error {
                self.delegate?.webSocketDidReceiveError(error.localizedDescription)// Notify delegates
            } else {
                print("Message sent successfully!")
            }
        }
    }

    private func listenForMessages() {
        webSocketTask?.receive { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let message):
                switch message {
                case .string(let text):
                    print("Received string: \(text)")
                    self.delegate?.webSocketDidReceiveMessage(text)// Notify delegate
                case .data(let data):
                    print("Received data: \(data)")
                @unknown default:
                    print("Unknown message type received.")
                }
                self.listenForMessages() // Continue listening
            case .failure(let error):
                self.delegate?.webSocketDidReceiveError(error.localizedDescription)// Notify delegate

            }
        }
    }
}

