//
//  HomePageViewController.m
//  XQB-ZhiHuDaily
//
//  Created by 许其斌 on 16/7/23.
//  Copyright © 2016年 scrat. All rights reserved.
//

#import "HomePageViewController.h"
#import "StoryModelTool.h"
#import "MJExtension.h"
#import "HomePageCell.h"
#import "HomeHeaderView.h"
#import "StoryModel.h"
#import "CycleScrollView.h"
#import "RefreshView.h"
#import "DetailViewController.h"
#import "DetailContainerViewController.h"
#import "AppDelegate.h"
#import "MainViewController.h"

@interface HomePageViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *sectionModels;
@property (strong, nonatomic) StoryModelTool *storyModelTool;
@property (strong, nonatomic) TopCycleScrollView *topCycleScrollView;
@property (strong, nonatomic) RefreshView *refreshView;
@property (strong, nonatomic) UIView *navigationBar;
@property (strong, nonatomic) UILabel *navigationTitle;
@property (strong, nonatomic) UIButton *leftSideBarButton;
@end

#define kHeaderViewHeight  35
#define kNavigationBarHeight  55  //35+20

@implementation HomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.automaticallyAdjustsScrollViewInsets = NO;
//    [UIApplication sharedApplication].statusBarHidden = NO;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
//    [[[self.navigationController.navigationBar subviews] objectAtIndex:0] setAlpha:0];
//    
//    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
//    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:2.0/255.0 green:143.0/255.0 blue:214.0/255.0 alpha:1]];
    
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.topCycleScrollView];
//    [self.tableView addSubview:self.topCycleScrollView];
    [self.view addSubview:self.navigationBar];
    [self.view addSubview:self.navigationTitle];
    [self.view addSubview:self.leftSideBarButton];
    [self.view addSubview:self.refreshView];
    self.tableView.tableFooterView = [[UIView alloc]init];
    
    __weak typeof(self) weakSelf = self;
    
    self.topCycleScrollView.touchUpInsideAction = ^(id obj) {
        StoryModel *story = obj;
        [weakSelf pushDetailViewControllerWithStoryId:story.ID];
    };
    
    [self.storyModelTool loadNewsWithCallBack:^(id obj) {
        self.sectionModels = obj;
        
        self.topCycleScrollView.topStories = [StoryModel mj_objectArrayWithKeyValuesArray:[self.sectionModels[0] top_stories]];
        
        [self.tableView reloadData];
    }];
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
        _navigationBar.backgroundColor = [UIColor colorWithRed:2.0/255.0 green:143.0/255.0 blue:214.0/255.0 alpha:1];
        _navigationBar.alpha = 0.f;
    }
    
    return _navigationBar;
}

- (UILabel *)navigationTitle
{
    if (!_navigationTitle) {
        _navigationTitle = [[UILabel alloc]init];
        _navigationTitle.text = @"今日热闻";
        _navigationTitle.attributedText = [[NSAttributedString alloc]initWithString:@"今日热闻"
                                                                         attributes:@{
                                                                                      NSFontAttributeName:[UIFont systemFontOfSize:18],NSForegroundColorAttributeName:[UIColor whiteColor]
                                                                                    }];
        [_navigationTitle sizeToFit];
        _navigationTitle.centerX = self.navigationBar.centerX;
        _navigationTitle.y = 20 + (kHeaderViewHeight - 18) / 2;
    }
    
    return _navigationTitle;
}

- (UIButton *)leftSideBarButton
{
    if (!_leftSideBarButton) {
        _leftSideBarButton = [[UIButton alloc]initWithFrame:CGRectMake(10, 20 + (kHeaderViewHeight - 30) / 2, 30, 30)];
        [_leftSideBarButton setImage:[UIImage imageNamed:@"Home_Icon"] forState:UIControlStateNormal];
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
    [self.storyModelTool updateNewsWithCallBack:^(id obj) {
        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
        self.topCycleScrollView.topStories = [StoryModel mj_objectArrayWithKeyValuesArray:[self.sectionModels[0] top_stories]];
        
        [self.refreshView stopAnimation];
    }];
}

- (RefreshView *)refreshView
{
    if (!_refreshView) {
        _refreshView = [RefreshView refreshViewAttachToScrollView:self.tableView target:self action:@selector(updateData)];
        _refreshView.frame = CGRectMake(self.navigationTitle.x - 25, 20 + (kHeaderViewHeight - 20) / 2 + 2, 20, 20);
    }
    
    return _refreshView;
}

- (StoryModelTool *)storyModelTool
{
    if (!_storyModelTool) {
        _storyModelTool = [[StoryModelTool alloc]init];
    }
    
    return _storyModelTool;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, SCREEN_HEIGHT - 20)];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        
        _tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, CONTENT_HEIGHT - 20)];
        //_tableView.tableHeaderView = self.topCycleScrollView;
        //_tableView.contentInset = UIEdgeInsetsMake(64 + CONTENT_INSET_SIZE, 0, 0, 0);
        //_tableView.scrollIndicatorInsets = UIEdgeInsetsMake(CONTENT_HEIGHT, 0, 0, 0);
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.rowHeight = 90;
    }
    
    return _tableView;
}

- (TopCycleScrollView *)topCycleScrollView
{
    if (!_topCycleScrollView) {
        _topCycleScrollView = [TopCycleScrollView cycleScrollViewAttachToTableView:self.tableView];
    }
    
    return _topCycleScrollView;
}

#pragma mark -TableView数据源
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.sectionModels.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.sectionModels[section] stories] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HomePageCell *cell = [HomePageCell homePageCellWithTableView:tableView];
    
    StoryModel *storyModel = [StoryModel mj_objectWithKeyValues: [self.sectionModels[indexPath.section] stories][indexPath.row]];
    
    cell.storyModel = storyModel;
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return nil;
    }
    
    HomeHeaderView *headerView = [HomeHeaderView headerViewViewWithTableView:tableView];
    SectionModel *sectionModel = self.sectionModels[section];
    headerView.date = sectionModel.date;
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return section ? kHeaderViewHeight : CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
//    NSLog(@"%s", __func__);
    if (section == 0) {
        self.navigationBar.height = kNavigationBarHeight;
        self.navigationTitle.hidden = NO;
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section
{
//   NSLog(@"%s", __func__);
    if (section == 0) {
        self.navigationBar.height = kNavigationBarHeight - kHeaderViewHeight;
        self.navigationTitle.hidden = YES;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y + scrollView.contentInset.top;

    if (offsetY > scrollView.contentSize.height - 1.5 * SCREEN_HEIGHT) {
        [self.storyModelTool loadOldNewsWithCallBack:^(id obj) {
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:self.sectionModels.count - 1] withRowAnimation:UITableViewRowAnimationFade];
        }];
    }
    
    if (offsetY < 0) {
        _navigationBar.alpha = 0.f;
    } else if (offsetY > 0 && offsetY < CONTENT_HEIGHT) {
        _navigationBar.alpha = offsetY * (1.0f / CONTENT_HEIGHT);
    } else if (offsetY > CONTENT_HEIGHT) {
        _navigationBar.alpha = 1.f;
    }
}

- (void)pushDetailViewControllerWithStoryId:(NSNumber *)id
{
    DetailContainerViewController *dvc = [[DetailContainerViewController alloc]init];
    //DetailViewController *dvc = [[DetailViewController alloc]init];

    dvc.storyId = id;
    dvc.storyTool = self.storyModelTool;
    
    [self.navigationController pushViewController:dvc animated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    StoryModel *storyModel = [StoryModel mj_objectWithKeyValues: [self.sectionModels[indexPath.section] stories][indexPath.row]];
    
    [self pushDetailViewControllerWithStoryId:storyModel.ID];
}

@end
