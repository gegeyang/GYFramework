//
//  GYCollectionViewController.m
//  GYFramework
//
//  Created by GeYang on 2018/7/11.
//  Copyright © 2018年 GeYang. All rights reserved.
//

#import "GYCollectionViewController.h"
#import "UIScrollView+GYRefresh.h"
#import "UIView+GYFetchDataView.h"

@interface GYCollectionViewController ()

@end

@implementation GYCollectionViewController
- (instancetype)init {
    _collectionLayout = [[UICollectionViewFlowLayout alloc] init];
    _collectionLayout.sectionInset = UIEdgeInsetsZero;
    _collectionLayout.minimumLineSpacing = 0;
    _collectionLayout.minimumInteritemSpacing = 0;
    _collectionLayout.headerReferenceSize = CGSizeZero;
    _collectionLayout.footerReferenceSize = CGSizeZero;
    return [self initWithFlowLayout:_collectionLayout];
}

- (instancetype)initWithFlowLayout:(UICollectionViewFlowLayout *)flowlayout {
    if (self = [super init]) {
        _collectionLayout = flowlayout;
    }
    return self;
}

- (void)loadView {
    [super loadView];
    self.collectionView.frame = self.view.bounds;
    self.collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view insertSubview:self.collectionView
                     atIndex:0];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.collectionView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.dataSource && [self.dataSource dataNeedReload]) {
        [self.collectionView.gy_refreshHeader beginRefreshing];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - implementation
- (void)viewContentInsetDidChanged {
    [super viewContentInsetDidChanged];
    UIEdgeInsets inset = UIEdgeInsetsZero;
    inset.top += self.navigationBar.gy_height;
    inset.bottom += self.safeAreaInsets.bottom;
    self.collectionView.contentInset = inset;
    [self.collectionView.gy_refreshHeader updateContentInsets:inset];
}

- (void)forceRefresh {
    if (!self.viewLoaded) {
        return;
    }
    if (![self.collectionView.gy_refreshHeader isRefreshing]) {
        self.collectionView.gy_refreshHeader.state = MJRefreshStatePulling;
        [self.collectionView setContentOffset:CGPointMake(0, -3 - self.collectionView.contentInset.top)
                                     animated:YES];
    } else {
        [self.dataSource reset];
        [self.collectionView reloadData];
        [self.dataSource reloadDataWithCompletion:nil];
    }
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return [self.dataSource sectionCount];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.dataSource numberOfDatasInSection:section];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - getter and setter
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds
                                             collectionViewLayout:self.collectionLayout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.backgroundColor = [UIColor gy_colorWithRGB:kPageGaryBGColorHex];
        if (@available(iOS 11.0, *)) {
            _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _collectionView;
}

@end

@implementation GYCollectionViewController (RefreshExtend)

- (void)gy_refresh_addDefaultRefreshHeader {
    __weak typeof(self) weakself = self;
    [self gy_refresh_addRefreshHeader:^{
        __strong typeof(weakself) strongself = weakself;
        [strongself.dataSource reloadDataWithCompletion:nil];
    }];
}

- (void)gy_refresh_addRefreshHeader:(void(^)(void))refreshingBlock {
    self.collectionView.gy_refreshHeader = [GYRefreshHeader refreshHeaderWithRefreshBlock:refreshingBlock];
    [self.collectionView gy_setDefaultErrorView];
}

- (void)gy_refresh_addDefaultRefreshFooter {
    __weak typeof(self) weakself = self;
    [self gy_refresh_addRefreshFooter:^{
        __strong typeof(weakself) strongself = weakself;
        [strongself.dataSource loadMoreDataWithCompletion:nil];
    }];
}

- (void)gy_refresh_addRefreshFooter:(void(^)(void))refreshingBlock {
    self.collectionView.gy_refreshFooter = [GYRefreshFooter refreshFooterWithRefreshBlock:refreshingBlock];
    self.collectionView.gy_refreshFooter.hidden = YES;
}

@end
