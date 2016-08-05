//
//  Resource.swift
//  ShareMyRide
//
//  Created by Dennis Adjei-Baah on 5/24/16.
//  Copyright © 2016 Dennis Adjei-Baah. All rights reserved.
//

import Foundation
import Argo
import Curry
import Alamofire
import AlamoArgo

protocol RestDecodable:class, Decodable{
    
    var resourceName:String {get set}
    var id:String? {get set}
    func toDictionary()-> AnyObject
}

extension RestDecodable {
    
    var baseUrl:String { return "http://localhost:8000"}
   
    
    func delete(onSuccess:AnyObject -> Void, onFailure:NSError -> Void){
        let urlRequest = NSMutableURLRequest(URL: NSURL(string:"\(baseUrl)/\(resourceName)/\(id)")!)
        urlRequest.HTTPMethod = Alamofire.Method.DELETE.rawValue
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        do{
            urlRequest.HTTPBody = try NSJSONSerialization.dataWithJSONObject(toDictionary() as AnyObject, options: NSJSONWritingOptions())
            
        }catch{
            // No op
        }
        
    }
    
    
    
    
    func update<T:RestDecodable where T == T.DecodedType>(onSuccess:T -> Void, onFailure:NSError -> Void){
        let urlRequest = NSMutableURLRequest(URL: NSURL(string:"\(baseUrl)/\(resourceName)\(id)")!)
        urlRequest.HTTPMethod = Alamofire.Method.POST.rawValue
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        do{
            urlRequest.HTTPBody = try NSJSONSerialization.dataWithJSONObject(toDictionary() as AnyObject, options: NSJSONWritingOptions())
        }catch{
            // No op
        }
        postData(urlRequest, onSuccess:onSuccess, onFailure: onFailure)
        
    }
    
    func post<T:RestDecodable where T == T.DecodedType>(onSuccess:T -> Void, onFailure:NSError -> Void){
        let urlRequest = NSMutableURLRequest(URL: NSURL(string:"\(baseUrl)/\(resourceName)")!)
        urlRequest.HTTPMethod = Alamofire.Method.POST.rawValue
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        do{
            urlRequest.HTTPBody = try NSJSONSerialization.dataWithJSONObject(toDictionary() as AnyObject, options: NSJSONWritingOptions())
        }catch{
            // No op
        }
        postData(urlRequest,onSuccess: onSuccess, onFailure: onFailure)
    }
    
    
    func postData<T:RestDecodable where T == T.DecodedType>(url:NSMutableURLRequest, onSuccess:T -> Void, onFailure:NSError -> Void){
        
        Alamofire.request(url).responseDecodable{
            (response:Response<T, NSError>) in
            if response.result.isSuccess{
                if let ride = response.result.value{
                    onSuccess(ride)
                }
            }else{
                onFailure(response.result.error!)
            }
        }
    }
    
    func deleteData(onSuccess:Bool -> Void, onFailure:NSError -> Void){
        let urlRequest = NSMutableURLRequest(URL: NSURL(string:"\(baseUrl)/\(resourceName)\(id)")!)
        urlRequest.HTTPMethod = Alamofire.Method.POST.rawValue
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        Alamofire.request(urlRequest)
            .validate()
            .responseJSON{ response in
                switch response.result{
                case .Success:
                    onSuccess(true)
                case .Failure(let error):
                    onFailure(error)
                }
        }
    }

        
        
    

}
