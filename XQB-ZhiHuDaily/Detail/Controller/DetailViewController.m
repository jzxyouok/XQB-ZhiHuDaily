//
//  DetailViewController.m
//  XQB-ZhiHuDaily
//
//  Created by 许其斌 on 16/7/24.
//  Copyright © 2016年 scrat. All rights reserved.
//

#import "DetailViewController.h"
#import "DetailStoryModelTool.h"
#import "DetailStoryModel.h"
#import "TopImageView.h"
#import "DetailHeaderFooterView.h"
#import "DetailWebViewController.h"
#import "StoryModelTool.h"


@interface DetailViewController()<UIWebViewDelegate>
@property (strong, nonatomic) UIWebView *webView;
@property (strong, nonatomic) UIView *statusBarView;
@property (strong, nonatomic) DetailStoryModel *detailStory;
@property (strong, nonatomic) DetailStoryModelTool *detailStoryTool;
@property (strong, nonatomic) TopImageView *topImageView;
@property (strong, nonatomic) DetailHeaderView *headerView;
@property (strong, nonatomic) DetailFooterView *footerView;
@property (strong, nonatomic) UILabel *headerLabel;
@property (strong, nonatomic) UILabel *footerLabel;
@end

@implementation DetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    
    //[[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:0];
//    NSLog(@"%s %@",__func__, self);
    [self.view addSubview:self.statusBarView];
    [self.view addSubview:self.webView];
}

- (void)viewDidAppear:(BOOL)animated
{
//    NSLog(@"%s %@",__func__, self);
//    if (self.detailStory.image) {
//        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
//    } else {
//        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
//    }
}

- (void)viewWillDisappear:(BOOL)animated
{
//    NSLog(@"%s %@",__func__, self);
//    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)dealloc
{
    [self.webView.scrollView removeObserver:self.headerView forKeyPath:@"contentOffset"];
    [self.webView.scrollView removeObserver:self.footerView forKeyPath:@"contentOffset"];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
//    NSLog(@"%s",__func__);
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self setupHeaderView];
}

- (void)setupHeaderView
{
    if (self.detailStory.image) {
        if ([self.storyTool isFirstStoryId:self.storyId]) {
            self.headerLabel.y = 40;
            [self.topImageView addSubview:self.headerLabel];
        } else {
            [self.topImageView addSubview:self.headerView];
        }
    } else {
        if ([self.storyTool isFirstStoryId:self.storyId]) {
            self.headerLabel.y = -40;
            [self.webView.scrollView addSubview:self.headerLabel];
        } else {
            self.headerView.y = -40;
            [self.webView.scrollView addSubview:self.headerView];
        }
    }
}

-(void)webViewDidFinishLoad:(UIWebView *)webView
{
//    NSLog(@"%s",__func__);
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    //self.topImageView.detailModel = self.detailStory;
//    static  NSString * const jsRemoveHeadline =
//    @"function removeHeadline(){\
//        var objs = document.getElementsByTagName(\"div\");\
//        for(var i = 0; i < objs.length; i++) {\
//            if (objs[i].className == 'headline') {\
//                objs[i].parentNode.removeChild(objs[i]);\
//                break;\
//            };\
//        };\
//    };";
    
    //[webView stringByEvaluatingJavaScriptFromString:jsRemoveHeadline];
    //[webView stringByEvaluatingJavaScriptFromString:@"removeHeadline()"];
    
    NSString *heightString = [webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight"];
    CGFloat height = [heightString floatValue];
    
    if (![self.storyTool isLastStoryId:self.storyId]) {
        self.footerView.y = height + 15;
        [self.webView.scrollView addSubview:self.footerView];
    } else {
        self.footerLabel.y = height + 15;
        [self.webView.scrollView addSubview:self.footerLabel];
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *str = request.URL.absoluteString;
    
//    NSLog(@"%s %@", __func__, str);
    if ([str isEqualToString:@"about:blank"]){
        
    } else {
        DetailWebViewController *wvc = [[DetailWebViewController alloc]initWithUrl:str];
        [self.navigationController pushViewController:wvc animated:YES];
        return NO;
    }
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    return YES;
}

- (void)nextDetailView
{
    if (![self.storyTool isLastStoryId:self.storyId]) {
        if ([self.delegate respondsToSelector:@selector(detaileViewScrollToNextWithStoryId:)]) {
            [self.delegate detaileViewScrollToNextWithStoryId:[self.storyTool getNextStoryIdWithCurrentStoryId:self.storyId]];
        }
    }
    
}

- (void)prevDetailView
{
    if (![self.storyTool isFirstStoryId:self.storyId]) {
        if ([self.delegate respondsToSelector:@selector(detaileViewScrollToPrevWithStoryId:)]) {
            [self.delegate detaileViewScrollToPrevWithStoryId:[self.storyTool getPrevStoryIdWithCurrentStoryId:self.storyId]];
        }
    }
}

- (DetailFooterView *)footerView
{
    if (!_footerView) {
        _footerView = [DetailFooterView detailFooterViewAttachToScrollView:self.webView.scrollView target:self action:@selector(nextDetailView)];
    }
    
    return _footerView;
}

- (DetailHeaderView *)headerView
{
    if (!_headerView) {
        _headerView = [DetailHeaderView detailHeaderViewAttachToScrollView:self.webView.scrollView target:self action:@selector(prevDetailView)];
        _headerView.y = 40;
    }
    
    return _headerView;
}

- (UIView *)statusBarView
{
    if (!_statusBarView) {
        _statusBarView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
        _statusBarView.backgroundColor = [UIColor whiteColor];
        _statusBarView.opaque = NO;
    }
    
    return _statusBarView;
}

- (UIWebView *)webView
{
    if (!_webView) {
        _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 20, kScreenWidth, kScreenHeight - 60)];
        _webView.backgroundColor = [UIColor whiteColor];
        _webView.delegate = self;
        _webView.opaque = NO;
    }
    
    return _webView;
}

- (DetailStoryModelTool *)detailStoryTool
{
    if (!_detailStoryTool) {
        _detailStoryTool = [[DetailStoryModelTool alloc]init];
    }
    
    return _detailStoryTool;
}

- (TopImageView *)topImageView
{
    if (!_topImageView) {
        _topImageView = [TopImageView topImageViewAttachToScrollView:self.webView.scrollView];
    }
    
    return _topImageView;
}

- (void)setStoryId:(NSNumber *)storyId
{
    _storyId = storyId;
    
//    NSLog(@"%s %@",__func__, storyId);
    
    [DetailStoryModelTool loadDetailStoryWithStoryId:storyId success:^(id obj) {
        self.detailStory = obj;
        
        if (self.detailStory.image) {
            self.webView.scrollView.contentInset = UIEdgeInsetsMake(CONTENT_HEIGHT - 220, 0, 0, 0);
            self.webView.scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(CONTENT_HEIGHT - 20, 0, 0, 0);
            [self.view addSubview:self.topImageView];
            self.topImageView.detailModel = self.detailStory;
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        } else {
            [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
        }
        
        [self.webView loadHTMLString:self.detailStory.htmlUrl baseURL:nil];
    }];
}

- (UILabel *)headerLabel
{
    if (!_headerLabel) {
        _headerLabel = [[UILabel alloc]init];
        _headerLabel.attributedText = [[NSAttributedString alloc]initWithString:@"已经是第一篇啦"
                                                                     attributes:@{
                                                                                NSFontAttributeName:[UIFont systemFontOfSize:16],
                                                                                NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
        [_headerLabel sizeToFit];
        _headerLabel.centerX = self.webView.centerX;
    }
    
    return _headerLabel;
}

- (UILabel *)footerLabel
{
    if (!_footerLabel) {
        _footerLabel = [[UILabel alloc]init];
        _footerLabel.attributedText = [[NSAttributedString alloc]initWithString:@"已经是最后一篇啦"
                                                                     attributes:@{
                                                                                  NSFontAttributeName:[UIFont systemFontOfSize:16],
                                                                                  NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
        [_footerLabel sizeToFit];
        _footerLabel.centerX = self.webView.centerX;
    }
    
    return _footerLabel;
}

@end
