//
//  ThemesStoryModelTool.h
//  XQB-ZhiHuDaily
//
//  Created by 许其斌 on 16/7/31.
//  Copyright © 2016年 scrat. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^CallBack)(id obj);

@interface ThemesStoryModelTool : NSObject

- (void)loadThemesWithThemesId:(NSInteger)themesId success:(CallBack)callBack;

- (BOOL)isFirstStoryId:(NSNumber *)storyId;
- (BOOL)isLastStoryId:(NSNumber *)storyId;

- (NSNumber *)getNextStoryIdWithCurrentStoryId:(NSNumber *)storyId;
- (NSNumber *)getPrevStoryIdWithCurrentStoryId:(NSNumber *)storyId;

@end
