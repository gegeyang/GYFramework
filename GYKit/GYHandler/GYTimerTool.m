//
//  GYTimerTool.m
//  GYFramework
//
//  Created by Yang Ge on 2021/3/23.
//  Copyright © 2021 GeYang. All rights reserved.
//

#import "GYTimerTool.h"

@interface GYTimerTool ()

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation GYTimerTool

- (instancetype)init {
    if (self = [super init]) {
        _isRepeat = YES;
        _timeInterval = 1;
    }
    return self;
}

#pragma mark - implementaction
- (void)timeToolDistance {
    if (self.distanceBlock) {
        self.distanceBlock();
    }
}

- (void)startTimer:(BOOL)fire {
    [self stopTimer];
    _timer = [NSTimer scheduledTimerWithTimeInterval:self.timeInterval
                                              target:self
                                            selector:@selector(timeToolDistance)
                                            userInfo:nil
                                             repeats:self.isRepeat];
    if (fire) {
        //开始
        [_timer fire];
    }
}

- (void)stopTimer {
    [_timer invalidate];
    _timer = nil;
}


#pragma mark - getter and setter
- (CGFloat)timeInterval {
    return _timeInterval / 1000.0;
}



@end
