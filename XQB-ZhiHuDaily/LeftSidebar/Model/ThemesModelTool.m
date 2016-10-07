//
//  ThemesModelTool.m
//  XQB-ZhiHuDaily
//
//  Created by 许其斌 on 16/7/31.
//  Copyright © 2016年 scrat. All rights reserved.
//

#import "ThemesModelTool.h"
#import "MJExtension.h"
#import "ThemesModel.h"

@implementation ThemesModelTool

+ (void) loadThemesWithCallBack:(CallBack)callBack
{
    [NetworkTool get:@"http://news-at.zhihu.com/api/4/themes" params:nil success:^(id json) {
        NSArray *themes = [NSArray array];
        themes = [ThemesModel mj_objectArrayWithKeyValuesArray: json[@"others"]];
        callBack(themes);
    } failure:^(NSError *error) {
        nil;
    }];
}

@end
