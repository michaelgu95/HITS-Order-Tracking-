//
//  DetailViewController.swift
//  Pulga Latina
//
//  Created by Michael Gu on 10/18/14.
//  Copyright (c) 2014 Gutang. All rights reserved.
//

import UIKit

var DisplayedAdContent:String = ""
var DisplayedEmail:String = ""

class DetailViewController: UIViewController {
    
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var webView: UIWebView!

    var detailItem: AnyObject? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
    
        webView.loadHTMLString(DisplayedAdContent, baseURL: nil)
        var nav = self.navigationController?.navigationBar
        nav?.tintColor = UIColor.whiteColor()
        nav?.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.blueColor()]
        nav?.barTintColor = UIColorFromRGB(0x067AB5)
      
        var tLabel = UILabel(frame: CGRectMake(0, 0, 200, 40))
        tLabel.textColor = UIColor.whiteColor()
        tLabel.adjustsFontSizeToFitWidth = true
        self.navigationItem.titleView = tLabel
       
        emailLabel.text = DisplayedEmail
      
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
       
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

