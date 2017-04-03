//
//  CLHFastButton.m
//  BaiSiBuDeJie
//
//  Created by AnICoo1 on 17/1/22.
//  Copyright © 2017年 AnICoo1. All rights reserved.
//

#import "CLHFastButton.h"

@implementation CLHFastButton

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    // 设置图片位置
    self.imageView.y = 0;
    CGPoint imageCenter = self.imageView.center;
    imageCenter.x = self.width * 0.5;
    self.imageView.center = imageCenter;
    
    // 设置标题位置
    self.titleLabel.y = self.height - self.titleLabel.height;
    
    // 计算文字宽度 , 设置label的宽度
    [self.titleLabel sizeToFit];
    CGPoint titleCenter = self.titleLabel.center;
    titleCenter.x = self.width * 0.5;
    self.titleLabel.center = titleCenter;
    
}

@end
