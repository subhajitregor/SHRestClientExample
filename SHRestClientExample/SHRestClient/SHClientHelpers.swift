//
//  SHRestClientUtilities.swift
//  SHRestClientExample
//
//  Created by Subhajit Halder on 24/07/17.

//

import Foundation
import UIKit

enum ContentType {
    static let urlEncoded = "application/x-www-form-urlencoded"
    static let formData = "multipart/form-data"
    static let json = "application/json"
}

enum MethodType {
    static let get = "GET"
    static let post = "POST"
    static let put = "PUT"
    static let delete = "DELETE"
}

enum ResponseErrorType: Error {
    case reachability
    case jsonError
    case decoding
    case emptyResponseData
}

extension ResponseErrorType: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .reachability:
            return NSLocalizedString("Cannot connect to Internet.", comment: "reachabilty error")
        case .jsonError:
            return NSLocalizedString("Cannot convert to JSON.", comment: "json error")
        case .decoding:
            return NSLocalizedString("Cannot decode data to T.", comment: "text error")
        case .emptyResponseData:
            return NSLocalizedString("Cannot find data", comment: "")
        }
    }
    
    public var failureReason: String? {
        switch self {
        case .reachability:
            return NSLocalizedString("No Internet Found", comment: "")
        case .jsonError:
            return NSLocalizedString("JSON type mismatch", comment: "")
        case .decoding:
            return NSLocalizedString("JSON type mismatch", comment: "")
        case .emptyResponseData:
            return NSLocalizedString("Response from API is empty", comment: "")
        }
    }
    public var recoverySuggestion: String? {
        switch self {
        case .reachability:
            return NSLocalizedString("Check Internet connection", comment: "")
        case .jsonError:
            return NSLocalizedString("Check the response from API", comment: "")
        case .decoding:
            return NSLocalizedString("Check the response from API", comment: "")
        case .emptyResponseData:
            return NSLocalizedString("Check the response from API", comment: "")
        }
    }
}

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
        
    }
}

class ProgressHUD: UIView {
        
    static let shared = ProgressHUD()
    
    let indicatorView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    var indicatorColor = UIColor.black
    var noOfActivations = 0
    var isDisabledByUser = false
    init() {
        super.init(frame: CGRect.zero)
        self.indicatorView.hidesWhenStopped = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    class func setIndicatorColor(_ color: UIColor) {
        ProgressHUD.shared.indicatorColor = color
    }
    
    class func disable() {
        shared.isDisabledByUser = true
    }
    
    class func enable() {
        shared.isDisabledByUser = false
    }
    
    class func show() {
        shared.indicatorView.color = shared.indicatorColor
        let appDelegate: AppDelegate? = (UIApplication.shared.delegate as? AppDelegate)
        
        shared.indicatorView.center = (appDelegate?.window?.center)!
        
        appDelegate?.window?.addSubview(shared.indicatorView)
        
        shared.indicatorView.startAnimating()
        shared.noOfActivations = shared.noOfActivations + 1
    }
    
    class func hide() {
        shared.noOfActivations = shared.noOfActivations - 1
        if shared.noOfActivations == 0 {
            shared.indicatorView.stopAnimating()
            shared.indicatorView.removeFromSuperview()
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




