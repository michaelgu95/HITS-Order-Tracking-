//
//  CheckListDetails.h
//  TEACHHMe
//
//  Created by Michael Gu on 12/13/14.
//  Copyright (c) 2014 Gutang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CheckList;

@interface CheckListDetails : NSManagedObject

@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSString * image;
@property (nonatomic, retain) NSNumber * checked;
@property (nonatomic, retain) CheckList *checkListItem;

@end
