//
//  MainViewController.m
//  XQB-ZhiHuDaily
//
//  Created by 许其斌 on 16/7/31.
//  Copyright © 2016年 scrat. All rights reserved.
//

#import "MainViewController.h"
#import "HomePageViewController.h"
#import "LeftSideBarController.h"
#import "MMExampleDrawerVisualStateManager.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    LeftSideBarController *leftSideBarController = [[LeftSideBarController alloc]init];
    leftSideBarController.mainViewController = self;
    
    HomePageViewController *homePageViewController = [[HomePageViewController alloc]init];
    UINavigationController *centerViewController = [[UINavigationController alloc]initWithRootViewController:homePageViewController];
    centerViewController.navigationBar.hidden = YES;
    
    self.navigationController = centerViewController;

    self.centerViewController = centerViewController;
    self.leftDrawerViewController = leftSideBarController;
    self.maximumLeftDrawerWidth = 220;
    
    self.shouldStretchDrawer = NO;
    
    self.openDrawerGestureModeMask = MMOpenDrawerGestureModeAll;
    self.closeDrawerGestureModeMask = MMCloseDrawerGestureModeAll;
    [self setDrawerVisualStateBlock:[MMDrawerVisualState slideVisualStateBlock]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
