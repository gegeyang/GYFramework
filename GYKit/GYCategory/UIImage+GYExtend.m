//
//  UIImage+GYExtend.m
//  GYFrameworkTests
//
//  Created by Yang Ge on 2021/2/23.
//  Copyright © 2021 GeYang. All rights reserved.
//

#import "UIImage+GYExtend.h"
#import "GYTagAppearanceObject.h"

@implementation UIImage (GYExtend)
+ (UIImage *)gy_imageWithColor:(UIColor *)aColor
                          size:(CGSize)aSize
                        radius:(CGFloat)aRadius {
    return [self gy_drawImageWithSize:aSize
                         drawingBlock:^(CGContextRef content, CGSize size) {
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, size.width, size.height)
                                                        cornerRadius:aRadius];
        [aColor setFill];
        [path fill];
    }];
}

+ (UIImage *)gy_imageWithFillColor:(UIColor *)aFillColor
                    andStrokeColor:(UIColor *)aStrokeColor
                              size:(CGSize)aSize
                            radius:(CGFloat)aRadius
                         lineThick:(CGFloat)lineThick {
    UIImage *drawImage = [self gy_drawImageWithSize:aSize
                                       drawingBlock:^(CGContextRef  _Nonnull content, CGSize size) {
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(lineThick, lineThick, size.width - lineThick * 2, size.height - lineThick * 2)
                                                   byRoundingCorners:UIRectCornerAllCorners
                                                         cornerRadii:CGSizeMake(aRadius, aRadius)];
        [path closePath];
        if (aFillColor) {
            [aFillColor setFill];
            [path fill];
        }
        if (aStrokeColor || lineThick > 0) {
            UIColor *lineColor = [UIColor blackColor];
            if (aStrokeColor) {
                lineColor = aStrokeColor;
            }
            [lineColor setStroke];
            path.lineWidth = lineThick;
            [path stroke];
        }
    }];
    return [drawImage stretchableImageWithLeftCapWidth:aSize.width / 2.0
                                          topCapHeight:aSize.height / 2.0];
}

+ (UIImage *)gy_drawImageWithSize:(CGSize)size
                     drawingBlock:(void(^)(CGContextRef content, CGSize size))drawingBlock {
    NSAssert(size.width > 1 && size.height > 1, @"illegal image size");
    NSAssert(drawingBlock != nil, @"drawingBlock can't be nil");
    UIGraphicsBeginImageContextWithOptions(size, NO, [[UIScreen mainScreen] scale]);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, CGRectMake(0, 0, size.width, size.height));
    drawingBlock(context, size);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

+ (UIImage *)gy_imageWithTitle:(NSString *)title
                        radius:(CGFloat)radius
              appearanceObject:(id<GYTagAppearanceObject>)appearanceObject {
    if (title.length == 0) {
        return nil;
    }
    const CGFloat borderThickness = 0.5;
    UIFont *font = appearanceObject.tagNameFont;
    UILabel *labelTitle = [[UILabel alloc] init];
    labelTitle.font = font;
    labelTitle.text = title;
    //文字size
    const CGSize finalTitleSize = [labelTitle textRectForBounds:CGRectMake(0, 0, CGFLOAT_MAX, CGFLOAT_MAX)
                                         limitedToNumberOfLines:1].size;
    UIEdgeInsets inset = UIEdgeInsetsMake(1, 4, 1, 4);
    if ([appearanceObject respondsToSelector:@selector(tagContentInset)]) {
        inset = appearanceObject.tagContentInset;
    }
    CGSize tagFixedSize = CGSizeZero;
    if ([appearanceObject respondsToSelector:@selector(tagFixedSize)]) {
        tagFixedSize = appearanceObject.tagFixedSize;
    } else {
        tagFixedSize = CGSizeMake(finalTitleSize.width + inset.left + inset.right,
                                  finalTitleSize.height + inset.top + inset.bottom);
    }
    const CGSize titleSize = CGSizeMake(MIN(tagFixedSize.width, finalTitleSize.width),
                                        MIN(tagFixedSize.height, finalTitleSize.height));
    const CGFloat hMargin = roundf((tagFixedSize.width - titleSize.width) * 0.5);
    const CGFloat vMargin = roundf((tagFixedSize.height - titleSize.height) * 0.5);
    const CGFloat imageWidth = titleSize.width + hMargin * 2;
    const CGFloat imageHeight = titleSize.height + vMargin * 2;
    const CGRect frame = CGRectMake(0, 0, imageWidth, imageHeight);
    const CGSize cornerSize = CGSizeMake(radius, radius);
    return [self gy_drawImageWithSize:frame.size
                         drawingBlock:^(CGContextRef  _Nonnull content, CGSize size) {
        UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(borderThickness, borderThickness, size.width - borderThickness * 2, size.height - borderThickness * 2)
                                                   byRoundingCorners:UIRectCornerAllCorners
                                                         cornerRadii:cornerSize];
        [path closePath];
        if (appearanceObject.tagFillColor) {
            [appearanceObject.tagFillColor setFill];
            [path fill];
        }
        if (appearanceObject.tagBorderColor) {
            [appearanceObject.tagBorderColor setStroke];
            path.lineWidth = borderThickness;
            [path stroke];
        }
        NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
        style.alignment = NSTextAlignmentCenter;
        style.lineBreakMode = NSLineBreakByTruncatingTail;
        NSDictionary *attributes = @{
                                     NSFontAttributeName: font,
                                     NSForegroundColorAttributeName: appearanceObject.tagNameColor,
                                     NSBackgroundColorAttributeName: [UIColor clearColor],
                                     NSParagraphStyleAttributeName: style,
                                     };
        [title drawInRect:CGRectMake(hMargin, vMargin, titleSize.width, titleSize.height) withAttributes:attributes];
    }];
}


+ (UIImage *)gy_image_compoundImageAndView:(UIView *)view
                                     image:(UIImage *)image {
    const CGSize imageSize = view.gy_size;
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [image drawInRect:CGRectMake(0, 0, imageSize.width, imageSize.height)];
    [[view layer] renderInContext:context];
    UIImage *watermarkImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return watermarkImage;
}
@end
