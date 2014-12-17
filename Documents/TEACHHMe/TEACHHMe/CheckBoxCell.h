//
//  CheckBoxCell.h
//  TEACHHMe
//
//  Created by Michael Gu on 11/23/14.
//  Copyright (c) 2014 Gutang. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>
#import "GKImagePicker.h"

@class CheckListItem;

@interface CheckBoxCell : UICollectionViewCell <UITextViewDelegate, GKImagePickerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>


@property (weak, nonatomic) IBOutlet UIButton *pickImageButton;
@property (weak, nonatomic) IBOutlet UITextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) CheckListItem *item;
@property(retain, nonatomic) UICollectionView *collectionView;

@end
