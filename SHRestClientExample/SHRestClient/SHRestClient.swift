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
    
    private func baseURLWithParams(url: String, parameters: [String:String]?) -> URL {
        
        if parameters == nil {
            
            print("url - \(String(describing: URL(string: url)))")
            return URL(string: url)!
            
        } else {
            
            var components = URLComponents(string: url)
            
            var queryItems = [URLQueryItem]()
            
            for param in parameters! {
                
                queryItems.append(URLQueryItem(name: param.key, value: param.value))
                
            }
            
            components?.queryItems = queryItems
            
            print("url - \(String(describing: components?.url))")
            
            return (components?.url)!
            
        }
        
    }
    
    private func httpBodyForParams(parameters: [String: String]) -> Data {
        
        var parameterArray = [String]()
        
        for param in parameters {
            
            let newParam = "\(param.key)=\(String(describing: param.value.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)))"
            
            parameterArray.append(newParam)
            
        }
        
        let string = parameterArray.joined(separator: "&")
        
        print("Post params - \(string)")
        
        return string.data(using: .utf8)!
        
    }
    
    private let boundary = "----SHRestClientFormBoundary32E6xxV194klWY1384Xcjie"
    private func httpFormDataForParams(parameters: [String: Any], imageParams:[String: Data]?) {
        
        var httpFormBody = Data()
        
        for (key, value) in parameters {
            httpFormBody.append("--\(boundary)\r\n")
            httpFormBody.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            httpFormBody.append("\(value)\r\n")
        }
        
        if (imageParams != nil) {
            
            for (key, value) in imageParams! {
                let fileName = "image_\(key).png"
                httpFormBody.append("\r\n--\(boundary)\r\n")
                httpFormBody.append("Content-Disposition:form-data; name=\"\(key)\"; filename=\"\(fileName)\"\r\n")
                httpFormBody.append("Content-Type: application/octet-stream\r\n\r\n")
                httpFormBody.append(value)
                httpFormBody.append("\r\n--\(boundary)--\r\n")
            }
            
        }
        
        
       
        
    }
    
    
    private func proceedFetchingWith(method: String, parameters: [String:String]?, headers: [String:String]?, success: @escaping SHSuccessBlock, faliure: @escaping SHErrorBlock) {
        
        self.reachabilty.addListner(listener: self)
        
        var url = URL(string: urlString)
        
        if method == "GET" && parameters != nil {
            
            url = baseURLWithParams(url: urlString, parameters: parameters)
            
        } else {
            
            url = baseURLWithParams(url: urlString, parameters: nil)
            
        }
        
        let session = URLSession(configuration: httpSessionConfiguration)
        var request = URLRequest(url: url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30.0)
        
        request.httpMethod = method
        
        if method == "POST" {
            request.httpBody = httpBodyForParams(parameters: parameters!)
        }
        
        if headers != nil {
            
            for (key, value) in headers! {
                request.setValue(value, forHTTPHeaderField: key)
            }
            
        }
        
        ProgressHUD.shared.show()
        
        let queue = SHHTTPCache.shared.getQueueFor(url: url!)
        
        queue.async {
            
            let dataTask = session.dataTask(with: request) { (responseData, urlResponse, error) in
                
                DispatchQueue.main.async {
                    
                    defer {
                        self.reachabilty.removeListener(listener: self)
                        ProgressHUD.shared.hide()
                    }
                    
                    if error != nil {
                        
                        if self.reachabilty.isNetworkAvailable {
                             faliure(SHRestClientErrorType.error, error)
                        } else {
                            faliure(SHRestClientErrorType.reachability, error)
                        }
                        
                       
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
    
    func get(parameters: [String: String]?, headers: [String: String]?, success: @escaping SHSuccessBlock, faliure: @escaping SHErrorBlock) {
        
        proceedFetchingWith(method: "GET", parameters: parameters, headers: headers, success: success, faliure: faliure)
        
    }
    
    func post(parameters: [String:String], headers: [String:String], success: @escaping SHSuccessBlock, faliure: @escaping SHErrorBlock) {
        
        proceedFetchingWith(method: "POST", parameters: parameters, headers: headers, success: success, faliure: faliure)
        
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
