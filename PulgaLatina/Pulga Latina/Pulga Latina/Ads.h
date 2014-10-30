//
//  Ads.h
//  Pulga Latina
//
//  Created by Michael Gu on 10/29/14.
//  Copyright (c) 2014 Gutang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Ads : NSManagedObject

@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSString * email;
@property (nonatomic, retain) NSString * price;
@property (nonatomic, retain) id title;

@end
