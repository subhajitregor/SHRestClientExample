//
//  SHRestClient.swift
//  SHRestClientExample
//
//  Created by subhajit halder on 19/07/17.
//  Copyright © 2017 SubhajitHalder. All rights reserved.
//

import UIKit
import ReachabilitySwift

class SHRestClient: NSObject {
    
    typealias SHHTTPResponseBlock = (Any?, HTTPURLResponse?, Error?) -> Void
    typealias SHReachabilityErrorBlock = () -> Void
    typealias SHErrorBlock = (SHRestClientErrorType,Error?) -> Void
    typealias SHSuccessBlock = (Any?, HTTPURLResponse?) -> Void
    
    var urlString : String
    
//    private var httpBody: Dictionary<String, String>
//    private var httpHeaders: [String: String] = ["":""]
    private var httpSessionConfiguration: URLSessionConfiguration = .default
    var reachabilty: SHReachabilityManager
    
    var sessionConfiguration: URLSessionConfiguration {
        set {
            self.httpSessionConfiguration = newValue
        }
        get {
            return self.httpSessionConfiguration
        }
    }
    
    init(with url: String!) {
        self.urlString = url
        self.reachabilty = SHReachabilityManager.shared
    }
    
    override init() {
        self.urlString = ""
        self.reachabilty = SHReachabilityManager.shared
    }
    
    
    private func proceedFetchingWith(method: String, parameters: Data, headers: [String: String], success: @escaping SHSuccessBlock, faliure: @escaping SHErrorBlock) {
        
        self.reachabilty.addListner(listener: self)
        
        guard let url = URL(string: self.urlString) else {
            print("Error: cannot create URL")
            return
        }
        let session = URLSession(configuration: httpSessionConfiguration)
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30.0)
        
        request.httpMethod = method
        
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
        
        ProgressHUD.shared.show()
        
        let queue = SHHTTPCache.shared.getQueueFor(url: url)
        
        queue.async {
            
            let dataTask = session.dataTask(with: request) { (responseData, urlResponse, error) in
                
                DispatchQueue.main.async {
                    
                    defer {
                        self.reachabilty.removeListener(listener: self)
                        ProgressHUD.shared.hide()
                    }
                    
                    if error != nil {
                        faliure(SHRestClientErrorType.error, error)
                    } else {
                        
                        guard let data = responseData else {
                            print("Error: did not receive data")
                            return
                        }
                        
                        do {
                            
                            if let json = try JSONSerialization.jsonObject(with: data, options: [.mutableContainers, .mutableLeaves]) as? [String: Any] {
                                success(json, urlResponse as? HTTPURLResponse)
                            } else if let json = try JSONSerialization.jsonObject(with: data, options: [.mutableContainers, .mutableLeaves]) as? [Any] {
                                success(json, urlResponse as? HTTPURLResponse)
                            }
                            
                        } catch {
                            faliure(SHRestClientErrorType.jsonError, nil)
                        }
                    }

                }
                
            }
            dataTask.resume()

            
        }
        
        
        
        
    }
    
    func get(parameters: [String: String], headers: [String: String], success: @escaping SHSuccessBlock, faliure: @escaping SHErrorBlock) {
        
    }
    
    func get(response: @escaping SHHTTPResponseBlock, reachability: @escaping SHReachabilityErrorBlock) {
        if SHReachabilityManager.shared.isNetworkAvailable {
            

        } else {
            reachability()
        }
        
        
    }
    
    func post(body: SHHTTPBody, response: @escaping SHHTTPResponseBlock, reachability: @escaping SHReachabilityErrorBlock) {
        
        if SHReachabilityManager.shared.isNetworkAvailable {
            guard let url = URL(string: self.urlString) else {
                print("Error: cannot create URL")
                return
            }
            let session = URLSession(configuration: httpSessionConfiguration)
            var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30.0)
            request.httpMethod = "POST"
            request.httpBody = body.body
            request.setValue(body.getContentType(), forHTTPHeaderField: "Content-Type")
            
//            for (key, value) in httpHeaders {
//                request.setValue(value, forHTTPHeaderField: key)
//            }
            
            let dataTask = session.dataTask(with: request) { (responseData, urlResponse, error) in
                if error != nil {
                    response(nil, nil, error)
                } else {
                    
                    guard let data = responseData else {
                        print("Error: did not receive data")
                        return
                    }
                    
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data, options: [.mutableContainers, .mutableLeaves]) as? [String: Any] {
                            response(json, urlResponse as? HTTPURLResponse, nil)
                        } else if let json = try JSONSerialization.jsonObject(with: data, options: [.mutableContainers, .mutableLeaves]) as? [Any] {
                            response(json, urlResponse as? HTTPURLResponse, nil)
                        }
                    } catch {
                        let jsonError = NSError(domain: "com.shrestclient.json", code: 2017, userInfo: [NSLocalizedDescriptionKey: NSLocalizedString("Error trying to convert data to JSON", comment: "")])
                        response(nil, urlResponse as? HTTPURLResponse, jsonError)
                    }
                }
            }
            dataTask.resume()
            
        } else {
            reachability()
        }
        
        
    }
    
    func put(body: SHHTTPBody, response: @escaping SHHTTPResponseBlock, reachability: @escaping SHReachabilityErrorBlock) {
        if SHReachabilityManager.shared.isNetworkAvailable {
            guard let url = URL(string: self.urlString) else {
                print("Error: cannot create URL")
                return
            }
            let session = URLSession(configuration: httpSessionConfiguration)
            var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30.0)
            request.httpMethod = "PUT"
            request.httpBody = body.body
            request.setValue(body.getContentType(), forHTTPHeaderField: "Content-Type")
            
//            for (key, value) in httpHeaders {
//                request.setValue(value, forHTTPHeaderField: key)
//            }
            
            let dataTask = session.dataTask(with: request) { (responseData, urlResponse, error) in
                if error != nil {
                    response(nil, nil, error)
                } else {
                    
                    guard let data = responseData else {
                        print("Error: did not receive data")
                        return
                    }
                    
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data, options: [.mutableContainers, .mutableLeaves]) as? [String: Any] {
                            response(json, urlResponse as? HTTPURLResponse, nil)
                        } else if let json = try JSONSerialization.jsonObject(with: data, options: [.mutableContainers, .mutableLeaves]) as? [Any] {
                            response(json, urlResponse as? HTTPURLResponse, nil)
                        }
                    } catch {
                        let jsonError = NSError(domain: "com.shrestclient.json", code: 2017, userInfo: [NSLocalizedDescriptionKey: NSLocalizedString("Error trying to convert data to JSON", comment: "")])
                        response(nil, urlResponse as? HTTPURLResponse, jsonError)
                    }
                }
            }
            dataTask.resume()
            
        } else {
            reachability()
        }
        

    }
    
    func delete(response: @escaping SHHTTPResponseBlock, reachability: @escaping SHReachabilityErrorBlock) {
        if SHReachabilityManager.shared.isNetworkAvailable {
            
        } else {
            reachability()
        }
    }
}

extension SHRestClient: SHReachabilityManagerDelegate {
    
    func networkStatusDidChange(status: Reachability.NetworkStatus) {
        
        if status == .notReachable {
            // TODO: Present a reachability view controller in current window
            
        } else {
            
            
            //TODO: Dissmiss the reachability controller
            
        }
        
        
    }
    
}
