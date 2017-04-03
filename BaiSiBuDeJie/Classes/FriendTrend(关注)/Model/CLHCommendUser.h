//
//  CLHCommendUser.h
//  BaiSiBuDeJie
//
//  Created by AnICoo1 on 17/2/13.
//  Copyright © 2017年 AnICoo1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CLHCommendUser : NSObject
/*头像*/
@property (nonatomic,copy) NSString *header;
/*昵称*/
@property (nonatomic,copy) NSString *screen_name;
/*粉丝数*/
@property (nonatomic,assign) NSInteger fans_count;

@end
