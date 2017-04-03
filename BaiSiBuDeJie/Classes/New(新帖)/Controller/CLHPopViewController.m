//
//  CLHPopViewController.m
//  BaiSiBuDeJie
//
//  Created by AnICoo1 on 2017/3/18.
//  Copyright © 2017年 AnICoo1. All rights reserved.
//

#import "CLHPopViewController.h"
#import <SDAutoLayout/SDAutoLayout.h>

#import "CLHPublishButton.h"
@interface CLHPopViewController ()

@end

@implementation CLHPopViewController
{
    UIImageView *_imageView;
    UIImageView *_logoImageView;
    UIView *_buttonView;
    CLHPublishButton *_videoButton;
    CLHPublishButton *_photoButton;
    CLHPublishButton *_wordButton;
    CLHPublishButton *_voiceButton;
    CLHPublishButton *_linkButton;
    CLHPublishButton *_reviewButton;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpAll];
     _videoButton.frame = CGRectMake(0, -1000, screenW / 3, _buttonView.height / 2);
    _photoButton.frame = CGRectMake(screenW / 3, -1000, screenW / 3, _buttonView.height / 2);
    _wordButton.frame = CGRectMake(screenW / 3 * 2, -1000, screenW / 3, _buttonView.height / 2);
    _voiceButton.frame = CGRectMake(0, -1000, screenW / 3, _buttonView.height / 2);
    _linkButton.frame = CGRectMake(screenW / 3 , -1000, screenW / 3, _buttonView.height / 2);
    _reviewButton.frame = CGRectMake(screenW / 3 * 2, -1000, screenW / 3, _buttonView.height / 2);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [UIView animateWithDuration:0.5 animations:^{
            _voiceButton.frame = CGRectMake(0, _buttonView.height / 2, screenW / 3, _buttonView.height / 2);
            _linkButton.frame = CGRectMake(screenW / 3, _buttonView.height / 2, screenW / 3, _buttonView.height / 2);
            _reviewButton.frame = CGRectMake(screenW / 3 * 2, _buttonView.height / 2, screenW / 3, _buttonView.height / 2);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.5 animations:^{
                _videoButton.frame = CGRectMake(0, 0, screenW / 3, _buttonView.height / 2);
                _photoButton.frame = CGRectMake(screenW / 3, 0, screenW / 3, _buttonView.height / 2);
                _wordButton.frame = CGRectMake(screenW / 3 * 2, 0, screenW / 3, _buttonView.height / 2);
            }];
        }];
        
        
    });
    
}

- (void)setUpAll{
    //背景图片
    _imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"shareBottomBackground"]];
    _imageView.frame = self.view.bounds;
    [self.view addSubview:_imageView];
    //logo
    _logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"app_slogan"]];
    [self.view addSubview:_logoImageView];
    
    _logoImageView.sd_layout
    .topSpaceToView(self.view, 100)
    .leftSpaceToView(self.view, 40)
    .rightSpaceToView(self.view, 40)
    .heightIs(40);
    
    //buttonView
    _buttonView = [[UIView alloc] init];
    [self.view addSubview:_buttonView];
    
    _buttonView.sd_layout
    .topSpaceToView(_logoImageView, 100)
    .leftSpaceToView(self.view, 0)
    .rightSpaceToView(self.view, 0)
    .heightIs(300);
    
    [self setUpButton];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(imageViewClick)];
    [self.view addGestureRecognizer:tap];
}
- (void)imageViewClick{
    [UIView animateWithDuration:0.1 animations:^{
        _voiceButton.frame = CGRectMake(0, 1000, screenW / 3, _buttonView.height / 2);
        _linkButton.frame = CGRectMake(screenW / 3 , 1000, screenW / 3, _buttonView.height / 2);
        _reviewButton.frame = CGRectMake(screenW / 3 * 2, 1000, screenW / 3, _buttonView.height / 2);
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            _videoButton.frame = CGRectMake(0, 1000, screenW / 3, _buttonView.height / 2);
            _photoButton.frame = CGRectMake(screenW / 3, 1000, screenW / 3, _buttonView.height / 2);
            _wordButton.frame = CGRectMake(screenW / 3 * 2, 1000, screenW / 3, _buttonView.height / 2);

        }completion:^(BOOL finished) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
    }];
    
}

- (void)setUpButton{
    
    //发视频
    _videoButton = [self publishButtonWithImage:@"publish-video" title:@"发视频"];
    _videoButton.frame = CGRectMake(0, 0, screenW / 3, _buttonView.height / 2);
    [_buttonView addSubview:_videoButton];
    //发照片
    _photoButton = [self publishButtonWithImage:@"publish-picture" title:@"发照片"];
    _photoButton.frame = CGRectMake(screenW / 3, 0, screenW / 3, _buttonView.height / 2);
    [_buttonView addSubview:_photoButton];
    //发段子
    _wordButton = [self publishButtonWithImage:@"publish-text" title:@"发段子"];
    _wordButton.frame = CGRectMake(screenW / 3 * 2, 0, screenW / 3, _buttonView.height / 2);
    [_buttonView addSubview:_wordButton];
    //发声音
    _voiceButton = [self publishButtonWithImage:@"publish-audio" title:@"发声音"];
    _voiceButton.frame = CGRectMake(0, _buttonView.height / 2, screenW / 3, _buttonView.height / 2);
    [_buttonView addSubview:_voiceButton];
    //发链接
    _linkButton = [self publishButtonWithImage:@"publish-offline" title:@"发链接"];
    _linkButton.frame = CGRectMake(screenW / 3, _buttonView.height / 2, screenW / 3, _buttonView.height / 2);
    [_buttonView addSubview:_linkButton];
    //评论
    _reviewButton = [self publishButtonWithImage:@"publish-review" title:@"评论"];
    _reviewButton.frame = CGRectMake(screenW / 3 * 2, _buttonView.height / 2, screenW / 3, _buttonView.height / 2);
    [_buttonView addSubview:_reviewButton];
}

- (CLHPublishButton *)publishButtonWithImage:(NSString *)imageName title:(NSString *)title{
    CLHPublishButton *button = [[CLHPublishButton alloc] init];
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    return button;
}
@end
