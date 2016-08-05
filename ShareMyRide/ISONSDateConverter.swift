//
//  ISONSDateConverter.swift
//  ShareMyRide
//  https://github.com/justinmakaila/NSDate-ISO-8601/blob/master/NSDateISO8601.swift
//  Created by Dennis Adjei-Baah on 4/24/16.
//  Copyright © 2016 Dennis Adjei-Baah. All rights reserved.
//

import Foundation
public extension NSDate{
    
    public class func ISOtoNSDate(date:String)-> NSDate{
    let utcformatter = NSDateFormatter()
    utcformatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    utcformatter.timeZone = NSTimeZone.init(name: "CDT")
    let convertedDate = utcformatter.dateFromString(date)
    return convertedDate!
       }
}