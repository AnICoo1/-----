//
//  CLHTrendViewController.m
//  BaiSiBuDeJie
//
//  Created by AnICoo1 on 17/2/13.
//  Copyright © 2017年 AnICoo1. All rights reserved.
//

#import "CLHTrendViewController.h"
#import "AFNetworking.h"
#import "MJExtension.h"
#import "SVProgressHUD.h"
#import "MJRefresh.h"

#import "CLHCommendCategory.h"
#import "CLHCommendUser.h"
#import "CLHCategoryCell.h"
#import "CLHUserCell.h"

@interface CLHTrendViewController () <UITableViewDataSource, UITableViewDelegate>
/*左侧*/
@property (nonatomic, weak) IBOutlet UITableView *categoryView;
/*左侧数据*/
@property(nonatomic, strong) NSArray *categorys;
/*右侧*/
@property (nonatomic, weak) IBOutlet UITableView *rightView;
/*右侧数据*/
@property(nonatomic, strong) NSArray *users;

/*选中的分类*/
@property(nonatomic,weak) CLHCommendCategory *category;
/*记录存储*/
@property(nonatomic, strong) NSDictionary *parameters;

@end

static NSString  * const categoryCellID = @"categorycell";
static NSString  * const userCellID = @"usercell";

@implementation CLHTrendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化
    [self setUpBegin];
    //最初刷新
    [self setUpData];
    
}

#pragma mark - 初始化
- (void)setUpBegin{
    self.navigationItem.title= @"推荐关注";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor lightGrayColor];
    //左边的tableView
    self.categoryView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    self.categoryView.dataSource = self;
    self.categoryView.delegate = self;
    [self.categoryView registerNib:[UINib nibWithNibName:NSStringFromClass([CLHCategoryCell class]) bundle:nil] forCellReuseIdentifier:categoryCellID];
    
    //右边的tableView
    self.rightView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    self.rightView.dataSource = self;
    self.rightView.delegate = self;
    [self.rightView registerNib:[UINib nibWithNibName:NSStringFromClass([CLHUserCell class]) bundle:nil] forCellReuseIdentifier:userCellID];
    self.rightView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget	:self refreshingAction:@selector(loadNewData)];
    self.rightView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData) ];
}

- (void)loadNewData{
    
    CLHCommendCategory *category = self.category;
    category.currentPage = 1;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = @"list";
    parameters[@"c"] = @"subscribe";
    parameters[@"category_id"] = @(category.id);
    parameters[@"page"] = @(category.currentPage);
    self.parameters = parameters;
    
    [manager GET:@"http://api.budejie.com/api/api_open.php" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *users = [CLHCommendUser mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        category.total = [responseObject[@"total"] integerValue];
        
        //移除之前的数据
        [category.users removeAllObjects];
        //添加新数据
        [category.users addObjectsFromArray:users];
        //如果返回的数据不是最后一次的请求，直接返回
        if(self.parameters != parameters) return;
        //刷新数据
        [self.rightView reloadData];
        //顶部控件停止刷新
        [self.rightView.mj_header endRefreshing];
        //检查底部控件状态
        [self checkFootStatus];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"刷新失败"];
        [self.rightView.mj_header endRefreshing];
    }];
}

- (void)loadMoreData{
#warning here begin
    NSLog(@"上拉刷新");
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self.rightView.mj_footer endRefreshing];
    });
}

- (void)setUpData{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    parameters[@"a"] = @"category";
    parameters[@"c"] = @"subscribe";
    
    [manager GET:@"http://api.budejie.com/api/api_open.php" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        self.categorys = [CLHCommendCategory mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        [self.categoryView reloadData];
        
        [self.categoryView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionNone];
        [self tableView:self.categoryView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"加载失败"];
    }];
    
}

#pragma mark - 监视方法
- (void)checkFootStatus{
    CLHCommendCategory *category = self.category;
    self.rightView.mj_footer.hidden = (category.users.count == 0);
    
    if(category.users.count == category.total){
        [self.rightView.mj_footer endRefreshingWithNoMoreData];
    } else{
        [self.rightView.mj_footer endRefreshing];
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView == self.categoryView){
        return self.categorys.count;
    } else{
        return self.category.users.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == self.categoryView){
        CLHCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:categoryCellID];
        cell.category = self.categorys[indexPath.row];
        return cell;
    } else{
        CLHUserCell *cell = [tableView dequeueReusableCellWithIdentifier:userCellID];
        cell.user = self.users[indexPath.row];
        return cell;
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView == self.rightView){
        return 76;
    }else{
        return 43;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CLHCommendCategory *category = self.categorys[indexPath.row];
    self.category = category;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = @"list";
    parameters[@"c"] = @"subscribe";
    parameters[@"category_id"] = @(category.id);
    [manager GET:@"http://api.budejie.com/api/api_open.php" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        self.users = [CLHCommendUser mj_objectArrayWithKeyValuesArray:responseObject[@"list"]];
        self.category.users = [NSMutableArray arrayWithArray:self.users];
        [self.rightView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD showErrorWithStatus:@"加载失败"];
    }];
    
}

@end
