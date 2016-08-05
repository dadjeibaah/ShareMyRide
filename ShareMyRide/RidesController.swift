//
//  RidesController.swift
//  ShareMyRide
//
//  Created by Dennis Adjei-Baah on 2/25/16.
//  Copyright © 2016 Dennis Adjei-Baah. All rights reserved.
//

import Foundation
import UIKit

import Alamofire

class RidesController:UITableViewController {
    
    let rideDetailSegue = "showRideDetail"
    
    var ridesViewModel:[Ride]!
    var ridesSearch:UISearchController!
    let user = CoreUser()
    var errorMessage:UIView!
    
    override func viewDidLoad() {
     
        ridesViewModel = []
        ridesSearch = UISearchController()
        errorMessage = NSBundle.mainBundle().loadNibNamed("RideTableError", owner: self, options: nil).first as! UIView
        
        
    }
    
     @IBAction func facebookLogout(sender: AnyObject) {
        FBSDKLoginManager().logOut()
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "LoginState")
        self.transitionToLoginViewController()
    }
   
    override func viewDidAppear(animated: Bool) {
        let params = [
            "communityId":user.communities[0],
            "currentTime":NSDate().formattedDateWithFormat("yyyy-MM-dd'T'HH:mmZZZ")!
        ]
        
      
        Ride.nearby(params, onSuccess: {
            (rides:[Ride]) in
            self.ridesViewModel = rides
            self.tableView.reloadData()
            
            }, onFailure: {
                (error:NSError) in
                print(error)
        })
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return ridesViewModel.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let tableViewCell = tableView.dequeueReusableCellWithIdentifier("RidesTableViewCell", forIndexPath: indexPath) as! RidesTableViewCell
        tableViewCell.loadCellWithRideInfo(ridesViewModel[indexPath.row])
        return tableViewCell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == rideDetailSegue {
            let destinationVC = segue.destinationViewController as! RideDetailController
            destinationVC.rideDetail = ridesViewModel[(tableView.indexPathForSelectedRow?.row)!]
        }
    }
    
    
}
