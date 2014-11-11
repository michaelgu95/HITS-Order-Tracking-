//
//  FavoritesTableViewController.swift
//  Pulga Latina
//
//  Created by Michael Gu on 10/24/14.
//  Copyright (c) 2014 Gutang. All rights reserved.
//

import Foundation
import UIKit
import CoreData


    var favoriteTitles: [String] = []
    var favoritePrices: [String] = []
    var favoriteLocations: [String] = []
    var favoriteImages: [UIImage] = []
    var favoriteAdContent: [String] = []
    var favoriteEmail: [String] = []
    var coreDataEnabled:Bool = false


class FavoritesTableViewController:UITableViewController, UITableViewDataSource, UITableViewDelegate {
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
                     
        //load Nib
        var nib = UINib(nibName: "AdCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: "Ad")
        
        //retrieve from CoreData
               //removes divider line between cells
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        //creates custom navbar
        var nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.Black
        
        
        let image = UIImage(named: "32.png") as UIImage!
        //resize navbar image
        var newSize:CGSize = CGSize(width: 46,height: 46)
  
        let newImage = image.imageScaledToFitSize(newSize)
        
        //set navbar image
        self.navigationItem.titleView = UIImageView(image: newImage)
        //nav?.setBackgroundImage(newImage, forBarMetrics: UIBarMetrics.Default)
        nav?.translucent = true
        nav?.barTintColor = UIColorFromRGB(0x067AB5)
        
        //set background image
        let backgroundImage = UIImage(named: "graygradient.jpg") as UIImage!
        let tableViewBackground = UIImageView(image: backgroundImage) as UIImageView
        tableViewBackground.frame = self.tableView.frame
        self.tableView.backgroundView = tableViewBackground

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
  
    
    override func tableView(tableView: (UITableView!), canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
       //remove from favorite attributes arrays
        favoriteTitles.removeLast()
        favoritePrices.removeLast()
        favoriteLocations.removeLast()
        favoriteImages.removeLast()
        favoriteAdContent.removeLast()
        favoriteEmail.removeLast()
        //delete from CoreData
        managedObjectContext.deleteObject(fetchResults[indexPath.row+1 ])
        managedObjectContext.save(nil)
        self.tableView.reloadData()
        }
    }
    
    
    func controllerDidChangeContent(controller: NSFetchedResultsController!) {
        tableView.reloadData()
    }
   
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "favoriteDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                let controller = segue.destinationViewController as DetailViewController
                controller.detailAdContent = favoriteAdContent[indexPath.row] as String
                controller.detailAdEmail = favoriteEmail[indexPath.row] as String
                
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.performSegueWithIdentifier("favoriteDetail", sender: tableView)
    }
    
}
