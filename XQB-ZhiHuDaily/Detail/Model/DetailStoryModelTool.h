//
//  DetailStoryModelTool.h
//  XQB-ZhiHuDaily
//
//  Created by 许其斌 on 16/7/24.
//  Copyright © 2016年 scrat. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^CallBack)(id obj);

@interface DetailStoryModelTool : NSObject

+ (void)loadDetailStoryWithStoryId:(NSNumber *)storyId success:(CallBack)callBack;
+ (void)loadStoryExtraWithStoryId:(NSNumber *)storyId success:(CallBack)callBack;

@end
