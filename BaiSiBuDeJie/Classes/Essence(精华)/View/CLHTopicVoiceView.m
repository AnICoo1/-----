//
//  CLHTopicVoiceView.m
//  BaiSiBuDeJie
//
//  Created by AnICoo1 on 17/1/31.
//  Copyright © 2017年 AnICoo1. All rights reserved.
//

#import "CLHTopicVoiceView.h"
#import <AVFoundation/AVFoundation.h>
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"


#import "CLHTopicItem.h"
#import "CLHSeeBigPhotoViewController.h"

@interface CLHTopicVoiceView ()

@property (weak, nonatomic) IBOutlet UIImageView *backImageView;

@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *placeholderImageView;
@property(nonatomic, strong) AVPlayer *Player;

@end


@implementation CLHTopicVoiceView
    
- (AVPlayer *)Player{
    if(_Player == nil){
        _Player = [AVPlayer playerWithURL:[NSURL URLWithString:@"http://wvoice.spriteapp.cn/voice/2015/0824/55dafc15020d9.mp3"]];
    }
    return _Player;
}
    
//添加手势
- (void)awakeFromNib{
    
    self.autoresizingMask = UIViewAutoresizingNone;
    //http://cc.stream.qqmusic.qq.com/C100003j8IiV1X80aw.m4a?fromtag=52
    self.backImageView.userInteractionEnabled = YES;
    [self.backImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(seeBigPicture)]];
}

#pragma mark - 查看大图
- (void)seeBigPicture{
    CLHSeeBigPhotoViewController *seeVC = [[CLHSeeBigPhotoViewController alloc] init];
    seeVC.topic = self.topic;
    [self.window.rootViewController presentViewController:seeVC animated:YES completion:nil];
    [_Player play];
}

#pragma mark - 图片加载
- (void)setTopic:(CLHTopicItem *)topic{
    _topic = topic;
    // 占位图片
    self.placeholderImageView.hidden = NO;
    [self.backImageView clh_setOriginImage:topic.image1 thumbnailImage:topic.image0 placeholder:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (!image) return;
        
        self.placeholderImageView.hidden = YES;
    }];
    
    // 播放数量
    if (topic.playcount >= 10000) {
        self.countLabel.text = [NSString stringWithFormat:@"%.1f万播放", topic.playcount / 10000.0];
    } else {
        self.countLabel.text = [NSString stringWithFormat:@"%zd播放", topic.playcount];
    }
    // %04d : 占据4位，多余的空位用0填补
    self.timeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd", topic.voicetime / 60, topic.voicetime % 60];
}

@end
