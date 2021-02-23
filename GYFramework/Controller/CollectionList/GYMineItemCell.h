//
//  GYMineItemCell.h
//  GYFramework
//
//  Created by Yang Ge on 2021/2/23.
//  Copyright © 2021 GeYang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol GYMineInfoObject;

@interface GYMineItemCell : UICollectionViewCell

- (void)updateCellInfo:(id<GYMineInfoObject>)infoObject;

@end

NS_ASSUME_NONNULL_END
