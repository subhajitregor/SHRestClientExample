//
//  SHRestClientCore.swift
//  Partner
//
//  Created by Subhajit Halder on 05/05/18.
//  Copyright © 2018 Ozoprop Technologies Pvt Ltd. All rights reserved.
//

import Foundation

extension SHRestClient {
    
    
    
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
            
            let newParam = "\(param.key)=\(param.value.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? "")"
            
            parameterArray.append(newParam)
            
        }
        
        let string = parameterArray.joined(separator: "&")
        
        print("Post params - \(string)")
        
        return string.data(using: .utf8)!
        
    }
    
    private func httpBodyForJSON(parameters: [String: Any]) -> Data {
        
        guard let body = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            return Data()
        }
        
        return body
    }
    
    //private let boundary = "----SHRestClientFormBoundary32E6xxV194klWY1384Xcjie"
//    private func httpFormDataForParams(parameters: [String: Any], imageParams:[String: Data]?) -> Data {
//
//        var httpFormBody = Data()
//
//        for (key, value) in parameters {
//            httpFormBody.append("--\(boundary)\r\n")
//            httpFormBody.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
//            httpFormBody.append("\(value)\r\n")
//        }
//
//        if (imageParams != nil) {
//
//            for (key, value) in imageParams! {
//                let fileName = "image_\(key).png"
//                httpFormBody.append("\r\n--\(boundary)\r\n")
//                httpFormBody.append("Content-Disposition:form-data; name=\"\(key)\"; filename=\"\(fileName)\"\r\n")
//                httpFormBody.append("Content-Type: application/octet-stream\r\n\r\n")
//                httpFormBody.append(value)
//                httpFormBody.append("\r\n--\(boundary)--\r\n")
//            }
//
//        }
//
//        return httpFormBody
//
//    }
    
    
    internal func proceedFetchingWith(method: String, parameters: Any?, headers: [String:String]?, success: @escaping SHSuccessBlock, faliure: @escaping SHErrorBlock) {
        
        var url = URL(string: urlString)
        
        if method == "GET" && parameters != nil {
            
            url = baseURLWithParams(url: urlString, parameters: (parameters as! [String : String]))
            
        } else if method == "DELETE" && parameters != nil{
            
            url = baseURLWithParams(url: urlString, parameters: (parameters as! [String : String]))
            
        } else {
            
            url = baseURLWithParams(url: urlString, parameters: nil)
            
        }
        
        let session = URLSession(configuration: self.httpSessionConfiguration)
        var request = URLRequest(url: url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30.0)
        
        request.httpMethod = method
        
        if method == "POST" || method == "PUT" {
            if let newParams = parameters as? [String: String] {
                 request.setValue(SHHTTPContentType.wwwFormURLEncoded.rawValue, forHTTPHeaderField: "Content-Type")
                request.httpBody = httpBodyForParams(parameters: newParams)
            } else if let newParams = parameters as? [String: Any] {
                request.setValue(SHHTTPContentType.json.rawValue, forHTTPHeaderField: "Content-Type")
                request.httpBody = httpBodyForJSON(parameters: newParams)
            }
            
        }
        
        if headers != nil {
            
            for (key, value) in headers! {
                request.setValue(value, forHTTPHeaderField: key)
            }
            
        }
        
        
        if SHRestClientSettings.shared.showProgressHuD {
//            ProgressHUDSV.show()
        }
        
        
        let queue = SHHTTPCache.shared.getQueueFor(url: url!)
        
        queue.async {
            
            let dataTask = session.dataTask(with: request) { (responseData, urlResponse, error) in
                
                DispatchQueue.main.async {
                    
                    defer {
                        
                        if SHRestClientSettings.shared.showProgressHuD {
//                            ProgressHUDSV.dismiss()
                        }
                        
                        
                    }
                    
                    if error != nil {
                        

                        if SHNetworkManager.isNetworkAvailable {
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
                            if let stringData = String(data: data, encoding: String.Encoding.utf8) {
                                print(stringData) //JSONSerialization
                            }
                            faliure(SHRestClientErrorType.jsonError, nil)
                        }
                    }
                    
                }
                
            }
            
            
            
            dataTask.resume()
            
            
        }
        
        
        
        
    }
    
    private func proceedUploadingWith(parameters: [String: String], images: [String: String]) {
        
        let url = URL(string: urlString)
        let session = URLSession(configuration: httpSessionConfiguration)
        var request = URLRequest(url: url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30.0)
        
        request.httpMethod = "POST"
        
        let _ = session.uploadTask(with: request, from: nil) { (data, response, error) in
            //
        }
        
    }
    
    
}
