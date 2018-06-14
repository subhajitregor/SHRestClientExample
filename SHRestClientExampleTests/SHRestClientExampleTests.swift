//
//  SHRestClientExampleTests.swift
//  SHRestClientExampleTests
//
//  Created by subhajit halder on 26/07/17.
//  Copyright © 2017 SubhajitHalder. All rights reserved.
//

import XCTest
@testable import SHRestClientExample

class SHRestClientExampleTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        
    }
    
    func testPreformanceOfClientObject () {
        self.measure {
            let randomNum: UInt32 = arc4random_uniform(100)
            for _ in 1...10000 {
                let client = SHRestClient("http://www.google.com")
                client.addHeader(key: "some", value: "\(randomNum)")
            }
        }
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            let randomNum: UInt32 = arc4random_uniform(100)
            for _ in 1...10000 {
                var resource = URLRequest(url: URL(string: "https://www.google.com")!)
                resource.setValue("some", forHTTPHeaderField: "\(randomNum)")
            }
        }
    }
    
}
