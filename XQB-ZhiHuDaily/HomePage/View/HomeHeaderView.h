//
//  HeadView.h
//  XQBZhiHuDaily
//
//  Created by 许其斌 on 16/7/14.
//  Copyright © 2016年 scrat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeHeaderView : UITableViewHeaderFooterView

@property (strong, nonatomic) NSString *date;

+ (instancetype) headerViewViewWithTableView:(UITableView *)tableView;

@end
