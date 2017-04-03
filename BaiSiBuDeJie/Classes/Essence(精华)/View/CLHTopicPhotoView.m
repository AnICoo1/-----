//
//  CLHTopicPhotoView.m
//  BaiSiBuDeJie
//
//  Created by AnICoo1 on 17/1/31.
//  Copyright © 2017年 AnICoo1. All rights reserved.
//

#import "CLHTopicPhotoView.h"


#import "CLHSeeBigPhotoViewController.h"
#import "CLHTopicItem.h"

@interface CLHTopicPhotoView ()

@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
@property (weak, nonatomic) IBOutlet UIImageView *placeholderImageView;
@property (weak, nonatomic) IBOutlet UIImageView *gifImageView;
@property (weak, nonatomic) IBOutlet UIButton *seeBigPhotoButton;

@end

@implementation CLHTopicPhotoView

- (void)awakeFromNib
{
    self.autoresizingMask = UIViewAutoresizingNone;
    
    self.backImageView.userInteractionEnabled = YES;
    [self.backImageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(seeBigPicture)]];
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

- (void)setTopic:(CLHTopicItem *)topic
{
    _topic = topic;
    
    // 设置图片
    self.placeholderImageView.hidden = NO;
    
    [self.backImageView clh_setOriginImage:topic.image1 thumbnailImage:topic.image0 placeholder:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (!image) return;
        
        self.placeholderImageView.hidden = YES;
        
        // 处理超长图片的大小
        if (topic.isBigPicture) {
            CGFloat imageW = topic.middleFrame.size.width;
            CGFloat imageH = imageW * topic.height / topic.width;
            
            // 开启上下文
            UIGraphicsBeginImageContext(CGSizeMake(imageW, imageH));
            // 绘制图片到上下文中
            [self.backImageView.image drawInRect:CGRectMake(0, 0, imageW, imageH)];
            self.backImageView.image = UIGraphicsGetImageFromCurrentImageContext();
            // 关闭上下文
            UIGraphicsEndImageContext();
        }
    }];
    
    // gif
    self.gifImageView.hidden = !topic.is_gif;
    
    //NSLog(@"%d",topic.isBigPicture);
    
    // 点击查看大图
    if (topic.isBigPicture) { // 超长图
        self.seeBigPhotoButton.hidden = NO;
        self.backImageView.contentMode = UIViewContentModeTop;
        self.backImageView.clipsToBounds = YES;
    } else {
        self.seeBigPhotoButton.hidden = YES;
        self.backImageView.contentMode = UIViewContentModeScaleToFill;
        self.backImageView.clipsToBounds = NO;
    }
}

@end
