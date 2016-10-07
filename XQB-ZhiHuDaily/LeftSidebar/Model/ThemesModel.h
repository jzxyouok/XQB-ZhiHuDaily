//
//  ThemsModel.h
//  XQB-ZhiHuDaily
//
//  Created by 许其斌 on 16/7/31.
//  Copyright © 2016年 scrat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ThemesModel: NSObject

@property (assign, nonatomic) NSNumber *color;
@property (strong, nonatomic) NSString *thumbnail;
//@property (strong, nonatomic) NSString *description;
@property (assign, nonatomic) NSInteger ID;
@property (strong, nonatomic) NSString *name;

@end

@interface ThemesSectionModel: NSObject

@property (assign, nonatomic) NSNumber *limit;
@property (strong, nonatomic) NSArray *subscribed;
@property (strong, nonatomic) NSArray *others;

@end
