//
//  NetworkTool.h
//  XQBZhiHuDaily
//
//  Created by 许其斌 on 16/7/12.
//  Copyright © 2016年 scrat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NetworkTool : NSObject

+ (void)get:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;

+ (void)setupNetworkReachability;

@end
