//
//  GYWaterFlowLayout.m
//  GYFramework
//
//  Created by Yang Ge on 2021/4/9.
//  Copyright © 2021 GeYang. All rights reserved.
//

#import "GYWaterFlowLayout.h"

@interface GYWaterFlowLayout ()

/**所有item的布局属性*/
@property (nonatomic, strong) NSMutableArray *itemAttrsArray;
/**所有column的当前高度  示例：@[50, 40, 70]  代表每列当前的高度 */
@property (nonatomic, strong) NSMutableArray *columnHeightArray;
/**内容高度*/
@property (nonatomic, assign) CGFloat allContentHeight;

@end

@implementation GYWaterFlowLayout

#pragma mark - 初始化
- (void)prepareLayout {
    [super prepareLayout];
    self.allContentHeight = 0.0;
    self.columnHeightArray = [NSMutableArray array];
    self.itemAttrsArray = [NSMutableArray array];
    
    const NSInteger sectionCount = [self.collectionView numberOfSections];
    for (NSInteger section = 0; section < sectionCount; section++) {
        NSInteger colunmCount = [self.flowLayoutDelegate waterlayout_collectionView:self.collectionView
                                                                             layout:self
                                                   numberOfColumnsForSectionAtIndex:section];
        UIEdgeInsets edgeInsets = [self.flowLayoutDelegate waterlayout_collectionView:self.collectionView
                                                                               layout:self
                                                               insetForSectionAtIndex:section];
        //设置每列默认高度
        for (NSInteger index = 0; index < colunmCount; index++) {
            [self.columnHeightArray addObject:@(edgeInsets.top)];
        }
        const NSInteger itemCount = [self.collectionView numberOfItemsInSection:section];
        for (NSInteger index = 0; index < itemCount; index++) {
            UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForRow:index
                                                                                                                  inSection:section]];
            [self.itemAttrsArray addObject:attrs];
        }
        self.allContentHeight += edgeInsets.bottom;
    }
}

#pragma mark - 返回indexPath位置cell对应的布局属性
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UIEdgeInsets sectionEdgeInsets = [self.flowLayoutDelegate waterlayout_collectionView:self.collectionView
                                                                                  layout:self
                                                                  insetForSectionAtIndex:indexPath.section];
    NSInteger colunmCount = [self.flowLayoutDelegate waterlayout_collectionView:self.collectionView
                                                                         layout:self
                                               numberOfColumnsForSectionAtIndex:indexPath.section];
    CGFloat coulumInteritemSpacing = [self.flowLayoutDelegate waterlayout_collectionView:self.collectionView
                                                                                  layout:self
                                                minimumInteritemSpacingForSectionAtIndex:indexPath.section];
    CGFloat coulumLineSpacing = [self.flowLayoutDelegate waterlayout_collectionView:self.collectionView
                                                                             layout:self
                                                minimumLineSpacingForSectionAtIndex:indexPath.section];
    const CGFloat collectionWidth = self.collectionView.frame.size.width;
    //item宽高
    const CGFloat itemWidth = (collectionWidth - sectionEdgeInsets.left - sectionEdgeInsets.right - (colunmCount - 1) * coulumInteritemSpacing) / colunmCount;
    const CGFloat itemHeight = [self.flowLayoutDelegate waterlayout_collectionView:self.collectionView
                                                                            layout:self
                                                                     heightForItem:itemWidth
                                                                       atIndexPath:indexPath];
    
    // 找出最短的那一列
    NSInteger lowColumn = 0;
    CGFloat minColumnHeight = [self.columnHeightArray.firstObject doubleValue];
    for (NSInteger index = 1; index < colunmCount; index++) {
        CGFloat currentHeight = [self.columnHeightArray[index] doubleValue];
        if (minColumnHeight > currentHeight) {
            minColumnHeight = currentHeight;
            lowColumn = index;
        }
    }
    CGFloat itemX = sectionEdgeInsets.left + lowColumn * (itemWidth + coulumInteritemSpacing);
    CGFloat itemY = minColumnHeight;
    if (itemY != sectionEdgeInsets.top) {
        //非第一行item 需加上lineSpaceing
        itemY += coulumLineSpacing;
    }
    UICollectionViewLayoutAttributes * attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attrs.frame = CGRectMake(itemX, itemY, itemWidth, itemHeight);
    // 更新最短那一列的高度(更新后变成最长的一列)
    self.columnHeightArray[lowColumn] = @(CGRectGetMaxY(attrs.frame));
    // 记录最长的那一列高度
    CGFloat maxColumnHeight = [self.columnHeightArray[lowColumn] doubleValue];
    self.allContentHeight = (MAX(self.allContentHeight, maxColumnHeight));
    return attrs;
}

#pragma mark - 返回rect中所有元素的布局属性
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect{
    return self.itemAttrsArray;
}

#pragma mark - 整体内容的高度
- (CGSize)collectionViewContentSize {
    return CGSizeMake(self.collectionView.frame.size.width, _allContentHeight);
}

#pragma mark - 当边界发生改变时，是否应该刷新。
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return NO;
}
@end
