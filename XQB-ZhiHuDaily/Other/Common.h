//
//  Common.h
//  XQB-ZhiHuDaily
//
//  Created by 许其斌 on 16/7/20.
//  Copyright © 2016年 scrat. All rights reserved.
//

#ifndef Common_h
#define Common_h

#import <UIKit/UIKit.h>
#import "UIView+Category.h"
#import "HttpTool.h"

/* Screen param */
#define kScreenSize  ([UIScreen mainScreen].bounds.size)
#define kScreenWidth  ([UIScreen mainScreen].bounds.size.width)
#define kScreenHeight  ([UIScreen mainScreen].bounds.size.height)

#define SCREEN_WIDTH       ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT      ([UIScreen mainScreen].bounds.size.height)
#define CONTENT_HEIGHT     (SCREEN_WIDTH * (3.5 / 5.0))
#define SCALE_HEIGHT       (CONTENT_HEIGHT - SCREEN_WIDTH)

#endif /* Common_h */
