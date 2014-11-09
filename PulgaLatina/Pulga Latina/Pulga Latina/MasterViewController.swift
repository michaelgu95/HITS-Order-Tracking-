//
//  MasterViewController.swift
//  Pulga Latina
//
//  Created by Michael Gu on 10/18/14.
//  Copyright (c) 2014 Gutang. All rights reserved.
//


import UIKit
import CoreData



public func UIColorFromRGB(rgbValue: UInt) -> UIColor {
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}

class MasterViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate, UITabBarControllerDelegate {
    var window: UIWindow?
    var namesToSearch:Array<String> = []
    var rowData: NSDictionary!
    var refresher: UIRefreshControl!
    var jsonURL:NSURL!
    var jsonURLString:String!
    var loadedCells = [AdCell]()
    var filteredCells = [AdCell]()
    var adData: NSMutableArray = []
    var newAdData: Array <AnyObject> = []
    //variables to store cell values
    var detailViewController: DetailViewController? = nil
    var managedObjectContext: NSManagedObjectContext? = nil
    var cellsAlreadyLoaded: Bool = false
    @IBOutlet var adTableView : UITableView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            self.clearsSelectionOnViewWillAppear = false
            self.preferredContentSize = CGSize(width: 320.0, height: 600.0)
            
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
                   }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        appDelegate.setTabBarColors()
        
        // Do any additional setup after loading the view, typically from a nib.
        
        //sets background of tableview
        adTableView.separatorInset = UIEdgeInsetsZero
        let backgroundImage = UIImage(named: "graygradient.jpg") as UIImage!
        let tableViewBackground = UIImageView(image: backgroundImage) as UIImageView
        tableViewBackground.frame = self.adTableView.frame
        self.adTableView.backgroundView = tableViewBackground
        
        //removes divider line between cells
        adTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        
        //creates custom navbar
        var nav = self.navigationController?.navigationBar
        nav?.barStyle = UIBarStyle.Black
        
        
        let image = UIImage(named: "pulga.png") as UIImage!
        //resize navbar image
        var newSize:CGSize = CGSize(width: 190,height: 54)
               let newImage = image.imageScaledToFitSize(newSize)
        
        //set navbar image
        self.navigationItem.titleView = UIImageView(image: newImage)
        //nav?.setBackgroundImage(newImage, forBarMetrics: UIBarMetrics.Default)
        nav?.translucent = true
        nav?.barTintColor = UIColorFromRGB(0x067AB5)
       

        //load nib
        var nib = UINib(nibName: "AdCell", bundle: nil)
        adTableView.registerNib(nib, forCellReuseIdentifier: "Ad")
        
        //load json
        jsonURLString = "http://www.pulgalatina.com/api/v1/ads/?format=json&page=1"
        jsonURL = NSURL(string: jsonURLString)
        if !cellsAlreadyLoaded {
        loadJSON(jsonURL)
        }

        self.tableView.addInfiniteScrollingWithActionHandler({
            self.loadNewJSON()
            
            self.tableView.infiniteScrollingView.stopAnimating()
        })

    }

    
    func loadJSON(jsonURL: NSURL){
        var request: NSURLRequest = NSURLRequest(URL:jsonURL)
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session  = NSURLSession(configuration: config)
        let task: NSURLSessionDataTask = session.dataTaskWithRequest(request, completionHandler: {(data, response, error)  in
            if error != nil {
                println(error.localizedDescription)
            }
            var err: NSError?
            if var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as? NSDictionary {
            let results = jsonResult["results"] as NSMutableArray
            
            dispatch_async(dispatch_get_main_queue(), {
                self.adData = results as NSMutableArray
                self.adTableView!.reloadData()
            })
            }
            
        })
        task.resume()
        cellsAlreadyLoaded = true
        
    }
    
    func loadNewJSON(){
        var page = jsonURLString.componentsSeparatedByString("page=")
        var pageNumber:Int = page[1].toInt()!
        pageNumber += 1
        jsonURLString = "http://www.pulgalatina.com/api/v1/ads/?format=json&page=\(pageNumber)"
        jsonURL = NSURL(string: jsonURLString)
        var request: NSURLRequest = NSURLRequest(URL:jsonURL)
        let config = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session  = NSURLSession(configuration: config)
        let task: NSURLSessionDataTask = session.dataTaskWithRequest(request, completionHandler: {(data, response, error)  in
            if error != nil {
                println(error.localizedDescription)
            }
            var err: NSError?
            var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as NSDictionary
            let results: Array = jsonResult["results"] as NSArray
            
          
                self.newAdData = results
                for object in self.newAdData {
                    self.adData.addObject(object)
                    println(self.adData)
                    self.adTableView!.beginUpdates()
                    var indexPath: NSIndexPath = NSIndexPath(forRow: self.adData.count  - 1 , inSection: 0)
                    var indexPaths = [indexPath]
                    self.adTableView!.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Fade)
                    self.adTableView!.endUpdates()
                    self.adTableView!.reloadData()

                    }
      
            
        })
        task.resume()
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            if let indexPath = self.tableView.indexPathForSelectedRow() {
          
                let controller = (segue.destinationViewController as UINavigationController).topViewController as DetailViewController
               
                let rowData: NSDictionary = self.adData[indexPath.row] as NSDictionary
                var adContents = rowData["description"] as? String
                var  emails = rowData["email"] as? String
               
                controller.detailAdContent = adContents
                controller.detailAdEmail = emails
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
        
        if segue.identifier == "search" {
            let controller: SearchController = segue.destinationViewController as SearchController
            controller.loadedCells = self.loadedCells 

        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
 
        self.performSegueWithIdentifier("showDetail", sender: tableView)
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
            return adData.count
        
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 110
    }
    

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var rowData: NSDictionary
        var cell:AdCell = self.tableView.dequeueReusableCellWithIdentifier("Ad") as AdCell
    
            //store json objects into variables
            rowData = self.adData[indexPath.row] as NSDictionary
            var names =  rowData["name"] as? String
            var locations = rowData["city"] as? String
            var prices = rowData["price"] as? String
            var URL =  rowData["primary_image_url"] as String
            var fullURL = "http://www.pulgalatina.com" + URL
            var adImagesNSURL: NSURL! = NSURL(string: fullURL)
            var adImagesData: NSData! = NSData(contentsOfURL: adImagesNSURL)
            var adImage = UIImage(data:adImagesData)!
            var adContents = rowData["description"] as? NSString
            var emails = rowData["email"] as?String
        
        
            cell.swipeEnabled = true
            cell.loadAd(names!, price: prices, location: locations, adImage: adImage, adContent: adContents, email: emails)
            //add already loaded cells to loadedCells array for search function
                loadedCells.append(cell)
        
        
        return cell
    }
    
}

