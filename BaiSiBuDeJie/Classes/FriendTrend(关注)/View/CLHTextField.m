//
//  CLHTextField.m
//  BaiSiBuDeJie
//
//  Created by AnICoo1 on 17/1/22.
//  Copyright © 2017年 AnICoo1. All rights reserved.
//

#import "CLHTextField.h"


@implementation CLHTextField

- (void)awakeFromNib{
    //设置光标颜色为白色
    self.tintColor = [UIColor whiteColor];
    
    //监听事件
    [self addTarget:self action:@selector(textBegin) forControlEvents:UIControlEventEditingDidBegin];
    [self addTarget:self action:@selector(textEnd) forControlEvents:UIControlEventEditingDidEnd];
}

- (void)textBegin{
    self.placeholderColor = [UIColor whiteColor];
}

- (void)textEnd{
    self.placeholderColor = [UIColor lightGrayColor];
}


@end
