//
//  CheckBoxCell.m
//  TEACHHMe
//
//  Created by Michael Gu on 11/23/14.
//  Copyright (c) 2014 Gutang. All rights reserved.
//

#import "CheckBoxCell.h"
#import "M13Checkbox.h"


@implementation CheckBoxCell
UIButton *checkbox;
BOOL checkBoxSelected;

- (void)awakeFromNib {
  
    self.layer.cornerRadius = 5;
    self.layer.masksToBounds = YES;
    
    self.textField.borderStyle = UITextBorderStyleRoundedRect;
   
    //Checkbox
    
    M13Checkbox *tint = [[M13Checkbox alloc] initWithFrame:CGRectMake(100,100, 80, 80) title:@"" checkHeight:80.0];
    tint.tintColor = [UIColor colorWithRed: 0.608 green: 0.967 blue: 0.646 alpha: 1];
 
    [self addSubview:tint];
}
                
-(void)checkboxSelected:(id)sender
    {
        checkBoxSelected = !checkBoxSelected;
        [checkbox setSelected:checkBoxSelected];
    }

@end
