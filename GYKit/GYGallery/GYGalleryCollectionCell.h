//
//  GYGalleryCollectionCell.h
//  GYFramework
//
//  Created by Yang Ge on 2021/4/12.
//  Copyright © 2021 GeYang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYGalleryItemObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface GYGalleryCollectionCell : UICollectionViewCell

- (void)updateCellInfo:(id<GYGalleryItemObject>)itemObject;

@end

NS_ASSUME_NONNULL_END
