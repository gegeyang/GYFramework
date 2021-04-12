//
//  GYImageZoomingScrollView.h
//  GYFramework
//
//  Created by Yang Ge on 2021/4/12.
//  Copyright © 2021 GeYang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GYImageZoomingScrollView : UIScrollView <UIScrollViewDelegate>

@property (nonatomic, readonly) UIImageView *imageView;

- (void)displayImage:(UIImage *)image;
- (void)doubleTapOnPoint:(CGPoint)aPoint;

@end

NS_ASSUME_NONNULL_END
