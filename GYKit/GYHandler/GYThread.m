//
//  GYThread.m
//  RunTime
//
//  Created by Yang Ge on 2021/6/3.
//

#import "GYThread.h"

@interface GYThread ()

@property (nonatomic, strong) NSThread *thread;
@property (nonatomic, assign) BOOL stopTag;

@end

@implementation GYThread

- (instancetype)init {
    if (self = [super init]) {
        _stopTag = NO;
        __weak typeof(self) weakself = self;
        if (@available(iOS 10.0, *)) {
            self.thread = [[NSThread alloc] initWithBlock:^{
                NSLog(@"开启了runloop  %@", weakself.thread);
                //添加source1 无source无法开启runloop
                [[NSRunLoop currentRunLoop] addPort:[[NSPort alloc] init] forMode:NSDefaultRunLoopMode];
                while (weakself && !weakself.stopTag) {
                    //添加runloop的执行时间。
                    [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
                }
                //run方法无法停止
                //            [[NSRunLoop currentRunLoop] run];
                NSLog(@"停止了runloop");
            }];
            [self.thread start];
        } else {
            // Fallback on earlier versions
        }
    }
    return self;
}

- (void)executeTask:(GYThreadTaskBlock)taskBlock {
    if (self.thread && taskBlock) {
        [self performSelector:@selector(taskAction:)
                     onThread:self.thread
                   withObject:taskBlock
                waitUntilDone:NO];
    }
}

- (void)stopTask {
    if (self.thread) {
        [self performSelector:@selector(stopThread)
                     onThread:self.thread
                   withObject:nil
                waitUntilDone:NO];
    }
}

- (void)stopThread {
    self.stopTag = YES;
}

- (void)taskAction:(GYThreadTaskBlock)taskBlock {
    taskBlock();
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}

@end
