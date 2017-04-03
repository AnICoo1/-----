//
//  CLHUserCell.m
//  BaiSiBuDeJie
//
//  Created by AnICoo1 on 17/2/15.
//  Copyright © 2017年 AnICoo1. All rights reserved.
//

#import "CLHUserCell.h"
#import "UIImageView+WebCache.h"

#import "CLHCommendUser.h"

@interface CLHUserCell ()

@property (weak, nonatomic) IBOutlet UIImageView *userImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *fansCountLabel;


@end


@implementation CLHUserCell

- (void)setUser:(CLHCommendUser *)user{
    
    _user = user;
    [self.userImageView clh_setHeader:user.header];
    
    self.nameLabel.text = user.screen_name;
    self.fansCountLabel.text = [NSString stringWithFormat:@"%zd人关注",user.fans_count];
}

@end
