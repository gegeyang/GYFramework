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
    //可在设置当前点击位置
//    NSSet *arrTouch = [event allTouches];
//    UITouch *touch = arrTouch.allObjects.firstObject;
//    CGPoint position = [touch locationInView:self];
    [super sendEvent:event];
}

@end
