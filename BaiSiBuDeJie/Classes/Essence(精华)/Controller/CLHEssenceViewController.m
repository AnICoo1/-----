//
//  CLHEssenceViewController.m
//  BaiSiBuDeJie
//
//  Created by AnICoo1 on 17/1/20.
//  Copyright © 2017年 AnICoo1. All rights reserved.
//

#import "CLHEssenceViewController.h"

#import "CLHAllTableViewController.h"
#import "CLHVideoTableViewController.h"
#import "CLHVoiceTableViewController.h"
#import "CLHPhotoTableViewController.h"
#import "CLHWordTableViewController.h"
#import "CLHButton.h"

@interface CLHEssenceViewController () <UIScrollViewDelegate>

//scrollView
@property(nonatomic, weak)UIScrollView *scrollView;
//标题栏
@property(nonatomic, weak) UIView *titleView;
//标题按钮下的线
@property(nonatomic, weak) UIView *titleLineOfButton;

//被选中标题按钮
@property(nonatomic, weak) CLHButton *selectedButton;

@end

@implementation CLHEssenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //添加子控制器
    [self setUpChildVC];
    //设置子控制器位置
    [self setUpFrameOfChildVC];
    //设置导航栏
    [self setUpNav];
    //设置标题栏
    [self setUpTitle];
    //设置开始的View
    [self addOneChildVCIntoScrollView:0];
}


#pragma mark - 初始化

#pragma mark - 设置子控制器位置
- (void)setUpFrameOfChildVC{
    // 不允许自动修改UIScrollView的内边距
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.frame = self.view.bounds;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.bounces = NO;
    scrollView.delegate = self;
    scrollView.pagingEnabled = YES;
    self.scrollView = scrollView;
    [self.view addSubview:scrollView];
    
    // 添加子控制器的view
    NSUInteger count = self.childViewControllers.count;
    CGFloat scrollViewW = scrollView.width;
    CGFloat scrollViewH = scrollView.height;
    
    for (NSUInteger i = 0; i < count; i++) {
        // 取出i位置子控制器的view
        UIView *childVcView = self.childViewControllers[i].view;
        childVcView.frame = CGRectMake(i * scrollViewW, 0, scrollViewW, scrollViewH);
        [scrollView addSubview:childVcView];
    }
    
    scrollView.contentSize = CGSizeMake(count * scrollViewW, 0);
}

#pragma  mark - 添加子控制器
- (void)setUpChildVC{
    
    [self addChildViewController:[[CLHAllTableViewController alloc] init]];
    [self addChildViewController:[[CLHVideoTableViewController alloc] init]];
    [self addChildViewController:[[CLHVoiceTableViewController alloc] init]];
    [self addChildViewController:[[CLHPhotoTableViewController alloc] init]];
    [self addChildViewController:[[CLHWordTableViewController alloc] init]];
    
}

#pragma mark - 设置标题栏
- (void)setUpTitle{
    UIView *titleV = [[UIView alloc] init];
    titleV.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5];
    titleV.frame = CGRectMake(0, 64, self.view.width, 35);
    [self.view addSubview:titleV];
    self.titleView = titleV;
    
    //设置标题栏按钮
    [self setUpButtonOfTitle];
    //设置按钮的下划线
    [self setUpLineOfButton];
}

#pragma mark - 设置按钮的下划线
- (void)setUpLineOfButton{
    
    // 标题按钮
    CLHButton *firstTitleButton = self.titleView.subviews.firstObject;
    
    // 下划线
    UIView *titleUnderline = [[UIView alloc] init];
    titleUnderline.height = 2;
    titleUnderline.y = self.titleView.height - titleUnderline.height;
    titleUnderline.backgroundColor = [firstTitleButton titleColorForState:UIControlStateSelected];
    [self.titleView addSubview:titleUnderline];
    self.titleLineOfButton = titleUnderline;
    
    // 切换按钮状态
    firstTitleButton.selected = YES;
    self.selectedButton = firstTitleButton;
    
    [firstTitleButton.titleLabel sizeToFit]; // 让label根据文字内容计算尺寸
    self.titleLineOfButton.width = firstTitleButton.titleLabel.width + 10;
    self.titleLineOfButton.center = CGPointMake(firstTitleButton.center.x, self.titleLineOfButton.center.y);
    
}
#pragma mark - 设置标题栏按钮

- (void)setUpButtonOfTitle{
    NSArray *name = @[@"全部", @"视频", @"声音", @"图片", @"段子"];
    NSInteger count = name.count;
    
    CGFloat buttonW = self.titleView.width / count;
    CGFloat buttonH = self.titleView.height;
    CGFloat buttonX = 0;
    CGFloat buttonY = 0;
    
    for(NSInteger i = 0;i < count; i++){
        
        CLHButton *button = [[CLHButton alloc] init];
        button.tag = i;
        buttonX = i * buttonW;
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        [button setTitle:name[i] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(titleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.titleView addSubview:button];
    }
    
    
}

#pragma mark - 设置导航栏
- (void)setUpNav{
    
    //左边按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithimage:[UIImage imageNamed:@"nav_item_game_icon"] highImage:[UIImage imageNamed:@"nav_item_game_click_icon"] target:self action:@selector(game)];
    
    // 右边按钮
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithimage:[UIImage imageNamed:@"navigationButtonRandom"] highImage:[UIImage imageNamed:@"navigationButtonRandomClick"] target:nil action:nil];
    
    // titleView
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MainTitle"]];
    
}

#pragma mark - <UIScrollViewDelegate>

//当手指停止滑动并且scrollView停止滚动的时候调用
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    NSInteger index = scrollView.contentOffset.x / self.scrollView.width;
    
    CLHButton *button = self.titleView.subviews[index];
    
    [self titleButtonClick:button];
    
}



- (void)titleButtonClick:(CLHButton *)button{
    // 重复点击了标题按钮
    if (self.selectedButton == button) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TitleButtonDidRepeatClickNotification" object:nil];
    }
    
    self.selectedButton.selected = NO;
    button.selected = YES;
    self.selectedButton = button;
    
    NSInteger index = button.tag;
    
    [UIView animateWithDuration:0.25 animations:^{
        // 处理下划线
        self.titleLineOfButton.width = button.titleLabel.width + 10;
        self.titleLineOfButton.center = CGPointMake(button.center.x, self.titleLineOfButton.center.y);
        //scrollView平移
        self.scrollView.contentOffset = CGPointMake(self.scrollView.width * index, self.scrollView.contentOffset.y);
    } completion:^(BOOL finished) {
        [self addOneChildVCIntoScrollView:index];
    }];
    
    
    
}




#pragma mark - 游戏按钮点击
- (void)game{
    
}

#pragma mark - 其他

- (void)addOneChildVCIntoScrollView:(NSInteger)index{
    
    UIViewController *childVc = self.childViewControllers[index];
    
    // 如果view已经被加载过，就直接返回
    if (childVc.isViewLoaded) return;
    
    // 取出index位置对应的子控制器view
    UIView *childVcView = childVc.view;
    
    // 设置子控制器view的frame
    CGFloat scrollViewW = self.scrollView.width;
    childVcView.frame = CGRectMake(index * scrollViewW, 0, scrollViewW, self.scrollView.height);
    // 添加子控制器的view到scrollView中
    [self.scrollView addSubview:childVcView];
    
    
}


@end
