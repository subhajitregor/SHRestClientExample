//
//  SHNetworkManager.swift
//  SHRestClientExample
//
//  Created by Subhajit Halder on 11/06/18.

//

import UIKit

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
    
    class func monitor() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(appIsDeactivating(_:)), name: Notification.Name.UIApplicationWillResignActive, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(appIsActive(_:)), name: Notification.Name.UIApplicationWillEnterForeground, object: nil)
        self.startMonitoring()
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(SHNetworkObserver.networkStatusChanged(_:)), name: .reachabilityChanged, object: SHNetworkObserver.reachability)
        
        do {
            try SHNetworkObserver.reachability.startNotifier()
        } catch {
            print("Error while starting reachability notifier : \(error)")
        }
    }
    
    
    class func stopMonitoring() {
        SHNetworkObserver.reachability.stopNotifier()
        NotificationCenter.default.removeObserver(SHNetworkObserver.self, name: .reachabilityChanged, object: SHNetworkObserver.reachability)
        
    }
    
    class func presentViewControllerOnNoNetwork(_ viewController: UIViewController) {
        SHNetworkObserver.noConnectionVC = viewController
    }
    
    // MARK: Listeners
    
    @objc class func appIsDeactivating(_ notification: Notification) {
        SHNetworkObserver.stopMonitoring()
    }
    
    @objc class func appIsActive(_ notification: Notification) {
        SHNetworkObserver.startMonitoring()
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
            if let rootController = UIApplication.shared.keyWindow?.rootViewController {
                rootController.present(SHNetworkObserver.noConnectionVC, animated: true, completion: nil)
            }
            
            
        case .cellular, .wifi:
            if var topController = UIApplication.shared.keyWindow?.rootViewController {
                while let presentedViewController = topController.presentedViewController {
                    topController = presentedViewController
                }
                
                if topController == SHNetworkObserver.noConnectionVC {
                    topController.dismiss(animated: true, completion: nil)
                }
                // topController should now be your topmost view controller
            }
           
            print("Network Reachable")
       
        }
        
        if SHNetworkObserver.delegate != nil {
            SHNetworkObserver.delegate?.networkStatus(isReachable: reachability.connection != .none)
        }
        
    }
    
}
