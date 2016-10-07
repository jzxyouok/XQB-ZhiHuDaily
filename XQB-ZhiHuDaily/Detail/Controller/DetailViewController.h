//
//  DetailViewController.h
//  XQB-ZhiHuDaily
//
//  Created by 许其斌 on 16/7/24.
//  Copyright © 2016年 scrat. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DetailViewDelegate <NSObject>

@optional
- (void)detaileViewScrollToNextWithStoryId:(NSNumber *)storyId;
- (void)detaileViewScrollToPrevWithStoryId:(NSNumber *)storyId;

@end

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id storyTool;
@property (strong, nonatomic) NSNumber *storyId;

@property (weak, nonatomic) id<DetailViewDelegate> delegate;

@end
