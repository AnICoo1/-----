//
//  CLHNavigationController.m
//  BaiSiBuDeJie
//
//  Created by AnICoo1 on 17/1/21.
//  Copyright © 2017年 AnICoo1. All rights reserved.
//

#import "CLHNavigationController.h"
#import "UIBarButtonItem+CLH.h"
@interface CLHNavigationController ()<UIGestureRecognizerDelegate>

@end

@implementation CLHNavigationController

+ (void)load
{
    UINavigationBar *navBar = [UINavigationBar appearanceWhenContainedIn:self, nil];
    
    // 设置导航条标题 => UINavigationBar
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont boldSystemFontOfSize:20];
    [navBar setTitleTextAttributes:attrs];
    
    // 设置导航条背景图片
    [navBar setBackgroundImage:[UIImage imageNamed:@"navigationbarBackgroundWhite"] forBarMetrics:UIBarMetricsDefault];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self.interactivePopGestureRecognizer.delegate action:@selector(handleNavigationTransition:)];
    
    [self.view addGestureRecognizer:pan];
    
    // 控制手势什么时候触发,只有非根控制器才需要触发手势
    pan.delegate = self;
    
    // 禁止之前手势
    self.interactivePopGestureRecognizer.enabled = NO;
    
    
}

#pragma mark - UIGestureRecognizerDelegate
// 决定是否触发手势
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    return self.childViewControllers.count > 1;
}

- (void)handleNavigationTransition:(UIPanGestureRecognizer *)pan{
    
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    //只有非根控制器才需要设置返回按钮
    if(self.childViewControllers.count > 0){
        
         viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem backItemWithimage:[UIImage imageNamed:@"navigationButtonReturn"] highImage:[UIImage imageNamed:@"navigationButtonReturnClick"]  target:self action:@selector(back) title:@"返回"];
        
        viewController.hidesBottomBarWhenPushed = YES;
    }
    
    [super pushViewController:viewController animated:animated];
}

- (void)back
{
    [self popViewControllerAnimated:YES];
}

@end
