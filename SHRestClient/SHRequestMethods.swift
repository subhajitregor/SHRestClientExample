//
//  SHRestClientMethods.swift
//  SHRestClientExample
//
//  Created by Subhajit Halder on 13/06/18.

//

import Foundation

extension SHRestClient {
    
    @objc public func get(parameters: [String: String]?) -> SHResponseLoader {
        self.request.httpMethod = MethodType.get
        self.request.url =
        self.baseURLWithParams(url: self.request.url?.absoluteString ?? "", parameters: parameters)
        return SHResponseLoader(rest: self)
    }
    
    @objc public func postMultipart(files: [String: Data], params: [String: Any]? = nil ) -> SHResponseLoader {
        self.contentType("\(ContentType.formData); boundary=\(boundary)")
        self.request.httpMethod = MethodType.post
        self.request.httpBody = self.httpBodyForMultipartParams(parameters: params, dataParams: files)
        return SHResponseLoader(rest: self)
    }
    
    @objc public func postMultipart(params: [String: Any]) -> SHResponseLoader {
        self.contentType("\(ContentType.formData); boundary=\(boundary)")
        self.request.httpMethod = MethodType.post
        self.request.httpBody = self.httpBodyForMultipartParams(parameters: params, dataParams: nil)
        return SHResponseLoader(rest: self)
    }
    
    @objc public func putMultipart(files: [String: Data], params: [String: Any]? = nil ) -> SHResponseLoader {
        self.contentType("\(ContentType.formData); boundary=\(boundary)")
        self.request.httpMethod = MethodType.put
        self.request.httpBody = self.httpBodyForMultipartParams(parameters: params, dataParams: files)
        return SHResponseLoader(rest: self)
    }
    
    @objc public func putMultipart(params: [String: Any]) -> SHResponseLoader {
        self.contentType("\(ContentType.formData); boundary=\(boundary)")
        self.request.httpMethod = MethodType.put
        self.request.httpBody = self.httpBodyForMultipartParams(parameters: params, dataParams: nil)
        return SHResponseLoader(rest: self)
    }
    
    @objc public func post(fields: [String:String]?) -> SHResponseLoader {
        self.contentType(ContentType.urlEncoded)
        self.request.httpMethod = MethodType.post
        self.request.httpBody = self.httpBodyForParams(parameters: fields)
        return SHResponseLoader(rest: self)
    }
    
    @objc public func post(json: [String:Any]?) -> SHResponseLoader {
        self.contentType(ContentType.json)
        self.request.httpMethod = MethodType.post
        self.request.httpBody = self.httpBodyForJSON(parameters: json)
        return SHResponseLoader(rest: self)
    }
    
    public func post<T: Encodable>(encodable: T, encoder: JSONEncoder = JSONEncoder()) -> SHResponseLoader {
        self.contentType(ContentType.json)
        self.request.httpMethod = MethodType.post
        do {
            self.request.httpBody = try encoder.encode(encodable)
        } catch {
            print("JSON cannot be encoded \(error)")
        }
        
        return SHResponseLoader(rest: self)
    }
    
    @objc public func put(fields: [String: String]?) -> SHResponseLoader {
        self.contentType(ContentType.urlEncoded)
        self.request.httpMethod = MethodType.put
        self.request.httpBody = self.httpBodyForParams(parameters: fields)
        return SHResponseLoader(rest: self)
        
    }
    
    @objc public func put(json: [String: Any]?) -> SHResponseLoader {
        self.contentType(ContentType.json)
        self.request.httpMethod = MethodType.put
        self.request.httpBody = self.httpBodyForJSON(parameters: json)
        return SHResponseLoader(rest: self)
    }
    
    public func put<T: Encodable>(encodable: T, encoder: JSONEncoder = JSONEncoder()) -> SHResponseLoader {
        self.contentType(ContentType.json)
        self.request.httpMethod = MethodType.put
        do {
            self.request.httpBody = try encoder.encode(encodable)
        }
        catch {
            print("JSON cannot be encoded \(error)")
        }
        return SHResponseLoader(rest: self)
    }
    
    @objc public func delete(parameters: [String: String]) -> SHResponseLoader {
        self.request.httpMethod = MethodType.delete
        self.request.url =
            self.baseURLWithParams(url: self.request.url?.absoluteString ?? "", parameters: parameters)
        return SHResponseLoader(rest: self)
    }
    
}
