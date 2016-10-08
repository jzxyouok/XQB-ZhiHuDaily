//
//  TopImageView.m
//  XQBZhiHuDaily
//
//  Created by 许其斌 on 16/7/11.
//  Copyright © 2016年 scrat. All rights reserved.
//

#import "TopImageView.h"
#import "UIImageView+WebCache.h"

@interface TopImageView()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *imageSourceLabel;
@property (weak, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) StoryModel *storyModel;
@property (strong, nonatomic) CAGradientLayer *grandient;
@property (assign, nonatomic) NSUInteger loadCount;
@end

@implementation TopImageView

- (void)awakeFromNib
{
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.clipsToBounds = YES;
}

//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
//{
//    NSLog(@"%s",__func__);
//    
//    return nil;
//}

+ (instancetype) initWithFrame:(CGRect)frame andStoryModel:(StoryModel *)storyModel
{
    TopImageView *imageView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
    
    imageView.frame = frame;
    imageView.storyModel = storyModel;
    
    imageView.grandient = [CAGradientLayer layer];
    imageView.grandient.frame = imageView.frame;
    imageView.grandient.colors = @[(id)[[UIColor blackColor] colorWithAlphaComponent:0.35f].CGColor,
                         (id)[[UIColor blackColor] colorWithAlphaComponent:0.f].CGColor,
                         (id)[[UIColor blackColor] colorWithAlphaComponent:0.35f].CGColor];
    imageView.grandient.locations = @[@0.0,@0.2,@0.8,@1.0];
    imageView.grandient.startPoint = CGPointMake(0, 0);
    imageView.grandient.endPoint = CGPointMake(0, 1);
    [imageView.imageView.layer addSublayer:imageView.grandient];
    
    return imageView;
}

- (void)layoutSubviews
{
    [CATransaction setDisableActions:YES];
    self.grandient.frame = CGRectMake(0, 0, self.width, self.height);
}

+ (instancetype)topImageViewAttachToScrollView:(UIScrollView *)scrollView
{
    TopImageView *imageView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
    
    imageView.frame = CGRectMake(0, SCALE_HEIGHT, kScreenWidth, kScreenWidth);
    
    imageView.grandient = [CAGradientLayer layer];
    imageView.grandient.frame = imageView.frame;
    imageView.grandient.colors = @[(id)[[UIColor blackColor] colorWithAlphaComponent:0.35f].CGColor,
                                   (id)[[UIColor blackColor] colorWithAlphaComponent:0.f].CGColor,
                                   (id)[[UIColor blackColor] colorWithAlphaComponent:0.35f].CGColor];
    imageView.grandient.locations = @[@0.0,@0.2,@0.8,@1.0];
    imageView.grandient.startPoint = CGPointMake(0, 0);
    imageView.grandient.endPoint = CGPointMake(0, 1);
    [imageView.imageView.layer addSublayer:imageView.grandient];
    
    imageView.scrollView = scrollView;
    [imageView.scrollView addObserver:imageView forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    
    return imageView;
}

#pragma mark - other methods
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    UIScrollView *scrollView = object;
    CGFloat offsetY = scrollView.contentOffset.y + scrollView.contentInset.top;
    
//    NSLog(@"%f", offsetY);
    /*  */
    if (_loadCount < 6) {
        _loadCount++;
//        NSLog(@"%f %ld", scrollView.contentOffset.y, _loadCount);
        return;
    }
    
//    NSLog(@"%f %f %f", offsetY, self.y, SCALE_HEIGHT);
    
    CGRect rect = self.frame;
    if (offsetY < 0 && offsetY > SCALE_HEIGHT) {
        rect.origin.y = SCALE_HEIGHT - offsetY;
        scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(CONTENT_HEIGHT - 20 - offsetY, 0, 0, 0);
    } else if (offsetY < SCALE_HEIGHT) {
        scrollView.contentOffset = CGPointMake(0, (int)(SCALE_HEIGHT - scrollView.contentInset.top));
    } else if (offsetY > 0 && offsetY < CONTENT_HEIGHT - 20) {
        rect.origin.y = SCALE_HEIGHT - offsetY;
        scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(CONTENT_HEIGHT - 20 - offsetY, 0, 0, 0);
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    } else if (offsetY > CONTENT_HEIGHT - 20) {
        rect.origin.y = SCALE_HEIGHT - offsetY;
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    }
    self.frame = rect;
}

#pragma mark - setter and getter
- (void)setDetailModel:(DetailStoryModel *)detailModel
{
    _detailModel = detailModel;
    
    self.titleLabel.text = detailModel.title;
    self.imageSourceLabel.text = [NSString stringWithFormat:@"图片：%@",detailModel.image_source];
    self.imageSourceLabel.hidden = NO;
    
    //NSLog(@"%s %@", __func__ , self.titleLabel.text);
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:detailModel.image]
                      placeholderImage:[UIImage imageNamed:@"Image_Preview"]];
}

- (void)setStoryModel:(StoryModel *)storyModel
{
    _storyModel = storyModel;
    
    self.titleLabel.text = storyModel.title;
    self.imageSourceLabel.hidden = YES;
    
    //NSLog(@"%s %@", __func__ , self.titleLabel.text);
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:storyModel.image]
                       placeholderImage:[UIImage imageNamed:@"Image_Preview"]];
}

- (void)dealloc
{
    [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
}

@end
