//
//  SHRestClientMethods.swift
//  SHRestClientExample
//
//  Created by Subhajit Halder on 13/06/18.
//  Copyright © 2018 SubhajitHalder. All rights reserved.
//

import Foundation

extension SHRestClient {
    
    @objc func get(parameters: [String: String]?) -> SHResponseLoader {
        self.request.httpMethod = MethodType.get
        self.request.url =
        self.baseURLWithParams(url: self.request.url?.absoluteString ?? "", parameters: parameters)
        return SHResponseLoader(rest: self)
    }
    
    @objc func post(fields: [String:String]?) -> SHResponseLoader {
        self.contentType(ContentType.urlEncoded)
        self.request.httpMethod = MethodType.post
        self.request.httpBody = self.httpBodyForParams(parameters: fields)
        return SHResponseLoader(rest: self)
    }
    
    @objc func post(json: [String:Any]?) -> SHResponseLoader {
        self.contentType(ContentType.json)
        self.request.httpMethod = MethodType.post
        self.request.httpBody = self.httpBodyForJSON(parameters: json)
        return SHResponseLoader(rest: self)
    }
    
    func post<T: Encodable>(encodable: T, encoder: JSONEncoder = JSONEncoder()) -> SHResponseLoader {
        self.contentType(ContentType.json)
        self.request.httpMethod = MethodType.post
        do {
            self.request.httpBody = try encoder.encode(encodable)
        } catch {
            print("JSON cannot be encoded \(error)")
        }
        
        return SHResponseLoader(rest: self)
    }
    
    @objc func put(fields: [String: String]?) -> SHResponseLoader {
        self.contentType(ContentType.urlEncoded)
        self.request.httpMethod = MethodType.put
        self.request.httpBody = self.httpBodyForParams(parameters: fields)
        return SHResponseLoader(rest: self)
        
    }
    
    @objc func put(json: [String: Any]?) -> SHResponseLoader {
        self.contentType(ContentType.json)
        self.request.httpMethod = MethodType.put
        self.request.httpBody = self.httpBodyForJSON(parameters: json)
        return SHResponseLoader(rest: self)
    }
    
    func put<T: Encodable>(encodable: T, encoder: JSONEncoder = JSONEncoder()) -> SHResponseLoader {
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
    
    @objc func delete(parameters: [String: String]) -> SHResponseLoader {
        self.request.httpMethod = MethodType.delete
        self.request.url =
            self.baseURLWithParams(url: self.request.url?.absoluteString ?? "", parameters: parameters)
        return SHResponseLoader(rest: self)
    }
    
}
