//
//  CycleScrollView.m
//  XQB-ZhiHuDaily
//
//  Created by 许其斌 on 16/7/19.
//  Copyright © 2016年 scrat. All rights reserved.
//

#import "CycleScrollView.h"
#import "TopImageView.h"

@interface CycleScrollView()<UIScrollViewDelegate>
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) UIPageControl *pageControl;
@property (strong, nonatomic) NSTimer *timer;

@property (strong, nonatomic) NSMutableArray *contentViews;
@property (assign ,nonatomic) NSInteger currentPageIndex;
@property (assign ,nonatomic) NSUInteger totalPageNum;
@end

@implementation CycleScrollView

#pragma mark - instancetype

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
//        self.autoresizesSubviews = YES;
        self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
//        NSLog(@"%s %@",__func__, NSStringFromCGRect(self.scrollView.frame));
//        self.scrollView.autoresizingMask = 0xFF;
//        self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        self.scrollView.contentSize = CGSizeMake(3 * self.scrollView.width, self.scrollView.height);
        self.scrollView.contentOffset = CGPointMake(self.scrollView.width, 0);
        self.scrollView.showsHorizontalScrollIndicator = NO;
        self.scrollView.contentMode = UIViewContentModeCenter;
        self.scrollView.pagingEnabled = YES;
        self.scrollView.delegate = self;
        
        self.pageControl = [[UIPageControl alloc]init];
        self.pageControl.centerX = self.centerX;
        self.pageControl.y = self.scrollView.height - 10;
        
        [self addSubview:self.scrollView];
        [self addSubview:self.pageControl];
    }
  
    return self;
}

- (void)layoutSubviews
{
    self.scrollView.frame = self.frame;
    self.scrollView.contentSize = CGSizeMake(3 * self.scrollView.width, self.scrollView.height);
    self.pageControl.y = self.scrollView.height - 10;
//    NSLog(@"%s %f %@",__func__, self.pageControl.y, NSStringFromCGRect(self.scrollView.frame));
    for (UIView *view in self.scrollView.subviews) {
        view.height = self.scrollView.height;
//        self.pageControl.y = self.scrollView.height - 10;
    }
}


#pragma mark - private method
- (void)updateContentViews
{
    NSInteger count = 0;
    
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self configContentViewsDataSource];
    self.pageControl.numberOfPages = _totalPageNum;
    
    for (UIView *view in self.contentViews) {

        view.userInteractionEnabled = YES;
        view.origin = CGPointMake(self.scrollView.width * (count++), 0);
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
        [view addGestureRecognizer:tapGestureRecognizer];
        
        [self.scrollView addSubview:view];
    }
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.width, 0)];
}

- (void)configContentViewsDataSource
{
    NSInteger preIndex = [self getNextVaildPageIndexWithCurrentIndex:_currentPageIndex - 1];
    NSInteger nextIndex = [self getNextVaildPageIndexWithCurrentIndex:_currentPageIndex + 1];
    
    [self.contentViews removeAllObjects];
    
    //NSLog(@"%s", __func__);
    if (_contentViewAtIndex) {
        [self.contentViews addObject:self.contentViewAtIndex(preIndex)];
        [self.contentViews addObject:self.contentViewAtIndex(_currentPageIndex)];
        [self.contentViews addObject:self.contentViewAtIndex(nextIndex)];
    }
}

- (NSInteger) getNextVaildPageIndexWithCurrentIndex:(NSInteger) currentIndex
{
    if (currentIndex == -1) {
        return _totalPageNum - 1;
    } else if (currentIndex == _totalPageNum) {
        return 0;
    }
    
    return currentIndex;
}

- (void)startTimer
{
    self.timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
    
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void) stopTimer
{
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark - event action
- (void) tapAction
{
    if (_contentViewTapAction) {
        _contentViewTapAction(_currentPageIndex);
    }
}

- (void) nextPage
{
    CGPoint offset = self.scrollView.contentOffset;
    
    offset.x = self.scrollView.frame.size.width * 2;
    
    [self.scrollView setContentOffset:offset animated:YES];
}

#pragma mark - setter and getter
- (NSMutableArray *)contentViews
{
    if (!_contentViews) {
        _contentViews = [NSMutableArray array];
    }
    
    return _contentViews;
}

- (void)setNumberOfPage:(NSUInteger (^)(void))numberOfPage
{
    _totalPageNum = numberOfPage();
    if (_totalPageNum > 0) {
        self.currentPageIndex = 0;
        self.pageControl.currentPage = 0;
        [self updateContentViews];
    }
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetX = scrollView.contentOffset.x;
    
    if (offsetX >= scrollView.width * 2) {
        self.currentPageIndex = [self getNextVaildPageIndexWithCurrentIndex:_currentPageIndex + 1];
        [self updateContentViews];
    } else if (offsetX <= 0) {
        self.currentPageIndex = [self getNextVaildPageIndexWithCurrentIndex:_currentPageIndex - 1];
        [self updateContentViews];
    }
    
    self.pageControl.currentPage = self.currentPageIndex;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self stopTimer];
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    [self startTimer];
}


@end


@interface TopCycleScrollView()

@property (strong, nonatomic) UIScrollView *observeScrollView;

@end

@implementation TopCycleScrollView

+ (instancetype)cycleScrollViewAttachToTableView:(UITableView *)tableView
{
    TopCycleScrollView *cycleView = [[TopCycleScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, CONTENT_HEIGHT)];
    
    cycleView.observeScrollView = tableView;
    [tableView addObserver:cycleView forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    
    return cycleView;
}

- (void)setTopStories:(NSArray *)topStories
{
    _topStories = topStories;
    
    //NSLog(@"%s %ld", __func__, topStories.count);
    
    [self stopTimer];
    
    __weak typeof(self) weakSelf = self;

    self.contentViewAtIndex = ^(NSInteger index) {
        return [TopImageView initWithFrame:weakSelf.frame andStoryModel:topStories[index]];
    };
    
    self.numberOfPage = ^NSUInteger(void){
        return topStories.count;
    };

    self.contentViewTapAction = ^(NSInteger index) {
//        NSLog(@"contentViewTapAction: %ld", (long)index);
        weakSelf.touchUpInsideAction(topStories[index]);
    };
    
    [self startTimer];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    UIScrollView *scrollView = object;
    CGFloat offsetY = scrollView.contentOffset.y;
    
//    NSLog(@"%f %f", offsetY, scrollView.y);
    
    CGRect rect = self.frame;
    if (offsetY < 0 && offsetY > SCALE_HEIGHT) {
        rect.origin.y = 0;
        rect.size.height = CONTENT_HEIGHT + ABS(offsetY);
    } else if (offsetY < SCALE_HEIGHT) {
        scrollView.contentOffset = CGPointMake(0, (int)SCALE_HEIGHT);
    } else if (offsetY > 0 && offsetY < CONTENT_HEIGHT) {
        rect.origin.y = 0;
        rect.size.height = CONTENT_HEIGHT - ABS(offsetY);
    } else if (offsetY > CONTENT_HEIGHT) {
        rect.origin.y = -0.5 * offsetY;
    }
//    NSLog(@"%f %f\r\n", rect.origin.y, rect.size.height);
    self.frame = rect;
}

- (void)dealloc
{
    [self.observeScrollView removeObserver:self forKeyPath:@"contentOffset"];
}

@end









