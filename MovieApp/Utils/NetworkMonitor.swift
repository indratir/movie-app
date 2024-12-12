//
//  NetworkMonitor.swift
//  MovieApp
//
//  Created by Indra Tirta Nugraha on 12/12/24.
//

import Foundation
import Network
import Combine

protocol NetworkMonitor {
    func isConnected() -> AnyPublisher<Bool, Never>
}

final class NetworkMonitorImpl: NetworkMonitor {
    private let networkMonitor: NWPathMonitor
    private let queue: DispatchQueue = .init(label: "network-monitor")
    
    init(networkMonitor: NWPathMonitor = .init()) {
        self.networkMonitor = networkMonitor
    }
    
    func isConnected() -> AnyPublisher<Bool, Never> {
        Deferred {
            Future { [weak self] promise in
                guard let self else {
                    promise(.success(false))
                    return
                }
                self.networkMonitor.pathUpdateHandler = { path in
                    promise(.success(path.status == .satisfied))
                }
                self.networkMonitor.start(queue: self.queue)
            }
            .eraseToAnyPublisher()
        }
        .eraseToAnyPublisher()
    }
}


