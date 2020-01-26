//
//  LeboncoinTestTests.swift
//  LeboncoinTestTests
//
//  Created by Sébastien Gousseau on 25/01/2020.
//  Copyright © 2020 Sébastien Gousseau. All rights reserved.
//

import XCTest
@testable import LeboncoinTest

class LeboncoinTestTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testApiAndStorage() {
        let exp = expectation(description: "exp")
        
        var manager = ForecastsManager()
        var forecasts: [Date: Forecast]?
        
        manager.forecasts { (result) in
            forecasts = result
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 5.0)
        XCTAssertNotNil(forecasts)
        XCTAssertFalse(forecasts!.isEmpty)
        
        manager = ForecastsManager()
        XCTAssertTrue(manager.currentForecasts.count == forecasts!.count)
    }

}
