//
//  GYThread.h
//  RunTime
//
//  Created by Yang Ge on 2021/6/3.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^GYThreadTaskBlock)(void);

@interface GYThread : NSObject

/**
 执行线程任务
 */
- (void)executeTask:(GYThreadTaskBlock)taskBlock;
/**
 停止线程任务
 */
- (void)stopTask;

@end

NS_ASSUME_NONNULL_END
