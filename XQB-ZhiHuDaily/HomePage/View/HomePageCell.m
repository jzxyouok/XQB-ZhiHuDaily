//
//  HomePageCell.m
//  XQB-ZhiHuDaily
//
//  Created by 许其斌 on 16/7/21.
//  Copyright © 2016年 scrat. All rights reserved.
//

#import "HomePageCell.h"
#import "UIImageView+WebCache.h"

@interface HomePageCell()
@property (weak, nonatomic) IBOutlet UIImageView *titleImage;
@property (weak, nonatomic) IBOutlet UIImageView *sourceImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabelConstraints;

@end


@implementation HomePageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.titleImage.contentMode = UIViewContentModeScaleAspectFill;
    self.titleImage.clipsToBounds = YES;
    
    self.sourceImage.hidden = YES;
}

+ (instancetype)homePageCellWithTableView:(UITableView *)tableView
{
    HomePageCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(self)];
    
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil] lastObject];
    }
    
    return cell;
}

#pragma mark - setter and getter
- (void)setStoryModel:(StoryModel *)storyModel
{
    _storyModel = storyModel;
    
    self.titleLabel.text = storyModel.title;
    
    if (!storyModel.images[0]) {
        self.titleLabelConstraints .constant = -70;
        self.titleImage.hidden = YES;
    } else {
        self.titleLabelConstraints .constant = 15;
        self.titleImage.hidden = NO;
        __weak typeof(self) weakSelf = self;
        [self.titleImage sd_setImageWithURL:[NSURL URLWithString:storyModel.images[0]]
                           placeholderImage:[UIImage imageNamed:@"Image_Preview"]
                                  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                      weakSelf.sourceImage.hidden = !weakSelf.storyModel.multipic;
        }];
    }
}


@end
