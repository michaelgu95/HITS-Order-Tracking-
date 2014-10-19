//
//  DetailViewController.swift
//  Pulga Latina
//
//  Created by Michael Gu on 10/18/14.
//  Copyright (c) 2014 Gutang. All rights reserved.
//

import UIKit



class DetailViewController: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!

    var detailItem: AnyObject? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
    
            webView.loadHTMLString(adContent, baseURL: nil)
        
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

