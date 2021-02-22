//
//  UIFont+GYExtend.h
//  GYFramework
//
//  Created by GeYang on 2018/6/4.
//  Copyright © 2018年 GeYang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, GYFontWeightType) {
    GYFontWeightTypeLight,
    GYFontWeightTypeRegular,  //常规
    GYFontWeightTypeMedium,
    GYFontWeightTypeBold,  //加粗
};

@interface UIFont (GYExtend)

+ (UIFont *)gy_CNFontWithFontSize:(CGFloat)fontsize;
+ (UIFont *)gy_CNBoldFontWithFontSize:(CGFloat)fontsize;

+ (UIFont *)gy_CNBaseFontSize;
+ (UIFont *)gy_CNFontSizeS1;
+ (UIFont *)gy_CNFontSizeS2;
+ (UIFont *)gy_CNFontSizeS3;
+ (UIFont *)gy_CNFontSizeS4;

@end
