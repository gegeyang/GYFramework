//
//  GYCollectionViewController+GYListViewDelegate.m
//  GYFramework
//
//  Created by GeYang on 2018/9/12.
//  Copyright © 2018年 GeYang. All rights reserved.
//

#import "GYCollectionViewController+GYListViewDelegate.h"
#import "UIScrollView+GYRefresh.h"
#import "NSError+GYExtend.h"
#import "UIView+GYFetchDataView.h"

@implementation GYCollectionViewController (GYListViewDelegate)

#pragma mark - GYListViewDelegate
- (void)onDataModelLoading {
    [self.collectionView gy_hideErrorView];
}

- (void)onDataModelLoadSuccess {
    [self.collectionView.gy_refreshHeader endRefreshing];
    [self.collectionView.gy_refreshFooter endRefreshing];
    [self.collectionView reloadData];
    if ([self.dataSource hasData]) {
        [self.collectionView gy_hideErrorView];
    } else {
        [self.collectionView gy_showEmptyErrorView];
    }
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(hasMoreData)]) {
        self.collectionView.gy_refreshFooter.hidden = ![self.dataSource hasMoreData];
    } else {
        self.collectionView.gy_refreshFooter.hidden = YES;
    }
}

- (void)onDataModelLoadFailed:(NSError *)error {
    [self.collectionView.gy_refreshHeader endRefreshing];
    [self.collectionView.gy_refreshFooter endRefreshing];
    if ([error gy_isCancelled]) {
        return;
    }
    [self.collectionView reloadData];
    if ([self.dataSource hasData]) {
        [self.collectionView gy_hideErrorView];
        NSString *message = [error gy_isResponseError] ? error.localizedDescription : NSLocalizedString(@"获取数据失败", nil);
        NSLog(@"%@", message);
    } else {
        [self.collectionView gy_showErrorView:error];
    }
}

@end
