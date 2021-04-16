//
//  GYWaterGalleryCell.h
//  GYFramework
//
//  Created by Yang Ge on 2021/4/13.
//  Copyright © 2021 GeYang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYGalleryItemObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface GYWaterGalleryCell : UICollectionViewCell

- (void)updateCellInfo:(id<GYGalleryUrlObject>)itemInfo;
- (CGRect)imageFrameAtIndex:(NSInteger)index;

@end

NS_ASSUME_NONNULL_END
