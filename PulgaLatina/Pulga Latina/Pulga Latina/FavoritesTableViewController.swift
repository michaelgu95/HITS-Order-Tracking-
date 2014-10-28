//
//  FavoritesTableViewController.swift
//  Pulga Latina
//
//  Created by Michael Gu on 10/24/14.
//  Copyright (c) 2014 Gutang. All rights reserved.
//

import Foundation
import UIKit


    var favoriteTitles: [String] = []
    var favoritePrices: [String] = []
    var favoriteLocations: [String] = []
    var favoriteImages: [UIImage] = []
    var favoriteAdContent: [String] = []
    var favoriteEmail: [String] = []

class FavoritesTableViewController:UITableViewController, UITableViewDataSource, UITableViewDelegate {
    
    override func viewDidLoad() {
        var nib = UINib(nibName: "AdCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "Ad")
        //removes divider line between cells
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        //creates custom navbar
        var nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.Black
        
        
        let image = UIImage(named: "32.png") as UIImage!
        //resize navbar image
        var newSize:CGSize = CGSize(width: 46,height: 46)
        let rect = CGRectMake(0,0, newSize.width, newSize.height)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.drawInRect(rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //set navbar image
        self.navigationItem.titleView = UIImageView(image: newImage)
        //nav?.setBackgroundImage(newImage, forBarMetrics: UIBarMetrics.Default)
        nav?.translucent = true
        nav?.barTintColor = UIColorFromRGB(0x067AB5)

    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return favoriteTitles.count
        
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 110
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:AdCell = tableView.dequeueReusableCellWithIdentifier("Ad") as AdCell
        var names = favoriteTitles[indexPath.row]
        var locations = favoriteLocations[indexPath.row]
        var prices = favoritePrices[indexPath.row]
        var adImage = favoriteImages[indexPath.row]
        cell.swipeEnabled = false
        cell.loadAd(names, price: prices, location: locations, adImage: adImage, adContent: nil, email: nil)
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        DisplayedAdContent = favoriteAdContent[indexPath.row] as String
        println(DisplayedAdContent)
        DisplayedEmail = favoriteEmail[indexPath.row] as String
        self.performSegueWithIdentifier("favoriteDetail", sender: tableView)
    }
    
    override func tableView(tableView: UITableView!, canEditRowAtIndexPath indexPath: NSIndexPath!) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView!, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath!) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
        favoriteTitles.removeLast()
        favoritePrices.removeLast()
        favoriteLocations.removeLast()
        favoriteImages.removeLast()
        favoriteAdContent.removeLast()
        favoriteEmail.removeLast()
        self.tableView.reloadData()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "favoriteDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                let controller = (segue.destinationViewController as UINavigationController).topViewController as DetailViewController
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
}