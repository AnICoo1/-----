//
//  CLHTopicCell.h
//  BaiSiBuDeJie
//
//  Created by AnICoo1 on 17/1/28.
//  Copyright © 2017年 AnICoo1. All rights reserved.
//

#import <UIKit/UIKit.h>


@class CLHTopicItem;
@interface CLHTopicCell : UITableViewCell

@property (nonatomic,strong) CLHTopicItem *topic;

@property (nonatomic, strong) UIViewController *locVC;

@property (nonatomic, strong) NSIndexPath *indexPath;

@end
