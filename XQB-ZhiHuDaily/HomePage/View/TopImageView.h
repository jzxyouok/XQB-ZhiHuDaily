//
//  TopImageView.h
//  XQBZhiHuDaily
//
//  Created by 许其斌 on 16/7/11.
//  Copyright © 2016年 scrat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoryModel.h"
#import "DetailStoryModel.h"

@interface TopImageView : UIView

@property (strong, nonatomic) DetailStoryModel *detailModel;

+ (instancetype)initWithFrame:(CGRect)frame andStoryModel:(StoryModel *)storyModel;
+ (instancetype)topImageViewAttachToScrollView:(UIScrollView *)scrollView;

@end
