//
//  ThemesModelTool.h
//  XQB-ZhiHuDaily
//
//  Created by 许其斌 on 16/7/31.
//  Copyright © 2016年 scrat. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^CallBack)(id obj);

@interface ThemesModelTool : NSObject

+ (void)loadThemesWithCallBack:(CallBack)callBack;

@end
