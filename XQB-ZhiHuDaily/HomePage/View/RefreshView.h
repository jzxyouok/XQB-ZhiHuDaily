//
//  RefreshView.h
//  XQB-ZhiHuDaily
//
//  Created by 许其斌 on 16/7/23.
//  Copyright © 2016年 scrat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RefreshView : UIView

+ (instancetype)refreshViewAttachToScrollView:(UIScrollView *)scrollView target:(id) target action:(SEL)action
;

- (void)stopAnimation;

@end
