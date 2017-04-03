//
//  CLHCommendCategory.h
//  BaiSiBuDeJie
//
//  Created by AnICoo1 on 17/2/13.
//  Copyright © 2017年 AnICoo1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLHCommendCategory : NSObject
/*id*/
@property (nonatomic,assign) NSInteger id;
/*总数*/
@property (nonatomic,assign) NSInteger count;
/*名字*/
@property (nonatomic,strong) NSString  *name;
/*当前页*/
@property (nonatomic,assign) NSInteger currentPage;
/*当前分类的user数*/
@property (nonatomic,assign) NSInteger total;
/*右侧数据*/
@property(nonatomic, strong) NSMutableArray *users;
@end
