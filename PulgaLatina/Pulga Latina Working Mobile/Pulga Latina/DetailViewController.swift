//
//  DetailViewController.swift
//  Pulga Latina
//
//  Created by Michael Gu on 10/18/14.
//  Copyright (c) 2014 Gutang. All rights reserved.
//

import UIKit
import CoreData

class DetailViewController: UIViewController {
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var webView: UIWebView!
    let context = (UIApplication.sharedApplication().delegate as AppDelegate).managedObjectContext!

    
    @IBAction dynamic func favoriteButton(sender: AnyObject) {
        favoriteTitles.append(detailAdTitle)
        favoritePrices.append(detailAdPrice)
        favoriteLocations.append(detailAdLocation)
        favoriteImages.append(detailAdImage!)
        favoriteAdContent.append(detailAdContent)
        favoriteEmail.append(detailAdEmail)
        
        coreDataEnabled = true
        var favoriteImage:UIImage! = UIImage(named: "32.png")
        var newSize:CGSize = CGSize(width: 46,height: 46)
        let newFavoriteImage = favoriteImage.imageScaledToFitSize(newSize)
        
//        //HUD
//        var hud = HUDContentView.SubtitleView(subtitle: "Favorito Añadido", image: newFavoriteImage )
//        HUDController.sharedController.contentView = hud
//        HUDController.sharedController.dimsBackground = true
//        HUDController.sharedController.show()
//        HUDController.sharedController.hide(afterDelay: 0.83)
        
        //add favorite to CoreData
        let entityDescription = NSEntityDescription.entityForName("FavoriteAd", inManagedObjectContext: context)
        let task = Pulga_Latina(entity: entityDescription!, insertIntoManagedObjectContext: context)
        task.favTitle = detailAdTitle
        task.favPrice = detailAdPrice
        task.favLocation = detailAdLocation
        task.favContent = detailAdContent
        task.favEmail = detailAdEmail
        task.favImage = UIImagePNGRepresentation(detailAdImage)
        context.save(nil)
    }
    
    var detailAdContent:String = ""
    var detailAdEmail:String = ""
    var detailAdLocation:String = ""
    var detailAdPrice:String = ""
    var detailAdTitle:String = ""
    var detailAdImage:UIImage?

    var detailItem: AnyObject? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        

        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.loadHTMLString(detailAdContent, baseURL: nil)
        webView.layer.cornerRadius = 10
        
        emailLabel.text = detailAdEmail

        // Do any additional setup after loading the view, typically from a nib.
        var nav = self.navigationController?.navigationBar
        
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()

        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
        nav?.tintColor = UIColor.whiteColor()
        
        var tLabel = UILabel(frame: CGRectMake(0, 0, 200, 40))
        tLabel.textColor = UIColor.whiteColor()
        tLabel.adjustsFontSizeToFitWidth = true
        self.navigationItem.titleView = tLabel

        
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func disablesAutomaticKeyboardDismissal() -> Bool {
        return false;
    }
}

