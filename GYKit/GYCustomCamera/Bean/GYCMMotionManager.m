//
//  GYCMMotionManager.m
//  GYFramework
//
//  Created by Yang Ge on 2021/3/23.
//  Copyright © 2021 GeYang. All rights reserved.
//

#import "GYCMMotionManager.h"

@interface GYCMMotionManager ()

@property (nonatomic, strong) CMMotionManager *motionManager;

@end

@implementation GYCMMotionManager

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static GYCMMotionManager *instance;
    dispatch_once(&onceToken, ^{
        instance = [[GYCMMotionManager alloc] init];
    });
    return instance;
}

- (instancetype)init {
    if (self = [super init]) {
        self.motionManager = [[CMMotionManager alloc] init];
        self.motionManager.accelerometerUpdateInterval = 0.5;
    }
    return self;
}

- (void)startAccelerometerUpdatesWithHandler:(void(^)(UIDeviceOrientation orientation))handler {
    [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue]
                                             withHandler:^(CMAccelerometerData * _Nullable accelerometerData, NSError * _Nullable error) {
        UIDeviceOrientation orientation = UIDeviceOrientationPortrait;
        if (accelerometerData) {
            CMAcceleration acceleration = accelerometerData.acceleration;
            double x = acceleration.x;
            double y = acceleration.y;
            if (x < -0.5) {
                orientation = UIDeviceOrientationLandscapeLeft;
            } else if (x > 0.5) {
                orientation = UIDeviceOrientationLandscapeRight;
            } else if (y < -0.5) {
                orientation = UIDeviceOrientationPortrait;
            } else {
                orientation = UIDeviceOrientationPortrait;
            }
        }
        if (handler) {
            handler(orientation);
        }
    }];
}

- (void)startAccelerometerUpdates {
    if (!self.motionManager.isAccelerometerActive) {
        [self.motionManager startAccelerometerUpdates];
    }
}

- (void)stopAccelerometerUpdates {
    if (self.motionManager.isAccelerometerActive) {
        [self.motionManager stopAccelerometerUpdates];
    }
}

@end
