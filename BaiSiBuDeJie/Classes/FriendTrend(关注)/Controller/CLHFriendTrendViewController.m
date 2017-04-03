//
//  CLHFriendTrendViewController.m
//  BaiSiBuDeJie
//
//  Created by AnICoo1 on 17/1/20.
//  Copyright © 2017年 AnICoo1. All rights reserved.
//

#import "CLHFriendTrendViewController.h"
#import "CLHLoginAndRegisterViewController.h"
#import "CLHTrendViewController.h"

@interface CLHFriendTrendViewController ()

@end

@implementation CLHFriendTrendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //设置导航栏
    [self setupNavBar];
    
    
}
#pragma mark - 设置导航条
- (void)setupNavBar
{
    // 左边按钮
    // 把UIButton包装成UIBarButtonItem.就导致按钮点击区域扩大
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithimage:[UIImage imageNamed:@"friendsRecommentIcon"] highImage:[UIImage imageNamed:@"friendsRecommentIcon-click"] target:self action:@selector(friendsRecomment)];
    
    // titleView
    self.navigationItem.title = @"我的关注";
    
}
#pragma mark - 登录注册按钮点击

- (IBAction)loginClick:(UIButton *)sender {
    
    CLHLoginAndRegisterViewController *loginVC = [[CLHLoginAndRegisterViewController alloc] init];
    
    [self presentViewController:loginVC animated:YES completion:nil];
}


#pragma mark - 按钮点击
- (void)friendsRecomment{
    
    CLHTrendViewController *trendVC = [[CLHTrendViewController alloc] init];
    [self.navigationController pushViewController:trendVC animated:YES];
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
