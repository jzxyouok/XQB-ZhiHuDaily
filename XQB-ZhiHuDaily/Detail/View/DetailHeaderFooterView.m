//
//  DetailHeaderFooterView.m
//  XQB-ZhiHuDaily
//
//  Created by 许其斌 on 16/7/27.
//  Copyright © 2016年 scrat. All rights reserved.
//

#import "DetailHeaderFooterView.h"

@interface DetailHeaderView()

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *textlabel;
@property (weak, nonatomic) UIScrollView *scrollView;

@property (assign, nonatomic) id target;
@property (assign, nonatomic) SEL action;

@property (assign, nonatomic, getter=isLoading) BOOL loading;

@end


@implementation DetailHeaderView

+ (instancetype)detailHeaderViewAttachToScrollView:(UIScrollView *)scrollView target:(id)target action:(SEL)action
{
    DetailHeaderView *headerView = [[DetailHeaderView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
    
    headerView.imageView = [[UIImageView alloc]init];
    headerView.imageView.image = [UIImage imageNamed:@"ZHAnswerViewBackIcon"];
    [headerView.imageView sizeToFit];
    headerView.imageView.centerY = headerView.centerY;
    
    headerView.textlabel = [[UILabel alloc]init];
    headerView.textlabel.attributedText = [[NSAttributedString alloc]initWithString:@"载入上一篇" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize: 16], NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    [headerView.textlabel sizeToFit];
    headerView.textlabel.centerY = headerView.centerY;
    
    headerView.imageView.x = (headerView.width - headerView.imageView.width - headerView.textlabel.width - 10) / 2;
    headerView.textlabel.x = headerView.imageView.x + headerView.imageView.width + 10;
    
    [headerView addSubview:headerView.imageView];
    [headerView addSubview:headerView.textlabel];
    
    headerView.scrollView = scrollView;
    [headerView.scrollView addObserver:headerView forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew |
     NSKeyValueObservingOptionOld context:nil];
    
    headerView.target = target;
    headerView.action = action;
    
    return headerView;
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    UIScrollView *scrollView = object;

    CGFloat offsetY = scrollView.contentOffset.y + scrollView.contentInset.top;
    
    if (offsetY > SCALE_HEIGHT + 50) {
        return;
    } else if (offsetY < SCALE_HEIGHT + 30) {
        [UIView animateWithDuration:0.15f animations:^{
            self.imageView.transform = CGAffineTransformMakeRotation(M_PI);
        }];
        
        if (!scrollView.isDragging && !self.isLoading) {
            if ([self.target respondsToSelector:self.action]) {
                [self.target performSelector:self.action withObject:nil];
            }
            self.loading = YES;
        }
    } else {
        [UIView animateWithDuration:0.15f animations:^{
            self.imageView.transform = CGAffineTransformIdentity;
        }];
    }
}

- (void)dealloc
{
    //[self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
}

@end







@interface DetailFooterView()

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UILabel *textlabel;
@property (weak, nonatomic) UIScrollView *scrollView;

@property (assign, nonatomic) id target;
@property (assign, nonatomic) SEL action;

@property (assign, nonatomic, getter=isLoading) BOOL loading;

@end


@implementation DetailFooterView

+ (instancetype)detailFooterViewAttachToScrollView:(UIScrollView *)scrollView target:(id)target action:(SEL)action
{
    DetailFooterView *footerView = [[DetailFooterView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
    
    footerView.imageView = [[UIImageView alloc]init];
    footerView.imageView.image = [UIImage imageNamed:@"ZHAnswerViewPrevIcon"];
    [footerView.imageView sizeToFit];
    footerView.imageView.centerY = footerView.centerY;
    
    footerView.textlabel = [[UILabel alloc]init];
    footerView.textlabel.attributedText = [[NSAttributedString alloc]initWithString:@"载入下一篇" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize: 16], NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    [footerView.textlabel sizeToFit];
    footerView.textlabel.centerY = footerView.centerY;
    
    footerView.imageView.x = (footerView.width - footerView.imageView.width - footerView.textlabel.width - 10) / 2;
    footerView.textlabel.x = footerView.imageView.x + footerView.imageView.width + 10;
    
    [footerView addSubview:footerView.imageView];
    [footerView addSubview:footerView.textlabel];
    
    footerView.scrollView = scrollView;
    [footerView.scrollView addObserver:footerView forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew |
     NSKeyValueObservingOptionOld context:nil];
    
    footerView.target = target;
    footerView.action = action;
    
    return footerView;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    UIScrollView *scrollView = object;
    CGFloat offsetY = scrollView.contentOffset.y;
    
    //NSLog(@"%f %f", scrollView.contentOffset.y, scrollView.contentSize.height);
    
    if (offsetY < scrollView.contentSize.height - scrollView.height) {
        return;
    }else if (offsetY > scrollView.contentSize.height + 60 - scrollView.height) {
        [UIView animateWithDuration:0.15f animations:^{
            self.imageView.transform = CGAffineTransformMakeRotation(M_PI);
        }];
        
        if (!scrollView.isDragging && !self.isLoading) {
            if ([self.target respondsToSelector:self.action]) {
                [self.target performSelector:self.action withObject:nil];
            }
            self.loading = YES;
        }
    }else {
        [UIView animateWithDuration:0.15f animations:^{
            self.imageView.transform = CGAffineTransformIdentity;
        }];
        
    }
}

- (void)dealloc
{
    //[self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
}

@end