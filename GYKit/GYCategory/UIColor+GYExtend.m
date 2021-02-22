//
//  UIColor+GYExtend.m
//  GYFramework
//
//  Created by GeYang on 2018/6/4.
//  Copyright © 2018年 GeYang. All rights reserved.
//

#import "UIColor+GYExtend.h"

#define GYKIT_GENERAL_COLOR_HEX_0           0x000000
#define GYKIT_GENERAL_COLOR_HEX_3           0x333333
#define GYKIT_GENERAL_COLOR_HEX_6           0x666666
#define GYKIT_GENERAL_COLOR_HEX_9           0x999999
#define GYKIT_GENERAL_COLOR_HEX_C           0xCCCCCC
#define GYKIT_GENERAL_COLOR_HEX_F           0xFFFFFF

@implementation UIColor (GYExtend)

+ (UIColor *)gy_colorWithRGB:(NSInteger)rgb {
    return [self gy_colorWithRGB:rgb alpha:1.0];
}

+ (UIColor *)gy_colorWithRGB:(NSInteger)rgb alpha:(CGFloat)alpha {
    return [self colorWithRed:(((rgb & 0xFF0000) >> 16) / 255.0)
                        green:(((rgb & 0x00FF00) >> 8) / 255.0)
                         blue:((rgb & 0x0000FF) / 255.0)
                        alpha:alpha];
}

+ (UIColor *)gy_color0 {
    return [self gy_colorWithRGB:GYKIT_GENERAL_COLOR_HEX_0];
}

+ (UIColor *)gy_color3 {
    return [self gy_colorWithRGB:GYKIT_GENERAL_COLOR_HEX_3];
}

+ (UIColor *)gy_color6 {
    return [self gy_colorWithRGB:GYKIT_GENERAL_COLOR_HEX_6];
}

+ (UIColor *)gy_color9 {
    return [self gy_colorWithRGB:GYKIT_GENERAL_COLOR_HEX_9];
}

+ (UIColor *)gy_colorC {
    return [self gy_colorWithRGB:GYKIT_GENERAL_COLOR_HEX_C];
}

+ (UIColor *)gy_colorF {
    return [self gy_colorWithRGB:GYKIT_GENERAL_COLOR_HEX_F];
}


@end
