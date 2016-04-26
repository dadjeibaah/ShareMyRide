//
//  Users.swift
//  ShareMyRide
//
//  Created by Dennis Adjei-Baah on 4/16/16.
//  Copyright © 2016 Dennis Adjei-Baah. All rights reserved.
//

import Foundation
import Argo
import Curry



struct User {

    let id:Int
    let firstName:String
    let lastName:String
    let rides:[Ride]?
    
    
}



extension User:Decodable {
    
    
    static func decode(j:JSON) -> Decoded<User>{
        return curry(User.init)
            <^> j <| "id"
            <*> j <| "firstName"
            <*> j <| "lastName"
            <*> j <||? "rides"
            
    }
}
