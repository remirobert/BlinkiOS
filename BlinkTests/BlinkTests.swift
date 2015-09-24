//
//  BlinkTests.swift
//  BlinkTests
//
//  Created by Remi Robert on 17/09/15.
//  Copyright © 2015 Remi Robert. All rights reserved.
//

import XCTest
import Parse
@testable import Blink

class BlinkTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testSignup() {
        User.signupUser("+33695116381", username: "test23").subscribeNext({ (next: AnyObject!) -> Void in
            print("next : \(next)")
            }, error: { (error: NSError!) -> Void in
                print("error : \(error)")
            }) {() -> Void in
                print("completed")
        }
    }
    
}
