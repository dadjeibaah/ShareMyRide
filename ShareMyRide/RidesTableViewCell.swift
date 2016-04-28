//
//  RidesTableViewCell.swift
//  ShareMyRide
//
//  Created by Dennis Adjei-Baah on 2/25/16.
//  Copyright © 2016 Dennis Adjei-Baah. All rights reserved.
//

import Foundation
import UIKit




class RidesTableViewCell:UITableViewCell {
    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var destination: UILabel!
    @IBOutlet weak var time: UILabel!
    @IBOutlet weak var duration: UILabel!
    
    func loadCellWithRideInfo(ride:Ride){
        destination.text = ride.destination
        time.text = timeUntilLeaving(ride.timeLeaving)
        duration.text = String(format:"%02d mins", ride.duration)
    }
    
    func timeUntilLeaving(timeLeaving:String)-> String{
        let date = Int(NSDate.ISOtoNSDate(timeLeaving).hoursUntil())
        if date >= 24{
            return String(format:"%02d days", NSDate.ISOtoNSDate(timeLeaving).daysUntil())
        }else if date < 24 && date > 1 {
            return String(format:"%02d hours", date)
        }else if date <= 1 && date > 0 {
            return String(format: "%02d minutes", NSDate.ISOtoNSDate(timeLeaving).minutesUntil())
        }else{
            return "Past"
        }
    }
    
}