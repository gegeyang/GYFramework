//
//  UIView+GYPosition.m
//  GYFramework
//
//  Created by GeYang on 2018/6/4.
//  Copyright © 2018年 GeYang. All rights reserved.
//

#import "UIView+GYPosition.h"

@implementation UIView (GYPosition)

- (void)setGy_x0:(CGFloat)gy_x0 {
    CGRect frame = self.frame;
    frame.origin.x = gy_x0;
    self.frame = frame;
}

- (CGFloat)gy_x0 {
    return self.frame.origin.x;
}

- (void)setGy_y0:(CGFloat)gy_y0 {
    CGRect frame = self.frame;
    frame.origin.y = gy_y0;
    self.frame = frame;
}

- (CGFloat)gy_y0 {
    return self.frame.origin.y;
}

- (void)setGy_x1:(CGFloat)gy_x1 {
    CGRect frame = self.frame;
    frame.origin.x = gy_x1 - frame.size.width;
    self.frame = frame;
}

- (CGFloat)gy_x1 {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setGy_y1:(CGFloat)gy_y1 {
    CGRect frame = self.frame;
    frame.origin.y = gy_y1 - frame.size.height;
    self.frame = frame;
}

- (CGFloat)gy_y1 {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setGy_width:(CGFloat)gy_width {
    CGRect frame = self.frame;
    frame.size.width = gy_width;
    self.frame = frame;
}

- (void)setGy_centerX:(CGFloat)gy_centerX {
    self.center = CGPointMake(gy_centerX, self.center.y);
}

- (CGFloat)gy_centerX {
    return self.center.x;
}

- (CGFloat)gy_width {
    return self.frame.size.width;
}

- (void)setGy_height:(CGFloat)gy_height {
    CGRect frame = self.frame;
    frame.size.height = gy_height;
    self.frame = frame;
}

- (CGFloat)gy_height {
    return self.frame.size.height;
}

- (void)setGy_origin:(CGPoint)gy_origin {
    CGRect frame = self.frame;
    frame.origin = gy_origin;
    self.frame = frame;
}

- (CGPoint)gy_origin {
    return self.frame.origin;
}

- (void)setGy_size:(CGSize)gy_size {
    CGRect frame = self.frame;
    frame.size = gy_size;
    self.frame = frame;
}

- (CGSize)gy_size {
    return self.frame.size;
}

@end
