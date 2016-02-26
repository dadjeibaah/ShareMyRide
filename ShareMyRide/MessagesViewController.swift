//
//  MessagesViewController.swift
//  ShareMyRide
//
//  Created by Dennis Adjei-Baah on 2/26/16.
//  Copyright © 2016 Dennis Adjei-Baah. All rights reserved.
//

import Foundation
import UIKit

class RideMessagesController:JSQMessagesViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        self.senderId = "Test"
        self.senderDisplayName = "Dennis"
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
    }
}
