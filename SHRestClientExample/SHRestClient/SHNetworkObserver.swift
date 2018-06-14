//
//  SHNetworkManager.swift
//  SHRestClientExample
//
//  Created by Subhajit Halder on 11/06/18.
//  Copyright © 2018 SubhajitHalder. All rights reserved.
//

import UIKit
import Reachability

final class SHNetworkObserver: NSObject {
    
    private static let reachability = Reachability()!
    
    private static var noConnectionVC: UIViewController = NoConnectionVC()
    
    private static var connection: Reachability.Connection = .none
    
    static var isNetworkAvailable : Bool {
        return connection != .none
    }
    
    //TODO: Implement Delegates
    
//    static var whenReachable: Reachability.NetworkReachable? {
//        set {
//            SHNetworkObserver.reachability.whenReachable = newValue
//        }
//        get {
//            return SHNetworkObserver.reachability.whenReachable
//        }
//    }
//
//    static var whenUnReachable: Reachability.NetworkUnreachable? {
//        set {
//            SHNetworkObserver.reachability.whenUnreachable = newValue
//        }
//        get {
//            return SHNetworkObserver.reachability.whenUnreachable
//        }
//    }
    
    class func startMonitoring() {
        
        NotificationCenter.default.addObserver(SHNetworkObserver.self, selector: #selector(SHNetworkObserver.networkStatusChanged(_:)), name: .reachabilityChanged, object: SHNetworkObserver.reachability)
        
        do {
            try SHNetworkObserver.reachability.startNotifier()
        } catch {
            print("Error while starting reachability notifier : \(error)")
        }
    }
    
    class func presentViewControllerOnNoNetwork(_ viewController: UIViewController) {
        SHNetworkObserver.noConnectionVC = viewController
    }
    
    class func networkStatusChanged(_ notification: Notification) {
        guard let reachability = notification.object as? Reachability else {
            print("Notification object is not of type Reachability")
            return
        }
        SHNetworkObserver.connection = reachability.connection
        switch reachability.connection {
        case .none:
        
            print("Network Unreachable")
            let appDel = UIApplication.shared.delegate
            appDel?.window??.rootViewController?.present(SHNetworkObserver.noConnectionVC, animated: true, completion: nil)
//            AppDelegate.topViewController?.present(SHNetworkObserver.noConnectionVC, animated: true, completion: nil)
        case .cellular, .wifi:
            if AppDelegate.topViewController == SHNetworkObserver.noConnectionVC {
                AppDelegate.topViewController?.dismiss(animated: true, completion: nil)
            }
            print("Network Reachable")
       
        }
        
    }
    
    class func stopMonitoring() {
        SHNetworkObserver.reachability.stopNotifier()
        NotificationCenter.default.removeObserver(SHNetworkObserver.self, name: .reachabilityChanged, object: SHNetworkObserver.reachability)
    }
    
}
