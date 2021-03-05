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
@property (nonatomic, assign) NSInteger selectedIndex;
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
    [self.view insertSubview:self.headerView
                belowSubview:self.navigationBar];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.equalTo(self.navigationBar.mas_bottom).offset(0);
        make.height.mas_equalTo(kGYHeaderViewHeight);
    }];
    _subViewController = @[self.pageVC1, self.pageVC2];
    [self addHorizontalViewControllers:_subViewController];
    [self updateHorizontalViewControllersContentInsetFromRoot:UIEdgeInsetsMake(self.navigationBar.gy_height + kGYHeaderViewHeight, 0, 0, 0)];
    NSInteger tag = 0;
    for (GYCollectionViewController *collectionVC in _subViewController) {
        collectionVC.collectionView.tag = tag++;
        [collectionVC.collectionView addObserver:self
                                      forKeyPath:@"contentOffset"
                                         options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                                         context:nil];
    }
}

- (void)viewContentInsetDidChanged {
    [super viewContentInsetDidChanged];
    [self updateHorizontalViewControllersContentInsetFromRoot:UIEdgeInsetsMake(self.navigationBar.gy_height + kGYHeaderViewHeight, 0, 0, 0)];;
}

- (void)dealloc {
    for (GYCollectionViewController *collectionVC in _subViewController) {
        [collectionVC.collectionView removeObserver:self
                                         forKeyPath:@"contentOffset"];
    }
}

#pragma mark - implementaction
- (void)segmentSelected:(NSInteger)index {
    self.segmentSliderView.selectedSegmentIndex = index;
    [self.scrollView setContentOffset:CGPointMake(index * self.scrollView.gy_width, 0)
                             animated:YES];
    self.selectedIndex = index;
}

#pragma mark - Observer
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    UICollectionView *collectionView = (UICollectionView *)object;
    if (collectionView.tag != _selectedIndex) {
        return;
    }
    if (![keyPath isEqualToString:@"contentOffset"]) {
        return;
    }
    const CGPoint oldOffset = [[change objectForKey:NSKeyValueChangeOldKey] CGPointValue];
    const CGPoint newOffset = [[change objectForKey:NSKeyValueChangeNewKey] CGPointValue];
    if (CGPointEqualToPoint(oldOffset, newOffset)) {
        return;
    }
    const CGFloat scrollDeltaY = newOffset.y - oldOffset.y;
    //当header初始状态下，仍下拉 （即下拉刷新状态下）
    if (CGAffineTransformIsIdentity(self.headerView.transform)
        && (scrollDeltaY <= 0)) {
        return;
    }
    const CGFloat contentOffsetY = collectionView.contentOffset.y;
    //吸附时的偏移量
    const CGFloat adsorbOffsetY = -(self.navigationBar.gy_height + kGYSegmentSliderHeight);
    //初始化时的偏移量
    const CGFloat originalOffsetY = -(self.navigationBar.gy_height + kGYHeaderViewHeight);
    //吸附状态下，header的最大便宜
    const CGFloat minDy = originalOffsetY - adsorbOffsetY;
    //初始化 - 吸附过程中，header的偏移
    const CGFloat offsetY = originalOffsetY - contentOffsetY;
    
    if (contentOffsetY <= originalOffsetY) {
        //初始位置
        self.headerView.transform = CGAffineTransformIdentity;
    } else if(contentOffsetY >= adsorbOffsetY){
        //吸附之后的滚动
        self.headerView.transform = CGAffineTransformMakeTranslation(0, minDy);
        for (GYCollectionViewController *collectionVC in _subViewController) {
            if (collectionVC.collectionView != collectionView) {
                const CGFloat curOffsetY = collectionVC.collectionView.contentOffset.y;
                collectionVC.collectionView.contentOffset = CGPointMake(0, MAX(adsorbOffsetY, curOffsetY));
            }
        }
    } else {
        //初始位置 - 吸附前的滚动
        self.headerView.transform = CGAffineTransformMakeTranslation(0, MAX(minDy, MIN(offsetY, 0)));
        for (GYCollectionViewController *collectionVC in _subViewController) {
            if (collectionVC.collectionView != collectionView) {
                const CGFloat curOffsetY = collectionVC.collectionView.contentOffset.y;
                if (scrollDeltaY >= 0 && curOffsetY <= contentOffsetY) {
                    //上划
                    collectionVC.collectionView.contentOffset = CGPointMake(0, contentOffsetY);
                } else {
                    //下滑时，让其他collectionview保持当前的contentoffset
                    const CGFloat newOffsetY = curOffsetY + scrollDeltaY;
                    collectionVC.collectionView.contentOffset = CGPointMake(0, MAX(originalOffsetY, newOffsetY));
                }
            }
        }
    }
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
