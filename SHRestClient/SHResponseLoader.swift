//
//  SHResponseLoader.swift
//  SHRestClientExample
//
//  Created by Subhajit Halder on 13/06/18.

//

import UIKit



final class SHResponseLoader: NSObject {
    
    internal var request: URLRequest
    internal var httpSessionConfiguration: URLSessionConfiguration
    internal var currentSession: URLSession
    internal var currentSessionDataTask: URLSessionDataTask
    init(rest: SHRestClient) {
        self.request = rest.request
        self.httpSessionConfiguration = rest.httpSessionConfiguration
        self.currentSession = URLSession(configuration: self.httpSessionConfiguration)
        self.currentSessionDataTask = URLSessionDataTask()
    }
}

extension SHResponseLoader {
    
    @objc @discardableResult func fetchRaw(success: @escaping ResponseSuccessBlock, failure: @escaping ResponseErrorBlock) -> SHSessionDataTask {
        if !ProgressHUD.shared.isDisabledByUser {
            ProgressHUD.show()
        }
        
        #if DEBUG
        
        debugPrint(self.request.url ?? "No valid url")
        if self.request.httpMethod == MethodType.post || self.request.httpMethod == MethodType.put {
            do {
                debugPrint(try JSONSerialization.jsonObject(with: self.request.httpBody!, options: [.mutableLeaves, .mutableContainers, .allowFragments]))
            } catch {
                debugPrint(String(data: self.request.httpBody!, encoding: String.Encoding.utf8) ?? "")
            }
        }
        #endif
        
        self.currentSessionDataTask = self.currentSession.dataTask(with: self.request, completionHandler: { (data, response, error) in
            defer {
                DispatchQueue.main.async {
                    ProgressHUD.hide()                    
                }
            }
            
            if error != nil {
                if SHNetworkObserver.isNetworkAvailable {
                    failure(error!)
                } else {
                    failure(ResponseErrorType.reachability)
                }
            } else {
                success(data, response)
            }
        })
        
        self.currentSessionDataTask.resume()
        
        
        
        return SHSessionDataTask(task: self.currentSessionDataTask)
    }
    
    @objc @discardableResult func proceedFetching(success: @escaping ResponseSuccessBlock, failure: @escaping ResponseErrorBlock) -> SHSessionDataTask {
        return self.fetchRaw(success: { (data, response) in
            if data != nil {
                success(data, response)
            } else {
                failure(ResponseErrorType.emptyResponseData)
            }
        }) { (error) in
            failure(error)
        }
    }
    
    @objc @discardableResult func fetchData(success: @escaping (_ response: Data) -> Void, failure: @escaping ResponseErrorBlock) -> SHSessionDataTask {
        
        return self.proceedFetching(success: { (data, response) in
            DispatchQueue.main.async {
                success(data!)
            }
            
        }, failure: { (error) in
            DispatchQueue.main.async {
                failure(error)
            }
            
        })
    }
    
    @discardableResult func fetchJSON<T: Decodable>(decodeable: T.Type, decoder: JSONDecoder = JSONDecoder(), success: @escaping (_ response: T) -> Void, failure: @escaping ResponseErrorBlock) -> SHSessionDataTask {
        
        return self.fetchData(success: { (data) in
            do {
                let jsonObj = try decoder.decode(decodeable, from: data)
                DispatchQueue.main.async {
                    success(jsonObj)
                }
            } catch {
                
                #if DEBUG
                
                do {
                    print(try JSONSerialization.jsonObject(with: data, options: [.mutableLeaves, .mutableContainers]))
                } catch {
                    print(error)
                }
                #endif
                
                DispatchQueue.main.async {
                    failure(ResponseErrorType.decoding)
                }
            }
            
        }, failure: { (error) in
            DispatchQueue.main.async {
                failure(error)
            }
            
        })
        
    }
    
    
    @objc @discardableResult func fetchJSON(readingOptions: JSONSerialization.ReadingOptions = [], success: @escaping (_ response: Any?) -> Void, failure: @escaping ResponseErrorBlock) -> SHSessionDataTask {
        
        return self.fetchData(success: { (data) in
            do {
                let jsonObj = try JSONSerialization.jsonObject(with: data, options: readingOptions)
                DispatchQueue.main.async {
                    success(jsonObj)
                }
            } catch {
                
                #if DEBUG
                
                do {
                    print(try JSONSerialization.jsonObject(with: data, options: [.mutableLeaves, .mutableContainers]))
                } catch {
                    print(error)
                }
                
                #endif
                
                DispatchQueue.main.async {
                    failure(ResponseErrorType.decoding)
                }
                
            }
        }, failure: { (error) in
            DispatchQueue.main.async {
                failure(error)
            }
            
        })
    }
}
