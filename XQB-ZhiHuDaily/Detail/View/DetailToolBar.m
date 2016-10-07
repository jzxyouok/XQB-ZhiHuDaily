//
//  DetailToolBar.m
//  XQB-ZhiHuDaily
//
//  Created by 许其斌 on 16/7/28.
//  Copyright © 2016年 scrat. All rights reserved.
//

#import "DetailToolBar.h"
#import "DetailStoryModelTool.h"
#import "StoryExtra.h"

@interface DetailToolBar()

@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *nextButton;
@property (nonatomic, strong) UIButton *praiseButton;
@property (nonatomic, strong) UIButton *commentButton;
@property (nonatomic, strong) UIButton *shareButton;

@property (nonatomic, strong) UILabel *praiseLabel;
@property (nonatomic, strong) UILabel *commentLabel;

@end

@implementation DetailToolBar

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self == [super initWithFrame:frame]) {
        
        [self addSubview:self.backButton];
        [self addSubview:self.nextButton];
        [self addSubview:self.praiseButton];
        [self addSubview:self.commentButton];
        [self addSubview:self.shareButton];
        
        [self.praiseButton addSubview:self.praiseLabel];
        [self.commentButton addSubview:self.commentLabel];
    }
    
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    _backButton.frame = self.bounds;
    _backButton.width = self.width * 0.2;
    
    _nextButton.frame = _backButton.frame;
    _nextButton.x = _backButton.width;
    
    _praiseButton.frame = _nextButton.frame;
    _praiseButton.x = _nextButton.x + _nextButton.width;
    
    _shareButton.frame = _praiseButton.frame;
    _shareButton.x = _praiseButton.x + _praiseButton.width;
    
    _commentButton.frame = _shareButton.frame;
    _commentButton.x = _shareButton.x + _shareButton.width;
    
    _praiseLabel.x = _praiseButton.width * 0.5;
    _praiseLabel.y = _praiseButton.height * 0.2;
    _praiseLabel.width = _praiseButton.width * 0.3;
    _praiseLabel.height = _praiseButton.height * 0.2;
    
    _commentLabel.x = _commentButton.width * 0.5;
    _commentLabel.y = _commentButton.height * 0.2;
    _commentLabel.width = _commentButton.width * 0.3;
    _commentLabel.height = _commentButton.height * 0.2;
}

- (IBAction)touchUpToolBarButton:(UIButton *)sender
{
//    NSLog(@"%s %ld",__func__, (long)sender.tag);
    if ([self.delegate respondsToSelector:@selector(buttonTouchUpWithTag:)]) {
        [self.delegate buttonTouchUpWithTag:sender.tag];
    }
}

- (UIButton *)buttonWithImageName:(NSString *)imageName tag:(NSInteger)tag
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    button.tag = tag;
    
    [button setImage:[UIImage imageNamed:imageName]
            forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(touchUpToolBarButton:)
     forControlEvents:UIControlEventTouchUpInside];
	   
    return button;
}

- (UIButton *)backButton
{
    if (!_backButton) {
        _backButton = [self buttonWithImageName:@"News_Navigation_Arrow" tag:1];
    }
    
    return _backButton;
}

- (UIButton *)nextButton
{
    if (!_nextButton) {
        _nextButton = [self buttonWithImageName:@"News_Navigation_Next" tag:2];
    }
    
    return _nextButton;
}

- (UIButton *)praiseButton
{
    if (!_praiseButton) {
        _praiseButton = [self buttonWithImageName:@"News_Navigation_Vote" tag:4];
        [_praiseButton setImage:[UIImage imageNamed:@"News_Navigation_Voted"] forState:UIControlStateSelected];
    }
    
    return _praiseButton;
}

- (UIButton *)commentButton
{
    if (!_commentButton) {
        _commentButton = [self buttonWithImageName:@"News_Navigation_Comment" tag:8];
    }
    
    return _commentButton;
}

- (UIButton *)shareButton
{
    if (!_shareButton) {
        _shareButton = [self buttonWithImageName:@"News_Navigation_Share" tag:16];
    }
    
    return _shareButton;
}

- (UILabel *)praiseLabel
{
    if (!_praiseLabel) {
        _praiseLabel = [[UILabel alloc] init];
        _praiseLabel.text = @"...";
        _praiseLabel.font = [UIFont systemFontOfSize:8.f];
        _praiseLabel.textColor = [UIColor grayColor];
        _praiseLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _praiseLabel;
}

- (UILabel *)commentLabel
{
    if (!_commentLabel) {
        _commentLabel = [[UILabel alloc] init];
        _commentLabel.text = @"...";
        _commentLabel.font = [UIFont systemFontOfSize:8.f];
        _commentLabel.textColor = [UIColor whiteColor];
        _commentLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _commentLabel;
}

- (void)setStoryId:(NSNumber *)storyId
{
    _storyId = storyId;
    [DetailStoryModelTool loadStoryExtraWithStoryId:storyId success:^(StoryExtra *obj) {
        self.praiseLabel.text = [NSString stringWithFormat:@"%@",obj.popularity];
        self.commentLabel.text = [NSString stringWithFormat:@"%@",obj.comments];
    }];
}

@end
