//
//  HomePageCell.h
//  XQB-ZhiHuDaily
//
//  Created by 许其斌 on 16/7/21.
//  Copyright © 2016年 scrat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StoryModel.h"

@interface HomePageCell : UITableViewCell

@property (strong, nonatomic) StoryModel *storyModel;

+ (instancetype)homePageCellWithTableView:(UITableView *)tableView;

@end
