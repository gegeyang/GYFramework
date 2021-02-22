//
//  GYBorderView.m
//  GYFramework
//
//  Created by GeYang on 2018/7/9.
//  Copyright © 2018年 GeYang. All rights reserved.
//

#import "GYBorderView.h"

@implementation GYBorderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _lineColor = [UIColor gy_colorWithRGB:kGeneralUnderLineColorHex];
        _lineWidth = GYKIT_LINE_THICKNESS;
        self.userInteractionEnabled = NO;
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self setNeedsDisplay];
}

- (void)setBorderType:(GYBorderType)borderType {
    _borderType = borderType;
    [self setNeedsDisplay];
}

- (void)setLineColor:(UIColor *)lineColor {
    _lineColor = lineColor;
    [self setNeedsDisplay];
}

- (void)setLineWidth:(CGFloat)lineWidth {
    _lineWidth = lineWidth;
    [self setNeedsDisplay];
}

- (CGFloat)lineAdjustOffsetForWidth:(CGFloat)lineWidth {
    CGFloat lineAdjustOffset = 0;
    if (((int)(lineWidth * [UIScreen mainScreen].scale) + 1) % 2 == 0) {
        lineAdjustOffset = ((1 / [UIScreen mainScreen].scale) / 2);
    }
    return lineAdjustOffset;
}

- (void)drawRect:(CGRect)rect {
    if (_borderType == GYBorderNone) {
        [super drawRect:rect];
        return;
    }
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextBeginPath(context);
    
    /**
     *  https://developer.apple.com/library/ios/documentation/2DDrawing/Conceptual/DrawingPrintingiOS/GraphicsDrawingOverview/GraphicsDrawingOverview.html
     * 仅当要绘制的线宽为奇数像素时，绘制位置需要调整
     */
    const CGFloat pixelAdjustOffset = [self lineAdjustOffsetForWidth:_lineWidth];
    
    if (_borderType & GYBorderTop) {
        CGContextMoveToPoint(context, 0, pixelAdjustOffset);
        CGContextAddLineToPoint(context, self.bounds.size.width, pixelAdjustOffset);
    }
    
    if (_borderType & GYBorderLeft) {
        CGContextMoveToPoint(context, pixelAdjustOffset, 0);
        CGContextAddLineToPoint(context, pixelAdjustOffset, self.bounds.size.height);
    }
    
    if (_borderType & GYBorderBottom) {
        CGContextMoveToPoint(context, 0, self.bounds.size.height - pixelAdjustOffset);
        CGContextAddLineToPoint(context, self.bounds.size.width, self.bounds.size.height - pixelAdjustOffset);
    }
    
    if (_borderType & GYBorderRight) {
        CGContextMoveToPoint(context, self.bounds.size.width - pixelAdjustOffset, 0);
        CGContextAddLineToPoint(context, self.bounds.size.width - pixelAdjustOffset, self.bounds.size.height);
    }
    
    if (_borderType & GYBorderCenterX) {
        CGContextMoveToPoint(context, roundf(self.bounds.size.width / 2) - pixelAdjustOffset, 0);
        CGContextAddLineToPoint(context, roundf(self.bounds.size.width / 2) - pixelAdjustOffset, self.bounds.size.height);
    }
    
    if (_borderType & GYBorderCenterY) {
        CGContextMoveToPoint(context, 0, roundf(self.bounds.size.height / 2) - pixelAdjustOffset);
        CGContextAddLineToPoint(context, self.bounds.size.width, roundf(self.bounds.size.height / 2) - pixelAdjustOffset);
    }
    
    CGContextSetLineWidth(context, _lineWidth);
    CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
    CGContextStrokePath(context);
}

@end
