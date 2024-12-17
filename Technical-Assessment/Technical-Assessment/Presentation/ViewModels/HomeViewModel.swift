//
//  HomeViewModel.swift
//  Technical-Assessment
//
//  Created by Rayan Taj on 15/12/2024.
//

import Foundation

// MARK: - Link ViewModel with ViewController
protocol HomeViewModelDelegate: AnyObject {
    func connectedSuccessfully()
    func disconnected()
    func showRecivedMessage(_ message: String)
}

class HomeViewModel {
    
    // MARK: - Properties
    private var webSocketManager: WebSocketManager?
    weak var delegate: HomeViewModelDelegate?
    
    var username: String
    
    init(username: String) {
        self.username = username
        
        guard let url = URL(string: "wss://echo.websocket.org/") else { return }
        
        webSocketManager = WebSocketManager(url: url)
        webSocketManager?.delegate = self
    }
  
}

// MARK: - Socket actions
extension HomeViewModel {
    
    // connect/dissconnect based on current connection
    func triggerWebSocket() {
        if webSocketManager?.connected ?? false {
            webSocketManager?.disconnect()
        } else {
            webSocketManager?.connect()
        }
    }
    
    func disConnectSocket() {
        webSocketManager?.disconnect()
    }
    
    func sendMassage(message: String) {
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            self.webSocketManager?.send(message: message)
        }
    }
    
}

// MARK: - Socket delegate
extension HomeViewModel: WebSocketManagerDelegate {
    func webSocketDidReceiveError(_ errorMessage: String) {
        DispatchQueue.main.async {
            self.delegate?.showRecivedMessage(errorMessage)
        }
    }
    
    func webSocketDidConnect() {
        delegate?.connectedSuccessfully()
    }
    
    func webSocketDidDisConnect() {
        delegate?.disconnected()
    }
    
    func webSocketDidReceiveMessage(_ message: String) {
        DispatchQueue.main.async {
            self.delegate?.showRecivedMessage(message)
        }
    }
    
}
