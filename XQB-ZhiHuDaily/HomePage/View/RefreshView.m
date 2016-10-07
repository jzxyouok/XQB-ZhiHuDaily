//
//  RefreshView.m
//  XQB-ZhiHuDaily
//
//  Created by 许其斌 on 16/7/23.
//  Copyright © 2016年 scrat. All rights reserved.
//

#import "RefreshView.h"

@interface RefreshView()
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicatorView;
@property (strong, nonatomic) CAShapeLayer *whiteLayer;
@property (strong, nonatomic) CAShapeLayer *grayLayer;
@property (assign, nonatomic, getter=isRefresh) BOOL refresh;

@property (weak, nonatomic) UIScrollView *scrollView;

@property (assign, nonatomic) id target;
@property (assign, nonatomic) SEL action;

@end

@implementation RefreshView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _activityIndicatorView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        [_activityIndicatorView stopAnimating];
        [self addSubview:_activityIndicatorView];
        
        CGFloat radius = MIN(frame.size.width, frame.size.height)/2 - 2;
        
        _grayLayer = [[CAShapeLayer alloc]init];
        _grayLayer.fillColor = [UIColor clearColor].CGColor;
        _grayLayer.strokeColor = [UIColor grayColor].CGColor;
        _grayLayer.opacity = 0.f;
        _grayLayer.lineWidth = 1.0f;
        _grayLayer.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(frame.size.width / 2 - radius, frame.size.width / 2 - radius, radius * 2, radius * 2)].CGPath;
        [self.layer addSublayer:_grayLayer];
        
        _whiteLayer = [[CAShapeLayer alloc]init];
        _whiteLayer.fillColor = [UIColor clearColor].CGColor;
        _whiteLayer.strokeColor = [UIColor whiteColor].CGColor;
        _whiteLayer.opacity = 0.f;
        _whiteLayer.lineWidth = 1.f;
        _whiteLayer.strokeEnd = 0.f;
        _whiteLayer.path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(frame.size.width / 2, frame.size.height / 2) radius:radius startAngle:M_PI_2 endAngle:M_PI * 5 / 2 clockwise:YES].CGPath;
        [self.layer addSublayer:_whiteLayer];
        
    }
    
    return self;
}

- (void)setProcess:(CGFloat) process
{
    if (!_refresh) {
        if (process > 0) {
            _whiteLayer.opacity = 1.f;
            _grayLayer.opacity = 1.f;
        } else {
            _whiteLayer.opacity = 0.f;
            _grayLayer.opacity = 0.f;
        }
        [CATransaction setDisableActions:YES];
        _whiteLayer.strokeEnd = process;
    }
}

- (void)startAnimation
{
    if (!_refresh) {
        self.refresh = YES;
        
        _whiteLayer.opacity = 0.f;
        _grayLayer.opacity = 0.f;

        [self.activityIndicatorView startAnimating];
        if ([self.target respondsToSelector:self.action]) {
            [self.target performSelector:self.action withObject:nil];
        }
    }
}

- (void)stopAnimation
{
    self.refresh = NO;
    [self setProcess: 0];
    [self.activityIndicatorView stopAnimating];
}

+ (instancetype)refreshViewAttachToScrollView:(UIScrollView *)scrollView target:(id) target action:(SEL)action
{
    RefreshView *refreshView = [[RefreshView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    
    refreshView.scrollView = scrollView;
    refreshView.action = action;
    refreshView.target = target;
    refreshView.refresh = NO;
    
    [scrollView addObserver:refreshView forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    
    return refreshView;
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    if (_refresh) {
        return;
    }
    
    UIScrollView *scrollView = object;
    CGFloat offsetY = scrollView.contentOffset.y;
    
//    NSLog(@"offsetY %f",offsetY);
    if (offsetY <= -80 && !scrollView.isDragging) {
        [self startAnimation];
    } else if (offsetY <= -10 && offsetY >= -90) {
        CGFloat process = offsetY * (1.f / -80);
        [self setProcess: process];
    } else if (offsetY > -10 && offsetY < 0) {
//        NSLog(@"setProcess");
        [self setProcess: 0];
    }
}

- (void)dealloc
{
    [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
}

@end
