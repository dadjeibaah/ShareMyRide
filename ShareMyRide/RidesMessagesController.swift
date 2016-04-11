//
//  RidesMessagesController.swift
//  ShareMyRide
//
//  Created by Dennis Adjei-Baah on 3/2/16.
//  Copyright © 2016 Dennis Adjei-Baah. All rights reserved.
//

import Foundation
class RidesMessagesController:UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1;
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell")!
        cell.textLabel?.text = "Dennis"
        return cell
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)
        let navigation = segue.destinationViewController as! UINavigationController
        let controller = navigation.viewControllers.first as! RideConversationController
        controller.senderId = "1"
        controller.senderDisplayName = "Dennis"
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.performSegueWithIdentifier("showConversation", sender: self)
        
    }
    
    @IBAction func unwindToListOfMessages(sender:UIStoryboardSegue){
        
    }
}
