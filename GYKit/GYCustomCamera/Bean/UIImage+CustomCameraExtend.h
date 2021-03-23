//
//  UIImage+CustomCameraExtend.h
//  GYFramework
//
//  Created by Yang Ge on 2021/3/23.
//  Copyright © 2021 GeYang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (CustomCameraExtend)

/**
 自定义相机拍摄图片，默认方向为Right。
 图片存储是需校正图片方向
 */
+ (UIImage *)gy_image_commonFixOrientation:(UIImage *)aImage
                               orientation:(UIDeviceOrientation)orientation;

@end

NS_ASSUME_NONNULL_END
