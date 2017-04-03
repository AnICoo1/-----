//
//  CLHSubTableViewController.m
//  BaiSiBuDeJie
//
//  Created by AnICoo1 on 17/1/21.
//  Copyright © 2017年 AnICoo1. All rights reserved.
//

#import "CLHSubTableViewController.h"
#import "AFNetworking.h"
#import "MJExtension.h"
#import "SVProgressHUD.h"
#import "CLHSubItem.h"
#import "CLHSubCell.h"


@interface CLHSubTableViewController ()

@property(nonatomic, strong) NSArray *subItems;

@property(nonatomic,weak) AFHTTPSessionManager *mgr;

@end

@implementation CLHSubTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //加载数据
    [self setUpData];
    
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"CLHSubCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.title = @"推荐标签";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor colorWithRed:220 green:220 blue:221 alpha:1];
    
    //数据加载提示
    [SVProgressHUD showWithStatus:@"正在加载ing..."];
}

#pragma mark  - view将要消失
- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    // 销毁指示器
    [SVProgressHUD dismiss];
    
    // 取消之前的请求
    [self.mgr.tasks makeObjectsPerformSelector:@selector(cancel)];
}

#pragma mark - 加载数据
- (void)setUpData{
    
    // 1.创建请求会话管理者
    AFHTTPSessionManager *mgr = [AFHTTPSessionManager manager];
    self.mgr = mgr;
    // 2.拼接参数
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"a"] = @"tag_recommend";
    parameters[@"action"] = @"sub";
    parameters[@"c"] = @"topic";
    
    
    
    // 3.发送请求
    [mgr GET:@"http://api.budejie.com/api/api_open.php" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, NSArray *  _Nullable responseObject) {
        
        [SVProgressHUD dismiss];
        
        [responseObject writeToFile:@"/Users/AnICoo1/Desktop/学习/BaiSiBuDeJie/BaiSiBuDeJie/Classes/New(新帖)/sub.plist" atomically:YES];
        // 字典数组转换模型数组
        self.subItems = [CLHSubItem mj_objectArrayWithKeyValuesArray:responseObject];
        
        // 刷新表格
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
    }];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.subItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CLHSubCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];

    //取模型
    CLHSubItem *subItem = self.subItems[indexPath.row];
    cell.data = subItem;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}
/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
