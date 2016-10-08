//
//  DetailContainerViewController.m
//  XQB-ZhiHuDaily
//
//  Created by 许其斌 on 16/7/28.
//  Copyright © 2016年 scrat. All rights reserved.
//

#import "DetailContainerViewController.h"
#import "DetailViewController.h"
#import "DetailToolBar.h"
#import "StoryModelTool.h"
#import "AppDelegate.h"
#import "MainViewController.h"
#import "UMSocial.h"
#import "DetailStoryModel.h"
#import "DetailStoryModelTool.h"

@interface DetailContainerViewController()<DetailToolBarDelegate,DetailViewDelegate>
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) DetailViewController *detailViewController;
@property (strong, nonatomic) DetailViewController *cacheDetailViewController;
@property (strong, nonatomic) NSMutableArray *cacheDetailViewControllers;
@property (strong, nonatomic) DetailToolBar *detailToolBar;
@property (strong, nonatomic) DetailStoryModel *detailStory;
@end

@implementation DetailContainerViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.detailViewController = [self configDetailViewController];
    
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.detailToolBar];
    [self.scrollView addSubview:self.detailViewController.view];
    [self addChildViewController:self.detailViewController];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    [delegate.mainViewController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeNone];
}

- (void)dealloc{
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [delegate.mainViewController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
}

#pragma mark - other methods
- (DetailViewController *)configDetailViewController
{
    DetailViewController *dvc = [[DetailViewController alloc]init];
    dvc.view.frame = CGRectMake(0, self.scrollView.height, self.scrollView.width, self.scrollView.height);
    
    dvc.storyTool = self.storyTool;
    dvc.storyId = self.storyId;
    dvc.delegate = self;
//    NSLog(@"%s %@",__func__, dvc.storyId);
    
    return dvc;
}

- (void)containerViewScrollToPage:(NSUInteger)page
{
    DetailViewController *dvc = [self configDetailViewController];

    dvc.view.frame = CGRectMake(0, page * self.scrollView.height, self.scrollView.width, self.scrollView.height);
    
    if (!self.cacheDetailViewController) {
        self.cacheDetailViewController = dvc;
        [self.scrollView addSubview:self.cacheDetailViewController.view];
        [self addChildViewController:self.cacheDetailViewController];
    } else if (!self.detailViewController) {
        self.detailViewController = dvc;
        [self.scrollView addSubview:self.detailViewController.view];
        [self addChildViewController:self.detailViewController];
    }

    [UIView animateWithDuration:0.5f animations:^{
        self.scrollView.contentOffset = CGPointMake(0, page * self.scrollView.height);
    } completion:^(BOOL finished) {
        if ([self.cacheDetailViewController isEqual:dvc]) {
            [self.detailViewController removeFromParentViewController];
            [self.detailViewController.view removeFromSuperview];
            self.detailViewController = nil;
        } else if ([self.detailViewController isEqual:dvc]) {
            [self.cacheDetailViewController removeFromParentViewController];
            [self.cacheDetailViewController.view removeFromSuperview];
            self.cacheDetailViewController = nil;
        }
        self.scrollView.contentOffset = CGPointMake(0, self.scrollView.height);
        dvc.view.frame = CGRectMake(0, self.scrollView.height, self.scrollView.width, self.scrollView.height);
    }];
}

- (void)share
{
    //    NSLog(@"%s %@",__func__, self.detailStory.share_url);
    //            [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeImage url:self.detailStory.share_url];
    [UMSocialData defaultData].extConfig.title = self.detailStory.title;
    [UMSocialData defaultData].extConfig.wechatSessionData.url = self.detailStory.share_url;
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = self.detailStory.share_url;
    [UMSocialData defaultData].extConfig.sinaData.shareText = self.detailStory.share_url;
    //            [UMSocialData defaultData].extConfig.sinaData.urlResource.url = self.detailStory.share_url;
    
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:UmengAppkey
                                      shareText:self.detailStory.title
                                     shareImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.detailStory.image]]]
                                shareToSnsNames:@[UMShareToWechatSession,UMShareToWechatTimeline,UMShareToSina,UMShareToDouban,UMShareToTencent,UMShareToRenren]
                                       delegate:nil];
}

#pragma mark - detail view delegate
- (void)detaileViewScrollToPrevWithStoryId:(NSNumber *)storyId
{
    self.storyId = storyId;
    [self containerViewScrollToPage:0];
}

- (void)detaileViewScrollToNextWithStoryId:(NSNumber *)storyId
{
    self.storyId = storyId;
    [self containerViewScrollToPage:2];
}

#pragma mark - toolbar delegate
- (void)buttonTouchUpWithTag:(NSInteger)tag
{
    switch (tag) {
        case 1:
            [self.navigationController popViewControllerAnimated:YES];
            break;
        case 2:
            if (![self.storyTool isLastStoryId:self.storyId]) {
                [self detaileViewScrollToNextWithStoryId:[self.storyTool getNextStoryIdWithCurrentStoryId:self.storyId]];
            }
            break;
        case 16:
            [self share];
            break;
            
        default:
            break;
    }
}

#pragma mark - setter and getter
- (DetailToolBar *)detailToolBar
{
    if (!_detailToolBar) {
        _detailToolBar = [[DetailToolBar alloc]initWithFrame:CGRectMake(0, kScreenHeight - 40, kScreenWidth, 40)];
        _detailToolBar.backgroundColor = [UIColor whiteColor];
        _detailToolBar.delegate = self;
        _detailToolBar.storyId = self.storyId;
    }
    
    return _detailToolBar;
}

- (void)setStoryId:(NSNumber *)storyId
{
    _storyId = storyId;
    [DetailStoryModelTool loadDetailStoryWithStoryId:storyId success:^(id obj) {
        self.detailStory = obj;
    }];
    self.detailToolBar.storyId = storyId;
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        
        _scrollView.contentSize = CGSizeMake(_scrollView.width, 3 * _scrollView.height);
        _scrollView.contentOffset = CGPointMake(0, _scrollView.height);
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = NO;
        _scrollView.scrollEnabled = NO;
    }
    
    return _scrollView;
}

@end
