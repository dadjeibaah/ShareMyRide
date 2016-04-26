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
    
    override func viewDidLoad() {
        ridesViewModel = []
        ridesSearch = UISearchController()
    }
    
    override func viewDidAppear(animated: Bool) {
        Ride.Get(){
            (response:Response<[Ride], NSError>) in
            if let rides = response.result.value{
                self.ridesViewModel = rides
                self.tableView.reloadData()
            }
            else {print(response.result.error)}
        }
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
