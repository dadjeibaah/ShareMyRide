//
//  RidesTableViewCell.swift
//  ShareMyRide
//
//  Created by Dennis Adjei-Baah on 2/25/16.
//  Copyright © 2016 Dennis Adjei-Baah. All rights reserved.
//

import Foundation
import UIKit
import DateTools



class RidesTableViewCell:UITableViewCell {
    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var destination: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var duration: UILabel!
    
    func loadCellWithRideInfo(ride:Ride){
        destination.text = ride.destinationName
        time.text = TimeViewService.timeUntilLeaving(ride.departureTime)
        duration.text = TimeViewService.totalDuration(ride.departureTime, end: ride.duration)
    }
    
}