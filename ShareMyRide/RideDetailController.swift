//
//  RideDetailController.swift
//  ShareMyRide
//
//  Created by Dennis Adjei-Baah on 5/10/16.
//  Copyright © 2016 Dennis Adjei-Baah. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

class RideDetailController:UIViewController {
    var rideDetail:Ride!
    let user = CoreUser()
    
    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var timeLeavinglabel: UILabel!
    @IBOutlet weak var duration: UILabel!
    
    @IBOutlet weak var rideAlongButton: UIButton!
    override func viewDidLoad() {
        destinationLabel.text = rideDetail.destinationName
        timeLeavinglabel.text = TimeViewService.timeUntilLeaving(rideDetail.departureTime)
        duration.text = TimeViewService.totalDuration(rideDetail.departureTime, end: rideDetail.duration)

    }
    
    override func viewDidAppear(animated: Bool) {
        if rideDetail.riderSharer == user.id{
            rideAlongButton.hidden = true
        }
    }
    
    @IBAction func requestRideAlong(sender: AnyObject) {
    
        if rideDetail.riderSharer != user.id{
            rideDetail.rideAlongs.append(user.id)
            rideDetail.update({(response:Ride) in
                
                }, onFailure: {(error:NSError) in
                    print(error)
            })
        }
        
       
    }
}
