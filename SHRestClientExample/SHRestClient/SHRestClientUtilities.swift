//
//  SHRestClientUtilities.swift
//  SHRestClientExample
//
//  Created by subhajit halder on 24/07/17.
//  Copyright © 2017 SubhajitHalder. All rights reserved.
//

import Foundation
import UIKit

enum SHHTTPContentType: String {
    case wwwFormURLEncoded = "application/x-www-form-urlencoded"
    case formData = "multipart/form-data"
    case json = "application/json"
}

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
        
    }
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
