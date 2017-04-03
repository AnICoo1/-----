//
//  CLHTableViewController.m
//  BaiSiBuDeJie
//
//  Created by AnICoo1 on 17/1/20.
//  Copyright © 2017年 AnICoo1. All rights reserved.
//

#import "CLHTableViewController.h"
#import "SVProgressHUD.h"


#import "CLHFileTool.h"

#define CachePath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]

@interface CLHTableViewController ()

@property(nonatomic, assign) CGFloat totalSize;

@end

static NSString * const ID = @"cell";
@implementation CLHTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpBack];
    
    [self.tableView registerClass:[UITableViewCell class]forCellReuseIdentifier:ID];
    
    [SVProgressHUD showWithStatus:@"正在计算缓存"];
    
    [CLHFileTool getFileSize:CachePath completion:^(NSInteger totalSize) {
        _totalSize = totalSize;
        
        [self.tableView reloadData];
        
        [SVProgressHUD dismiss];

    }];
}


#pragma mark - 设置返回按钮
- (void)setUpBack{
    
    UIBarButtonItem *backItem = [UIBarButtonItem backItemWithimage:[UIImage imageNamed:@"navigationButtonReturn"] highImage:[UIImage imageNamed:@"navigationButtonReturnClick"] target:self action:@selector(back) title:@"返回"];
    self.navigationItem.leftBarButtonItem = backItem;
    
    
}

#pragma mark - 返回按钮点击
- (void)back{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    // 获取缓存尺寸字符串
    cell.textLabel.text = [self sizeStr];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // 清空缓存
    // 删除文件夹里面所有文件
    [CLHFileTool removeDirectoryPath:CachePath];
    
    _totalSize = 0;
    
    [self.tableView reloadData];
}

// 获取缓存尺寸字符串
- (NSString *)sizeStr
{
    NSInteger totalSize = _totalSize;
    NSString *sizeStr = @"清除缓存";
    // MB KB B
    if (totalSize > 1000 * 1000) {
        // MB
        CGFloat sizeF = totalSize / 1000.0 / 1000.0;
        sizeStr = [NSString stringWithFormat:@"%@(%.1fMB)",sizeStr,sizeF];
    } else if (totalSize > 1000) {
        // KB
        CGFloat sizeF = totalSize / 1000.0;
        sizeStr = [NSString stringWithFormat:@"%@(%.1fKB)",sizeStr,sizeF];
    } else if (totalSize > 0) {
        // B
        sizeStr = [NSString stringWithFormat:@"%@(%.ldB)",sizeStr,totalSize];
    }
    
    return sizeStr;
}
@end
