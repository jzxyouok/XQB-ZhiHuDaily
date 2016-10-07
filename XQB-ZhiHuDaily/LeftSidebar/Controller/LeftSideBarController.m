//
//  LeftSideBarController.m
//  XQB-ZhiHuDaily
//
//  Created by 许其斌 on 16/7/31.
//  Copyright © 2016年 scrat. All rights reserved.
//

#import "LeftSideBarController.h"
#import "LeftSideBarCell.h"
#import "ThemesModelTool.h"
#import "ThemesModel.h"
#import "AppDelegate.h"
#import "MainViewController.h"
#import "ThemesViewController.h"

static NSString *reuseIdentifier = @"leftSideBarCell";

@interface LeftSideBarController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray *themesArry;
@property (strong, nonatomic) UINavigationController *navigationController;
@property (strong, nonatomic) ThemesViewController *themesViewController;

@end

@implementation LeftSideBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    _themesViewController = [[ThemesViewController alloc]init];
    _navigationController = [[UINavigationController alloc]initWithRootViewController:_themesViewController];
    _navigationController.navigationBar.hidden = YES;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 50;
    
    [self.tableView registerClass:[LeftSideBarCell class] forCellReuseIdentifier:reuseIdentifier];
    
    [ThemesModelTool loadThemesWithCallBack:^(id obj) {
        [self.themesArry addObjectsFromArray:obj];
        [self.tableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSMutableArray *)themesArry
{
    if (!_themesArry) {
        _themesArry = [NSMutableArray array];
        
        ThemesModel *themes = [[ThemesModel alloc]init];
        themes.name = @"首页";
        
        [_themesArry addObject:themes];
    }
    
    return _themesArry;
}

#pragma mark -TableView数据源
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.themesArry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LeftSideBarCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    ThemesModel *themes = self.themesArry[indexPath.row];
    
//    NSLog(@"%s %@ %@",__func__, themes.name, themes.id);
    
    cell.detail = themes.name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSLog(@"%s %@",__func__, indexPath);
    
    ThemesModel *themes = self.themesArry[indexPath.row];
    
//    NSLog(@"%s %@ %ld",__func__, themes, themes.ID);
    
    self.themesViewController.themes = themes;
    
    if (indexPath.row == 0) {
        [self.mainViewController setCenterViewController:self.mainViewController.navigationController withCloseAnimation:YES completion:nil];
    } else {
        [self.mainViewController setCenterViewController:self.navigationController withCloseAnimation:YES completion:nil];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
