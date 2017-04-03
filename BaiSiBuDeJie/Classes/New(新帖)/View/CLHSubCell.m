//
//  CLHSubCell.m
//  BaiSiBuDeJie
//
//  Created by AnICoo1 on 17/1/21.
//  Copyright © 2017年 AnICoo1. All rights reserved.
//

#import "CLHSubCell.h"
#import "UIImageView+WebCache.h"
#import "CLHSubItem.h"

@interface CLHSubCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imageV;

@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *subTitleL;

@end


@implementation CLHSubCell

//bug:cell之间的间隔线
-(void)setFrame:(CGRect)frame{
    
    frame.size.height -= 1;
    
    [super setFrame:frame];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // 设置头像圆角,iOS9苹果修复
//    self.imageV.layer.cornerRadius = 30;
//    self.imageV.layer.masksToBounds = YES;
    UIImage *image = self.imageView.image;
    [image circleImage];
    self.imageView.image = image;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setData:(CLHSubItem *)data{
    
    self.titleL.text = data.theme_name;
    
    // 判断下有没有>10000
    NSString *numStr = [NSString stringWithFormat:@"%@人订阅",data.sub_number] ;
    NSInteger num = data.sub_number.integerValue;
    if (num > 10000) {
        CGFloat numF = num / 10000.0;
        numStr = [NSString stringWithFormat:@"%.1f万人订阅",numF];
        numStr = [numStr stringByReplacingOccurrencesOfString:@".0" withString:@""];
    }
    self.subTitleL.text = numStr;
    
    //设置没有加载出数据的时候占位的图片
    [self.imageV clh_setHeader:data.image_list];
    
    
}

@end
