//
//  StoryModel.h
//  XQB-ZhiHuDaily
//
//  Created by 许其斌 on 16/7/22.
//  Copyright © 2016年 scrat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StoryModel : NSObject
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *image;
@property (strong, nonatomic) NSArray *images;
@property (assign, nonatomic) NSNumber *type;
@property (assign, nonatomic) NSNumber *ID;
@property (strong, nonatomic) NSString *ga_prefix;
@property (assign, nonatomic) BOOL multipic;
@end

@interface SectionModel : NSObject
@property (strong, nonatomic) NSString *date;
@property (strong ,nonatomic) NSArray *stories;
@property (strong ,nonatomic) NSArray *top_stories;
@end