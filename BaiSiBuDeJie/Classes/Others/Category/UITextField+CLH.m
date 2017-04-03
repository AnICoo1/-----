//
//  UITextField+CLH.m
//  BaiSiBuDeJie
//
//  Created by AnICoo1 on 17/1/22.
//  Copyright © 2017年 AnICoo1. All rights reserved.
//

#import "UITextField+CLH.h"
#import <objc/message.h>

@implementation UITextField (CLH)
+ (void)load
{
    // setPlaceholder
    Method setPlaceholderMethod = class_getInstanceMethod(self, @selector(setPlaceholder:));
    Method set_PlaceholderMethod = class_getInstanceMethod(self, @selector(set_Placeholder:));
    
    method_exchangeImplementations(setPlaceholderMethod, set_PlaceholderMethod);
}
- (void)setPlaceholderColor:(UIColor *)placeholderColor
{
    
    // 给成员属性赋值 runtime给系统的类添加成员属性
    // 添加成员属性
    objc_setAssociatedObject(self, @"placeholderColor", placeholderColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    // 获取占位文字label控件
    UILabel *placeholderLabel = [self valueForKey:@"placeholderLabel"];
    
    // 设置占位文字颜色
    placeholderLabel.textColor = placeholderColor;
}


- (UIColor *)placeholderColor
{
    return objc_getAssociatedObject(self, @"placeholderColor");
}

// 设置占位文字
// 设置占位文字颜色
- (void)set_Placeholder:(NSString *)placeholder
{
    [self set_Placeholder:placeholder];
    
    self.placeholderColor = self.placeholderColor;
}

@end
