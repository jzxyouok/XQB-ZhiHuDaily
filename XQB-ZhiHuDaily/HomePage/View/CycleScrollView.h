//
//  CycleScrollView.h
//  XQB-ZhiHuDaily
//
//  Created by 许其斌 on 16/7/19.
//  Copyright © 2016年 scrat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CycleScrollView : UIView
/* 数据源：获取总页数 */
@property (strong, nonatomic) NSUInteger (^numberOfPage)(void);
/* 数据源：获取视图 */
@property (strong, nonatomic) UIView *(^contentViewAtIndex)(NSInteger index);
/* view被按下时的动作 */
@property (strong, nonatomic) void (^contentViewTapAction)(NSInteger index);
@end

typedef void (^TouchUpInsideAction)(id obj);

@interface TopCycleScrollView : CycleScrollView

@property (strong, nonatomic) TouchUpInsideAction touchUpInsideAction;

@property (strong, nonatomic) NSArray *topStories;
+ (instancetype)cycleScrollViewAttachToTableView:(UITableView *)tableView;

@end


