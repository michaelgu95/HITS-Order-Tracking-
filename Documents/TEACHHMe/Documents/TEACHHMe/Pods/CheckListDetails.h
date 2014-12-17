//
//  CheckListDetails.h
//  Pods
//
//  Created by Michael Gu on 12/12/14.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CheckList;

@interface CheckListDetails : NSManagedObject

@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSString * image;
@property (nonatomic, retain) NSNumber * checked;
@property (nonatomic, retain) CheckList *checklist;

@end
