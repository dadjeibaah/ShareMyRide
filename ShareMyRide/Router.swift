//
//  Router.swift
//  ShareMyRide
//
//  Created by Dennis Adjei-Baah on 8/20/16.
//  Copyright © 2016 Dennis Adjei-Baah. All rights reserved.
//

import Foundation
import Alamofire


enum Router: NSURLRequestConvertible{
    static let baseUrl = MY_API_URL
    
    case Rides(String)
    case Users(String)
    case Communities(String)
    
    var method:Alamofire.Method{
        switch self{
            case .
        }
    }
    
    var URLRequest:NSURLRequest{
        
    }
}