//
//  TipInCellAnimator.swift
//  Pulga Latina
//
//  Created by Michael Gu on 10/26/14.
//  Copyright (c) 2014 Gutang. All rights reserved.
//

import Foundation
import UIKit

class TipInCellAnimator {
    
    class func animate(cell: UITableViewCell) {
        let view = cell.contentView
        view.layer.opacity = 0.1
        UIView.animateWithDuration(1.4) {
            view.layer.opacity = 1.0
        }
    }
}
