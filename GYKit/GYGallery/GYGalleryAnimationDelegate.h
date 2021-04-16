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

/**动画时，获取列表上的图片*/
- (UIImage *)galleryImage;

/**Pop时，用来将fromview转换到window上*/
- (CGRect)galleryImageViewFrameToWindow;

/**动画时，获取列表上图片位置*/
- (CGRect)galleryConvertFrameToView:(UIView *)toView;

@end

NS_ASSUME_NONNULL_END
