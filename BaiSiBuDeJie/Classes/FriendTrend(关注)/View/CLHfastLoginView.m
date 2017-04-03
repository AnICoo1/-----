//
//  CLHfastLoginView.m
//  BaiSiBuDeJie
//
//  Created by AnICoo1 on 17/1/22.
//  Copyright © 2017年 AnICoo1. All rights reserved.
//

#import "CLHfastLoginView.h"

@implementation CLHfastLoginView

+ (instancetype)loginView{
    
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil]firstObject];
}

@end
