//
//  DetailToolBar.h
//  XQB-ZhiHuDaily
//
//  Created by 许其斌 on 16/7/28.
//  Copyright © 2016年 scrat. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DetailToolBarDelegate <NSObject>

@optional
- (void)buttonTouchUpWithTag:(NSInteger)tag;

@end

@interface DetailToolBar : UIView

@property (weak, nonatomic) NSNumber *storyId;
@property (weak, nonatomic) id<DetailToolBarDelegate> delegate;

@end
