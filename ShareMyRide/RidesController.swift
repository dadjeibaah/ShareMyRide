//
//  RidesController.swift
//  ShareMyRide
//
//  Created by Dennis Adjei-Baah on 2/25/16.
//  Copyright © 2016 Dennis Adjei-Baah. All rights reserved.
//

import Foundation
import UIKit
import AlamoArgo
import Alamofire

class RidesController:UITableViewController {
    var ridesViewModel:[Ride]!
    var ridesSearch:UISearchController!
    var errorMessage:UIView!
    
    override func viewDidLoad() {
        ridesViewModel = []
        ridesSearch = UISearchController()
        errorMessage = NSBundle.mainBundle().loadNibNamed("RideTableError", owner: self, options: nil).first as! UIView
    }
    
    override func viewDidAppear(animated: Bool) {
        Ride.Get(
                 onSuccess: {
                    (response:[Ride]?) in
                    if let rides = response{
                        self.ridesViewModel = rides
                        self.tableView.reloadData()
                    }
            },
                 onFailure:{
                    (error:NSError) in
                    self.tableView.backgroundView = self.errorMessage
                    print(error)
                }
            )
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
    
    
}
