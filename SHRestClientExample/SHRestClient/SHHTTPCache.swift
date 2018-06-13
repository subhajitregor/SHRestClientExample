//
//  SHHTTPCache.swift
//  SHRestClientExample
//
//  Created by subhajit halder on 24/09/17.
//  Copyright © 2017 SubhajitHalder. All rights reserved.
//

import UIKit
import CoreData

class SHHTTPCache: NSObject {
    
    static let shared = SHHTTPCache()
    
    private var dispatchQueueArray = [[URL:DispatchQueue]]()
    
    func getQueueFor(url: URL) -> DispatchQueue {
        
        var theDispatchQueue = DispatchQueue(label: "temp_unused_fucking_queue")
        
        if self.dispatchQueueArray.isEmpty || self.dispatchQueueArray.contains(where: {$0[url] == nil}) {
            
            let randomString = UUID().uuidString
//            theDispatchQueue = DispatchQueue(label: randomString, qos: .userInitiated, attributes: .concurrent)
            theDispatchQueue = DispatchQueue(label: randomString, qos: .userInitiated)
            
            self.dispatchQueueArray.append([url: theDispatchQueue])
            
        } else if let dict = self.dispatchQueueArray.first(where: {$0[url] != nil}) {
            theDispatchQueue = dict[url]!
        }
        return theDispatchQueue
    }
}
