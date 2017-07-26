//
//  SHHTTPBody.swift
//  SHRestClientExample
//
//  Created by subhajit halder on 24/07/17.
//  Copyright © 2017 SubhajitHalder. All rights reserved.
//

import Foundation


struct SHHTTPBody {
    
    var body: Data {
        get {
            if self.contentType == .formData {
                return httpUrlEncoded.data(using: .utf8)! //TODO: form Data
            } else if self.contentType == .json {
                return jsonData(from: httpJSON)
            } else {
                return formURLEncodedData(httpBodyString: httpUrlEncoded)
            }
        }
        
    }
    
    private var httpUrlEncoded: String
    private var httpJSON: [String: Any]
    private var httpFormBody: Data
    private var contentType: SHHTTPContentType
    private let boundary = "----SHRestClientFormBoundary32E6xxV194klWY1384Xcjie"
    
    init() {
        httpUrlEncoded = ""
        httpJSON = ["":""]
        httpFormBody = Data()
        contentType = .wwwFormURLEncoded
    }
    
    init(contentType: SHHTTPContentType) {
        httpUrlEncoded = ""
        httpJSON = ["":""]
        httpFormBody = Data()
        self.contentType = contentType
    }
    
    mutating func set(contentType: SHHTTPContentType) {
        self.contentType = contentType
    }
    
    func getContentType() -> String {
        return self.contentType.rawValue
    }
    
    mutating func add(key: String!, value: String!) {
        if contentType == .wwwFormURLEncoded {
            
            if self.httpUrlEncoded == "" {
                self.httpUrlEncoded.append(key+"="+value)
            } else {
                self.httpUrlEncoded.append("&"+key+"="+value)
            }
            
        } else if contentType == .json {
            httpJSON.updateValue(value, forKey: key)
        } else if contentType == .formData {
            httpFormBody.append("--\(boundary)\r\n")
            httpFormBody.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            httpFormBody.append("\(value)\r\n")
        }
        
    }
    
    mutating func add(key: String!, value: Int!) {
        if contentType == .wwwFormURLEncoded {
            
            if self.httpUrlEncoded == "" {
                self.httpUrlEncoded.append(key+"=\(value)")
            } else {
                self.httpUrlEncoded.append("&"+key+"=\(value)")
            }
        }else if contentType == .json {
            httpJSON.updateValue(value, forKey: key)
        } else if contentType == .formData {
            httpFormBody.append("--\(boundary)\r\n")
            httpFormBody.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            httpFormBody.append("\(value)\r\n")
        }
    }
    
    mutating func add(key: String!, value: Double!) {
        if contentType == .wwwFormURLEncoded {
            
            if self.httpUrlEncoded == "" {
                self.httpUrlEncoded.append(key+"=\(value)")
            } else {
                self.httpUrlEncoded.append("&"+key+"=\(value)")
            }
        }else if contentType == .json {
            httpJSON.updateValue(value, forKey: key)
        } else if contentType == .formData {
            httpFormBody.append("--\(boundary)\r\n")
            httpFormBody.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
            httpFormBody.append("\(value)\r\n")
        }
    }
    
    mutating func add(key: String, image: Data, fileName: String) {
        httpFormBody.append("\r\n--\(boundary)\r\n")
        httpFormBody.append("Content-Disposition:form-data; name=\"\(key)\"; filename=\"\(fileName)\"\r\n")
        httpFormBody.append("Content-Type: application/octet-stream\r\n\r\n")
        httpFormBody.append(image)
        httpFormBody.append("\r\n--\(boundary)--\r\n")
    }
    
    mutating func add(filePathkey: String, paths: [String]) {
        //TODO: Multiple images using file path
    }
    
    
    func jsonData(from dictionary: [String: Any]!) -> Data {
        var jsonError: Error?
        
        let jsonData : Any?
        do {
            jsonData = try JSONSerialization.data(withJSONObject: dictionary, options: .prettyPrinted)
        } catch let error as NSError {
            jsonError = error
            jsonData = Data()
            debugPrint(jsonError ?? "Error: Cannot convert to JSON String")
        } catch {
            fatalError()
        }
        
        return (String(data: jsonData as! Data, encoding: .utf8)?.data(using: .utf8))!
    }
    
    //    func createBody(with parameters: [String: String]?, filePathKey: String, paths: [String], boundary: String) throws -> Data {
    //        var body = Data()
    //
    //        if parameters != nil {
    //            for (key, value) in parameters! {
    //                body.append("--\(boundary)\r\n")
    //                body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
    //                body.append("\(value)\r\n")
    //            }
    //        }
    //
    //        for path in paths {
    //            let url = URL(fileURLWithPath: path)
    //            let filename = url.lastPathComponent
    //            let data = try Data(contentsOf: url)
    //            let mimetype = mimeType(for: path)
    //
    //            body.append("--\(boundary)\r\n")
    //            body.append("Content-Disposition: form-data; name=\"\(filePathKey)\"; filename=\"\(filename)\"\r\n")
    //            body.append("Content-Type: \(mimetype)\r\n\r\n")
    //            body.append(data)
    //            body.append("\r\n")
    //        }
    //
    //        body.append("--\(boundary)--\r\n")
    //        return body
    //    }
    
    
    //    func mimeType(for path: String) -> String {
    //        let url = NSURL(fileURLWithPath: path)
    //        let pathExtension = url.pathExtension
    //
    //        if let uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, pathExtension! as String, nil)?.takeRetainedValue() {
    //            if let mimetype = UTTypeCopyPreferredTagWithClass(uti, kUTTagClassMIMEType)?.takeRetainedValue() {
    //                return mimetype as String
    //            }
    //        }
    //        return "application/octet-stream";
    //    }
    
    func formURLEncodedData(httpBodyString: String!) -> Data {
        let urlString = self.httpUrlEncoded.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        return urlString.data(using: .utf8)!
    }
    
}
