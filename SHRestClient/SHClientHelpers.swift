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

public class ProgressHUD {
    
    public enum Position {
        case top
        case middle
        case bottom
        case customY(CGFloat)
        case multiplier(CGFloat)
        
        var point : CGPoint {
            switch self {
            case .top:
                return CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.height * 0.2)
            case .middle:
                return CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.midY)
            case .bottom:
                return CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.height * 0.8)
            case .customY(let y):
                return CGPoint(x: UIScreen.main.bounds.midX, y: y)
            case .multiplier(let x):
                return CGPoint(x: UIScreen.main.bounds.midX, y: UIScreen.main.bounds.height * x)
            }
        }
    }
        
    static let shared = ProgressHUD()
    
    let indicatorView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    var indicatorColor = UIColor.black
    var noOfActivations = 0
    var isDisabledByUser = true
    var currentlyActive = false
    
    var position: Position = .middle
    
    init() {
        self.indicatorView.hidesWhenStopped = true
    }
    
    
    class public func setIndicatorColor(_ color: UIColor) {
        ProgressHUD.shared.indicatorColor = color
    }
    
    class public func disable() {
        shared.isDisabledByUser = true
    }
    
    class public func setCenter(position: Position) {
        shared.position = position
    }
    
    class public func enable() {
        shared.isDisabledByUser = false
    }
    
    class public func show() {
        shared.indicatorView.color = shared.indicatorColor
        if let window = UIApplication.shared.keyWindow {
            shared.indicatorView.center = shared.position.point
            if shared.noOfActivations == 0 {
                window.addSubview(shared.indicatorView)
            }
        }
                
        shared.indicatorView.startAnimating()
        shared.noOfActivations = shared.noOfActivations + 1
        shared.currentlyActive = true
    }
    
    class public func hide() {
        shared.noOfActivations = shared.noOfActivations - 1
        if shared.noOfActivations == 0 {
            shared.indicatorView.stopAnimating()
            shared.indicatorView.removeFromSuperview()
            shared.currentlyActive = false
        }
    }
}





