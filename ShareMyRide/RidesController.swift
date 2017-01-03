//
//  RidesController.swift
//  ShareMyRide
//
//  Created by Dennis Adjei-Baah on 2/25/16.
//  Copyright © 2016 Dennis Adjei-Baah. All rights reserved.
//

import Foundation
import UIKit
import Stormpath

import Alamofire

class RidesController:UITableViewController {
    
    let rideDetailSegue = "showRideDetail"
    
    @IBOutlet weak var editCommunityButton: UIBarButtonItem!
    var ridesViewModel:[Ride]!
    let user = CoreUser()
    var communityPicker:UIPickerView!
    var errorMessage:UIView!
    
    override func viewDidLoad() {
     
        ridesViewModel = []
        communityPicker = UIPickerView()
        self.tableView.tableHeaderView = UIScrollView()
        errorMessage = NSBundle.mainBundle().loadNibNamed("RideTableError", owner: self, options: nil).first as! UIView
        
        
    }
    
     @IBAction func facebookLogout(sender: AnyObject) {
        FBSDKLoginManager().logOut()
        Stormpath.sharedSession.logout()
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
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        var rideToDelete:Ride = ridesViewModel[indexPath.row] as Ride
        if editingStyle == .Delete && rideToDelete.riderSharer != "577070f01e9f5d2614de1eb4"{
            Alamofire.request(.DELETE, "http://localhost:8000/\(rideToDelete.resourceName)/\(rideToDelete.id!)")
                .validate()
                .responseJSON(completionHandler: { (response:Response<AnyObject, NSError>) in
                    switch response.result{
                    case .Success:
                        self.ridesViewModel.removeAtIndex(indexPath.row)
                        self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                    case .Failure(let error):
                        print(error)
                    }
            })
        }else{
            
        }
    }
    
    override func tableView(tableView: UITableView, editingStyleForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCellEditingStyle {
         let rideToDelete:Ride = ridesViewModel[indexPath.row] as Ride
        if rideToDelete.riderSharer != "577070f01e9f5d2614de1eb4"{
            return .None
        }else{
            return .Delete
        }
    }
    
    
}

