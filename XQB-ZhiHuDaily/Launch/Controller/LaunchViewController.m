//
//  LaunchViewController.m
//  XQB-ZhiHuDaily
//
//  Created by 许其斌 on 16/7/24.
//  Copyright © 2016年 scrat. All rights reserved.
//

#import "LaunchViewController.h"
#import "UIImageView+WebCache.h"

@interface LaunchViewController()

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIImageView *logoImageView;
@property (strong, nonatomic) UILabel *textLabel;
@property (strong, nonatomic) CAGradientLayer *grandient;

@end

@implementation LaunchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [UIApplication sharedApplication].statusBarHidden = YES;
    
    [self.view addSubview:self.imageView];
    [self.view addSubview:self.logoImageView];
    [self.view addSubview:self.textLabel];
    [self showLaunchImage];
}

- (void)showLaunchImage
{
    
    [NetworkTool get:@"http://news-at.zhihu.com/api/4/start-image/1080*1776" params:nil success:^(id json) {
        
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        
        [manager downloadImageWithURL:[NSURL URLWithString:json[@"img"]] options: 0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            nil;
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
            if (error) {
                NSLog(@"error is %@",error);
            }
            [UIApplication sharedApplication].statusBarHidden = NO;
            self.imageView.image  = image;
            
            self.grandient = [CAGradientLayer layer];
            self.grandient.frame = self.imageView.bounds;
            self.grandient.colors = @[(id)[[UIColor blackColor] colorWithAlphaComponent:0.1f].CGColor,
                                           (id)[[UIColor blackColor] colorWithAlphaComponent:0.f].CGColor,
                                           (id)[[UIColor blackColor] colorWithAlphaComponent:0.1f].CGColor];
            self.grandient.locations = @[@0.0,@0.2,@0.8,@1.0];
            self.grandient.startPoint = CGPointMake(0, 0);
            self.grandient.endPoint = CGPointMake(0, 1);
            [self.imageView.layer addSublayer:self.grandient];
            
            self.textLabel.text = json[@"text"];
            [self.textLabel sizeToFit];
            self.textLabel.centerX = self.view.centerX;
            self.textLabel.y = self.view.height - 30;
            
            self.logoImageView.hidden = NO;
            
            [UIView animateWithDuration:3.f animations:^{
                self.imageView.transform = CGAffineTransformMakeScale(1.2, 1.2);
            } completion:^(BOOL finished) {
//                [self.view removeFromSuperview];
                [UIView animateWithDuration:1.f animations:^{
                    self.view.alpha = 0.f;
                } completion:^(BOOL finished) {
//                    [UIApplication sharedApplication].statusBarHidden = NO;
                    [self.view removeFromSuperview];
                }];
            }];
        }];
    } failure:^(NSError *error) {
        nil;
    }];
}

- (UIImageView *)imageView
{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _imageView.image = [UIImage imageNamed:@"Default"];
        //_imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    
    return _imageView;
}

- (UIImageView *)logoImageView
{
    if (!_logoImageView) {
        _logoImageView = [[UIImageView alloc]init];
        _logoImageView.image = [UIImage imageNamed:@"Login_Logo"];
        [_logoImageView sizeToFit];
        _logoImageView.centerX = self.view.centerX;
        _logoImageView.y = self.view.height - 100;
        
        _logoImageView.hidden = YES;
    }
    
    return _logoImageView;
}

-(UILabel *)textLabel
{
    if (!_textLabel) {
        _textLabel = [[UILabel alloc]init];
        _textLabel.textColor = [UIColor whiteColor];
        _textLabel.font = [UIFont systemFontOfSize: 14];
    }
    
    return _textLabel;
}


@end


