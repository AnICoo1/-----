//
//  CLHLoginAndRegisterViewController.m
//  BaiSiBuDeJie
//
//  Created by AnICoo1 on 17/1/22.
//  Copyright © 2017年 AnICoo1. All rights reserved.
//

#import "CLHLoginAndRegisterViewController.h"
#import "CLHLoginAndRegisterView.h"
#import "CLHfastLoginView.h"

@interface CLHLoginAndRegisterViewController ()
@property (weak, nonatomic) IBOutlet UIView *midView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftcon;

@end

@implementation CLHLoginAndRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //创建中间登录的view
    CLHLoginAndRegisterView *loginV = [CLHLoginAndRegisterView loginView];
    //添加到中间的view
    [self.midView addSubview:loginV];
    //创建中间注册的View
    CLHLoginAndRegisterView *registerV = [CLHLoginAndRegisterView registerView];
    //添加到中间的view
    [self.midView addSubview:registerV];
    //创建下面快速登录的view
    CLHfastLoginView *fastLoginV = [CLHfastLoginView loginView];
    //添加到下面的view
    [self.bottomView addSubview:fastLoginV];
}

#pragma mark - 返回按钮
- (IBAction)backClick:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - 注册账号

- (IBAction)registerNumber:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
    self.leftcon.constant = self.leftcon.constant == 0? -self.midView.bounds.size.width * 0.5:0;
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];

}


#pragma mark - 布局子控件
- (void)viewDidLayoutSubviews{
    
    [super viewDidLayoutSubviews];
    
    CLHLoginAndRegisterView *loginV = self.midView.subviews[0];
    loginV.frame = CGRectMake(0, 0, self.midView.bounds.size.width * 0.5, self.midView.bounds.size.height);
    CLHLoginAndRegisterView *registerV = self.midView.subviews[1];
    registerV.frame = CGRectMake(self.midView.bounds.size.width * 0.5, 0, self.midView.bounds.size.width * 0.5, self.midView.bounds.size.height);
}
@end
