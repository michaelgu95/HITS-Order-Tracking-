//
//  AdCell.swift
//  Pulga Latina
//
//  Created by Michael Gu on 10/19/14.
//  Copyright (c) 2014 Gutang. All rights reserved.
//

import Foundation
import UIKit
import CoreData


let context = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext!


class AdCell: MGSwipeTableCell, MGSwipeTableCellDelegate {
   
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet  weak var locationLabel: UILabel!
    @IBOutlet var adImageLabel: UIImageView!
    var swipeEnabled: Bool?
    var newFavoriteAdded: Bool = false
    var listedAdContent: String!
    var listedAdEmail: String!
    var titleForSearch:String!
    var locationForSearch:String!
    
    
    func UIColorFromRGB(rgbValue: UInt) -> UIColor {
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
         
    func loadAd(title: String, price: String?, location: String?, adImage: UIImage?, adContent: String?, email: String?) {
        // variables for searchbar
        titleForSearch = title
        locationForSearch = location
        
        newFavoriteAdded = false
       
    
        listedAdContent = adContent
        listedAdEmail = email
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
        
        
        if swipeEnabled == true {
            self.rightSwipeSettings.transition = MGSwipeTransition.Transition3D
            self.rightButtons = [
            
                MGSwipeButton(title: "Favorito", icon: newFavoriteImage, backgroundColor: UIColorFromRGB(0x067AB5), callback: { (sender) -> Bool in
                    //send cell into favoriteTableViewController
                    favoriteTitles.append(self.titleLabel.text!)
                    favoritePrices.append(self.priceLabel.text!)
                    favoriteLocations.append(self.locationLabel.text!)
                    favoriteImages.append(adImage!)
                    favoriteAdContent.append(self.listedAdContent!)
                    favoriteEmail.append(self.listedAdEmail!)
                 
                    
                    coreDataEnabled = true
                    
                    //HUD
                    var hud = HUDContentView.SubtitleView(subtitle: "Favorito Añadido", image: newFavoriteImage )
                    HUDController.sharedController.contentView = hud
                    HUDController.sharedController.dimsBackground = true
                    HUDController.sharedController.show()
                    HUDController.sharedController.hide(afterDelay: 0.83)
                    
                    //add favorite to CoreData
                    let entityDescription = NSEntityDescription.entityForName("FavoriteAd", inManagedObjectContext: context)
                    let task = Pulga_Latina(entity: entityDescription!, insertIntoManagedObjectContext: context)
                    task.favTitle = self.titleLabel.text!
                    task.favPrice = self.priceLabel.text!
                    task.favLocation = self.locationLabel.text!
                    task.favContent = self.listedAdContent!
                    task.favEmail = self.listedAdEmail!
                    task.favImage = UIImagePNGRepresentation(adImage!)
                    context.save(nil)
                    return true})
            ]
        }
        
        func swipeTableCell(cell: MGSwipeTableCell!, canSwipe direction: MGSwipeDirection) -> Bool {
            return true
            
        }
        
        
    }
}
