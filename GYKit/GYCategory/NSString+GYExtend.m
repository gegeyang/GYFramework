//
//  NSString+GYExtend.m
//  GYFramework
//
//  Created by Yang Ge on 2021/2/23.
//  Copyright © 2021 GeYang. All rights reserved.
//

#import "NSString+GYExtend.h"

@implementation NSString (GYExtend)

- (CGSize)gy_calcSizeWithFont:(UIFont *)font
            constrainedToSize:(CGSize)size {
    if (self == nil
        || [self isEqualToString:@""]) {
        return CGSizeZero;
    }
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    md[NSFontAttributeName] = font;
    CGRect titleRect = [self boundingRectWithSize:size
                                          options:NSStringDrawingUsesLineFragmentOrigin
                                       attributes:md
                                          context:nil];
    return titleRect.size;
}

@end
