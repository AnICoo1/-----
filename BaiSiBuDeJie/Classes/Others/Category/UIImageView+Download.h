//
//  UIImageView+Download.h
//  BaiSiBuDeJie
//
//  Created by AnICoo1 on 17/2/5.
//  Copyright © 2017年 AnICoo1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"



@interface UIImageView (Download)
- (void)clh_setOriginImage:(NSString *)originImageURL thumbnailImage:(NSString *)thumbnailImageURL placeholder:(UIImage *)placeholder completed:(SDExternalCompletionBlock)completedBlock;
    
- (void)clh_setHeader:(NSString *)headerUrl;
    
@end
