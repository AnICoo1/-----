//
//  CLHButton.m
//  BaiSiBuDeJie
//
//  Created by AnICoo1 on 17/1/25.
//  Copyright © 2017年 AnICoo1. All rights reserved.
//

#import "CLHButton.h"

@implementation CLHButton

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.font = [UIFont systemFontOfSize:16];
        [self setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
    }
    return self;
}
// 只要重写了这个方法，按钮就无法进入highlighted状态
- (void)setHighlighted:(BOOL)highlighted
{
    
}
@end
