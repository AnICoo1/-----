//
//  CLHMeTableViewController.m
//  BaiSiBuDeJie
//
//  Created by AnICoo1 on 17/1/20.
//  Copyright © 2017年 AnICoo1. All rights reserved.
//

#import "CLHMeTableViewController.h"
#import "AFNetworking.h"
#import "MJExtension.h"

#import "CLHTableViewController.h"
#import "CLHSquareCell.h"
#import "CLHSquareItem.h"
#import "CLHWebViewController.h"
#import "CLHLoginAndRegisterViewController.h"



@interface CLHMeTableViewController () <UICollectionViewDataSource,UICollectionViewDelegate>

@property(nonatomic, strong) NSArray *squareItems;
@property(nonatomic, weak) UICollectionView *collectionV;

@end

static NSString  * const ID = @"cell";

@implementation CLHMeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置导航条
    [self setupNavBar];
    //设置底部视图
    [self setUpFootView];
    //加载数据
    [self setUpData];
    
    //设置tableview间隔
    self.tableView.sectionHeaderHeight = 0;
    self.tableView.sectionFooterHeight = 10;
    self.tableView.contentInset = UIEdgeInsetsMake(-25, 0, 0, 0);
}

#pragma mark - 设置底部视图
- (void)setUpFootView{
    //创建流水布局
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat squareWH = (screenW - 3) / 4;
    layout.itemSize = CGSizeMake(squareWH, squareWH);
    layout.minimumLineSpacing = 1;
    layout.minimumInteritemSpacing = 1;
    
    //创建UICollectionView
    UICollectionView *collectionV = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 0, 300) collectionViewLayout:layout];
    collectionV.backgroundColor = self.tableView.backgroundColor;
    self.collectionV = collectionV;
    self.tableView.tableFooterView = collectionV;
    self.collectionV.scrollEnabled = NO;
    //设置数据源和代理
    collectionV.dataSource = self;
    collectionV.delegate = self;
    //注册cell
    [collectionV registerNib:[UINib nibWithNibName:@"CLHSquareCell" bundle:nil] forCellWithReuseIdentifier:ID];
    
}


#pragma mark - 计算collectionView高度
- (void)makeHeightOfCollection{
    
    NSInteger row = (self.squareItems.count - 1) / 4 + 1;
    CGFloat squareWH = (screenW - 3) / 4;
    
    NSMutableArray *arr = [NSMutableArray arrayWithArray:self.squareItems];
    for (int i = 0; i < 4 - self.squareItems.count % 4 ; i++) {
        
        [arr addObject:[[CLHSquareItem alloc] init]];
    }
    self.squareItems = arr;
    self.collectionV.height = squareWH * row;
}


#pragma mark - 加载数据
- (void)setUpData{
    
    // 1.创建请求会话管理者
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    
    // 2.拼接请求参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = @"square";
    parameters[@"c"] = @"topic";
    
    // 3.发送请求
    [mgr GET:@"http://api.budejie.com/api/api_open.php" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSDictionary *  _Nullable responseObject) {
        
        NSArray *dictArr = responseObject[@"square_list"];
        
        // 字典数组转换成模型数组
        self.squareItems = [CLHSquareItem mj_objectArrayWithKeyValuesArray:dictArr];
        
        [self makeHeightOfCollection];
        
        self.tableView.tableFooterView = self.collectionV;
        // 刷新表格
        [self.collectionV reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}
#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CLHSquareItem *item = self.squareItems[indexPath.row];
    
    if(![item.url containsString:@"http"]) return ;
    
    CLHWebViewController *webVC = [[CLHWebViewController alloc] init];
    webVC.url = [NSURL URLWithString:item.url];
    
    
    [self.navigationController pushViewController:webVC animated:YES];
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.squareItems.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CLHSquareCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ID forIndexPath:indexPath];
    cell.item = self.squareItems[indexPath.row];
    
    return cell;
    
}
#pragma mark - 设置导航条
- (void)setupNavBar
{
    // 左边按钮
    // 把UIButton包装成UIBarButtonItem.就导致按钮点击区域扩大
    
    // 设置
    UIBarButtonItem *settingItem =  [UIBarButtonItem itemWithimage:[UIImage imageNamed:@"mine-setting-icon"] highImage:[UIImage imageNamed:@"mine-setting-icon-click"] target:self action:@selector(setting)];
    
    // 夜间模型
    UIBarButtonItem *nightItem =  [UIBarButtonItem itemWithimage:[UIImage imageNamed:@"mine-moon-icon"] selImage:[UIImage imageNamed:@"mine-moon-icon-click"] target:self action:@selector(night:)];
    
    self.navigationItem.rightBarButtonItems = @[settingItem,nightItem];
    
    // titleView
    self.navigationItem.title = @"我的";
    
}

- (void)setting{
    
    CLHTableViewController *settingVC = [[CLHTableViewController alloc] init];
    
    [self.navigationController pushViewController:settingVC animated:YES];
}

- (void)night:(UIButton *)button{
    button.selected = !button.selected;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
