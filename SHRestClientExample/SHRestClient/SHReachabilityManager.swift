//
//  SHReachabilityManager.swift
//  SHRestClientExample
//
//  Created by subhajit halder on 24/07/17.
//  Copyright © 2017 SubhajitHalder. All rights reserved.
//

import UIKit
import ReachabilitySwift

public protocol SHReachabilityDelegate: class {
    func networkStatusDidChange(status: Reachability.NetworkStatus)
}

class SHReachabilityManager: NSObject {

    static let shared = SHReachabilityManager()    
    
    
    
    var reachabilityStatus : Reachability.NetworkStatus = .notReachable
    
    let reachability = Reachability()!
    
    var listeners = [SHReachabilityDelegate]()
    
    var isNetworkAvailable: Bool {

        return reachabilityStatus != .notReachable
    
    }
    
    func addListner(listener: SHReachabilityDelegate) {
        listeners.append(listener)
    }
    
    func removeListener(listener: SHReachabilityDelegate) {
        listeners = listeners.filter{$0 !== listener}
    }
    
    
    
    func reachabilityChanged(notification: Notification) {
        
        let reachability = notification.object as! Reachability
        
        switch reachability.currentReachabilityStatus {
        case .notReachable: break
        //
        case .reachableViaWiFi: break
        case .reachableViaWWAN: break
        }
        
        self.reachabilityStatus = reachability.currentReachabilityStatus
        
        for listener in listeners {
            listener.networkStatusDidChange(status: reachability.currentReachabilityStatus)
        }
    }
    
    func startMonitoring() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged), name: ReachabilityChangedNotification, object: reachability)
        
        do {
            
            try reachability.startNotifier()
            
        } catch {
            
            debugPrint("Could not start reachability notifier")
            
        }
    }
    
    func stopMonitoring() {
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: ReachabilityChangedNotification, object: reachability)
    }

}
