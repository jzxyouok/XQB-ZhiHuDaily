//
//  LeftSideBarCell.m
//  XQB-ZhiHuDaily
//
//  Created by 许其斌 on 16/7/31.
//  Copyright © 2016年 scrat. All rights reserved.
//

#import "LeftSideBarCell.h"

@implementation LeftSideBarCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
//        NSLog(@"%s",__func__);
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        self.backgroundColor = [UIColor clearColor];
        self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame];
        self.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:31/255.f green:38/255.f blue:46/255.f alpha:1];
        self.textLabel.textColor = [UIColor colorWithRed:128/255.f green:133/255.f blue:140/255.f alpha:1];
        self.textLabel.highlightedTextColor = [UIColor whiteColor];
    }
    
    return self;
}

#pragma mark - setter and getter
- (void)setDetail:(NSString *)detail
{
    _detail = detail;
    self.textLabel.text = detail;
}

//- (void)awakeFromNib {
//    [super awakeFromNib];
//    // Initialization code
//}
//
//- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
//
//    // Configure the view for the selected state
//}

@end
