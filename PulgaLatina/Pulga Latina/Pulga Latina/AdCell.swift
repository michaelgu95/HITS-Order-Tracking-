//
//  AdCell.swift
//  Pulga Latina
//
//  Created by Michael Gu on 10/19/14.
//  Copyright (c) 2014 Gutang. All rights reserved.
//

import Foundation
import UIKit



class AdCell: MGSwipeTableCell, MGSwipeTableCellDelegate {
   
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet  weak var locationLabel: UILabel!
    @IBOutlet var adImageLabel: UIImageView!
    
    
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    func loadAd(title: String, price: String?, location: String?, adImage: UIImage?, adContent: String?, email: String?) {
        titleLabel.numberOfLines = 0
        locationLabel.numberOfLines = 0
        priceLabel.numberOfLines = 0
        
        //set json data into cell
        titleLabel.text = title
        locationLabel.text = location
        priceLabel.text = price

        ////configure the images
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
        
        //favoriteImage
        var favoriteImage:UIImage! = UIImage(named: "32.png")
        var newSize:CGSize = CGSize(width: 46,height: 46)
        let rect = CGRectMake(0,0, newSize.width, newSize.height)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        favoriteImage.drawInRect(rect)
        let newFavoriteImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //shareImage
        var shareImage:UIImage! = UIImage(named: "55.png")
        var newSizeShare:CGSize = CGSize(width: 46,height: 46)
        let rectShare = CGRectMake(0,0, newSize.width, newSizeShare.height)
        UIGraphicsBeginImageContextWithOptions(newSizeShare, false, 1.0)
        shareImage.drawInRect(rectShare)
        let newShareImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        
        self.rightSwipeSettings.transition = MGSwipeTransition.Transition3D
        self.rightButtons = [
            
            MGSwipeButton(title: "Favorito", icon: newFavoriteImage, backgroundColor: UIColorFromRGB(0x067AB5), callback: { (sender) -> Bool in
        //send cell into favorites
                favoriteTitles.append(self.titleLabel.text!)
                favoritePrices.append(self.priceLabel.text!)
                favoriteLocations.append(self.locationLabel.text!)
                favoriteImages.append(adImage!)
                favoriteAdContent.append(adContent!)
                favoriteEmail.append(email!)
            return true}),
            MGSwipeButton(title: "Compartir", icon: newShareImage, backgroundColor: UIColorFromRGB(0x067AB5), callback:{ (sender) -> Bool in
            println("yes")
            return true
        })]
        
        func swipeTableCell(cell: MGSwipeTableCell!, canSwipe direction: MGSwipeDirection) -> Bool {
            return true
        }
    
    }
}
