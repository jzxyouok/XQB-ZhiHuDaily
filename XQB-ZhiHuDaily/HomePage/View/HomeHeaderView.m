//
//  HeadView.m
//  XQBZhiHuDaily
//
//  Created by 许其斌 on 16/7/14.
//  Copyright © 2016年 scrat. All rights reserved.
//

#import "HomeHeaderView.h"

@implementation HomeHeaderView

+ (instancetype) headerViewViewWithTableView:(UITableView *)tableView
{
    HomeHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"homeHeader"];
    
    if (!headerView) {
        headerView = [[HomeHeaderView alloc]init];
        headerView.contentView.backgroundColor = [UIColor colorWithRed:2.0/255.0 green:143.0/255.0 blue:214.0/255.0 alpha:1];
    }
    
    return headerView;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGPoint center = self.textLabel.center;
    center.x = self.center.x;
    self.textLabel.center = center;
}

- (void)setDate:(NSString *)date
{
    _date = date;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    
    [dateFormatter setDateFormat:@"yyyyMMdd"];
    
    NSDate *tempDate = [dateFormatter dateFromString:date];
    
    [dateFormatter setLocale: [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    [dateFormatter setDateFormat:@"MM月dd日 EEEE"];
    
    _date = [dateFormatter stringFromDate:tempDate];
    
    self.textLabel.attributedText = [[NSAttributedString alloc]initWithString:_date
                                                                   attributes: @{NSFontAttributeName: [UIFont systemFontOfSize:18], NSForegroundColorAttributeName: [UIColor whiteColor]}];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
