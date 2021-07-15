//
//  GYAsyncLabel.m
//  GYFramework
//
//  Created by Yang Ge on 2021/7/15.
//  Copyright © 2021 GeYang. All rights reserved.
//

#import "GYAsyncLabel.h"
#import <CoreText/CoreText.h>

@implementation GYAsyncLabel

- (void)displayLayer:(CALayer *)layer {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        __block CGSize size = CGSizeZero;
        __block CGFloat scale = 1.0;
        dispatch_sync(dispatch_get_main_queue(), ^{
            size = self.bounds.size;
            scale = [UIScreen mainScreen].scale;
        });
        UIGraphicsBeginImageContextWithOptions(size, NO, scale);
        CGContextRef context = UIGraphicsGetCurrentContext();
        [self draw:context size:size];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        dispatch_async(dispatch_get_main_queue(), ^{
            self.layer.contents = (__bridge id)(image.CGImage);
        });
    });
}

- (void)draw:(CGContextRef)context
        size:(CGSize)size {
    //将坐标系上下翻转。因为底层坐标系和UIKit的坐标系原点位置不同。
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, size.height);
    CGContextScaleCTM(context, 1.0,-1.0);
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0, 0, size.width, size.height));
    //设置内容
    NSMutableAttributedString * attString = [[NSMutableAttributedString alloc] initWithString:self.text];
    //设置字体
    [attString addAttribute:NSFontAttributeName value:self.font range:NSMakeRange(0, self.text.length)];
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attString);
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, attString.length), path, NULL);
    //把frame绘制到context里
    CTFrameDraw(frame, context);
}

@end
