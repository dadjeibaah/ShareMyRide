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


class Ride :Decodable, NSCopying{
    static let manager = Alamofire.Manager.sharedInstance
    static let URLRequest: NSMutableURLRequest = NSMutableURLRequest(URL: NSURL(string:"http://localhost:8080/rides")!)
    private var managerForInstance:Manager
    var id:Int
    var riderSharer:Int
    var destination:String
    var timeLeaving:String
    var duration:Int
    var availableSeats:Int
    var longitude:Float
    var latitude: Float
    
    
    
    init(id:Int, rideSharer:Int, destination:String, timeLeaving:String, duration:Int, availableSeats:Int,longitude:Float, latitude:Float){
        self.id = id
        self.riderSharer = rideSharer
        self.destination = destination
        self.availableSeats = availableSeats
        self.timeLeaving = timeLeaving
        self.duration = duration
        self.longitude = longitude
        self.latitude = latitude
        self.managerForInstance = Ride.manager
    }
    
    @objc func copyWithZone(_zone: NSZone) -> AnyObject {
        return self
    }
    
    
    func post(response:Response<Ride, NSError> -> Void){
        let urlRequest = NSMutableURLRequest(URL: NSURL(string:"http://localhost:8080/rides")!)
        urlRequest.HTTPMethod = Alamofire.Method.POST.rawValue
        do{
            urlRequest.HTTPBody = try NSJSONSerialization.dataWithJSONObject(self.toDictionary(), options: NSJSONWritingOptions())
        }catch{
            // No op
        }
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        managerForInstance.request(urlRequest).responseDecodable(completionHandler:response)
    }
    
    static func Get(rideId:String = "", response:Response<[Ride], NSError> -> Void){
        URLRequest.HTTPMethod = Alamofire.Method.GET.rawValue
        manager.request(Ride.URLRequest).responseDecodable(completionHandler: response)
    }
    
    private func toDictionary()->[String:String]{
        var result = [String:String]()
        result["rideSharer"] = "1"
        result["destination"] = self.destination
        result["timeLeaving"] = self.timeLeaving
        result["duration"] = self.duration.description
        result["availableSeats"] = self.availableSeats.description
        result["latitude"] = "0.0"
        result["longitude"] = "0.0"
        return result
    
    }
    
    
    
    static func decode(json: JSON) -> Decoded<Ride> {
        let create =  curry(Ride.init)
        return create
        <^> json <| "id"
        <*> json <| ["rideSharer","id"]
        <*> json <| "destination"
        <*> json <| "timeLeaving"
        <*> json <| "duration"
        <*> json <| "availableSeats"
        <*> json <| "latitude"
        <*> json <| "longitude"
    }
    
    
}