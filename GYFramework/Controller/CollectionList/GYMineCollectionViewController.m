//
//  GYMineCollectionViewController.m
//  GYFramework
//
//  Created by GeYang on 2018/9/12.
//  Copyright © 2018年 GeYang. All rights reserved.
//

#import "GYMineCollectionViewController.h"
#import "GYViewController+GYNavBarExtend.h"
#import "GYCollectionViewController+GYListViewDelegate.h"
#import "GYMineItemCell.h"
#import "GYMineDataModel.h"
#import "GYMineInfoObject.h"

static NSString *const kGYMineItemCellReuserIdentifier = @"kGYMineItemCellReuserIdentifier";

@interface GYMineCollectionViewController ()

@property (nonatomic, strong) GYMineDataModel *dataModel;

@end

@implementation GYMineCollectionViewController

- (void)loadView {
    [super loadView];
    [self gy_navigation_initTitle:@"Collection List"];
    [self gy_navigation_initLeftBackBtn:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = self.dataModel;
    [self.collectionView registerClass:[GYMineItemCell class]
            forCellWithReuseIdentifier:kGYMineItemCellReuserIdentifier];
    [self gy_refresh_addDefaultRefreshHeader];
    [self gy_refresh_addDefaultRefreshFooter];
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    id<GYMineInfoObject> itemObject = [self.dataSource itemInfoAtIndexPath:indexPath];
    GYMineItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kGYMineItemCellReuserIdentifier
                                                                     forIndexPath:indexPath];
    [cell updateCellInfo:itemObject];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(collectionView.gy_width, 80);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return GYKIT_GENERAL_SPACING2;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    id<GYMineInfoObject> itemObject = [self.dataSource itemInfoAtIndexPath:indexPath];
    GYLog(@"%@", itemObject.infoTitle);
}

#pragma mark - getter and setter
- (GYMineDataModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[GYMineDataModel alloc] init];
        _dataModel.delegate = self;
    }
    return _dataModel;
}

@end
