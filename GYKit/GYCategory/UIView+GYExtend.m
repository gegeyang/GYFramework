//
//  UIView+GYExtend.m
//  GYFramework
//
//  Created by GeYang on 2018/7/9.
//  Copyright © 2018年 GeYang. All rights reserved.
//

#import "UIView+GYExtend.h"
#import "GYBorderView.h"

static char drawBorderViewTag;
NSInteger const kDrawBorderViewTag = (NSInteger const)&drawBorderViewTag;

@implementation UIView (GYExtend)

- (void)gy_removeAllSubviews {
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
}

- (UIView *)gy_viewWithTag:(NSInteger)tag
                 recursive:(BOOL)recursive {
    if (recursive) {
        return [self viewWithTag:tag];
    }
    
    for (UIView *subView in self.subviews) {
        if (subView.tag == tag) {
            return subView;
        }
    }
    return nil;
}

- (void)gy_drawBorderWithLineType:(GYDrawLineType)type {
    [self gy_drawBorderWithColor:[UIColor gy_colorWithRGB:kGeneralUnderLineColorHex]
                        lineType:type];
}

- (void)gy_drawBorderWithColor:(UIColor *)color
                      lineType:(GYDrawLineType)type {
    [self gy_drawBorderWithColor:color
                        lineType:type
                   lineThickness:GYKIT_LINE_THICKNESS];
}

- (void)gy_drawBorderWithColor:(UIColor *)color
                      lineType:(GYDrawLineType)type
                 lineThickness:(CGFloat)lineThickness {
    GYBorderView *borderView = (GYBorderView *)[self gy_viewWithTag:kDrawBorderViewTag recursive:NO];
    if (GYDrawLineNone == type) {
        [borderView removeFromSuperview];
        return;
    }
    if (!borderView) {
        borderView = [[GYBorderView alloc] initWithFrame:self.bounds];
        borderView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        borderView.tag = kDrawBorderViewTag;
        [self insertSubview:borderView atIndex:0];
    }
    borderView.borderType = (GYBorderType)type;
    borderView.lineColor = color;
    borderView.lineWidth = lineThickness;
}

@end
