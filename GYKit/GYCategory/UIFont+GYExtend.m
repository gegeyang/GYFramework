//
//  UIFont+GYExtend.m
//  GYFramework
//
//  Created by GeYang on 2018/6/4.
//  Copyright © 2018年 GeYang. All rights reserved.
//

#import "UIFont+GYExtend.h"

@implementation UIFont (GYExtend)

+ (UIFont *)gy_font:(BOOL)isChinese weightType:(GYFontWeightType)weightType fontSize:(CGFloat)fontSize {
    UIFont *font = nil;
    NSString *fontName = nil;
    if (isChinese) {
        if (@available(iOS 9.0, *)) {
            switch (weightType) {
                case GYFontWeightTypeLight:
                    fontName = @"PingFang SC-Light";
                    break;
                case GYFontWeightTypeRegular:
                    fontName = @"PingFang SC";
                    break;
                case GYFontWeightTypeMedium:
                    fontName = @"PingFang SC-Medium";
                    break;
                case GYFontWeightTypeBold:
                    fontName = @"PingFang SC-Bold";
                    break;
            }
        } else {
            switch (weightType) {
                case GYFontWeightTypeLight:
                    fontName = @"Heiti SC-Light";
                    break;
                case GYFontWeightTypeRegular:
                    fontName = @"Heiti SC";
                    break;
                case GYFontWeightTypeMedium:
                    fontName = @"Heiti SC-Medium";
                    break;
                case GYFontWeightTypeBold:
                    fontName = @"Heiti SC-Bold";
                    break;
            }
        }
    } else {
        switch (weightType) {
            case GYFontWeightTypeLight:
                fontName = @"HelveticaNeue-Light";
                break;
            case GYFontWeightTypeRegular:
                fontName = @"HelveticaNeue";
                break;
            case GYFontWeightTypeMedium:
                fontName = @"HelveticaNeue-Medium";
                break;
            case GYFontWeightTypeBold:
                fontName = @"HelveticaNeue-Bold";
                break;
        }
    }
    font = [UIFont fontWithName:fontName size:fontSize];
    if (font == nil) {
        if (weightType == GYFontWeightTypeBold) {
            font = [UIFont boldSystemFontOfSize:fontSize];
        } else {
            font = [UIFont systemFontOfSize:fontSize];
        }
    }
    return font;
}

+ (UIFont *)gy_CNFontWithFontSize:(CGFloat)fontsize {
    return [self gy_font:YES weightType:GYFontWeightTypeRegular fontSize:fontsize];
}

+ (UIFont *)gy_CNBoldFontWithFontSize:(CGFloat)fontsize {
    return [self gy_font:YES weightType:GYFontWeightTypeBold fontSize:fontsize];
}

+ (UIFont *)gy_CNBaseFontSize {
    return [self gy_CNFontWithFontSize:GYKIT_GENERAL_BASE_FONTSIZE];
}

+ (UIFont *)gy_CNFontSizeS1 {
    return [self gy_CNFontWithFontSize:GYKIT_GENERAL_FONTSIZE_S1];
}

+ (UIFont *)gy_CNFontSizeS2 {
    return [self gy_CNFontWithFontSize:GYKIT_GENERAL_FONTSIZE_S2];
}

+ (UIFont *)gy_CNFontSizeS3 {
    return [self gy_CNFontWithFontSize:GYKIT_GENERAL_FONTSIZE_S3];
}

+ (UIFont *)gy_CNFontSizeS4 {
    return [self gy_CNFontWithFontSize:GYKIT_GENERAL_FONTSIZE_S4];
}

@end
