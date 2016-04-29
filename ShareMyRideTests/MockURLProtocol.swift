//
//  MockURLProtocol.swift
//  ShareMyRide
//
//  Created by Dennis Adjei-Baah on 4/28/16.
//  Copyright © 2016 Dennis Adjei-Baah. All rights reserved.
//

import Foundation
class MockingURLProtocol: NSURLProtocol {
    static var requestMaps:[String: AnyObject]!
    private var baseUrl = "http://localhost:8080/"
    var cannedResponse: NSData?
    let cannedHeaders = ["Content-Type" : "application/json; charset=utf-8"]
    
    override func startLoading() {
        let request = self.request
        if request.HTTPMethod == "GET" {
            do{
                self.cannedResponse = try NSJSONSerialization.dataWithJSONObject(
                    MockingURLProtocol.requestMaps[(request.URL?.absoluteString)!]!,
                    options: NSJSONWritingOptions())

            }catch _{
                self.cannedResponse = NSData()
            }
            
//            if request.URL?.absoluteString == "rides" {
//                cannedResponse = "{\"count\":3,\"items\":[\"car\",\"boat\",\"airplane\"]}".dataUsingEncoding(NSUTF8StringEncoding)
//            } else if request.URL?.absoluteString == "http://notRight/items" {
//                cannedResponse = "{\"count\":3,\"concepts\":[\"art\",\"beauty\",\"ennui\"]}".dataUsingEncoding(NSUTF8StringEncoding)
//            } else {
//                cannedResponse = "GARBAGE".dataUsingEncoding(NSUTF8StringEncoding)
//            }
            let client = self.client
            let response = NSHTTPURLResponse(URL: request.URL!, statusCode: 200, HTTPVersion: "HTTP/1.1", headerFields: cannedHeaders)
            client?.URLProtocol(self, didReceiveResponse: response!, cacheStoragePolicy: NSURLCacheStoragePolicy.NotAllowed)
            client?.URLProtocol(self, didLoadData: cannedResponse!)
            client?.URLProtocolDidFinishLoading(self)
        }
        
    }
    
    override func stopLoading() {
        //noop
    }
    
    override internal class func canInitWithRequest(request: NSURLRequest) -> Bool {
        return request.URL?.scheme == "http" && (request.HTTPMethod == "GET")
    }
    
    override internal class func canonicalRequestForRequest(request: NSURLRequest) -> NSURLRequest {
        return request
}
}