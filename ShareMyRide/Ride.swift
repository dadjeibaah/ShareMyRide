//
//  Rides.swift
//  ShareMyRide
//
//  Created by Dennis Adjei-Baah on 4/22/16.
//  Copyright © 2016 Dennis Adjei-Baah. All rights reserved.
//

import Foundation
import Argo
import Curry
import Alamofire


class Ride :RestDecodable{
    var resourceName: String = "rides"
    var id:String?
    var riderSharer:String
    var destinationName:String
    var departureTime:String
    var duration:String
    var availableSeats:Int
    var loc:[Double]
    var community:String
    var rideAlongs:[String]
    
    
    
    init(id:String?, rideSharer:String, destinationName:String, departureTime:String, duration:String, availableSeats:Int, location:[Double], community:String, rideAlongs:[String]){
        self.id = id
        self.riderSharer = rideSharer
        self.destinationName = destinationName
        self.availableSeats = availableSeats
        self.departureTime = departureTime
        self.duration = duration
        self.loc = location
        self.community = community
        self.rideAlongs = rideAlongs
    }
    
    

    internal func toDictionary()-> AnyObject{
        let result:NSDictionary = [
        "rideSharer":self.riderSharer,
        "destinationName":self.destinationName,
        "departureTime":self.departureTime,
        "duration":self.duration,
        "availableSeats": self.availableSeats.description,
        "loc":["type":"Point", "coordinates":[self.loc[0], self.loc[1]]],
        "rideAlongs":self.rideAlongs,
        "community":self.community
        ]
        return result
    
    }
    
    static func nearby(params:[String:String], onSuccess:[Ride] -> Void, onFailure:NSError -> Void){
        Alamofire.request(.POST, NSMutableURLRequest(URL: NSURL(string:"http://localhost:8000/rides/nearby")!), parameters:params).responseDecodable{
            (response:Response<[Ride],NSError>) in
            switch response.result{
            case .Success(let rides):
                onSuccess(rides)
            case .Failure(let error):
                onFailure(error)
            }
        }

    }
    
    static func decode(json: JSON) -> Decoded<Ride> {
    let create =  curry(Ride.init)
        <^> json <|? "_id"
        <*> json <| "rideSharer"
        <*> json <| "destinationName"
        <*> json <| "departureTime"
        
        return create
        <*> json <| "duration"
        <*> json <| "availableSeats"
        <*> json <|| ["loc","coordinates"]
        <*> json <| "community"
        <*> json <|| "riders"
    }
    
    
}