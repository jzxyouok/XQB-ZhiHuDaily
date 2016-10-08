//
//  UIViewController+HUD.m
//  XQB-ZhiHuDaily
//
//  Created by 许其斌 on 16/7/20.
//  Copyright © 2016年 scrat. All rights reserved.
//

#import "UIViewController+HUD.h"

#import "MBProgressHUD.h"
#import <objc/runtime.h>

static const void *HttpRequestHUDKey = &HttpRequestHUDKey;

@implementation UIViewController (HUD)

- (MBProgressHUD *)HUD{
    return objc_getAssociatedObject(self, HttpRequestHUDKey);
}

- (void)setHUD:(MBProgressHUD *)HUD{
    objc_setAssociatedObject(self, HttpRequestHUDKey, HUD, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)showHudInView:(UIView *)view hint:(NSString *)hint{
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
    
    hud.label.text = hint;
//    hud.contentColor = [UIColor whiteColor];
    //黑色透明
//    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
//    hud.bezelView.backgroundColor =[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    
    [view addSubview:hud];
    
    [hud showAnimated:YES];
    
    [self setHUD:hud];
}

- (void)showHint:(NSString *)hint
{
    UIView *view = [[UIApplication sharedApplication].delegate window];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
//    hud.userInteractionEnabled = NO;
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.label.text = hint;
//    hud.contentColor = [UIColor whiteColor];
//    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
//    hud.bezelView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
//    hud.margin = 10.f;
//    hud.offset.y = 180;
//    hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:2];
}

//- (void)showHint:(NSString *)hint yOffset:(float)yOffset
//{
//    UIView *view = [[UIApplication sharedApplication].delegate window];
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
//    hud.userInteractionEnabled = NO;
//    // Configure for text only and offset down
//    hud.mode = MBProgressHUDModeText;
//    hud.label.text = hint;
////    hud.margin = 10.f;
////    hud.yOffset = 180;
////    hud.yOffset += yOffset;
//    hud.offset = CGPointMake(0.f, MBProgressMaxOffset);
//    hud.removeFromSuperViewOnHide = YES;
//    [hud hide:YES afterDelay:2];
//}

- (void)hideHud{
    [[self HUD] hideAnimated:YES];
}

@end
