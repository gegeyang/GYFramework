//
//  UIColor+GYExtend.h
//  GYFramework
//
//  Created by GeYang on 2018/6/4.
//  Copyright © 2018年 GeYang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (GYExtend)

+ (UIColor *)gy_colorWithRGB:(NSInteger)rgb;
+ (UIColor *)gy_colorWithRGB:(NSInteger)rgb alpha:(CGFloat)alpha;

+ (UIColor *)gy_color0;
+ (UIColor *)gy_color3;
+ (UIColor *)gy_color6;
+ (UIColor *)gy_color9;
+ (UIColor *)gy_colorC;
+ (UIColor *)gy_colorF;

@end
