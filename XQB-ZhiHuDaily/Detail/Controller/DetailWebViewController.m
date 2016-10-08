//
//  DetailWebViewController.m
//  XQB-ZhiHuDaily
//
//  Created by 许其斌 on 16/7/28.
//  Copyright © 2016年 scrat. All rights reserved.
//

#import "DetailWebViewController.h"


@interface DetailWebViewController()<UIWebViewDelegate>

@property (strong, nonatomic) NSURL *url;
@property (strong, nonatomic) UIWebView *webView;
@property (strong, nonatomic) UIView *navigationBarView;
@property (strong, nonatomic) UIView *toolBarView;
@property (nonatomic, strong) UIActivityIndicatorView *activityView;

@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIButton *toolBarBackButton;
@property (nonatomic, strong) UIButton *toolBarRefreshButton;
@property (nonatomic, strong) UIButton *toolBarPrevButton;
@property (nonatomic, strong) UIButton *toolBarNextButton;
@property (nonatomic, strong) UIButton *toolBarShareButton;

@property (nonatomic, assign) UIStatusBarStyle oldStyle;

@end

@implementation DetailWebViewController

- (instancetype)initWithUrl:(NSString *)url
{
    if (self = [super init]) {
        self.url = [NSURL URLWithString:url];
        self.oldStyle = [UIApplication sharedApplication].statusBarStyle;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.navigationBarView];
    [self.view addSubview:self.toolBarView];
    [self.view addSubview:self.webView];
    [self.view addSubview:self.backButton];
    [self.view addSubview:self.titleLabel];
    [self.view addSubview:self.activityView];
    
    [self configToolBarButton];
}

- (void)viewDidAppear:(BOOL)animated
{
//    NSLog(@"%s",__func__);
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewWillDisappear:(BOOL)animated
{
//    NSLog(@"%s",__func__);
    [UIApplication sharedApplication].statusBarStyle = self.oldStyle;
}

#pragma mark - web view delegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [self.activityView startAnimating];
    
    [self updateToolBarButtonState];
//    NSLog(@"%s",__func__);
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    [self.activityView stopAnimating];
    
    [self updateToolBarButtonState];
    
    self.titleLabel.text = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
//    NSLog(@"%s %@",__func__,self.titleLabel.text);
}

#pragma mark - other methods
- (void)popViewController
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)configToolBarButton
{
    [self.toolBarView addSubview:self.toolBarBackButton];
    [self.toolBarView addSubview:self.toolBarRefreshButton];
    [self.toolBarView addSubview:self.toolBarPrevButton];
    [self.toolBarView addSubview:self.toolBarNextButton];
    [self.toolBarView addSubview:self.toolBarShareButton];
    
    _toolBarBackButton.frame = _toolBarView.bounds;
    _toolBarBackButton.width = _toolBarView.width * 0.2;
    
    _toolBarRefreshButton.frame = _toolBarBackButton.frame;
    _toolBarRefreshButton.x = _toolBarBackButton.width;
    
    _toolBarPrevButton.frame = _toolBarRefreshButton.frame;
    _toolBarPrevButton.x = _toolBarRefreshButton.x + _toolBarRefreshButton.width;
    
    _toolBarNextButton.frame = _toolBarPrevButton.frame;
    _toolBarNextButton.x = _toolBarPrevButton.x + _toolBarPrevButton.width;
    
    _toolBarShareButton.frame = _toolBarNextButton.frame;
    _toolBarShareButton.x = _toolBarNextButton.x + _toolBarNextButton.width;
}

- (void) updateToolBarButtonState
{
    self.toolBarPrevButton.enabled = self.webView.canGoBack;
    self.toolBarNextButton.enabled = self.webView.canGoForward;
}

#pragma mark - setter and getter
- (void)setUrl:(NSURL *)url
{
    _url = url;
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

- (UIView *)toolBarView
{
    if (!_toolBarView) {
        _toolBarView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight - 40, kScreenWidth, 40)];
        _toolBarView.backgroundColor = [UIColor colorWithRed:2.0/255.0 green:143.0/255.0 blue:214.0/255.0 alpha:1];
    }
    
    return _toolBarView;
}

- (UIButton *)backButton
{
    if (!_backButton) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backButton.frame = CGRectMake(10, 20, 40, 40);
        
        [_backButton setImage:[UIImage imageNamed:@"Back_White"]
                     forState:UIControlStateNormal];
        
        [_backButton addTarget:self action:@selector(popViewController)
              forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _backButton;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 25, kScreenWidth - 90, 30)];
        _titleLabel.font = [UIFont systemFontOfSize:18];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _titleLabel;
}

- (UIActivityIndicatorView *)activityView
{
    if (!_activityView) {
        _activityView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(kScreenWidth - 40, 25, 30, 30)];
        _activityView.hidesWhenStopped = YES;
        [_activityView stopAnimating];
    }
    
    return _activityView;
}

- (UIView *)navigationBarView
{
    if (!_navigationBarView) {
        _navigationBarView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
        _navigationBarView.backgroundColor = [UIColor colorWithRed:2.0/255.0 green:143.0/255.0 blue:214.0/255.0 alpha:1];
        
    }
    
    return _navigationBarView;
}

- (UIWebView *)webView
{
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 60, kScreenWidth, kScreenHeight - 100)];
        _webView.scrollView.showsHorizontalScrollIndicator = NO;
        _webView.delegate = self;
    }
    
    return _webView;
}

- (UIButton *)toolBarBackButton
{
    if (!_toolBarBackButton) {
        _toolBarBackButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_toolBarBackButton setImage:[UIImage imageNamed:@"Back_White"]
                            forState:UIControlStateNormal];
        
        [_toolBarBackButton addTarget:self action:@selector(popViewController)
                     forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _toolBarBackButton;
}

- (UIButton *)toolBarRefreshButton
{
    if (!_toolBarRefreshButton) {
        _toolBarRefreshButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_toolBarRefreshButton setImage:[UIImage imageNamed:@"Browser_Icon_Reload"]
                               forState:UIControlStateNormal];
        
        [_toolBarRefreshButton addTarget:self.webView action:@selector(reload)
                        forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _toolBarRefreshButton;
}

- (UIButton *)toolBarPrevButton
{
    if (!_toolBarPrevButton) {
        _toolBarPrevButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_toolBarPrevButton setImage:[UIImage imageNamed:@"Browser_Icon_Back"]
                            forState:UIControlStateNormal];
        [_toolBarPrevButton setImage:[UIImage imageNamed:@"Browser_Icon_Back_Disable"]
                            forState:UIControlStateDisabled];
        
        [_toolBarPrevButton addTarget:self.webView action:@selector(goBack)
                     forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _toolBarPrevButton;
}

- (UIButton *)toolBarNextButton
{
    if (!_toolBarNextButton) {
        _toolBarNextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_toolBarNextButton setImage:[UIImage imageNamed:@"Browser_Icon_Forward"]
                            forState:UIControlStateNormal];
        [_toolBarNextButton setImage:[UIImage imageNamed:@"Browser_Icon_Forward_Disable"]
                            forState:UIControlStateDisabled];
        
        [_toolBarNextButton addTarget:self.webView action:@selector(goForward)
                     forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _toolBarNextButton;
}

- (UIButton *)toolBarShareButton
{
    if (!_toolBarShareButton) {
        _toolBarShareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_toolBarShareButton setImage:[UIImage imageNamed:@"Browser_Icon_Action"]
                             forState:UIControlStateNormal];
        
        [_toolBarShareButton addTarget:self action:nil
                      forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _toolBarShareButton;
}

@end
