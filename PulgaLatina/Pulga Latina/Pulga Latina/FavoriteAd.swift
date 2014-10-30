//
//  FavoriteAd.swift
//  Pulga Latina
//
//  Created by Michael Gu on 10/29/14.
//  Copyright (c) 2014 Gutang. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class FavoriteAd: NSManagedObject {
    
    @NSManaged var favTitle: String
    @NSManaged var favPrice: String
    @NSManaged var favLocation: String
    @NSManaged var favImage: UIImage
    @NSManaged var favContent: String
    @NSManaged var favEmail: String
    
     func execute(title: String?, price: String?, location: String?, adImage: UIImage?, adContent: String?, email: String?){
        let appDel:AppDelegate = (UIApplication.sharedApplication().delegate as AppDelegate)
        let context:NSManagedObjectContext = appDel.managedObjectContext!
        
        let entityDescripition = NSEntityDescription.entityForName("FavoriteAd", inManagedObjectContext: context)
        let contact = FavoriteAd(entity: entityDescripition!, insertIntoManagedObjectContext: context)
        
        favTitle = title!
        favPrice = price!
        favLocation = location!
        
        favContent = adContent!
        favEmail = email!
        context.save(nil)
    }
}