//
//  SHRestClientCore.swift
//  Partner
//
//  Created by Subhajit Halder on 05/05/18.
//  Copyright © 2018 Ozoprop Technologies Pvt Ltd. All rights reserved.
//

import Foundation

extension SHRestClient {
    
    
    
    internal func baseURLWithParams(url: String, parameters: [String:String]?) -> URL {
        
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
    
    internal func httpBodyForParams(parameters: [String: String]?) -> Data? {
        if parameters != nil {
            var parameterArray = [String]()
            
            for param in parameters! {
                
                let newParam = "\(param.key)=\(param.value.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? "")"
                
                parameterArray.append(newParam)
                
            }
            
            let string = parameterArray.joined(separator: "&")
            
            print("Post params: \n \(string)")
            
            return string.data(using: .utf8)!
        }
        
        return nil
    }
    
    internal func httpBodyForJSON(parameters: [String: Any]?) -> Data? {
        if parameters != nil {
            guard let body = try? JSONSerialization.data(withJSONObject: parameters ?? ["":""], options: []) else {
                return Data()
            }
            do {
                print("Post Json: \n \(try JSONSerialization.jsonObject(with: body, options: [.mutableContainers, .mutableLeaves]))")
            } catch {
                print(error)
            }
            
            
            return body
        }
        
        return nil
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
    
    private func proceedUploadingWith(parameters: [String: String], images: [String: String]) {
//        
//        let url = URL(string: urlString)
//        let session = URLSession(configuration: httpSessionConfiguration)
//        var request = URLRequest(url: url!, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 30.0)
//        
//        request.httpMethod = "POST"
//        
//        let _ = session.uploadTask(with: request, from: nil) { (data, response, error) in
//            //
//        }
        
    }
    
    
}
