//
//  RideTests.swift
//  ShareMyRide
//
//  Created by Dennis Adjei-Baah on 4/28/16.
//  Copyright © 2016 Dennis Adjei-Baah. All rights reserved.
//

//Inspired By: https://github.com/diatrevolo/NetworkTesting/blob/master/NetworkTestingTests/MyRESTClientTests.swift

import XCTest
import Alamofire
@testable import ShareMyRide

class RideTests: XCTestCase {
    
    var manager: Alamofire.Manager?
    override func setUp() {
        super.setUp()
        MockingURLProtocol.requestMaps = ["http://localhost:8080/rides":[
            [
                "id":1,
                "rideSharer":["id":1],
                "destination":"Walmart",
                "longitude":0.0,
                "latitude":0.0,
                "timeLeaving":"time",
                "duration":30,
                "availableSeats":0
            ]
    ]
        ]
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        config.protocolClasses!.insert(MockingURLProtocol.self, atIndex: 0)
        manager = Manager(configuration: config)
        Ride.manager = self.manager!
        
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testReturnRenderARideObjectFromJSON() {
        let expectation = expectationWithDescription("GET All Rides")
        var expectedRides:[Ride]!
        var expectedError:NSError!
        
        Ride.Get(
            onSuccess:{(rides:[Ride]) in
                expectedRides = rides
                expectation.fulfill()
            
            }, onFailure:{(error:NSError) in
                expectedError = error
                print(error)
                expectation.fulfill()
                
        })
        
        
        waitForExpectationsWithTimeout(10) { (error: NSError?) -> Void in
            XCTAssertNil(expectedError) 
            XCTAssertNotNil(expectedRides)
        }
        
    }
    
    
}
