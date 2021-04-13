//
//  GYWaterGalleryController.m
//  GYFramework
//
//  Created by Yang Ge on 2021/4/13.
//  Copyright © 2021 GeYang. All rights reserved.
//

#import "GYWaterGalleryController.h"
#import "GYWaterGalleryModel.h"
#import "GYCollectionViewController+GYListViewDelegate.h"
#import "GYWaterGalleryCell.h"
#import "GYWaterFlowLayout.h"
#import "GYGalleryItemObject.h"

static NSString *const kGYWaterGalleryCellReuseIdentifier = @"kGYWaterGalleryCellReuseIdentifier";

@interface GYWaterGalleryController () <GYWaterFlowLayoutDelegate>

@property (nonatomic, strong) GYWaterGalleryModel *dataModel;

@end

@implementation GYWaterGalleryController
- (instancetype)init {
    GYWaterFlowLayout *layout = [[GYWaterFlowLayout alloc] init];
    if (self = [super initWithFlowLayout:layout]) {
        layout.flowLayoutDelegate = self;
    }
    return self;
}

- (void)loadView {
    [super loadView];
    [self gy_navigation_initTitle:@"瀑布流 + Gallery"];
    [self gy_navigation_initLeftBackBtn:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = self.dataModel;
    [self.collectionView registerClass:[GYWaterGalleryCell class]
            forCellWithReuseIdentifier:kGYWaterGalleryCellReuseIdentifier];
    [self gy_refresh_addDefaultRefreshHeader];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GYWaterGalleryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kGYWaterGalleryCellReuseIdentifier
                                                                         forIndexPath:indexPath];
    [cell updateCellInfo:[self.dataSource itemInfoAtIndexPath:indexPath]];
    return cell;
}

#pragma mark - GYWaterFlowLayoutDelegate
- (NSInteger)waterlayout_collectionView:(UICollectionView *)collectionView
                                 layout:(GYWaterFlowLayout *)collectionViewLayout
       numberOfColumnsForSectionAtIndex:(NSInteger)section {
    return 2;
}

- (CGFloat)waterlayout_collectionView:(UICollectionView *)collectionView
                               layout:(GYWaterFlowLayout *)collectionViewLayout
                        heightForItem:(CGFloat)givenWidth
                          atIndexPath:(NSIndexPath *)indexPath {
    id<GYGalleryUrlObject> itemObject = [self.dataSource itemInfoAtIndexPath:indexPath];
    return ceil(givenWidth * itemObject.galleryImageRadio);
}

- (UIEdgeInsets)waterlayout_collectionView:(UICollectionView *)collectionView
                                    layout:(GYWaterFlowLayout *)collectionViewLayout
                    insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(GYKIT_GENERAL_H_MARGIN, GYKIT_GENERAL_H_MARGIN, GYKIT_GENERAL_H_MARGIN, GYKIT_GENERAL_H_MARGIN);
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

#pragma makr - getter and setter
- (GYWaterGalleryModel *)dataModel {
    if (!_dataModel) {
        _dataModel = [[GYWaterGalleryModel alloc] init];
        _dataModel.delegate = self;
    }
    return _dataModel;
}

@end
