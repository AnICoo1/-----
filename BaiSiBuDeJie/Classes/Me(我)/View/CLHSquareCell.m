//
//  CLHSquareCell.m
//  BaiSiBuDeJie
//
//  Created by AnICoo1 on 17/1/22.
//  Copyright © 2017年 AnICoo1. All rights reserved.
//

#import "CLHSquareCell.h"
#import "UIImageView+WebCache.h"
#import "CLHSquareItem.h"

@interface CLHSquareCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageV;

@property (weak, nonatomic) IBOutlet UILabel *nameL;


@end



@implementation CLHSquareCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setItem:(CLHSquareItem *)item{
    
    _item = item;
    self.nameL.text =  item.name;
    [self.imageV sd_setImageWithURL:[NSURL URLWithString:item.icon]];
    
}

@end
