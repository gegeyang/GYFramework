//
//  GYMineScrollPageRootController.m
//  GYFramework
//
//  Created by Yang Ge on 2021/2/24.
//  Copyright © 2021 GeYang. All rights reserved.
//

#import "GYMineScrollPageRootController.h"
#import "GYMineCollectionViewController.h"
#import "GYSegmentSliderBar.h"

#define kGYSegmentSliderHeight   40
#define kGYHeaderViewHeight      200

@interface GYMineScrollPageRootController () {
    NSArray *_subViewController;
}

@property (nonatomic, copy) NSString *naviTitle;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) GYSegmentSliderBar *segmentSliderView;
@property (nonatomic, strong) GYMineCollectionViewController *pageVC1;
@property (nonatomic, strong) GYMineCollectionViewController *pageVC2;

@end

@implementation GYMineScrollPageRootController
- (instancetype)initWithTitle:(NSString *)title {
    if (self = [super init]) {
        _naviTitle = title;
    }
    return self;
}

- (void)loadView {
    [super loadView];
    [self gy_navigation_initTitle:_naviTitle];
    [self gy_navigation_initLeftBackBtn:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.headerView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.equalTo(self.navigationBar.mas_bottom).offset(0);
        make.height.mas_equalTo(kGYHeaderViewHeight);
    }];
    _subViewController = @[self.pageVC1, self.pageVC2];
    [self addHorizontalViewControllers:_subViewController];
    [self updateHorizontalViewControllersContentInsetFromRoot:UIEdgeInsetsMake(self.navigationBar.gy_height + kGYHeaderViewHeight, 0, 0, 0)];
}

- (void)viewContentInsetDidChanged {
    [super viewContentInsetDidChanged];
    [self updateHorizontalViewControllersContentInsetFromRoot:UIEdgeInsetsMake(self.navigationBar.gy_height + kGYHeaderViewHeight, 0, 0, 0)];;
}

- (void)segmentSelected:(NSInteger)index {
    self.segmentSliderView.selectedSegmentIndex = index;
    [self.scrollView setContentOffset:CGPointMake(index * self.scrollView.gy_width, 0)
                             animated:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    const NSInteger newIndex = roundf(scrollView.contentOffset.x / scrollView.gy_width);
    [self segmentSelected:newIndex];
}

#pragma mark - getter and setter
- (GYMineCollectionViewController *)pageVC1 {
    if (!_pageVC1) {
        _pageVC1 = [[GYMineCollectionViewController alloc] initWithTitle:nil];
    }
    return _pageVC1;
}

- (GYMineCollectionViewController *)pageVC2 {
    if (!_pageVC2) {
        _pageVC2 = [[GYMineCollectionViewController alloc] initWithTitle:nil];
    }
    return _pageVC2;
}

- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [[UIView alloc] init];
        _headerView.backgroundColor = [UIColor purpleColor];
        [_headerView addSubview:self.segmentSliderView];
        [_segmentSliderView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(0);
            make.height.mas_equalTo(kGYSegmentSliderHeight);
        }];
    }
    return _headerView;
}

- (GYSegmentSliderBar *)segmentSliderView {
    if (!_segmentSliderView) {
        _segmentSliderView = [[GYSegmentSliderBar alloc] initWithFrame:CGRectMake(0, 0, self.view.gy_width, kGYSegmentSliderHeight)
                                                           contentMode:GYSegmentBarContentModeFill
                                                         selectedIndex:0
                                                             itemArray:@[@"page1", @"page2"]];
        [_segmentSliderView gy_drawBorderWithLineType:GYDrawLineBottom];
        __weak typeof(self) weakself = self;
        _segmentSliderView.onClickSegment = ^(NSInteger index) {
            __strong typeof(weakself) strongself = weakself;
            [strongself segmentSelected:index];
        };
    }
    return _segmentSliderView;
}

@end
