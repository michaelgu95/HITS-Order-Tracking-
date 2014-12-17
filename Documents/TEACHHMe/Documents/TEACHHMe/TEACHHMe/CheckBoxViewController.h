//
//  CheckBoxViewController.h
//  TEACHHMe
//
//  Created by Michael Gu on 11/23/14.
//  Copyright (c) 2014 Gutang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CheckList;

@interface CheckBoxViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic) CheckList *checkList;
@property (weak,nonatomic) NSMutableDictionary *checkBoxItems;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@end
