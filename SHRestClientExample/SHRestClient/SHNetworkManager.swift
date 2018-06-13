//
//  SHNetworkManager.swift
//  SHRestClientExample
//
//  Created by Subhajit Halder on 11/06/18.
//  Copyright © 2018 SubhajitHalder. All rights reserved.
//

import UIKit
import Reachability

final class SHNetworkManager: NSObject {
    
    private static let reachability = Reachability()!
    
    private static var noConnectionVC: UIViewController = NoConnectionVC()
    
    private static var connection: Reachability.Connection = .none
    
    static var isNetworkAvailable : Bool {
        return connection != .none
    }
    
    class func startMonitoring() {
        NotificationCenter.default.addObserver(SHNetworkManager.self, selector: #selector(SHNetworkManager.networkStatusChanged(_:)), name: .reachabilityChanged, object: SHNetworkManager.reachability)
        
        do {
            try SHNetworkManager.reachability.startNotifier()
        } catch {
            print("Error while starting reachability notifier : \(error)")
        }
    }
    
    class func presentViewControllerOnNoNetwork(_ viewController: UIViewController) {
        SHNetworkManager.noConnectionVC = viewController
    }
    
    class func networkStatusChanged(_ notification: Notification) {
        guard let reachability = notification.object as? Reachability else {
            print("Notification object is not of type Reachability")
            return
        }
        SHNetworkManager.connection = reachability.connection
        switch reachability.connection {
        case .none:
        // TODO: Present not reachable VC
            print("Network Unreachable")
            AppDelegate.topViewController?.present(SHNetworkManager.noConnectionVC, animated: true, completion: nil)
        case .cellular, .wifi:
            AppDelegate.topViewController?.dismiss(animated: true, completion: nil)
            print("Network Reachable")
       
        }
        
    }
    
    class func stopMonitoring() {
        SHNetworkManager.reachability.stopNotifier()
        NotificationCenter.default.removeObserver(SHNetworkManager.self, name: .reachabilityChanged, object: SHNetworkManager.reachability)
    }
    
}
