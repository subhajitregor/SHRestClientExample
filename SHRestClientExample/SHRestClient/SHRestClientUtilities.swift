//
//  SHRestClientUtilities.swift
//  SHRestClientExample
//
//  Created by subhajit halder on 24/07/17.
//  Copyright © 2017 SubhajitHalder. All rights reserved.
//

import Foundation
import UIKit
//import FCAlertView
//import SVProgressHUD


enum SHHTTPContentType: String {
    case wwwFormURLEncoded = "application/x-www-form-urlencoded"
    case formData = "multipart/form-data"
    case json = "application/json"
}

enum SHRestClientErrorType {
    case none
    case reachability
    case error
    case jsonError
    case text
}

enum SHNoInternetAlertType {
    case viewController
    case alert
    case customAlert
    case customViewController
}

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
        
    }
}

class SHRestClientSettings: NSObject {
    
    static let shared = SHRestClientSettings()
    
    var showProgressHuD = true
    
    override init() {
        super.init()
        
    }
    
}

class ProgressHUD: UIView {
        
    static let shared = ProgressHUD()
    
    let indicatorView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    
    init() {
        super.init(frame: CGRect.zero)
        self.indicatorView.hidesWhenStopped = true
//        self.indicatorView.color = UIColor.themeGreen
//        self.indicatorView.tintColor = UIColor.themeGreen
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func show() {
        self.indicatorView.color = UIColor.black
        let appDelegate: AppDelegate? = (UIApplication.shared.delegate as? AppDelegate)
        
        self.indicatorView.center = (appDelegate?.window?.center)!
        
        appDelegate?.window?.addSubview(self.indicatorView)
        
        self.indicatorView.startAnimating()
        
    }
    
    func show(with color: UIColor) {
        self.indicatorView.color = color
        let appDelegate: AppDelegate? = (UIApplication.shared.delegate as? AppDelegate)
        
        self.indicatorView.center = (appDelegate?.window?.center)!
        
        appDelegate?.window?.addSubview(self.indicatorView)
        
        self.indicatorView.startAnimating()
        
    }
    
    func hide() {
        
        self.indicatorView.stopAnimating()
        self.indicatorView.removeFromSuperview()
        
    }
}

class NoInternet: NSObject {
    static let shared = NoInternet()
    
    var alertType : SHNoInternetAlertType = .customAlert
    
}


extension AppDelegate {
    
    static var topViewController: UIViewController? {
        get {
            return getTopViewController()
        }
    }
    
    static var root: UIViewController? {
        get {
            return UIApplication.shared.delegate?.window??.rootViewController
        }
    }
    
    static func getTopViewController(from viewController: UIViewController? = AppDelegate.root) -> UIViewController? {
        
        if let tabBarViewController = viewController as? UITabBarController {
            return getTopViewController(from: tabBarViewController.selectedViewController)
        } else if let navigationController = viewController as? UINavigationController {
            return getTopViewController(from: navigationController.visibleViewController)
        } else if let presentedViewController = viewController?.presentedViewController {
            return getTopViewController(from: presentedViewController)
        } else {
            return viewController
        }
    }

}

extension UIViewController {
    
//    func showReachabilityAlert() {
//        let alert = FCAlertView()
//        
//        alert.makeAlertTypeCaution()
//        
//        alert.showAlert(inView: self,
//                        withTitle: "No Internet",
//                        withSubtitle: "Please check you Internet connection.",
//                        withCustomImage: nil,
//                        withDoneButtonTitle: "OK",
//                        andButtons: nil)
//        
//        
//    }
}


//class ProgressHUDSV: SVProgressHUD {
//    
//    static let instance = ProgressHUDSV()
//    
//    var noOfActivations = 0
//    init() {
//        super.init(frame: CGRect.zero)
//        
//        
//    }
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//    }
//    
//    required init?(coder aDecoder: NSCoder) {
//        super.init(coder: aDecoder)
//    }
//    override class func show() {
//        super.show()
//        instance.noOfActivations = instance.noOfActivations + 1
//    }
//    
//    override class func dismiss() {
//       
//        instance.noOfActivations = instance.noOfActivations - 1
//        
//        if instance.noOfActivations == 0 {
//             super.dismiss()
//        }
//    }
//}

