//
//  DetailStoryModelTool.m
//  XQB-ZhiHuDaily
//
//  Created by 许其斌 on 16/7/24.
//  Copyright © 2016年 scrat. All rights reserved.
//

#import "DetailStoryModelTool.h"
#import "DetailStoryModel.h"
#import "StoryExtra.h"
#import "MJExtension.h"

@implementation DetailStoryModelTool

+ (void)loadDetailStoryWithStoryId:(NSNumber *)storyId success:(CallBack)callBack
{
    [NetworkTool get:[NSString stringWithFormat:@"http://news-at.zhihu.com/api/4/news/%@", storyId] params:nil success:^(id json) {
        DetailStoryModel *news = [DetailStoryModel mj_objectWithKeyValues:json];
        
        news.htmlUrl = [NSString stringWithFormat:@"<html><head><link rel=\"stylesheet\" href=%@></head><body>%@</body></html>",news.css[0],news.body];
        
        callBack(news);
    } failure:^(NSError *error) {
        nil;
    }];
}

+ (void)loadStoryExtraWithStoryId:(NSNumber *)storyId success:(CallBack)callBack
{
    [NetworkTool get:[NSString stringWithFormat:@"http://news-at.zhihu.com/api/4/story-extra/%@", storyId] params:nil success:^(id json) {
        StoryExtra *storyExtra = [StoryExtra mj_objectWithKeyValues:json];
        
        callBack(storyExtra);
    } failure:^(NSError *error) {
        nil;
    }];
}

@end
