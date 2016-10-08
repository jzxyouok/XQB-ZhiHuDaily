//
//  UIViewController+HUD.h
//  XQB-ZhiHuDaily
//
//  Created by 许其斌 on 16/7/20.
//  Copyright © 2016年 scrat. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface UIViewController (HUD)

- (void)showHudInView:(UIView *)view hint:(NSString *)hint;

- (void)hideHud;

- (void)showHint:(NSString *)hint;


@end
