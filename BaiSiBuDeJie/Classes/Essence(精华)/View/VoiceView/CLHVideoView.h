//
//  CLHVideoView.h
//  Test
//
//  Created by AnICoo1 on 2017/3/14.
//  Copyright © 2017年 AnICoo1. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CLHTopicItem;
@interface CLHVideoView : UIView


@property (nonatomic, strong) UIViewController *superVC;

@property (nonatomic,strong) CLHTopicItem *topic;

@property (nonatomic, assign) CGRect beginFrame;

@property (nonatomic, strong) NSIndexPath *indexPath;
@end
