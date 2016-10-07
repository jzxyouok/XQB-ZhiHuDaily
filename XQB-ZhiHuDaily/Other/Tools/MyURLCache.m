//
//  MyURLCache.m
//  XQB-ZhiHuDaily
//
//  Created by 许其斌 on 16/8/7.
//  Copyright © 2016年 scrat. All rights reserved.
//

#import "MyURLCache.h"

static NSString * const CustomURLCacheExpirationKey = @"CustomURLCacheExpiration";
static NSTimeInterval const CustomURLCacheExpirationInterval = 600;

@implementation MyURLCache

+ (instancetype)standardURLCache
{
    static MyURLCache *_standardURLCache = nil;
    static dispatch_once_t onceToken;

    dispatch_once(&onceToken, ^{
        _standardURLCache = [[MyURLCache alloc]
                             initWithMemoryCapacity:(2 * 1024 * 1024)
                             diskCapacity:(100 * 1024 * 1024)
                             diskPath:nil];
    });
                  
    return _standardURLCache;
}

#pragma mark - NSURLCache
- (NSCachedURLResponse *)cachedResponseForRequest:(NSURLRequest *)request {
    NSCachedURLResponse *cachedResponse = [super cachedResponseForRequest:request];

    if (cachedResponse) {
//        NSLog(@"%s %@",__func__, cachedResponse.response);

        NSDate* cacheDate = cachedResponse.userInfo[CustomURLCacheExpirationKey];
        NSDate* cacheExpirationDate = [cacheDate dateByAddingTimeInterval:CustomURLCacheExpirationInterval];
        if ([cacheExpirationDate compare:[NSDate date]] == NSOrderedAscending) {
            [self removeCachedResponseForRequest:request];
            return nil;
        }
    }
    
    return cachedResponse;
}

- (void)storeCachedResponse:(NSCachedURLResponse *)cachedResponse
forRequest:(NSURLRequest *)request
{
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:cachedResponse.userInfo];
    userInfo[CustomURLCacheExpirationKey] = [NSDate date];

    NSCachedURLResponse *modifiedCachedResponse = [[NSCachedURLResponse alloc] initWithResponse:cachedResponse.response data:cachedResponse.data userInfo:userInfo storagePolicy:cachedResponse.storagePolicy];

    [super storeCachedResponse:modifiedCachedResponse forRequest:request];
}
                  
@end