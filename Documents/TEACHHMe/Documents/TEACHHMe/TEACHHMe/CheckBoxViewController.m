//
//  CheckBoxViewController.m
//  TEACHHMe
//
//  Created by Michael Gu on 11/23/14.
//  Copyright (c) 2014 Gutang. All rights reserved.
//

#import "CheckBoxViewController.h"
#import "CheckList.h"
#import "CheckListDetails.h"
#import <MagicalRecord/CoreData+MagicalRecord.h>




@interface CheckBoxViewController ()

@end

@implementation CheckBoxViewController
int _numberOfCells = 0;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!self.checkList){
        self.checkList = [CheckList MR_createEntity];
    }
    
    
   
 
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    UINib *checkBoxCellNib = [UINib nibWithNibName:@"CheckBoxCell" bundle:nil];
    [self.collectionView registerNib:checkBoxCellNib forCellWithReuseIdentifier:@"cell"];
    // Do any additional setup after loading the view.
   
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(800, 300)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    [self.collectionView setCollectionViewLayout:flowLayout];
    
   
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
    UICollectionViewCell *cell = [view dequeueReusableCellWithReuseIdentifier: @"cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(void)collectionView:(UICollectionView *)collectioNView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (IBAction)addCell:(id)sender {
    
    _numberOfCells++;
    
    [self.collectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:_numberOfCells-1 inSection:0]]];
    
   
        self.checkList.checkListItem = [CheckListDetails MR_createEntity];
    
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionView *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0; // This is the minimum inter item spacing, can be more
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
