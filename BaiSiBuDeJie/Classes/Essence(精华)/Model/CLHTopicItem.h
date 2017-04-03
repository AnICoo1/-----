//
//  CLHTopicItem.h
//  BaiSiBuDeJie
//
//  Created by AnICoo1 on 17/1/28.
//  Copyright © 2017年 AnICoo1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, CLHTopicType) {
    /** 全部 */
    CLHTopicTypeAll = 1,
    /** 图片 */
    CLHTopicTypePhoto = 10,
    /** 段子 */
    CLHTopicTypeWord = 29,
    /** 声音 */
    CLHTopicTypeVoice = 31,
    /** 视频 */
    CLHTopicTypeVideo = 41
};

@interface CLHTopicItem : NSObject
/** 用户的名字 */
@property (nonatomic, copy) NSString *name;
/** 用户的头像 */
@property (nonatomic, copy) NSString *profile_image;
/** 帖子的文字内容 */
@property (nonatomic, copy) NSString *text;
/** 帖子审核通过的时间 */
@property (nonatomic, copy) NSString *passtime;

/** 顶数量 */
@property (nonatomic, assign) NSInteger ding;
/** 踩数量 */
@property (nonatomic, assign) NSInteger cai;
/** 转发\分享数量 */
@property (nonatomic, assign) NSInteger repost;
/** 评论数量 */
@property (nonatomic, assign) NSInteger comment;
/** 帖子的类型 10为图片 29为段子 31为音频 41为视频 */
@property (nonatomic, assign) NSInteger type;
/** 最热评论 */
@property (nonatomic, strong) NSArray *top_cmt;
/** 宽度(像素) */
@property (nonatomic, assign) NSInteger width;
/** 高度(像素) */
@property (nonatomic, assign) NSInteger height;
/** 是否为动图 */
@property (nonatomic, assign) BOOL is_gif;
/** 小图 */
@property (nonatomic, copy) NSString *image0;
/** 中图 */
@property (nonatomic, copy) NSString *image2;
/** 大图 */
@property (nonatomic, copy) NSString *image1;
/** 音频地址 */
@property (nonatomic, copy) NSString *voiceuri;
/** 音频时长 */
@property (nonatomic, assign) NSInteger voicetime;
/** 视频地址 */
@property (nonatomic, copy) NSString *videouri;
/** 视频时长 */
@property (nonatomic, assign) NSInteger videotime;
/** 音频\视频的播放次数 */
@property (nonatomic, assign) NSInteger playcount;
/*额外增加的属性*/
//cell的高度
@property (nonatomic,assign) CGFloat cellHeight;
//图片高度
@property(nonatomic, assign) CGFloat imageHeight;
/** 中间内容的frame */
@property (nonatomic, assign) CGRect middleFrame;
/** 是否为超长图片 */
@property (nonatomic, assign, getter=isBigPicture) BOOL bigPicture;

@end
