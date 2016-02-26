//
//  RidesController.swift
//  ShareMyRide
//
//  Created by Dennis Adjei-Baah on 2/25/16.
//  Copyright © 2016 Dennis Adjei-Baah. All rights reserved.
//

import Foundation
import UIKit
class RidesController:UITableViewController {
    
    var rides:[Rides]!
    var ridesSearch:UISearchController!
    
    override func viewDidLoad() {
        rides = [Rides()]
        ridesSearch = UISearchController()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rides.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let tableViewCell = tableView.dequeueReusableCellWithIdentifier("RidesTableViewCell", forIndexPath: indexPath)
        return tableViewCell
    }
    
    
}
