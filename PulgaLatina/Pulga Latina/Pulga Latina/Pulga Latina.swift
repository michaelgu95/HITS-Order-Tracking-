//
//  Pulga Latina.swift
//  Pulga Latina
//
//  Created by Michael Gu on 10/29/14.
//  Copyright (c) 2014 Gutang. All rights reserved.
//

import Foundation
import CoreData

class Pulga_Latina: NSManagedObject {

    @NSManaged var favContent: String?
    @NSManaged var favEmail: String?
    @NSManaged var favLocation: String?
    @NSManaged var favPrice: String?
    @NSManaged var favTitle: String?
    @NSManaged var favImage: NSData?
}
