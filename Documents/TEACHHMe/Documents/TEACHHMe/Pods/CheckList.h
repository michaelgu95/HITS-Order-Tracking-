//
//  CheckList.h
//  Pods
//
//  Created by Michael Gu on 12/12/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CheckListDetails;

@interface CheckList : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) CheckListDetails *checklistDetails;

@end
