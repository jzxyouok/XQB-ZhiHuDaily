//
//  ThemesStoryModelTool.m
//  XQB-ZhiHuDaily
//
//  Created by 许其斌 on 16/7/31.
//  Copyright © 2016年 scrat. All rights reserved.
//

#import "ThemesStoryModelTool.h"
#import "MJExtension.h"
#import "ThemesStoryModel.h"

@interface ThemesStoryModelTool()

@property (strong, nonatomic) NSArray *newsIds;

@end

@implementation ThemesStoryModelTool

#pragma mark - other methods
- (void)loadThemesWithThemesId:(NSInteger)themesId success:(CallBack)callBack
{
    [NetworkTool get:[NSString stringWithFormat:@"http://news-at.zhihu.com/api/4/theme/%d", themesId] params:nil success:^(id json) {
        ThemesStoryModel *themesStoryModel = [ThemesStoryModel mj_objectWithKeyValues:json];
        
        self.newsIds = [themesStoryModel.stories valueForKeyPath:@"id"];
        
        callBack(themesStoryModel);
    } failure:^(NSError *error) {
        nil;
    }];
}

- (BOOL)isFirstStoryId:(NSNumber *)storyId
{
    return [storyId isEqual:self.newsIds.firstObject];
}

- (BOOL)isLastStoryId:(NSNumber *)storyId
{
    return [storyId isEqual:self.newsIds.lastObject];
}

- (NSNumber *)getNextStoryIdWithCurrentStoryId:(NSNumber *)storyId
{
    return [self.newsIds objectAtIndex:[self.newsIds indexOfObject:storyId] + 1];
}

- (NSNumber *)getPrevStoryIdWithCurrentStoryId:(NSNumber *)storyId
{
    return [self.newsIds objectAtIndex:[self.newsIds indexOfObject:storyId] - 1];
}

#pragma mark - setter and getter
- (NSArray *)newsIds
{
    if (!_newsIds) {
        _newsIds = [NSArray array];
    }
    
    return _newsIds;
}

@end
