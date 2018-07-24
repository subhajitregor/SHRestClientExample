//
//  SHRestClient.swift
//  SHRestClientExample
//
//  Created by Subhajit Halder on 19/07/17.

//

import UIKit
//import Reachability
//import SVProgressHUD


typealias ResponseErrorBlock = (Error) -> Void
typealias ResponseSuccessBlock = (Data?, URLResponse?) -> Void


@objc final public class SHRestClient: NSObject {
    
    internal var request: URLRequest!
    
    internal var httpSessionConfiguration: URLSessionConfiguration = .default
    
    internal let boundary = "---------------SHRestClientFormBoundary32E6xxV194klWY1384Xcjie"
    
    var sessionConfiguration: URLSessionConfiguration {
        set {
            self.httpSessionConfiguration = newValue
        }
        get {
            return self.httpSessionConfiguration
        }
    }
    
    override public init() {
        super.init()
    }
    
    @objc public required convenience init(_ url: String!) {
        self.init()
        guard let urlForRequest = URL(string: url) else {
            #if DEBUG
            print("Not valid URL String")
            #endif
            return
        }
        self.request = URLRequest(url: urlForRequest, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30.0)
        
    }
    
    
}

