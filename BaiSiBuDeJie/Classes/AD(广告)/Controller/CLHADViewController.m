//
//  CLHADViewController.m
//  BaiSiBuDeJie
//
//  Created by AnICoo1 on 17/1/21.
//  Copyright © 2017年 AnICoo1. All rights reserved.
//

#import "CLHADViewController.h"
#import "CLHTabBarController.h"
#import "AFNetworking.h"
#import "MJExtension.h"
#import "UIImageView+WebCache.h"
#import "CLHADItem.h"

#define code2 @"phcqnauGuHYkFMRquANhmgN_IauBThfqmgKsUARhIWdGULPxnz3vndtkQW08nau_I1Y1P1Rhmhwz5Hb8nBuL5HDknWRhTA_qmvqVQhGGUhI_py4MQhF1TvChmgKY5H6hmyPW5RFRHzuET1dGULnhuAN85HchUy7s5HDhIywGujY3P1n3mWb1PvDLnvF-Pyf4mHR4nyRvmWPBmhwBPjcLPyfsPHT3uWm4FMPLpHYkFh7sTA-b5yRzPj6sPvRdFhPdTWYsFMKzuykEmyfqnauGuAu95Rnsnbfknbm1QHnkwW6VPjujnBdKfWD1QHnsnbRsnHwKfYwAwiu9mLfqHbD_H70hTv6qnHn1PauVmynqnjclnj0lnj0lnj0lnj0lnj0hThYqniuVujYkFhkC5HRvnB3dFh7spyfqnW0srj64nBu9TjYsFMub5HDhTZFEujdzTLK_mgPCFMP85Rnsnbfknbm1QHnkwW6VPjujnBdKfWD1QHnsnbRsnHwKfYwAwiuBnHfdnjD4rjnvPWYkFh7sTZu-TWY1QW68nBuWUHYdnHchIAYqPHDzFhqsmyPGIZbqniuYThuYTjd1uAVxnz3vnzu9IjYzFh6qP1RsFMws5y-fpAq8uHT_nBuYmycqnau1IjYkPjRsnHb3n1mvnHDkQWD4niuVmybqniu1uy3qwD-HQDFKHakHHNn_HR7fQ7uDQ7PcHzkHiR3_RYqNQD7jfzkPiRn_wdKHQDP5HikPfRb_fNc_NbwPQDdRHzkDiNchTvwW5HnvPj0zQWndnHRvnBsdPWb4ri3kPW0kPHmhmLnqPH6LP1ndm1-WPyDvnHKBrAw9nju9PHIhmH9WmH6zrjRhTv7_5iu85HDhTvd15HDhTLTqP1RsFh4ETjYYPW0sPzuVuyYqn1mYnjc8nWbvrjTdQjRvrHb4QWDvnjDdPBuk5yRzPj6sPvRdgvPsTBu_my4bTvP9TARqnam"

@interface CLHADViewController ()
//广告图片
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
//占位View
@property (weak, nonatomic) IBOutlet UIView *upView;
//广告模型
@property(nonatomic, strong) CLHADItem *item;
//广告图片
@property(nonatomic, weak) UIImageView *adImageV;
//计时器
@property (nonatomic, weak) NSTimer *timer;
//跳转按钮
@property (weak, nonatomic) IBOutlet UIButton *jumpButton;
@end

@implementation CLHADViewController
#pragma mark - 懒加载
- (UIImageView *)adImageV
{
    if (_adImageV == nil) {
        UIImageView *imageView = [[UIImageView alloc] init];
        
        [self.upView addSubview:imageView];
        //加上点按手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        [imageView addGestureRecognizer:tap];
        
        imageView.userInteractionEnabled = YES;
        
        
        _adImageV = imageView;
    }
    
    return _adImageV;
}

#pragma mark - 点击广告界面
- (void)tap{
    // 跳转到界面 => safari
    NSURL *url = [NSURL URLWithString:_item.ori_curl];
    UIApplication *app = [UIApplication sharedApplication];
    if ([app canOpenURL:url]) {
        [app openURL:url];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //设置启动图片
    [self setUpStartImage];
    //加载广告数据
    [self loadAdData];
    //加载定时器
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(nextTime) userInfo:nil repeats:YES];
}
#pragma mark - 跳过按钮点击
- (IBAction)jumpClick:(UIButton *)sender {
    
    CLHTabBarController *tabVC = [[CLHTabBarController alloc] init];
    //跳转(重新设置窗口的根控制器)
    [UIApplication sharedApplication].keyWindow.rootViewController = tabVC;
    //停止计时器
    [self.timer invalidate];
}

#pragma mark - 定时器
- (void)nextTime{
    static int i = 5;
    if(i == 0){
        [self jumpClick:nil];
    }
    
    i--;
    [self.jumpButton setTitle:[NSString stringWithFormat:@"跳转 (%d)",i] forState:UIControlStateNormal];
    
}
#pragma mark - 加载广告数据
- (void)loadAdData
{
    
    
    // 1.创建请求会话管理者
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    // 2.拼接参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"code2"] = code2;
    
    // 3.发送请求
    [mgr GET:@"http://mobads.baidu.com/cpro/ui/mads.php" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //将收到的数据转成plist格式存入文件夹,来获取数据格式
        //[responseObject writeToFile:@"/Users/AnICoo1/Desktop/学习/BaiSiBuDeJie/BaiSiBuDeJie/Classes/AD(广告)/AD.plist" atomically:YES];
        
        // 获取字典
        NSDictionary *adDict = [responseObject[@"ad"] lastObject];
        //字典转模型
        self.item = [CLHADItem mj_objectWithKeyValues:adDict];
        // 创建UIImageView展示图片 =>
        CGFloat h = [UIScreen mainScreen].bounds.size.width / self.item.w * self.item.h;
        self.adImageV.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, h);
        
        // 加载广告网页
        [self.adImageV sd_setImageWithURL:[NSURL URLWithString:self.item.w_picurl]];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}
#pragma mark - 设置启动图片
- (void)setUpStartImage{
    //设置屏幕适配
    if (iphone6P) { // 6p
        self.imageV.image = [UIImage imageNamed:@"LaunchImage-800-Portrait-736h@3x"];
    } else if (iphone6) { // 6
        self.imageV.image = [UIImage imageNamed:@"LaunchImage-800-667h"];
    } else if (iphone5) { // 5
        self.imageV.image = [UIImage imageNamed:@"LaunchImage-568h"];
        
    } else if (iphone4) { // 4
        self.imageV.image = [UIImage imageNamed:@"LaunchImage-700"];
    }
}

@end
