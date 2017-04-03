//
//  CLHTopicVideoView.h
//  BaiSiBuDeJie
//
//  Created by AnICoo1 on 17/1/31.
//  Copyright © 2017年 AnICoo1. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CLHTopicItem;

@interface CLHTopicVideoView : UIView

@property (nonatomic,strong) CLHTopicItem *topic;

@property (nonatomic, copy) void (^videoButtonClick)();

@end
