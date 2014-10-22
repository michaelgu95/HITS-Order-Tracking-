//
//  AdCell.swift
//  Pulga Latina
//
//  Created by Michael Gu on 10/19/14.
//  Copyright (c) 2014 Gutang. All rights reserved.
//

import Foundation
import UIKit

class AdCell: UITableViewCell {
   
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet var adImageLabel: UIImageView!
    
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    func loadAd(title: String, price: String?, location: String?, adImage: UIImage?) {
        titleLabel.numberOfLines = 0
        locationLabel.numberOfLines = 0
        priceLabel.numberOfLines = 0
        
        titleLabel.text = title
        locationLabel.text = location
        priceLabel.text = price

        //configure the images
        
        //shadow
        adImageLabel.layer.shadowColor = UIColor.blueColor().CGColor!
        adImageLabel.layer.shadowOffset = CGSizeMake(0, 1)
        adImageLabel.layer.shadowOpacity = 1
        adImageLabel.layer.shadowRadius = 4.0
       adImageLabel.clipsToBounds = true
        
        //rounded border
        adImageLabel.layer.cornerRadius = 3.0
        adImageLabel.image =  adImage
        adImageLabel.contentMode = UIViewContentMode.ScaleAspectFill
        adImageLabel.autoresizingMask = (UIViewAutoresizing.FlexibleBottomMargin|UIViewAutoresizing.FlexibleHeight|UIViewAutoresizing.FlexibleLeftMargin|UIViewAutoresizing.FlexibleRightMargin|UIViewAutoresizing.FlexibleTopMargin|UIViewAutoresizing.FlexibleWidth)
        
        
        
    }
}