//
//  CLHTopicCell.m
//  BaiSiBuDeJie
//
//  Created by AnICoo1 on 17/1/28.
//  Copyright © 2017年 AnICoo1. All rights reserved.
//

#import "CLHTopicCell.h"
#import "UIImageView+WebCache.h"

#import "CLHTopicItem.h"
#import "CLHTopicPhotoView.h"

#import "CLHTopicVoiceView.h"
#import "CLHVideoView.h"

@interface CLHTopicCell ()

@property (weak, nonatomic) IBOutlet UIImageView *userImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *passtimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *textlabel;
@property (weak, nonatomic) IBOutlet UIButton *dingButton;
@property (weak, nonatomic) IBOutlet UIButton *caiButton;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIButton *saidButton;
@property (weak, nonatomic) IBOutlet UIView *hotSaidView;

@property (weak, nonatomic) IBOutlet UILabel *hotSaidLabel;
/* 中间控件 */
/** 图片控件 */
@property (nonatomic, weak) CLHTopicPhotoView *photoView;
/** 声音控件 */
@property (nonatomic, weak) CLHTopicVoiceView *voiceView;
/** 视频控件 */
@property (nonatomic, weak) CLHVideoView *videoView;
@end


@implementation CLHTopicCell
- (CLHTopicPhotoView *)photoView
{
    if (!_photoView) {
        CLHTopicPhotoView *photoV = [[NSBundle mainBundle] loadNibNamed:@"CLHTopicPhotoView" owner:nil options:nil].firstObject;
        [self.contentView addSubview:photoV];
        _photoView = photoV;
    }
    return _photoView;
}

- (CLHTopicVoiceView *)voiceView
{
    if (!_voiceView) {
        CLHTopicVoiceView *voiceView = [[NSBundle mainBundle] loadNibNamed:@"CLHTopicVoiceView" owner:nil options:nil].firstObject;
        [self.contentView addSubview:voiceView];
        _voiceView = voiceView;
    }
    return _voiceView;
}

- (CLHVideoView *)videoView
{
    if (!_videoView) {
        CLHVideoView *videoView =[[NSBundle mainBundle] loadNibNamed:@"CLHVideoView" owner:nil options:nil].firstObject;
        [self.contentView addSubview:videoView];
        _videoView = videoView;
    }
    return _videoView;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    //设置背景图片
    self.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mainCellBackground"]];
}

- (void)setTopic:(CLHTopicItem *)topic{
    _topic = topic;
    [self.userImageView sd_setImageWithURL:[NSURL URLWithString:topic.profile_image] placeholderImage:[UIImage imageNamed:@"defaultUserIcon"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if(!image) return;
        self.userImageView.image = image;
    }];
    
    self.nameLabel.text = topic.name;
    self.passtimeLabel.text = topic.passtime;
    self.textlabel.text = topic.text;
    
    [self setupButtonTitle:self.dingButton number:topic.ding placeholder:@"顶"];
    [self setupButtonTitle:self.caiButton number:topic.cai placeholder:@"踩"];
    [self setupButtonTitle:self.shareButton number:topic.repost placeholder:@"分享"];
    [self setupButtonTitle:self.saidButton number:topic.comment placeholder:@"评论"];
    // 最热评论
    if (topic.top_cmt.count) { // 有最热评论
        self.hotSaidView.hidden = NO;
        
        NSDictionary *cmt = topic.top_cmt.firstObject;
        NSString *content = cmt[@"content"];
        if (content.length == 0) { // 语音评论
            content = @"[语音评论]";
        }
        NSString *username = cmt[@"user"][@"username"];
        self.hotSaidLabel.text = [NSString stringWithFormat:@"%@ : %@", username, content];
    } else { // 没有最热评论
        self.hotSaidView.hidden = YES;
    }
    // 中间的内容
    if (topic.type == CLHTopicTypePhoto) { // 图片
        self.photoView.hidden = NO;
        self.photoView.topic = topic;
        self.voiceView.hidden = YES;
        self.videoView.hidden = YES;
    } else if (topic.type == CLHTopicTypeVoice) { // 声音
        self.photoView.hidden = YES;
        self.voiceView.hidden = NO;
        self.voiceView.topic = topic;
        self.videoView.hidden = YES;
    } else if (topic.type == CLHTopicTypeVideo) { // 视频
        self.photoView.hidden = YES;
        self.voiceView.hidden = YES;
        self.videoView.hidden = NO;
        self.videoView.topic = topic;
    } else if (topic.type == CLHTopicTypeWord) { // 段子
        self.photoView.hidden = YES;
        self.voiceView.hidden = YES;
        self.videoView.hidden = YES;
    }

}

- (void)setupButtonTitle:(UIButton *)button number:(NSInteger)number placeholder:(NSString *)placeholder
{
    if (number >= 10000) {
        [button setTitle:[NSString stringWithFormat:@"%.1f万", number / 10000.0] forState:UIControlStateNormal];
    } else if (number > 0) {
        [button setTitle:[NSString stringWithFormat:@"%zd", number] forState:UIControlStateNormal];
    } else {
        [button setTitle:placeholder forState:UIControlStateNormal];
    }
    
}

- (void)setFrame:(CGRect)frame{
    
    frame.size.height -= 10;
    return [super setFrame:frame];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.topic.type == CLHTopicTypePhoto) { // 图片
        self.photoView.frame = self.topic.middleFrame;
    } else if (self.topic.type == CLHTopicTypeVoice) { // 声音
        self.voiceView.frame = self.topic.middleFrame;
    } else if (self.topic.type == CLHTopicTypeVideo) { // 视频
        self.videoView.frame = self.topic.middleFrame;
        self.videoView.beginFrame = self.videoView.frame;
        self.videoView.superVC = self.locVC;
        self.videoView.indexPath = self.indexPath;
    }
}



@end
