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
    
    
    internal func httpBodyForMultipartParams(parameters: [String: Any]?, dataParams:[String: Data]?) -> Data {

        var httpFormBody = Data()

        if parameters != nil {
            for (key, value) in parameters! {
                httpFormBody.append("--\(boundary)\r\n")
                httpFormBody.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                httpFormBody.append("\(value)\r\n")
            }
        }
        

        if dataParams != nil {

            for (key, value) in dataParams! {
                let mimeType = getMimeType(value)
                let fileName = "file_\(key).\(mimeType.filetype)"
                httpFormBody.append("\r\n--\(boundary)\r\n")
                httpFormBody.append("Content-Disposition:form-data; name=\"\(key)\"; filename=\"\(fileName)\"\r\n")
                httpFormBody.append("Content-Type: \(getMimeType(value).mime)\r\n\r\n")
                httpFormBody.append(value)
                httpFormBody.append("\r\n--\(boundary)--\r\n")
            }

        }

        return httpFormBody

    }
    
    private func getMimeType(_ val : Data) -> (mime:String, filetype:String) {
        var value = [UInt8](repeating:0, count:1)
        val.copyBytes(to: &value, count: 1)
        var mimeType = "application/octet-stream"
        var fileType = ""
        switch (value[0]) {
        case 0xFF:
            mimeType = "image/jpeg"
            fileType = "jpeg"
        case 0x89:
            mimeType = "image/png"
            fileType = "png"
        case 0x47:
            mimeType = "image/gif"
            fileType = "gif"
        case 0x49, 0x4D:
            mimeType = "image/tiff"
            fileType = "tiff"
        case 0x25:
            mimeType = "application/pdf"
            fileType = "pdf"
        case 0xD0:
            mimeType = "application/vnd"
            fileType = "vnd"
        case 0x46:
            mimeType = "text/plain"
            fileType = "txt"
        default:
            mimeType = "application/octet-stream"
            fileType = ""
        }
        
        return (mimeType, fileType)
    }
    
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
