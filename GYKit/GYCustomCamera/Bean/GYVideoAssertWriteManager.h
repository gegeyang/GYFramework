//
//  GYVideoAssertWriteManager.h
//  GYFramework
//
//  Created by Yang Ge on 2021/3/24.
//  Copyright © 2021 GeYang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVAssetWriter.h>

NS_ASSUME_NONNULL_BEGIN

@interface GYVideoAssertWriteManager : NSObject
/**视频名称*/
@property (nonatomic, readonly) NSString *videoName;
@property (nonatomic, readonly) AVAssetWriterStatus writerStatus;

- (instancetype)initWithInputOrientation:(UIDeviceOrientation)orientation;
/**
 结束写入
 */
- (void)finishWrittingWithCompletionHandler:(nullable void(^)(BOOL isSuccess))completionHandler;

/**
 写入中...
 */
- (void)appendSampleBuffer:(CMSampleBufferRef)sampleBuffer
               ofMediaType:(NSString *)mediaType
                   failure:(void(^)(void))failure;

@end

NS_ASSUME_NONNULL_END
