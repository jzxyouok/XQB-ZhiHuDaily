//
//  NetworkTool.m
//  XQBZhiHuDaily
//
//  Created by 许其斌 on 16/7/12.
//  Copyright © 2016年 scrat. All rights reserved.
//

#import "NetworkTool.h"
#import "AFNetWorking.h"
#import "MyURLCache.h"

@implementation NetworkTool

+ (void)get:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];

//    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];

//    session.requestSerializer.cachePolicy = appDelegate.isNetworkReachability ?  NSURLRequestUseProtocolCachePolicy : NSURLRequestReturnCacheDataElseLoad;
    
//    NSLog(@"%d %d",appDelegate.isNetworkReachability, session.requestSerializer.cachePolicy);
    
    [session GET:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        nil;
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//        NSLog(@"%s",__func__);
        if (failure) {
            failure(error);
        }
    }];
}

+ (void)setupNetworkReachability
{
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];

    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"不可达的网络(未连接)");
                break;

            case AFNetworkReachabilityStatusReachableViaWWAN:
            case AFNetworkReachabilityStatusReachableViaWiFi:
                NSLog(@"3G/wifi的网络");
                break;
            default:
                break;
        }
    }];

    [manager startMonitoring];

    NSURLCache *sharedCache = [MyURLCache standardURLCache];
    [NSURLCache setSharedURLCache:sharedCache];
}

@end
