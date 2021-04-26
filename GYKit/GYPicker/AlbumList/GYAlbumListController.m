//
//  GYAlbumListController.m
//  GYFramework
//
//  Created by Yang Ge on 2021/4/26.
//  Copyright © 2021 GeYang. All rights reserved.
//

#import "GYAlbumListController.h"
#import "GYCollectionViewController+GYListViewDelegate.h"
#import "GYAlbumItemCell.h"
#import "GYAlbumModel.h"

static NSString * const kPhotoAlbumItemCellReusedIdentifier = @"kPhotoAlbumItemCellReusedIdentifier";

@interface GYAlbumListController ()

@property (nonatomic, strong) GYAlbumModel *dataModel;

@end

@implementation GYAlbumListController
- (instancetype)init {
    if (self = [super init]) {
        _dataModel = [[GYAlbumModel alloc] init];
        _dataModel.delegate = self;
    }
    return self;
}

- (void)loadView {
    [super loadView];
    [self gy_navigation_initTitle:NSLocalizedString(@"相册列表", nil)];
    [self gy_navigation_initLeftBackBtn:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = self.dataModel;
    self.view.backgroundColor = self.collectionView.backgroundColor = [UIColor whiteColor];
    const CGFloat spacing = GYKIT_GENERAL_SPACING1;
    self.collectionLayout.minimumLineSpacing = spacing;
    self.collectionLayout.sectionInset = UIEdgeInsetsMake(spacing, 0, spacing, 0);
    [self.collectionView registerClass:[GYAlbumItemCell class]
            forCellWithReuseIdentifier:kPhotoAlbumItemCellReusedIdentifier];
    [self gy_refresh_addDefaultRefreshHeader];
}

#pragma mark - UICollectionViewDataSource
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GYAlbumItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kPhotoAlbumItemCellReusedIdentifier
                                                                      forIndexPath:indexPath];
    [cell updateAlbumItem:[self.dataSource itemInfoAtIndexPath:indexPath]];
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.itemClickBlock) {
        self.itemClickBlock([self.dataSource itemInfoAtIndexPath:indexPath]);
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.view.gy_width, roundf(GYKIT_GENERAL_BASE_FONTSIZE * 3));
}

@end
