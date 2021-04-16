//
//  GYGalleryAnimationDelegate.h
//  GYFramework
//
//  Created by Yang Ge on 2021/4/13.
//  Copyright © 2021 GeYang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol GYGalleryAnimationDelegate <NSObject>

- (UIImage *)galleryImage;
- (CGRect)galleryImageViewFrameToWindow;
- (CGRect)galleryConvertFrameToView:(UIView *)toView;

@end

NS_ASSUME_NONNULL_END
