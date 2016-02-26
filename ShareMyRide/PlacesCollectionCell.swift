//
//  PlacesCollectionCell.swift
//  ShareMyRide
//
//  Created by Dennis Adjei-Baah on 2/21/16.
//  Copyright © 2016 Dennis Adjei-Baah. All rights reserved.
//

import Foundation
import UIKit

class PlacesCollectionCell:UICollectionViewCell {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.cornerRadius = self.frame.size.width/2
    }

    
}
