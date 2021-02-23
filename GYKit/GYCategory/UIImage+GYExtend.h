//
//  UIImage+GYExtend.h
//  GYFrameworkTests
//
//  Created by Yang Ge on 2021/2/23.
//  Copyright © 2021 GeYang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol GYTagAppearanceObject;

@interface UIImage (GYExtend)
/**
 生成指定大小的图片
 */
+ (UIImage *)gy_drawImageWithSize:(CGSize)size
                     drawingBlock:(void(^)(CGContextRef content, CGSize size))drawingBlock;

/**
 生成图片
 aColor：图片背景色；aSize：图片尺寸；aRadius：圆角大小
 */
+ (UIImage *)gy_imageWithColor:(UIColor *)aColor
                          size:(CGSize)aSize
                        radius:(CGFloat)aRadius;

/**
 生成带描边图片
 aFillColor：填充色；aStrokeColor：描边色；aSize：图片尺寸；aRadius：圆角大小；lineThick：线条宽度
 */
+ (UIImage *)gy_imageWithFillColor:(UIColor *)aFillColor
                    andStrokeColor:(UIColor *)aStrokeColor
                              size:(CGSize)aSize
                            radius:(CGFloat)aRadius
                         lineThick:(CGFloat)lineThick;

/**
 生成指定样式的图片（标签）
 title：标签的内容；radius：标签圆角；appearanceObject：标签样式协议
 */
+ (UIImage *)gy_imageWithTitle:(NSString *)title
                        radius:(CGFloat)radius
              appearanceObject:(id<GYTagAppearanceObject>)appearanceObject;

@end

NS_ASSUME_NONNULL_END
