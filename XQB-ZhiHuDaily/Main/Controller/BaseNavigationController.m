//
//  BaseNavigationController.m
//  XQB-ZhiHuDaily
//
//  Created by 许其斌 on 16/7/23.
//  Copyright © 2016年 scrat. All rights reserved.
//

#import "BaseNavigationController.h"

@implementation BaseNavigationController

- (UIViewController *)childViewControllerForStatusBarStyle{
    return self.topViewController;
}

@end
