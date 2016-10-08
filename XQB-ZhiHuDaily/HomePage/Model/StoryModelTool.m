//
//  StoryModelTool.m
//  XQB-ZhiHuDaily
//
//  Created by 许其斌 on 16/7/22.
//  Copyright © 2016年 scrat. All rights reserved.
//

#import "StoryModelTool.h"
#import "MJExtension.h"
#import "StoryModel.h"

@interface StoryModelTool()

@property (strong, nonatomic) NSMutableArray *newsItems;
@property (strong ,nonatomic) NSMutableArray *newsIds;
@property (assign, nonatomic, getter=isLoading) BOOL loading;

@end

@implementation StoryModelTool

#pragma mark - setter and getter
- (NSMutableArray *)newsIds
{
    if (!_newsIds) {
        _newsIds = [NSMutableArray array];
    }
    
    return _newsIds;
}

- (NSMutableArray *)newsItems
{
    if (!_newsItems) {
        _newsItems = [NSMutableArray array];
    }
    
    return _newsItems;
}

#pragma mark - other methods
- (void)loadNewsWithCallBack:(CallBack)callBack
{
    [NetworkTool get:@"http://news-at.zhihu.com/api/4/news/latest" params:nil success:^(id json) {
        SectionModel *news = [SectionModel mj_objectWithKeyValues:json];
        [self.newsItems addObject:news];
        [self updateNewsIds];
        objc_setAssociatedObject([self class], (__bridge const void *)(self.newsItems), news.date, OBJC_ASSOCIATION_COPY_NONATOMIC);
        callBack(self.newsItems);
    } failure:^(NSError *error) {
        nil;
    }];
}

- (void)updateNewsWithCallBack:(CallBack)callBack
{
    [NetworkTool get:@"http://news-at.zhihu.com/api/4/news/latest" params:nil success:^(id json) {
        SectionModel *news = [SectionModel mj_objectWithKeyValues:json];
        [self.newsItems replaceObjectAtIndex:0 withObject:news];
        [self updateNewsIds];
        callBack(self.newsItems);
    } failure:^(NSError *error) {
        nil;
    }];
}

- (void)loadOldNewsWithCallBack:(CallBack)callBack
{
    if (self.isLoading) {
        return;
    }
    self.loading = !self.loading;
    
    id date = objc_getAssociatedObject([self class], (__bridge const void *)(self.newsItems));
    NSString *url = [NSString stringWithFormat:@"http://news.at.zhihu.com/api/4/news/before/%@", date];
    
    [NetworkTool get:url params:nil success:^(id json) {
        SectionModel *news = [SectionModel mj_objectWithKeyValues:json];
        [self.newsItems addObject:news];
        [self updateNewsIds];
        objc_setAssociatedObject([self class], (__bridge const void *)(self.newsItems), news.date, OBJC_ASSOCIATION_COPY_NONATOMIC);
        callBack(self.newsItems);
        self.loading = !self.loading;
    } failure:^(NSError *error) {
        nil;
    }];
}

- (void)updateNewsIds
{
    self.newsIds = [self.newsItems valueForKeyPath:@"stories.id"];
    
    NSMutableArray *mutableArray = [NSMutableArray array];
    for (NSArray *array in self.newsIds) {
        [mutableArray addObjectsFromArray:array];
    }
    self.newsIds = mutableArray;
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

@end
