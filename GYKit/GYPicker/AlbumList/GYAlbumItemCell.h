//
//  GYAlbumItemCell.h
//  GYFramework
//
//  Created by Yang Ge on 2021/4/26.
//  Copyright © 2021 GeYang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYAlbumInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface GYAlbumItemCell : UICollectionViewCell

- (void)updateAlbumItem:(GYAlbumInfo *)itemObject;

@end

NS_ASSUME_NONNULL_END
