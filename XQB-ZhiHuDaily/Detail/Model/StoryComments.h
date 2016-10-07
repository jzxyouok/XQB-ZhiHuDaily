//
//  StoryComments.h
//  XQB-ZhiHuDaily
//
//  Created by 许其斌 on 16/8/31.
//  Copyright © 2016年 scrat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StoryComments : NSObject
@property (strong, nonatomic) NSString *author;
@property (strong, nonatomic) NSString *content;
@property (assign, nonatomic) NSNumber *likes;
@property (assign, nonatomic) NSNumber *ID;
@property (assign, nonatomic) NSNumber *time;
@property (strong, nonatomic) NSString *avatar;
@end
