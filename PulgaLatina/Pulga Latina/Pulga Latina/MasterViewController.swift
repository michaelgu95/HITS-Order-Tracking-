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

class MasterViewController: UITableViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UISearchDisplayDelegate, UITabBarControllerDelegate {
    var window: UIWindow?
    var namesToSearch:Array<String> = []
    var rowData: NSDictionary!
    var refresher: UIRefreshControl!
    var jsonURL:NSURL!
    var jsonURLString:String!
    var loadedCells: [AdCell]!
    var filteredCells: [AdCell]!
    var adData = []
    //variables to store cell values
    var names: String?
    var prices: String?
    var locations: String?
    var adImage:UIImage?
    var adContents: NSString?
    var emails: String?
    var detailViewController: DetailViewController? = nil
    var managedObjectContext: NSManagedObjectContext? = nil
    var isFiltered: Bool = false


    
    
    
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
    
//    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
//            TipInCellAnimator.animate(cell)
//    }
    
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
        
        
        let image = UIImage(named: "pulgalogo.png") as UIImage!
        //resize navbar image
        var newSize:CGSize = CGSize(width: 320,height: 46)
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
       

        //load nib
        var nib = UINib(nibName: "AdCell", bundle: nil)
        adTableView.registerNib(nib, forCellReuseIdentifier: "Ad")
        
        //load json
        jsonURLString = "http://www.pulgalatina.com/api/v1/ads/?format=json&page=1"
        jsonURL = NSURL(string: jsonURLString)
        loadJSON(jsonURL)
        
        //make pull to refresh
        refresher = UIRefreshControl()
        refresher.attributedTitle = NSAttributedString(string: "Nuevos Anuncios")
        refresher.addTarget(self, action: "loadNewJSON", forControlEvents: UIControlEvents.ValueChanged)
        adTableView.addSubview(refresher)

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
            var jsonResult = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &err) as NSDictionary
            let results: NSArray = jsonResult["results"] as NSArray
            
            dispatch_async(dispatch_get_main_queue(), {
                self.adData = results
                self.adTableView!.reloadData()
            })
            
        })
        task.resume()
    }
    
    func loadNewJSON(){
        var page = jsonURLString.componentsSeparatedByString("page=")
        var pageNumber:Int = page[1].toInt()!
        pageNumber += 1
        jsonURLString = "http://www.pulgalatina.com/api/v1/ads/?format=json&page=\(pageNumber)"
        jsonURL = NSURL(string: jsonURLString)
        println(jsonURL)
        loadJSON(jsonURL)
        self.adTableView.reloadData()
        refresher.endRefreshing()
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
    
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltered == true {
            return filteredCells.count
        } else {
            return adData.count
        }
        
        
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 110
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var rowData: NSDictionary
        var cell:AdCell = tableView.dequeueReusableCellWithIdentifier("Ad") as AdCell
        if filteredCells != nil && tableView == self.searchDisplayController!.searchResultsTableView {
            var filteredCell = filteredCells[indexPath.row]
            names = filteredCell.titleLabel.text
            locations = filteredCell.locationLabel.text
            prices = filteredCell.priceLabel.text
            adImage = filteredCell.adImageLabel.image
            adContents = filteredCell.listedAdContent
            emails = filteredCell.listedAdEmail
        } else{
            //store json objects into variables
            rowData = self.adData[indexPath.row] as NSDictionary
            names =  rowData["name"] as? String
            locations = rowData["city"] as? String
            prices = rowData["price"] as? String
            var URL =  rowData["primary_image_url"] as String
            var fullURL = "http://www.pulgalatina.com" + URL
            var adImagesNSURL: NSURL! = NSURL(string: fullURL)
            var adImagesData: NSData! = NSData(contentsOfURL: adImagesNSURL)
            adImage = UIImage(data:adImagesData)!
            adContents = rowData["description"] as? NSString
            emails = rowData["email"] as?String
        }
        
            cell.swipeEnabled = true
            cell.loadAd(names!, price: prices, location: locations, adImage: adImage, adContent: adContents, email: emails)
            if loadedCells != nil {
                loadedCells.append(cell)
            }
         return cell
        }
    
    
   override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
       let rowData: NSDictionary = self.adData[indexPath.row] as NSDictionary
        var adContents = rowData["description"] as? String
        var  emails = rowData["email"] as? String
        displayedAdContent = adContents
        displayedEmail = emails
        self.performSegueWithIdentifier("showDetail", sender: tableView)
    }

    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchString searchString: String!) -> Bool {
        self.filterContentForSearchText(searchString)
        return true
    }
    
//    func searchBar(searchBar: UISearchBar!, textDidChange searchText: NSString) {
//        if searchText.length == 0 {
//            isFiltered = false
//        } else{
//            isFiltered = true
//            for( var i = 0; i < adData.count ;i++) {
//                var name = self.adData[i]["name"] as String
//                var nameRange = name.rangeOfString(searchText)
//                    if nameRange != nil {
//                        filteredItems.append(adData[i])
//                    }
//            }
//        }
//    }
    
    func searchDisplayController(controller: UISearchDisplayController!, shouldReloadTableForSearchScope searchOption: Int) -> Bool {
        self.filterContentForSearchText(self.searchDisplayController!.searchBar.text)
        return true
    }
    
    func filterContentForSearchText(searchText: NSString){
        
        if searchText.length == 0 {
            isFiltered = false
        } else {
            isFiltered = true
        var scope = String()
        
            filteredCells = loadedCells.filter({ (ad: AdCell) -> Bool in
            let locationMatch = (scope == "All") || (ad.locationLabel.text == scope)
            let stringMatch = ad.titleForSearch.rangeOfString(searchText)
            return locationMatch && (stringMatch != nil)
            })
        }
    }
}
    
