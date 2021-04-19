//
//  GYGalleryBaseCell.h
//  GYFramework
//
//  Created by Yang Ge on 2021/4/19.
//  Copyright © 2021 GeYang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GYGalleryBaseCell : UICollectionViewCell

- (void)doubleTapOnPoint:(CGPoint)aPoint;

- (void)updateTransform:(CGAffineTransform)transform;

@end

NS_ASSUME_NONNULL_END
