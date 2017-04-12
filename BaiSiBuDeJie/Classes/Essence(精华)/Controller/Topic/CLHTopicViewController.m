//
//  CLHTopicViewController.m
//  BaiSiBuDeJie
//
//  Created by AnICoo1 on 17/1/25.
//  Copyright © 2017年 AnICoo1. All rights reserved.
//

#import "CLHTopicViewController.h"
#import "AFNetworking.h"
#import "MJExtension.h"
#import "SVProgressHUD.h"
#import "MJRefresh.h"

#import "CLHTopicItem.h"
#import "CLHTopicCell.h"
#import "CLHVideoView.h"

@interface CLHTopicViewController () <UIScrollViewDelegate>


/** 请求管理者 */
@property (nonatomic, strong) AFHTTPSessionManager *manager;
/** 当前最后一条帖子数据的描述信息，专门用来加载下一页数据 */
@property (nonatomic, copy) NSString *maxtime;
//模型
@property(nonatomic, strong) NSMutableArray *topics;

@end

@implementation CLHTopicViewController


static NSString * const ID = @"topicCell";

#pragma mark - 懒加载
- (AFHTTPSessionManager *)manager{
    
    if(!_manager){
        _manager = [AFHTTPSessionManager manager];
    }
    return _manager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weak typeof(self) weakSelf = self;
    [self setVideoBack:^CLHTopicCell *(NSIndexPath *indexPath) {
        return [weakSelf.tableView cellForRowAtIndexPath:indexPath];
    }];
    
    
    self.tableView.backgroundColor = [UIColor lightGrayColor];
    self.tableView.contentInset = UIEdgeInsetsMake(99, 0, 49, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //接受重复点击的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tabBarButtonDidRepeatClick) name:@"TabBarButtonDidRepeatClickNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(titleButtonDidRepeatClick) name:@"TitleButtonDidRepeatClickNotification" object:nil];
    [self setupRefresh];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CLHTopicCell" bundle:nil] forCellReuseIdentifier:ID];
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupRefresh
{
    //广告条
    UILabel *ADL = [[UILabel alloc] init];
    ADL.text = @"广告";
    ADL.frame = CGRectMake(0, 0, self.tableView.width, 35);
    ADL.backgroundColor = [UIColor whiteColor];
    ADL.textColor = [UIColor blackColor];
    ADL.textAlignment = NSTextAlignmentCenter;
    self.tableView.tableHeaderView = ADL;
    //上刷新条
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    //自动进行刷新
    [self.tableView.mj_header beginRefreshing];
    //下刷新条
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}

#pragma mark - 监听
/**
 *  监听tabBarButton重复点击
 */
- (void)tabBarButtonDidRepeatClick
{
    //重复点击的不是精华按钮
    if (self.view.window == nil) return;
    
    //显示在正中间的不是AllViewController
    if (self.tableView.scrollsToTop == NO) return;
    //进入下拉刷新
    [self.tableView.mj_header beginRefreshing];
}

/**
 *  监听titleButton重复点击
 */
- (void)titleButtonDidRepeatClick
{
    [self tabBarButtonDidRepeatClick];
}

#pragma mark - 数据源
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // 根据数据量显示或者隐藏footer
    return self.topics.count;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //CLHTopicCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    CLHTopicCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if(cell == nil){
        cell = [[NSBundle mainBundle] loadNibNamed:@"CLHTopicCell" owner:nil options:nil].firstObject;
    }
    cell.topic = self.topics[indexPath.row];
    cell.locVC = self;
    cell.indexPath = indexPath;
    return cell;
}
#pragma UITableViewControllerDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    CLHTopicItem *item = self.topics[indexPath.row];
    return item.cellHeight;
}


#pragma - 数据处理
- (void)loadNewData{
    //1.取消之前的请求
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    //2.拼接参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = @"list";
    parameters[@"c"] = @"data";
    parameters[@"type"] = @(self.type);
    parameters[@"mintime"] = @"5345345";
    
    [self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        // 存储maxtime
        self.maxtime = responseObject[@"info"][@"maxtime"];
        
        // 字典数组 -> 模型数据
        self.topics = [CLHTopicItem mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        
        // 刷新表格
        [self.tableView reloadData];
        
        //结束刷新
        [self.tableView.mj_header endRefreshing];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error.code != NSURLErrorCancelled) { // 并非是取消任务导致的error，其他网络问题导致的error
            [SVProgressHUD showErrorWithStatus:@"网络繁忙，请稍后再试！"];
        }
        
        // 结束刷新
        [self.tableView.mj_header endRefreshing];
        
    }];
    
}
- (void)loadMoreData{
    // 1.取消之前的请求
    [self.manager.tasks makeObjectsPerformSelector:@selector(cancel)];
    
    // 2.拼接参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = @"list";
    parameters[@"c"] = @"data";
    parameters[@"type"] = @(self.type);
    parameters[@"maxtime"] = self.maxtime;
    
    // 3.发送请求
    [self.manager GET:@"http://api.budejie.com/api/api_open.php" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        // 存储maxtime
        self.maxtime = responseObject[@"info"][@"maxtime"];
        
        // 字典数组 -> 模型数据
        NSArray *moreTopics = [CLHTopicItem mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        // 累加到旧数组的后面
        [self.topics addObjectsFromArray:moreTopics];
        
        // 刷新表格
        [self.tableView reloadData];
        
        // 结束刷新
        [self.tableView.mj_footer endRefreshing];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (error.code != NSURLErrorCancelled) { // 并非是取消任务导致的error，其他网络问题导致的error
            [SVProgressHUD showErrorWithStatus:@"网络繁忙，请稍后再试！"];
        }
        // 结束刷新
        [self.tableView.mj_footer endRefreshing];
    }];
    
}

@end
