//  
//  CheckBoxCell.m
//  TEACHHMe
//
//  Created by Michael Gu on 11/23/14.
//  Copyright (c) 2014 Gutang. All rights reserved.
//

#import "CheckBoxCell.h"
#import "AppDelegate.h"
#import "M13Checkbox.h"
#import "GKImagePicker.h"

@implementation CheckBoxCell
NSManagedObjectContext *_localContext;
UIButton *_checkbox;
BOOL checkBoxSelected;


- (void)awakeFromNib {
    self.item = [CheckListItem MR_createEntity];
    self.item.date = [NSDate date];
    [self.descriptionTextView setDelegate:self];
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;

   
    //Checkbox
    M13Checkbox *box = [[M13Checkbox alloc] initWithFrame:CGRectMake(100,100, 80, 80) title:@"" checkHeight:80.0];
    box.tintColor = [UIColor colorWithRed: 0.608 green: 0.967 blue: 0.646 alpha: 1];
 
    [self addSubview:box];
}


-(void)textViewDidChange:(UITextView *)textView{
    
        NSString *name = self.descriptionTextView.text;
        self.item.name = name;
}

                
-(void)checkboxSelected:(id)sender
    {
        checkBoxSelected = !checkBoxSelected;
        [_checkbox setSelected:checkBoxSelected];
        
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
            
            if(checkBoxSelected){
                self.item.checked = [NSNumber numberWithBool:YES];
            }else{
                self.item.checked = [NSNumber numberWithBool:NO];
            }
        }];
      
    }


@end
