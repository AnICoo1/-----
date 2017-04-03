//
//  CLHCategoryCell.m
//  BaiSiBuDeJie
//
//  Created by AnICoo1 on 17/2/15.
//  Copyright © 2017年 AnICoo1. All rights reserved.
//

#import "CLHCategoryCell.h"
#import "CLHCommendCategory.h"

@interface CLHCategoryCell ()

@property (weak, nonatomic) IBOutlet UIView *selectedView;


@end


@implementation CLHCategoryCell

- (void)awakeFromNib{
    self.backgroundColor = CLHRGBColor(244, 244, 244);
    self.selectedView.backgroundColor = CLHRGBColor(219, 21, 26);
}

- (void)setCategory:(CLHCommendCategory *)category{
    
    _category = category;
    self.textLabel.text = category.name;
}
//调整label的位置
- (void)layoutSubviews
{
    self.textLabel.y = 2;
    self.textLabel.x = 2;

    self.textLabel.height = self.contentView.height - 2 * self.textLabel.y;
    self.textLabel.frame = CGRectMake(10, 2, 300, 44);

    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated{
    [super setSelected:selected animated:animated];
    
    self.selectedView.hidden = !self.selected;
    self.textLabel.textColor = selected ? self.selectedView.backgroundColor:CLHRGBColor(78, 78, 78);
}

@end
