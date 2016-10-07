//
//  ThemesViewController.m
//  XQB-ZhiHuDaily
//
//  Created by 许其斌 on 16/7/31.
//  Copyright © 2016年 scrat. All rights reserved.
//

#import "ThemesViewController.h"
#import "ThemesStoryModelTool.h"
#import "ThemesStoryModel.h"
#import "ThemesModel.h"

#import "StoryModelTool.h"
#import "MJExtension.h"
#import "HomePageCell.h"
#import "StoryModel.h"
#import "RefreshView.h"
#import "DetailViewController.h"
#import "DetailContainerViewController.h"
#import "AppDelegate.h"
#import "MainViewController.h"
#import "UIImageView+WebCache.h"

@interface ThemesViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *stories;
@property (strong, nonatomic) RefreshView *refreshView;
@property (strong, nonatomic) UIView *navigationBar;
@property (strong, nonatomic) UILabel *navigationTitle;
@property (strong, nonatomic) UIButton *leftSideBarButton;

@property (strong, nonatomic) ThemesStoryModelTool *themesStoryModelTool;

@property (strong, nonatomic) UIImageView *topImageView;

@end

@implementation ThemesViewController

#define kHeaderViewHeight  35
#define kNavigationBarHeight  55  //35+20

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    //    [UIApplication sharedApplication].statusBarHidden = NO;
//    self.view.backgroundColor = [UIColor whiteColor];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.topImageView];
    [self.view addSubview:self.navigationBar];
    [self.view addSubview:self.navigationTitle];
    [self.view addSubview:self.leftSideBarButton];
    [self.view addSubview:self.refreshView];
    self.tableView.tableFooterView = [[UIView alloc]init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - setter and getter

- (UIView *)navigationBar
{
    if (!_navigationBar) {
        _navigationBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavigationBarHeight)];
        _navigationBar.backgroundColor = [UIColor clearColor];
    }
    
    return _navigationBar;
}

- (UIImageView *)topImageView
{
    if (!_topImageView) {
        _topImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavigationBarHeight)];
        _topImageView.contentMode = UIViewContentModeScaleAspectFill;
        _topImageView.clipsToBounds = YES;
        _topImageView.alpha = 0.5f;
    }
    
    return _topImageView;
}

- (UILabel *)navigationTitle
{
    if (!_navigationTitle) {
        _navigationTitle = [[UILabel alloc]init];
        _navigationTitle.y = 20 + (kHeaderViewHeight - 18) / 2;
    }
    
    return _navigationTitle;
}

- (UIButton *)leftSideBarButton
{
    if (!_leftSideBarButton) {
        _leftSideBarButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 20 + (kHeaderViewHeight - 30) / 2, 30, 30)];
        [_leftSideBarButton setImage:[UIImage imageNamed:@"News_Arrow"] forState:UIControlStateNormal];
        [_leftSideBarButton addTarget:self action:@selector(openLeftSideBar) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _leftSideBarButton;
}

- (void)openLeftSideBar
{
    AppDelegate *delegate = [UIApplication sharedApplication].delegate;
    [delegate.mainViewController toggleDrawerSide:MMDrawerSideLeft
                                         animated:YES
                                       completion:nil];
}

- (void)updateData
{
    [self.themesStoryModelTool loadThemesWithThemesId:self.themes.ID success:^(id obj) {
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
        
        [self.refreshView stopAnimation];
    }];
}

- (RefreshView *)refreshView
{
    if (!_refreshView) {
        _refreshView = [RefreshView refreshViewAttachToScrollView:self.tableView target:self action:@selector(updateData)];
    }
    
    return _refreshView;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, kNavigationBarHeight, kScreenWidth, kScreenHeight - kNavigationBarHeight)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        
        //_tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kNavigationBarHeight)];
        //_tableView.tableHeaderView = self.topCycleScrollView;
        //_tableView.contentInset = UIEdgeInsetsMake(64 + CONTENT_INSET_SIZE, 0, 0, 0);
        //_tableView.scrollIndicatorInsets = UIEdgeInsetsMake(CONTENT_HEIGHT, 0, 0, 0);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.rowHeight = 90;
    }
    
    return _tableView;
}

#pragma mark -TableView数据源
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.stories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomePageCell *cell = [HomePageCell homePageCellWithTableView:tableView];
    
    StoryModel *storyModel = self.stories[indexPath.row];
    
    cell.storyModel = storyModel;
    
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y + scrollView.contentInset.top;
    
    if (offsetY < -100) {
        scrollView.contentOffset = CGPointMake(0, -100);
        return;
    }
    
    if (offsetY < 0) {
        self.topImageView.alpha = 0.5f + ABS(offsetY) * (0.5f / 100);
        self.topImageView.height = kNavigationBarHeight + ABS(offsetY);
    } else {
        self.topImageView.alpha = 0.5f;
    }
}

- (void)pushDetailViewControllerWithStoryId:(NSNumber *)storyId
{
    DetailContainerViewController *dvc = [[DetailContainerViewController alloc]init];
    
    dvc.storyId = storyId;
    dvc.storyTool = self.themesStoryModelTool;
    
    [self.navigationController pushViewController:dvc animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    StoryModel *storyModel = self.stories[indexPath.row];
    
    [self pushDetailViewControllerWithStoryId:storyModel.ID];
}


- (ThemesStoryModelTool *)themesStoryModelTool
{
    if (!_themesStoryModelTool) {
        _themesStoryModelTool = [[ThemesStoryModelTool alloc]init];
    }
    
    return  _themesStoryModelTool;
}

- (void)setThemes:(ThemesModel *)themes
{
    _themes = themes;
    
//    NSLog(@"%s",__func__);
    self.tableView.contentOffset = CGPointMake(0, 0);
    
    self.navigationTitle.attributedText = [[NSAttributedString alloc]initWithString:themes.name
                                                                         attributes:@{
                                                                                      NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor whiteColor]
                                                                                      }];
    [self.navigationTitle sizeToFit];
    self.navigationTitle.centerX = self.navigationBar.centerX;
    self.refreshView.frame = CGRectMake(self.navigationTitle.x - 25, 20 + (kHeaderViewHeight - 20) / 2 + 2, 20, 20);
    
//    NSLog(@"%s %@ %@",__func__, self.themesStoryModelTool, themes.ID);
    
    [self.themesStoryModelTool loadThemesWithThemesId:themes.ID success:^(ThemesStoryModel *obj) {
        
        self.stories = [StoryModel mj_objectArrayWithKeyValuesArray:obj.stories];
        
        [self.topImageView sd_setImageWithURL:[NSURL URLWithString:obj.background]
                             placeholderImage:[UIImage imageNamed:@"Image_Preview"]];
        
        [self.tableView reloadData];
    }];
}



@end
