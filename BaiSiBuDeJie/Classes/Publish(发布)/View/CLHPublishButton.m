//
//  CLHButton.m
//  BaiSiBuDeJie
//
//  Created by AnICoo1 on 2017/3/18.
//  Copyright © 2017年 AnICoo1. All rights reserved.
//

#import "CLHPublishButton.h"

@implementation CLHPublishButton

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        self.titleLabel.tintColor = [UIColor blackColor];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.imageView.width = self.width * 0.6;
    self.imageView.height = self.imageView.width;
    self.imageView.y = self.height * 0.1;
    self.imageView.center = CGPointMake(self.width * 0.5, self.imageView.center.y);
    
    self.titleLabel.width = self.width;
    self.titleLabel.y = CGRectGetMaxY(self.imageView.frame);
    self.titleLabel.x = 0;
    self.titleLabel.height = self.height - self.titleLabel.y;
}

@end
