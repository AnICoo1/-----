//
//  CLHTopicItem.m
//  BaiSiBuDeJie
//
//  Created by AnICoo1 on 17/1/28.
//  Copyright © 2017年 AnICoo1. All rights reserved.
//

#import "CLHTopicItem.h"

@implementation CLHTopicItem


- (CGFloat)cellHeight{
    //如果这个cell的高度计算过了，就不再计算直接返回
    if(_cellHeight) return _cellHeight;
    
    _cellHeight += 55;
    // 文字的高度
    CGSize textMaxSize = CGSizeMake([UIScreen mainScreen]. bounds.size.width - 20, MAXFLOAT);
    _cellHeight += [self.text boundingRectWithSize:textMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil].size.height + 10;
    
    //中间内容
    if (self.type != CLHTopicTypeWord) { // 中间有内容（图片、声音、视频）
        CGFloat middleW = textMaxSize.width;
        CGFloat middleH = middleW * self.height / self.width;
        if (middleH >= [UIScreen mainScreen].bounds.size.height) { // 显示的图片高度超过一个屏幕，就是超长图片
            middleH = 200;
            self.bigPicture = YES;
        }
        CGFloat middleY = _cellHeight;
        CGFloat middleX = 10;
        self.middleFrame = CGRectMake(middleX, middleY, middleW, middleH);
        _cellHeight += middleH + 10;
    }

    // 最热评论
    if (self.top_cmt.count) { // 有最热评论
        // 标题
        _cellHeight += 21;
        
        // 内容
        NSDictionary *cmt = self.top_cmt.firstObject;
        NSString *content = cmt[@"content"];
        if (content.length == 0) {
            content = @"[语音评论]";
        }
        NSString *username = cmt[@"user"][@"username"];
        NSString *cmtText = [NSString stringWithFormat:@"%@ : %@", username, content];
        _cellHeight += [cmtText boundingRectWithSize:textMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil].size.height + 10;
    }
        // 工具条
    _cellHeight += 35 + 10;
    
    return _cellHeight;
}

@end
