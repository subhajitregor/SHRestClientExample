//
//  SHRestDataTask.swift
//  SHRestClientExample
//
//  Created by Subhajit Halder on 10/07/18.
//  Copyright © 2018 SubhajitHalder. All rights reserved.
//

import Foundation

final class SHSessionDataTask: NSObject {
    private let dataTask: URLSessionDataTask
    public var state: URLSessionTask.State { get { return dataTask.state}}
    
    enum ProgressState {
        case resumed
        case canceled
        case paused
    }
    
    @available(iOS 11.0, *)
    public var progress: Progress { get { return dataTask.progress}}
    
    init(task: URLSessionDataTask) {
        dataTask = task
    }
}

extension SHSessionDataTask {
    @objc public func cancel() {
        dataTask.cancel()
        if !ProgressHUD.shared.isDisabledByUser {
            ProgressHUD.hide()
        }
    }
    
    @objc public func resume() {
        dataTask.resume()
        ProgressHUD.show()
    }
    
    @objc public func suspend() {
        dataTask.suspend()
        if !ProgressHUD.shared.isDisabledByUser {
            ProgressHUD.hide()
        }
    }
//    @available(iOS 11.0, *)
//    public func progressCallback(_ completionHandler: @escaping (ProgressState) -> Void) {
//        
//        progress.resumingHandler = { completionHandler(.resumed) }
//        
//        progress.cancellationHandler = { completionHandler(.canceled) }
//        
//        progress.pausingHandler = { completionHandler(.paused) }
//    }
}
