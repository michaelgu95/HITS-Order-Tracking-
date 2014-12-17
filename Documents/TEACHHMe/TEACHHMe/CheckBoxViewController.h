//
//  CheckBoxViewController.h
//  TEACHHMe
//
//  Created by Michael Gu on 11/23/14.
//  Copyright (c) 2014 Gutang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GKImagePicker.h"

@interface CheckBoxViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UITextFieldDelegate, GKImagePickerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic) CheckList *checkList;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
//GKProperties
@property (nonatomic, strong) GKImagePicker *imagePicker;
@property (nonatomic, strong) UIPopoverController *popoverController;
@property (nonatomic, strong) UIImagePickerController *ctr;

@end
