//
//  Constants.swift
//  ShareMyRide
//
//  Created by Dennis Adjei-Baah on 8/21/16.
//  Copyright © 2016 Dennis Adjei-Baah. All rights reserved.
//

import Foundation

    #if DEBUG
    let MY_API_URL = "http://localhost:8000"
    #elseif STAGING
    let MY_API_URL = "https://ridealong-api.herokuapp.com"
    #endif

