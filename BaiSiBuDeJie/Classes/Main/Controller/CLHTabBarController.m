//
//  CLHTabBarController.m
//  BaiSiBuDeJie
//
//  Created by AnICoo1 on 17/1/20.
//  Copyright © 2017年 AnICoo1. All rights reserved.
//

#import "CLHTabBarController.h"
#import "CLHNewViewController.h"
#import "CLHEssenceViewController.h"
#import "CLHMeTableViewController.h"
#import "CLHPublishViewController.h"
#import "CLHFriendTrendViewController.h"
#import "CLHTabBar.h"
#import "CLHNavigationController.h"
#import "UIImage+CLH.h"
#import "CLHPopViewController.h"



@interface CLHTabBarController ()

@end

@implementation CLHTabBarController


+ (void)load{
    
    //设置字体属性
    UITabBarItem *tab = [UITabBarItem appearanceWhenContainedIn:self, nil];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSForegroundColorAttributeName] = [UIColor blackColor];
    dict[NSFontAttributeName] = [UIFont systemFontOfSize:13];
    [tab setTitleTextAttributes:dict forState:UIControlStateNormal];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    //1.设置子控制器
    [self setUpChildViewController];
    //2.设置子控制器标题及图片
    [self setUpTitleForChildViewController];
    //3.自定义tabBar
    [self setUpTabBar];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(publishButtonClick) name:@"PublishButtonClickNotification" object:nil];
}

- (void)publishButtonClick{
    CLHPopViewController *popVC = [[CLHPopViewController alloc] init];
    [self presentViewController:popVC animated:YES completion:nil];
}

#pragma mark - 自定义tabBar
- (void)setUpTabBar{
    
    CLHTabBar *tabBar = [[CLHTabBar alloc] init];
    [self setValue:tabBar forKey:@"tabBar"];
    
}

#pragma mark - 设置子控制器
- (void)setUpChildViewController{
    //精华
    CLHEssenceViewController *essenceVC = [[CLHEssenceViewController alloc] init];
    CLHNavigationController *nav = [[CLHNavigationController alloc] initWithRootViewController:essenceVC];
    [self addChildViewController:nav];
    //新帖
    CLHNewViewController *newVC = [[CLHNewViewController alloc] init];
    CLHNavigationController *nav1 = [[CLHNavigationController alloc] initWithRootViewController:newVC];
    [self addChildViewController:nav1];
    //关注
    CLHFriendTrendViewController *friendVC = [[CLHFriendTrendViewController alloc] init];
    CLHNavigationController *nav3 = [[CLHNavigationController alloc] initWithRootViewController:friendVC];
    [self addChildViewController:nav3];
    //我
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"CLHMeTableViewController" bundle:nil];
    CLHMeTableViewController *meVC = [storyboard instantiateInitialViewController];
    CLHNavigationController *nav4 = [[CLHNavigationController alloc] initWithRootViewController:meVC];
    [self addChildViewController:nav4];
    
}

#pragma mark - 设置子控制器标题及图片
-(void)setUpTitleForChildViewController{
    
    //精华
    CLHNavigationController *essenceVC = self.childViewControllers[0];
    essenceVC.tabBarItem.title = @"精华";
    //获取未渲染的图片
    essenceVC.tabBarItem.image = [UIImage renderOrigenImageWithImageName:@"tabBar_essence_icon"];
    essenceVC.tabBarItem.selectedImage = [UIImage renderOrigenImageWithImageName:@"tabBar_essence_click_icon"];
    //新帖
    CLHNavigationController *newVC = self.childViewControllers[1];
    newVC.tabBarItem.title = @"新帖";
    newVC.tabBarItem.image = [UIImage renderOrigenImageWithImageName:@"tabBar_new_icon"];
    newVC.tabBarItem.selectedImage = [UIImage renderOrigenImageWithImageName:@"tabBar_new_click_icon"];
    //关注
    CLHNavigationController *friendVC = self.childViewControllers[2];
    friendVC.tabBarItem.title = @"关注";
    friendVC.tabBarItem.image = [UIImage renderOrigenImageWithImageName:@"tabBar_friendTrends_icon"];
    friendVC.tabBarItem.selectedImage = [UIImage renderOrigenImageWithImageName:@"tabBar_friendTrends_click_icon"];
    //我
    
    CLHNavigationController *meVC = self.childViewControllers[3];
    meVC.tabBarItem.title = @"我";
    meVC.tabBarItem.image = [UIImage renderOrigenImageWithImageName:@"tabBar_me_icon"];
    meVC.tabBarItem.selectedImage = [UIImage renderOrigenImageWithImageName:@"tabBar_me_click_icon"];

    
    
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
