//
//  CheckBoxViewController.m
//  TEACHHMe
//
//  Created by Michael Gu on 11/23/14.
//  Copyright (c) 2014 Gutang. All rights reserved.
//

#import "CheckBoxViewController.h"
#import "CheckBoxCell.h"
#import "UseCheckBoxViewController.h"
#import "MBProgressHUD.h"
#import "GKImagePicker.h"


@interface CheckBoxViewController ()

@end

@implementation CheckBoxViewController
@synthesize popoverController;
int _numberOfCells = 0;
UIImage *_imageForCell;
CheckBoxCell *_cellInUse;


- (void)viewDidLoad {
    [super viewDidLoad];       
    self.checkList = [CheckList MR_createEntity];
    [self.nameTextField setDelegate:self];
    self.collectionView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"darkgray.png"]];
    
    UINib *checkBoxCellNib = [UINib nibWithNibName:@"CheckBoxCell" bundle:nil];
    [self.collectionView registerNib:checkBoxCellNib forCellWithReuseIdentifier:@"checkBoxCell"];
    // Do any additional setup after loading the view.
   
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(800, 300)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    [self.collectionView setCollectionViewLayout:flowLayout];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:self.nameTextField];
    
}

- (IBAction)saveButtonPressed:(id)sender {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Saved!";
    hud.mode = MBProgressHUDAnimationZoomOut;
    [hud hide:YES afterDelay:1.4];
    NSLog(@"%@", self.checkList.name);
    _numberOfCells = 0;
}

- (IBAction)backButtonPressed:(id)sender {
    _numberOfCells = 0;
    [CheckList MR_truncateAllInContext:[NSManagedObjectContext MR_defaultContext]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UICollectionViewDatasource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section{
    return _numberOfCells;
}

-(UICollectionViewCell*)collectionView:(UICollectionView*)view cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CheckBoxCell *cell = [view dequeueReusableCellWithReuseIdentifier: @"checkBoxCell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
  
    cell.item.CheckList = self.checkList;
    _cellInUse = cell;
    
    [cell.pickImageButton addTarget:self action:@selector(showResizablePicker:) forControlEvents:UIControlEventTouchUpInside];

    return cell;
}

-(void)showResizablePicker:(UIButton*)btn{
    self.imagePicker = [[GKImagePicker alloc] init];
    self.imagePicker.cropSize = CGSizeMake(240, 200);
    self.imagePicker.delegate = self;
    self.imagePicker.resizeableCropArea = YES;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        self.popoverController = [[UIPopoverController alloc] initWithContentViewController:self.imagePicker.imagePickerController];
        [self.popoverController presentPopoverFromRect:btn.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        
    } else {
        
        [self presentViewController:self.imagePicker.imagePickerController animated:YES completion:nil];
        
    }
}


- (IBAction)addCell:(id)sender {
    
    _numberOfCells++;
    [self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:_numberOfCells-1 inSection:0]]];
   
}


- (void)textFieldDidChange:(NSNotification *)notification {
   self.checkList.name = self.nameTextField.text;
}

#pragma mark - Navigation

//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//
//}


# pragma mark -
# pragma mark GKImagePicker Delegate Methods

- (void)imagePicker:(GKImagePicker *)imagePicker pickedImage:(UIImage *)image{
    _cellInUse.imageView.image = image;
    [self hideImagePicker];
}

- (void)hideImagePicker{
    if (UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM()) {
        
        [self.popoverController dismissPopoverAnimated:YES];
        
    } else {
        
        [self.imagePicker.imagePickerController dismissViewControllerAnimated:YES completion:nil];
        
    }
}

# pragma mark -
# pragma mark UIImagePickerDelegate Methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    _imageForCell = image;
    
    if (UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM()) {
        
        [self.popoverController dismissPopoverAnimated:YES];
        
    } else {
        
        [picker dismissViewControllerAnimated:YES completion:nil];
        
    }
}

@end
