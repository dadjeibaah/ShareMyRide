//
//  Communities.swift
//  ShareMyRide
//
//  Created by Dennis Adjei-Baah on 5/23/16.
//  Copyright © 2016 Dennis Adjei-Baah. All rights reserved.
//

import Foundation
import Argo
import Curry

class Communities:RestDecodable {
    
    var resourceName: String = "communities"
    
    var id:String?
    var communityName:String?
    
    init(id:String, communityName:String?){
        self.id = id
        self.communityName = communityName

    }
    func toDictionary() -> AnyObject {
        var result = [NSObject:AnyObject]()
        result["communityName"] = self.communityName
        return result
    }
    
    static func decode(json:JSON) -> Decoded<Communities>{
        let create = curry(Communities.init)
        return create
        <^> json <| "_id"
        <*> json <|? "communityName"
    }
}