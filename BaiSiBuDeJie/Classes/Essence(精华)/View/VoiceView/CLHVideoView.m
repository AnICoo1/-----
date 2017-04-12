//
//  CLHVideoView.m
//  Test
//
//  Created by AnICoo1 on 2017/3/14.
//  Copyright © 2017年 AnICoo1. All rights reserved.
//

#import "CLHVideoView.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>

#import "POPViewController.h"
#import "CLHTopicItem.h"
#import "CLHTopicViewController.h"
#import "CLHTopicCell.h"


@interface CLHVideoView ()
/**中间开始播放按钮*/
@property (weak, nonatomic) IBOutlet UIButton *beginButton;
/**背景图片*/
@property (weak, nonatomic) IBOutlet UIImageView *bgView;
/**底部状态栏*/
@property (weak, nonatomic) IBOutlet UIView *bottomView;
/**底部开始暂停按钮*/
//@property (weak, nonatomic) IBOutlet UIButton *playAndPauseButton;
/**全屏按钮*/
@property (weak, nonatomic) IBOutlet UIButton *fillScreenButton;
/**底部进度条*/
@property (weak, nonatomic) IBOutlet UISlider *slider;
/**缓冲条*/
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
/**已播放时间*/
@property (weak, nonatomic) IBOutlet UILabel *leftTimeLabel;
/**视频时长*/
@property (weak, nonatomic) IBOutlet UILabel *rightTimeLabel;
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
/** toolView显示时间的timer */
@property(nonatomic,strong)NSTimer *showTime;
/** slider和播放时间定时器 */
@property(nonatomic,strong)NSTimer *progressTimer;

@property (nonatomic, strong) UIViewController *fillVC;




@end


@implementation CLHVideoView

#pragma mark - 懒加载

-(NSTimer *)progressTimer
{
    if (_progressTimer == nil) {
        _progressTimer = [NSTimer timerWithTimeInterval:1.0 target:self selector:@selector(updateProgressInfo) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop]addTimer:self.progressTimer forMode:NSRunLoopCommonModes];
    }
    return _progressTimer;
}

- (UIViewController *)fillVC{
    if(!_fillVC){
        _fillVC = [[POPViewController alloc] init];
    }
    return _fillVC;
}

- (void)awakeFromNib{
    [self setUpAll];
    self.bgView.userInteractionEnabled = YES;
    self.userInteractionEnabled = YES;
    [super awakeFromNib];
}

- (void)setUpAll{
    //为背景添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bgViewDidClick)];
    [self.bgView addGestureRecognizer:tap];
    //设置player
    self.player = [[AVPlayer alloc]init];
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    [self.bgView.layer addSublayer:self.playerLayer];
    //设置缓存条
    [self setUpSlider];
    self.beginButton.selected = NO;
    self.bottomView.hidden = YES;
}

- (void)setUpSlider{
    [self.slider setThumbImage:[UIImage imageNamed:@"dot"] forState:UIControlStateNormal];
}

#pragma mark - 事件监听
//背景点击
- (void)bgViewDidClick{
    self.beginButton.hidden = !self.beginButton.hidden;
    self.bottomView.hidden = !self.bottomView.hidden;
    if(self.beginButton.selected){
        [self addShowTime];
    }else{
        [self removeShowTime];
    }
}
//更新进度条状况
- (void)updateProgressInfo{
    NSTimeInterval currentTime = CMTimeGetSeconds(self.player.currentTime);
    NSTimeInterval durationTime = CMTimeGetSeconds(self.player.currentItem.duration);
    
    self.leftTimeLabel.text = [self timeToStringWithTimeInterval:currentTime];
    self.rightTimeLabel.text = [self timeToStringWithTimeInterval:durationTime];
    self.slider.value = CMTimeGetSeconds(self.player.currentTime) / CMTimeGetSeconds(self.player.currentItem.duration);
}
//时间格式转换
-(NSString *)timeToStringWithTimeInterval:(NSTimeInterval)interval;
{
    NSInteger Min = interval / 60;
    NSInteger Sec = (NSInteger)interval % 60;
    NSString *intervalString = [NSString stringWithFormat:@"%02zd:%02zd",Min,Sec];
    return intervalString;
}
- (void)upDateBottomView{
    self.beginButton.hidden = YES;
    self.bottomView.hidden = YES;
}
#pragma mark - 按钮点击监听
//播放按钮点击
- (IBAction)pauseButtonClick:(UIButton *)sender {
    
    self.beginButton.selected = !self.beginButton.selected;
    if(!sender.selected){
        [self.player pause];
    }else{
        [self.player replaceCurrentItemWithPlayerItem:self.playerItem];
        [self.player play];
        //计时器开始工作
        [self addShowTime];
        [self addProgressTimer];
    }
    
}


//全屏按钮点击
- (IBAction)fillScreenButtonClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    if (sender.selected) {
        self.superVC.modalPresentationStyle = UIModalPresentationCustom;
        //弹出全屏的VC
        [self.superVC presentViewController:self.fillVC animated:NO completion:^{
            //将视频界面添加到新的VC
            
            [self removeFromSuperview];
            [self.fillVC.view addSubview:self];
            
            self.center = self.fillVC.view.center;
            [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
                self.frame = self.fillVC.view.bounds;
            } completion:nil];
        }];
    } else {
        //取消弹出的VC
        [self.fillVC dismissViewControllerAnimated:NO completion:^{
            CLHTopicViewController *topicVC = (CLHTopicViewController *)self.superVC;
            CLHTopicCell *cell = topicVC.videoBack(self.indexPath);
            cell.topic = self.topic;
            [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionLayoutSubviews animations:^{
                self.frame = self.beginFrame;
            } completion:nil];
        }];
    }

}



- (void)layoutSubviews{
    [super layoutSubviews];
    self.playerLayer.frame = self.bgView.bounds;
}


- (void)setTopic:(CLHTopicItem *)topic{
    _topic = topic;
    self.playerItem = nil;
    self.playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:topic.videouri]];
    [self.bgView clh_setOriginImage:topic.image1 thumbnailImage:topic.image0 placeholder:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (!image) return;
    }];
}

#pragma mark - 定时器状态
- (void)addProgressTimer{
    [self progressTimer];
}
- (void)addShowTime{
    self.showTime = [NSTimer scheduledTimerWithTimeInterval:8.0 target:self selector:@selector(upDateBottomView) userInfo:nil repeats:NO];
    [[NSRunLoop mainRunLoop]addTimer:self.showTime forMode:NSRunLoopCommonModes];
}
- (void)removeProgressTimer{
    [self.progressTimer invalidate];
    self.progressTimer = nil;
}

- (void)removeShowTime{
    [self.showTime invalidate];
    self.showTime = nil;
}
#pragma mark - slider拖动和点击事件
- (IBAction)touchDownSlider:(UISlider *)sender {
    // 按下去 移除监听器
    [self removeProgressTimer];
    [self removeShowTime];
}
- (IBAction)valueChangedSlider:(UISlider *)sender {
    
    // 计算slider拖动的点对应的播放时间
    NSTimeInterval currentTime = CMTimeGetSeconds(self.player.currentItem.duration) * sender.value;
    self.leftTimeLabel.text = [self timeToStringWithTimeInterval:currentTime];
}
- (IBAction)touchUpInside:(UISlider *)sender {
    [self addProgressTimer];
    //计算当前slider拖动对应的播放时间
    NSTimeInterval currentTime = CMTimeGetSeconds(self.player.currentItem.duration) * sender.value;
    // 播放移动到当前播放时间
    [self.player seekToTime:CMTimeMakeWithSeconds(currentTime, NSEC_PER_SEC) toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
    [self addShowTime];
}

@end
