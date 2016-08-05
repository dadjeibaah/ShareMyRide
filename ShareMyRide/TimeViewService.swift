//
//  TimeViewService.swift
//  ShareMyRide
//
//  Created by Dennis Adjei-Baah on 7/2/16.
//  Copyright © 2016 Dennis Adjei-Baah. All rights reserved.
//

import Foundation
import DateTools

public class TimeViewService{
    static func totalDuration(start:String, end:String) -> String{
        let startDate = NSDate.ISOtoNSDate(start)
        let endDate = NSDate.ISOtoNSDate(end)
        let timePeriod = DTTimePeriod(startDate: startDate, endDate: endDate)
        var returnString:String
        switch timePeriod.durationInMinutes() {
        case 1..<60:
            returnString = String(format: "%02d mins", Int(timePeriod.durationInMinutes()) )
        case 60:
            returnString = String(format: "%d hour", Int(timePeriod.durationInHours()))
        default:
            returnString = String(format: "%d hours", Int(timePeriod.durationInHours()))
        }
        return returnString
        
    }
    
    static func timeUntilLeaving(timeLeaving:String)-> String{
        let date = Double(NSDate.ISOtoNSDate(timeLeaving).hoursUntil())
        if date >= 24{
            return String(format:"%02d days", NSDate.ISOtoNSDate(timeLeaving).daysUntil())
        }else if date < 24 && date > 1 {
            return String(format:"%02d hours", Int(date))
        }else if date <= 1 && date > 0 {
            return String(format: "%02d minutes", Int(NSDate.ISOtoNSDate(timeLeaving).minutesUntil()))
        }else{
            return "Past"
        }
    }

}