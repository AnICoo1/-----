//
//  CLHTopicVideoView.m
//  BaiSiBuDeJie
//
//  Created by AnICoo1 on 17/1/31.
//  Copyright © 2017年 AnICoo1. All rights reserved.
//

#import "CLHTopicVideoView.h"


#import "CLHSeeBigPhotoViewController.h"
#import "CLHTopicItem.h"

@interface CLHTopicVideoView ()
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;

@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *placeholderImageView;



@end

@implementation CLHTopicVideoView

#pragma mark - 懒加载

- (void)awakeFromNib
{
    self.autoresizingMask = UIViewAutoresizingNone;
    
    self.backImageView.userInteractionEnabled = YES;
    [self.backImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(seeBigPicture)]];
    [super awakeFromNib];
}

/**
 *  查看大图
 */
- (void)seeBigPicture
{
    CLHSeeBigPhotoViewController *vc = [[CLHSeeBigPhotoViewController alloc] init];
    vc.topic = self.topic;
    [self.window.rootViewController presentViewController:vc animated:YES completion:nil];
}
//播放视频
- (IBAction)videoBegin:(UIButton *)sender {
    self.videoButtonClick();
}


- (void)setTopic:(CLHTopicItem *)topic
{
    _topic = topic;
    // 设置图片
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
    self.timeLabel.text = [NSString stringWithFormat:@"%02zd:%02zd", topic.videotime / 60, topic.videotime % 60];
}

@end
