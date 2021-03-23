//
//  UIImage+CustomCameraExtend.m
//  GYFramework
//
//  Created by Yang Ge on 2021/3/23.
//  Copyright © 2021 GeYang. All rights reserved.
//

#import "UIImage+CustomCameraExtend.h"

@implementation UIImage (CustomCameraExtend)

+ (UIImage *)gy_image_commonFixOrientation:(UIImage *)aImage
                               orientation:(UIDeviceOrientation)orientation {
    //旋转中心在左下角 旋转方向为逆时针
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGContextRef ctx = nil;
    switch (orientation) {
        case UIDeviceOrientationLandscapeLeft:
            ctx = CGBitmapContextCreate(NULL, aImage.size.height, aImage.size.width,
                                        CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                        CGImageGetColorSpace(aImage.CGImage),
                                        CGImageGetBitmapInfo(aImage.CGImage));
            CGContextConcatCTM(ctx, transform);
            CGContextDrawImage(ctx, CGRectMake(0, 0, aImage.size.height, aImage.size.width), aImage.CGImage);
            break;

        case UIDeviceOrientationLandscapeRight: {
            transform = CGAffineTransformTranslate(transform, aImage.size.height, aImage.size.width);
            transform = CGAffineTransformRotate(transform, M_PI);
            ctx = CGBitmapContextCreate(NULL, aImage.size.height, aImage.size.width,
                                        CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                        CGImageGetColorSpace(aImage.CGImage),
                                        CGImageGetBitmapInfo(aImage.CGImage));
            CGContextConcatCTM(ctx, transform);
            CGContextDrawImage(ctx, CGRectMake(0, 0, aImage.size.height, aImage.size.width), aImage.CGImage);
        }
            break;
        default: {
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI + M_PI_2);
            //生成图片大小
            ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                        CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                        CGImageGetColorSpace(aImage.CGImage),
                                        CGImageGetBitmapInfo(aImage.CGImage));
            CGContextConcatCTM(ctx, transform);
            CGContextDrawImage(ctx, CGRectMake(0, 0, aImage.size.height, aImage.size.width), aImage.CGImage);
        }
            
            break;
    }
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

@end
