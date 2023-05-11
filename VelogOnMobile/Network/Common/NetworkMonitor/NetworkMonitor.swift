//
//  NetworkMonitor.swift
//  VelogOnMobile
//
//  Created by 홍준혁 on 2023/04/29.
//

import Foundation

import Network

final class NetworkMonitor {
    
    private let queue = DispatchQueue.global(qos: .background)
    private let monitor: NWPathMonitor
    
    init() {
        monitor = NWPathMonitor()
        dump(monitor)
        print("------------")
    }
    
    func startMonitoring(statusUpdateHandler: @escaping (NWPath.Status) -> Void) {
        monitor.pathUpdateHandler = { path in
            statusUpdateHandler(path.status)
        }
        monitor.start(queue: queue)
    }
    
    func stopMonitoring() {
        monitor.cancel()
    }
}
