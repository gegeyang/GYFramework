//
//  GYWaterFlowLayout.h
//  GYFramework
//
//  Created by Yang Ge on 2021/4/9.
//  Copyright © 2021 GeYang. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 多个分区时，设置sectionInsets.top不起作用。可通过优化columnHeightArray来实现。
 多个分区时，设置不同的column会出现问题。可通过优化columnHeightArray来实现。
 */

@class GYWaterFlowLayout;
NS_ASSUME_NONNULL_BEGIN

@protocol GYWaterFlowLayoutDelegate <NSObject>

/**
 返回section中item列数
 */
- (NSInteger)waterlayout_collectionView:(UICollectionView *)collectionView
                                 layout:(GYWaterFlowLayout *)collectionViewLayout
       numberOfColumnsForSectionAtIndex:(NSInteger)section;
/**
 返回section中item高度
 */
- (CGFloat)waterlayout_collectionView:(UICollectionView *)collectionView
                               layout:(GYWaterFlowLayout *)collectionViewLayout
                        heightForItem:(CGFloat)givenWidth
                          atIndexPath:(NSIndexPath *)indexPath;
/**
 返回section的UIEdgeInsets
 */
- (UIEdgeInsets)waterlayout_collectionView:(UICollectionView *)collectionView
                                    layout:(GYWaterFlowLayout *)collectionViewLayout
                    insetForSectionAtIndex:(NSInteger)section;
/**
 返回section中item横向间距
 */
- (CGFloat)waterlayout_collectionView:(UICollectionView *)collectionView
                               layout:(GYWaterFlowLayout *)collectionViewLayout
  minimumLineSpacingForSectionAtIndex:(NSInteger)section;
/**
 返回section中item纵向间距
 */
- (CGFloat)waterlayout_collectionView:(UICollectionView *)collectionView
                               layout:(GYWaterFlowLayout *)collectionViewLayout
minimumInteritemSpacingForSectionAtIndex:(NSInteger)section;

@end

@interface GYWaterFlowLayout : UICollectionViewFlowLayout

@property (nonatomic, weak) id<GYWaterFlowLayoutDelegate> flowLayoutDelegate;

@end

NS_ASSUME_NONNULL_END
