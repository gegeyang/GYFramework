//
//  GYWindow.m
//  GYFramework
//
//  Created by GeYang on 2018/6/1.
//  Copyright © 2018年 GeYang. All rights reserved.
//

#import "GYWindow.h"

@implementation GYWindow

- (void)sendEvent:(UIEvent *)event {
    NSSet *arrTouch = [event allTouches];
    UITouch *touch = arrTouch.allObjects.firstObject;
    CGPoint position = [touch locationInView:self];
    NSLog(@"当前位置 x : %f - y : %f", position.x, position.y);
    [super sendEvent:event];
}

@end
