//
//  MessagesViewController.swift
//  ShareMyRide
//
//  Created by Dennis Adjei-Baah on 2/26/16.
//  Copyright © 2016 Dennis Adjei-Baah. All rights reserved.
//

import Foundation
import UIKit

class RideConversationController:JSQMessagesViewController{
    
    
    
    override func viewDidLoad() {
        self.senderId = "1"
        self.senderDisplayName = "Dennis"
        super.viewDidLoad()
        
    }
    
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
    }
    
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
        
    }
}
