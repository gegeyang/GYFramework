//
//  GYWaterListController.m
//  GYFramework
//
//  Created by Yang Ge on 2021/4/9.
//  Copyright © 2021 GeYang. All rights reserved.
//

#import "GYWaterListController.h"
#import "GYWaterListCell.h"
#import "GYWaterListModel.h"
#import "GYCollectionViewController+GYListViewDelegate.h"
#import "GYWaterFlowLayout.h"

static NSString *const kGYWaterListCellReuseIdentifier = @"kGYWaterListCellReuseIdentifier";

@interface GYWaterListController () <GYWaterFlowLayoutDelegate>

@property (nonatomic, strong) GYWaterListModel *dataModel;

@end

@implementation GYWaterListController
- (instancetype)init {
    GYWaterFlowLayout *layout = [[GYWaterFlowLayout alloc] init];
    if (self = [super initWithFlowLayout:layout]) {
        layout.flowLayoutDelegate = self;
    }
    return self;
}

- (void)loadView {
    [super loadView];
    [self gy_navigation_initTitle:@"瀑布流"];
    [self gy_navigation_initLeftBackBtn:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = self.dataModel;
    [self.collectionView registerClass:[GYWaterListCell class]
            forCellWithReuseIdentifier:kGYWaterListCellReuseIdentifier];
    [self gy_refresh_addDefaultRefreshHeader];
}

#pragma mark - GYWaterFlowLayoutDelegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 2;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GYWaterListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kGYWaterListCellReuseIdentifier
                                                                      forIndexPath:indexPath];
    [cell updateCellInfo:indexPath];
    return cell;
}

- (NSInteger)waterlayout_collectionView:(UICollectionView *)collectionView
                                 layout:(GYWaterFlowLayout *)collectionViewLayout
       numberOfColumnsForSectionAtIndex:(NSInteger)section {
    return 3;
}

- (CGFloat)waterlayout_collectionView:(UICollectionView *)collectionView
                               layout:(GYWaterFlowLayout *)collectionViewLayout
                        heightForItem:(CGFloat)givenWidth
                          atIndexPath:(NSIndexPath *)indexPath {
    return [[self.dataSource itemInfoAtIndexPath:indexPath] floatValue];
}

- (UIEdgeInsets)waterlayout_collectionView:(UICollectionView *)collectionView
                                    layout:(GYWaterFlowLayout *)collectionViewLayout
                    insetForSectionAtIndex:(NSInteger)section {
    if (section == 0) {
        return UIEdgeInsetsMake(GYKIT_GENERAL_H_MARGIN, GYKIT_GENERAL_H_MARGIN, GYKIT_GENERAL_H_MARGIN, GYKIT_GENERAL_H_MARGIN);
    }
    return UIEdgeInsetsMake(GYKIT_GENERAL_H_MARGIN * 2, GYKIT_GENERAL_H_MARGIN * 2, GYKIT_GENERAL_H_MARGIN * 2, GYKIT_GENERAL_H_MARGIN * 2);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout *)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section {
    if (section == 0) {
        return UIEdgeInsetsMake(GYKIT_GENERAL_H_MARGIN, GYKIT_GENERAL_H_MARGIN, 0, GYKIT_GENERAL_H_MARGIN);
    }
    return UIEdgeInsetsMake(0, GYKIT_GENERAL_H_MARGIN * 2, GYKIT_GENERAL_H_MARGIN * 2, GYKIT_GENERAL_H_MARGIN * 2);
}

- (CGFloat)waterlayout_collectionView:(UICollectionView *)collectionView
                               layout:(GYWaterFlowLayout *)collectionViewLayout
  minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return GYKIT_GENERAL_SPACING2;
}

- (CGFloat)waterlayout_collectionView:(UICollectionView *)collectionView
                               layout:(GYWaterFlowLayout *)collectionViewLayout
    minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return GYKIT_GENERAL_SPACING2;
}

#pragma mark - getter and setter
- (GYWaterListModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[GYWaterListModel alloc] init];
        _dataModel.delegate = self;
    }
    return _dataModel;
}

@end
