//
//  CLHTopicViewController.h
//  BaiSiBuDeJie
//
//  Created by AnICoo1 on 17/2/5.
//  Copyright © 2017年 AnICoo1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CLHTopicItem.h"
@interface CLHTopicViewController : UITableViewController

@property (nonatomic, copy) UITableViewCell* (^videoBack)(NSIndexPath *indexPath);


- (CLHTopicType)type;
@end
