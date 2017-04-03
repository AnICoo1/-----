//
//  CLHTabBar.m
//  BaiSiBuDeJie
//
//  Created by AnICoo1 on 17/1/20.
//  Copyright © 2017年 AnICoo1. All rights reserved.
//

#import "CLHTabBar.h"

@interface CLHTabBar ()

@property(nonatomic, weak) UIButton *button;

@property(nonatomic, weak) UIControl *selectedButton;

@end

@implementation CLHTabBar

#pragma mark - 懒加载按钮
- (UIButton *)button{
    
    if(!_button){
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"tabBar_publish_icon"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"tabBar_publish_click_icon"] forState:UIControlStateHighlighted];
        [button sizeToFit];
        [self addSubview:button];
        _button = button;
    }
    return _button;
}


#pragma mark - 布局子控件
- (void)layoutSubviews{
    [super layoutSubviews];
    
    NSInteger count = self.items.count;
    NSInteger i = 0;
    CGFloat Width = self.bounds.size.width / (count + 1);
    CGFloat Height = self.bounds.size.height;
    
    for (UIControl *tabBarButton in self.subviews) {
        //因为可能存在其他的子控件，所以判断
        if([tabBarButton isKindOfClass:NSClassFromString(@"UITabBarButton")]){
            //为中间的按钮空出地方
            if(i == 2){
                i++;
            }
            CGFloat X = Width * i;
            CGFloat Y = 0;
            tabBarButton.frame = CGRectMake(X, Y, Width, Height);
            i++;
            
            // 监听点击
            [tabBarButton addTarget:self action:@selector(tabBarButtonClick:) forControlEvents:UIControlEventTouchUpInside];
            
            
        }
    }
    
    self.button.center = CGPointMake(self.bounds.size.width * 0.5, self.bounds.size.height * 0.5);
    [self.button addTarget:self action:@selector(publishButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)publishButtonClick:(UIButton *)button{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PublishButtonClickNotification" object:nil];
}

- (void)tabBarButtonClick:(UIControl *)tabBarButton
{
    if (self.selectedButton == tabBarButton) {
        // 发出通知，告知外界tabBarButton被重复点击了
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TabBarButtonDidRepeatClickNotification" object:nil];
    }
    
    self.selectedButton = tabBarButton;
}
@end
