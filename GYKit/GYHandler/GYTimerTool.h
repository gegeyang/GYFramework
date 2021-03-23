//
//  GYTimerTool.h
//  GYFramework
//
//  Created by Yang Ge on 2021/3/23.
//  Copyright © 2021 GeYang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GYTimerTool : NSObject

/**计时的间隔时间：单位秒*/
@property (nonatomic, assign) NSTimeInterval timeInterval;
/**是否重复default： YES*/
@property (nonatomic, assign) BOOL isRepeat;
@property (nonatomic, copy) void(^distanceBlock)(void);

- (void)startTimer:(BOOL)fire;
- (void)stopTimer;

@end

NS_ASSUME_NONNULL_END
