//
//  DetailHeaderFooterView.h
//  XQB-ZhiHuDaily
//
//  Created by 许其斌 on 16/7/27.
//  Copyright © 2016年 scrat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailHeaderView : UIView

+ (instancetype)detailHeaderViewAttachToScrollView:(UIScrollView *)scrollView target:(id)target action:(SEL)action;

@end

@interface DetailFooterView : UIView

+ (instancetype)detailFooterViewAttachToScrollView:(UIScrollView *)scrollView target:(id)target action:(SEL)action;

@end