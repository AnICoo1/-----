//
//  CLHLoginAndRegisterView.m
//  BaiSiBuDeJie
//
//  Created by AnICoo1 on 17/1/22.
//  Copyright © 2017年 AnICoo1. All rights reserved.
//

#import "CLHLoginAndRegisterView.h"

@interface CLHLoginAndRegisterView ()

@property (weak, nonatomic) IBOutlet UIButton *loginbutton;


@end

@implementation CLHLoginAndRegisterView

+ (instancetype)loginView{
    
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil]firstObject];
}

+ (instancetype)registerView{
    
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil]lastObject];
}
- (void)awakeFromNib{
    
    UIImage *image = self.loginbutton.currentBackgroundImage;
    
    image = [image stretchableImageWithLeftCapWidth:image.size.width * 0.5 topCapHeight:image.size.height * 0.5];
    
    // 让按钮背景图片不要被拉伸
    [self.loginbutton setBackgroundImage:image forState:UIControlStateNormal];
}


@end
