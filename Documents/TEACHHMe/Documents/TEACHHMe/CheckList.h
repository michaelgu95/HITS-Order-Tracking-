//
//  CheckList.h
//  TEACHHMe
//
//  Created by Michael Gu on 12/13/14.
//  Copyright (c) 2014 Gutang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CheckListDetails;

@interface CheckList : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) CheckListDetails *checkListItem;

@end
