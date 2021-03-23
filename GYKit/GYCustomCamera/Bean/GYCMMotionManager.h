//
//  GYCMMotionManager.h
//  GYFramework
//
//  Created by Yang Ge on 2021/3/23.
//  Copyright © 2021 GeYang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreMotion/CoreMotion.h>

NS_ASSUME_NONNULL_BEGIN

@interface GYCMMotionManager : NSObject

@property (nonatomic, readonly) CMMotionManager *motionManager;

+ (instancetype)sharedManager;
- (void)startAccelerometerUpdatesWithHandler:(void(^)(UIDeviceOrientation orientation))handler;
- (void)startAccelerometerUpdates;
- (void)stopAccelerometerUpdates;

@end

NS_ASSUME_NONNULL_END
