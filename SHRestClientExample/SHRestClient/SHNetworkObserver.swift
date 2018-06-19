//
//  SHNetworkManager.swift
//  SHRestClientExample
//
//  Created by Subhajit Halder on 11/06/18.

//

import UIKit
import Reachability

@objc public protocol SHNetworkObserverDelegate : class {
    func networkStatus( isReachable: Bool)
}

@objc final public class SHNetworkObserver: NSObject {
    
    private static let reachability = Reachability()!
    
    private static var noConnectionVC: UIViewController = NoConnectionVC()
    
    private static var connection: Reachability.Connection = .none
    
    private static weak var delegate: SHNetworkObserverDelegate?
    
    static var isNetworkAvailable : Bool {
        return connection != .none
    }
    
    class func addDelegate(delegate: SHNetworkObserverDelegate) {
        SHNetworkObserver.delegate = delegate
    }
    
    class func removeDelegate(delegate: SHNetworkObserverDelegate) {
        SHNetworkObserver.delegate  = nil
    }
    
    class func recheckConnection() {
        if SHNetworkObserver.delegate != nil {
            SHNetworkObserver.delegate?.networkStatus(isReachable: SHNetworkObserver.isNetworkAvailable)
        }
    }
    
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
    
    @objc class func networkStatusChanged(_ notification: Notification) {
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
            
        case .cellular, .wifi:
            if AppDelegate.topViewController == SHNetworkObserver.noConnectionVC {
                AppDelegate.topViewController?.dismiss(animated: true, completion: nil)
            }
            print("Network Reachable")
       
        }
        
        if SHNetworkObserver.delegate != nil {
            SHNetworkObserver.delegate?.networkStatus(isReachable: reachability.connection != .none)
        }
        
    }
    
    class func stopMonitoring() {
        SHNetworkObserver.reachability.stopNotifier()
        NotificationCenter.default.removeObserver(SHNetworkObserver.self, name: .reachabilityChanged, object: SHNetworkObserver.reachability)
    }
    
}
