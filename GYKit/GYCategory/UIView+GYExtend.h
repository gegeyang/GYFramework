//
//  UIView+GYExtend.h
//  GYFramework
//
//  Created by GeYang on 2018/7/9.
//  Copyright © 2018年 GeYang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, GYDrawLineType) {
    GYDrawLineNone = 0x0,
    GYDrawLineTop = 0x1,
    GYDrawLineBottom = 0x2,
    GYDrawLineLeft = 0x4,
    GYDrawLineRight = 0x8,
    GYDrawLineCenterX = 0x10,
    GYDrawLineCenterY = 0x20,
    
    GYDrawLineVertical = GYDrawLineTop | GYDrawLineBottom,
    GYDrawLineHorizontal = GYDrawLineLeft | GYDrawLineRight,
    GYDrawLineCenter = GYDrawLineCenterX | GYDrawLineCenterY,
    GYDrawLineBorder = GYDrawLineTop | GYDrawLineBottom | GYDrawLineLeft | GYDrawLineRight,
};

@interface UIView (GYExtend)

- (UIView *)gy_viewWithTag:(NSInteger)tag
                 recursive:(BOOL)recursive;
- (void)gy_removeAllSubviews;

/**
 对指定的view设置边框线。
 type：指定边的枚举
 color：线条颜色
 lineThickness：线条宽度
 */
- (void)gy_drawBorderWithLineType:(GYDrawLineType)type;
- (void)gy_drawBorderWithColor:(UIColor *)color
                      lineType:(GYDrawLineType)type;
- (void)gy_drawBorderWithColor:(UIColor *)color
                      lineType:(GYDrawLineType)type
                 lineThickness:(CGFloat)lineThickness;

@end
