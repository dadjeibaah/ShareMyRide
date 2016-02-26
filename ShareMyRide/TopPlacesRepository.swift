//
//  TopPlacesRepository.swift
//  ShareMyRide
//
//  Created by Dennis Adjei-Baah on 2/19/16.
//  Copyright © 2016 Dennis Adjei-Baah. All rights reserved.
//

import Foundation

 class Places {
    var imageUrl:String?
    
    init(imageUrl:String){
        self.imageUrl = imageUrl
    }
    
}

 class TopPlacesRepository {
    static func getTopPlaces()-> [Places]{
        return [Places(imageUrl: "test1"), Places(imageUrl: "test2"), Places(imageUrl: "test3")]
    }
}
