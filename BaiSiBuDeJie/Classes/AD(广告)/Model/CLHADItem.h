//
//  CLHADItem.h
//  BaiSiBuDeJie
//
//  Created by AnICoo1 on 17/1/21.
//  Copyright © 2017年 AnICoo1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
// w_picurl,ori_curl:跳转到广告界面,w,h
@interface CLHADItem : NSObject

/** 广告地址 */
@property (nonatomic, strong) NSString *w_picurl;
/** 点击广告跳转的界面 */
@property (nonatomic, strong) NSString *ori_curl;

@property (nonatomic, assign) CGFloat w;

@property (nonatomic, assign) CGFloat h;

@end
