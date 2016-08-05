//
//  DestinationResultsController.swift
//  ShareMyRide
//
//  Created by Dennis Adjei-Baah on 7/11/16.
//  Copyright © 2016 Dennis Adjei-Baah. All rights reserved.
//

import Foundation
import UIKit
import MapKit

class DestinationResultsController: UITableViewController, UISearchControllerDelegate, UISearchResultsUpdating {
    
    var showLocationDelegate:DisplayMapSearchResult? = nil
    var mapView:MKMapView? = nil
    var searchResults:[MKMapItem] = []
    var results:[String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController){
        let searchText = searchController.searchBar.text
        let request = MKLocalSearchRequest()
        request.naturalLanguageQuery = searchText
        request.region = (mapView?.region)!
        let search = MKLocalSearch(request: request)
        search.startWithCompletionHandler({(response, _) in
            if let results = response{
                self.searchResults = results.mapItems
                self.tableView.reloadData()
            }
        
        })
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (searchResults.count)
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell")
        if(cell == nil){
            cell = UITableViewCell(style: .Default, reuseIdentifier: "cell")
        }
        cell!.textLabel?.text = searchResults[indexPath.row].name
        return cell!
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        showLocationDelegate?.showPlaceMarkPin(mapView!, placemark: searchResults[indexPath.row].placemark)
         dismissViewControllerAnimated(true, completion: nil)
    }
}