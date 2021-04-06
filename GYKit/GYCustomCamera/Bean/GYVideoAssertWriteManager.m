//
//  GYVideoAssertWriteManager.m
//  GYFramework
//
//  Created by Yang Ge on 2021/3/24.
//  Copyright © 2021 GeYang. All rights reserved.
//

#import "GYVideoAssertWriteManager.h"
#import "GYSandboxHelper.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVFoundation.h>

#define kCameraVideoShootMaxDuration      15

@interface GYVideoAssertWriteManager () {
    BOOL _isWriting;
    /**录制方向*/
    UIDeviceOrientation _orientation;
}

/** 写入路径*/
@property (nonatomic, readonly) NSString *videoInputPath;
/**导出路径*/
@property (nonatomic, readonly) NSString *videoSavePath;
/**封面路径*/
@property (nonatomic, readonly) NSString *videoCoverImagePath;
/**视频名称*/
@property (nonatomic, copy) NSString *videoName;
@property (nonatomic, strong) AVAssetWriter *assetWriter;
@property (nonatomic, strong) AVAssetWriterInput *assetWriterVideoInput;
@property (nonatomic, strong) AVAssetWriterInput *assetWriterAudioInput;

@end

@implementation GYVideoAssertWriteManager
- (instancetype)initWithInputOrientation:(UIDeviceOrientation)orientation {
    if (self = [super init]) {
        _orientation = orientation;
        _videoName = [NSString stringWithFormat:@"%@", [[NSDate date] gy_formatString:@"yyyy_MM_dd_HH_mm_ss"]];
        _videoInputPath = [GYSandboxHelper gy_videoCache_inputPath:_videoName];
        _videoSavePath = [GYSandboxHelper gy_videoCache_savePath:_videoName];
        _videoCoverImagePath = [GYSandboxHelper gy_videoCache_coverImagePath:_videoName];
        //默认720p
        CGFloat width = 1280;
        CGFloat height = 720;
        _assetWriter = [AVAssetWriter assetWriterWithURL:[NSURL fileURLWithPath:_videoInputPath]
                                                fileType:AVFileTypeMPEG4
                                                   error:nil];
        //写入视频大小
        NSInteger numPixels = width * height;
        //每像素比特
        const CGFloat bitsPerPixel = 6.0f;
        const NSInteger bitsPerSecond = numPixels * bitsPerPixel;
        /**
         码率和帧率设置
         AVVideoAverageBitRateKey    视频尺寸*比率 比率10.1相当于AVCaptureSessionPresetHigh，数值越大越精细
         AVVideoMaxKeyFrameIntervalKey    关键帧最大间隔，1为每个都是关键帧，数值越大压缩率越高
         AVVideoProfileLevelKey    默认选择 AVVideoProfileLevelH264BaselineAutoLevel
         */
        NSDictionary *compressionProperties = @{ AVVideoAverageBitRateKey : @(bitsPerSecond),
                                                 AVVideoExpectedSourceFrameRateKey : @(30),
                                                 AVVideoMaxKeyFrameIntervalKey : @(30),
                                                 AVVideoProfileLevelKey : AVVideoProfileLevelH264Main31};
        /**
         视频属性
         AVVideoCodecKey    编码格式，一般选h264,硬件编码
         AVVideoScalingModeKey    填充模式，AVVideoScalingModeResizeAspectFill拉伸填充
         AVVideoWidthKey    视频宽度，以手机水平，home 在右边的方向
         AVVideoHeightKey    视频高度，以手机水平，home 在右边的方向
         AVVideoCompressionPropertiesKey    压缩参数
         */
        NSDictionary *videoCompressionSettings = @{ AVVideoCodecKey : AVVideoCodecH264,
                                                    AVVideoWidthKey : @(width),
                                                    AVVideoHeightKey : @(height),
                                                    AVVideoScalingModeKey : AVVideoScalingModeResizeAspect,
                                                    AVVideoCompressionPropertiesKey : compressionProperties };
        _assetWriterVideoInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo
                                                                    outputSettings:videoCompressionSettings];
        _assetWriterVideoInput.expectsMediaDataInRealTime = YES;
        if (_orientation == UIDeviceOrientationLandscapeRight){
            _assetWriterVideoInput.transform = CGAffineTransformMakeRotation(M_PI);
        } else if (_orientation == UIDeviceOrientationLandscapeLeft){
            _assetWriterVideoInput.transform = CGAffineTransformMakeRotation(0);
        } else if (_orientation == UIDeviceOrientationPortraitUpsideDown){
            _assetWriterVideoInput.transform = CGAffineTransformMakeRotation(M_PI + (M_PI / 2.0));
        } else{
            _assetWriterVideoInput.transform = CGAffineTransformMakeRotation(M_PI / 2.0);
        }
        //音频属性
        NSDictionary *audioCompressionSetting = @{ AVEncoderBitRatePerChannelKey : @(28000),
                                                   AVFormatIDKey : @(kAudioFormatMPEG4AAC),
                                                   AVNumberOfChannelsKey : @(1),
                                                   AVSampleRateKey : @(22050) };
        _assetWriterAudioInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeAudio
                                                                    outputSettings:audioCompressionSetting];
        //需要从capture session 实时获取数据
        _assetWriterAudioInput.expectsMediaDataInRealTime = YES;
        if ([_assetWriter canAddInput:_assetWriterVideoInput]) {
            [_assetWriter addInput:_assetWriterVideoInput];
        }
        if ([_assetWriter canAddInput:_assetWriterAudioInput]) {
            [_assetWriter addInput:_assetWriterAudioInput];
        }
    }
    return self;
}

#pragma mark - implementation
- (void)appendSampleBuffer:(CMSampleBufferRef)sampleBuffer
               ofMediaType:(NSString *)mediaType
                   failure:(void(^)(void))failure {
    if (sampleBuffer == NULL){
        GYLog(@"empty sampleBuffer");
        return;
    }
    if (!_isWriting && mediaType == AVMediaTypeVideo) {
        [self.assetWriter startWriting];
        [self.assetWriter startSessionAtSourceTime:CMSampleBufferGetPresentationTimeStamp(sampleBuffer)];
        _isWriting = YES;
    }
    if (mediaType == AVMediaTypeVideo) {
        //写入视频数据
        if (self.assetWriterVideoInput.readyForMoreMediaData) {
            if (![self.assetWriterVideoInput appendSampleBuffer:sampleBuffer]) {
                if (failure) {
                    failure();
                }
            }
        }
    }
    if (mediaType == AVMediaTypeAudio) {
        //写入音频
        if (self.assetWriterAudioInput.readyForMoreMediaData) {
            if (![self.assetWriterAudioInput appendSampleBuffer:sampleBuffer]) {
                if (failure) {
                    failure();
                }
            }
        }
    }
}

- (void)finishWrittingWithCompletionHandler:(void(^)(BOOL isSuccess))completionHandler {
    __weak typeof(self) weakself = self;
    [_assetWriter finishWritingWithCompletionHandler:^{
        __strong typeof(weakself) strongself = weakself;
        strongself->_isWriting = NO;
        AVURLAsset *videoAsset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:self.videoInputPath] options:nil];
        //获取封面图
        [strongself getVideoCover:videoAsset];
        //导出原视频
        AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:videoAsset
                                                                               presetName:AVAssetExportPresetPassthrough];
        [strongself exportOriginalVideo:exportSession
                      completionHandler:completionHandler];
    }];
}

//导出视频
- (void)exportOriginalVideo:(AVAssetExportSession *)exportSession
          completionHandler:(void(^)(BOOL isSuccess))completionHandler {
    AVURLAsset *videoAsset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:self.videoInputPath] options:nil];
    exportSession.outputFileType = AVFileTypeMPEG4;
    exportSession.shouldOptimizeForNetworkUse = YES;
    exportSession.outputURL = [NSURL fileURLWithPath:self.videoSavePath];
    
    //固定视频时长，防止偶发的卡顿，造成视频超出计划时长。
    CMTime start = CMTimeMakeWithSeconds(0, videoAsset.duration.timescale);
    CMTime duration = CMTimeMakeWithSeconds(kCameraVideoShootMaxDuration, videoAsset.duration.timescale);
    CMTimeRange range = CMTimeRangeMake(start, duration);
    exportSession.timeRange = range;
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        switch ([exportSession status]) {
            case AVAssetExportSessionStatusCompleted: {
                GYLog(@"导出完成：%@", self.videoSavePath);
                //移除原始视频
                if ([[NSFileManager defaultManager] fileExistsAtPath:self.videoInputPath]) {
                    [[NSFileManager defaultManager] removeItemAtPath:self.videoInputPath
                                                               error:NULL];
                }
                if (completionHandler) {
                    completionHandler(YES);
                }
            }
                break;
            default: {
                GYLog(@"导出异常：%@  status: %@", exportSession.error.description, exportSession.status);
                if (completionHandler) {
                    completionHandler(NO);
                }
            }
                break;
        }
    }];
}

//获取视频封面
- (void)getVideoCover:(AVURLAsset *)videoAsset {
    AVAssetImageGenerator *imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:videoAsset];
    NSError *error = nil;
    CMTime requestTime = CMTimeMakeWithSeconds(0, 5);
    CMTime actualTime;
    CGImageRef cgImage = [imageGenerator copyCGImageAtTime:requestTime actualTime:&actualTime error:&error];
    if (error) {
        GYLog(@"视频生成封面图失败:%@", error.description);
        return;
    }
    UIImage *image = [UIImage imageWithCGImage:cgImage];
    UIImage *fixOriginalImage = [self fixVideoImage:image
                                        orientation:_orientation];
    CGImageRelease(cgImage);
    //保存图片
    NSData *resultOriginData = UIImageJPEGRepresentation(fixOriginalImage, 0.8);
    const BOOL saveOriginResult = [resultOriginData writeToFile:self.videoCoverImagePath
                                                     atomically:YES];
    if (!saveOriginResult) {
        GYLog(@"封面图保存失败");
    }
}

//校正图片方向
- (UIImage *)fixVideoImage:(UIImage *)aImage
               orientation:(UIDeviceOrientation)orientation {
    //旋转中心在左下角 旋转方向为逆时针
    CGAffineTransform transform = CGAffineTransformIdentity;
    CGContextRef ctx = nil;
    switch (orientation) {
        case UIDeviceOrientationLandscapeLeft:
            return aImage;
            break;
        case UIDeviceOrientationLandscapeRight: {
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                        CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                        CGImageGetColorSpace(aImage.CGImage),
                                        CGImageGetBitmapInfo(aImage.CGImage));
            CGContextConcatCTM(ctx, transform);
            CGContextDrawImage(ctx, CGRectMake(0, 0, aImage.size.width, aImage.size.height), aImage.CGImage);
            CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
            UIImage *img = [UIImage imageWithCGImage:cgimg];
            CGContextRelease(ctx);
            CGImageRelease(cgimg);
            return img;
        }
            break;
        default: {
            //变换前的宽高
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.width);
            transform = CGAffineTransformRotate(transform, M_PI + M_PI_2);
            //生成图片大小
            ctx = CGBitmapContextCreate(NULL, aImage.size.height, aImage.size.width,
                                        CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                        CGImageGetColorSpace(aImage.CGImage),
                                        CGImageGetBitmapInfo(aImage.CGImage));
            CGContextConcatCTM(ctx, transform);
            CGContextDrawImage(ctx, CGRectMake(0, 0, aImage.size.width, aImage.size.height), aImage.CGImage);
            CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
            UIImage *img = [UIImage imageWithCGImage:cgimg];
            CGContextRelease(ctx);
            CGImageRelease(cgimg);
            return img;
        }
            break;
    }
}


#pragma mark - 视频合成（添加文字 + 添加水印）
/**
 合成视频
 AVAsset：素材库里的素材；
 AVAssetTrack：素材的轨道；
 AVMutableComposition ：一个用来合成视频的工程文件；
 AVMutableCompositionTrack ：工程文件中的轨道，有音频轨、视频轨等，里面可以插入各种对应的素材；
 AVMutableVideoCompositionLayerInstruction：视频轨道中的一个视频，可以缩放、旋转等；
 AVMutableVideoCompositionInstruction：一个视频轨道，包含了这个轨道上的所有视频素材；
 AVMutableVideoComposition：管理所有视频轨道，可以决定最终视频的尺寸，裁剪需要在这里进行；
 AVAssetExportSession：配置渲染参数并渲染。
 */
- (void)dealWithVideoCompletion:(void(^)(BOOL isSuccess))completionHandler {
    AVURLAsset *videoAsset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:self.videoInputPath] options:nil];
    //生成合成文件
    AVMutableComposition *mixComposition = [AVMutableComposition composition];
    //视频轨迹
    AVMutableCompositionTrack *compositionVideoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo
                                                                            preferredTrackID:kCMPersistentTrackID_Invalid];
    //视频素材轨迹
    AVAssetTrack *clipVideoTrack = [[videoAsset tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    CGSize renderSize = clipVideoTrack.naturalSize;
    //视频加入合成文件
    [compositionVideoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration)
                                   ofTrack:clipVideoTrack
                                    atTime:kCMTimeZero
                                     error:nil];
    //音频轨迹
    AVMutableCompositionTrack *audioTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeAudio
                                                                            preferredTrackID:kCMPersistentTrackID_Invalid];
    //音频素材轨迹
    AVAssetTrack *clipAudioTrack = [[videoAsset tracksWithMediaType:AVMediaTypeAudio] objectAtIndex:0];
    //音频加入合成文件
    [audioTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration)
                        ofTrack:clipAudioTrack
                         atTime:kCMTimeZero
                          error:nil];
    //纠正视频方向
    CGAffineTransform transform = CGAffineTransformIdentity;
    switch (_orientation) {
        case UIDeviceOrientationLandscapeRight: {
            transform = CGAffineTransformTranslate(transform, clipVideoTrack.naturalSize.width, clipVideoTrack.naturalSize.height);
            transform = CGAffineTransformRotate(transform,M_PI);
            renderSize = CGSizeMake(clipVideoTrack.naturalSize.width, clipVideoTrack.naturalSize.height);
        }
            break;
        case UIDeviceOrientationLandscapeLeft: {
            transform = CGAffineTransformIdentity;
            renderSize = CGSizeMake(clipVideoTrack.naturalSize.width, clipVideoTrack.naturalSize.height);
        }
            break;
        default: {
            transform = CGAffineTransformTranslate(transform, clipVideoTrack.naturalSize.height, 0.0);
            transform = CGAffineTransformRotate(transform,M_PI_2);
            renderSize = CGSizeMake(clipVideoTrack.naturalSize.height, clipVideoTrack.naturalSize.width);
        }
            break;
    }
    
    //添加水印 固定格式
    CALayer *parentLayer = [CALayer layer];
    CALayer *videoLayer = [CALayer layer];
    parentLayer.frame = CGRectMake(0, 0, renderSize.width, renderSize.height);
    videoLayer.frame = CGRectMake(0, 0, renderSize.width, renderSize.height);
    [parentLayer addSublayer:videoLayer];
    [parentLayer addSublayer:[self watermarkForImage:[UIImage imageNamed:@"logo_share_placeholder.png"]
                                                size:renderSize]];
    [parentLayer addSublayer:[self watermarkForText:@""
                                               size:renderSize]];
    
    AVMutableVideoCompositionInstruction *roateInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    roateInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, mixComposition.duration);
    AVAssetTrack *videoTrack = [[mixComposition tracksWithMediaType:AVMediaTypeVideo] objectAtIndex:0];
    AVMutableVideoCompositionLayerInstruction* layerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
    [layerInstruction setTransform:transform atTime:kCMTimeZero];
    roateInstruction.layerInstructions = [NSArray arrayWithObject:layerInstruction];
    
    //配置属性
    AVMutableVideoComposition *videoCompostion = [AVMutableVideoComposition videoComposition];
    videoCompostion.frameDuration = CMTimeMake(1, 30); // 30fps
    videoCompostion.renderSize = renderSize;
    videoCompostion.animationTool = [AVVideoCompositionCoreAnimationTool videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer inLayer:parentLayer];
    videoCompostion.instructions = [NSArray arrayWithObject:roateInstruction];
    
    //获取asset兼容的预置列表
    AVAssetExportSession *exportSession = [[AVAssetExportSession alloc] initWithAsset:mixComposition
                                                                           presetName:AVAssetExportPreset1280x720];
    // 文件类型, 目前只支持 AVFileTypeMPEG4 AVFileTypeQuickTimeMovie
    exportSession.videoComposition = videoCompostion;
    [self exportOriginalVideo:exportSession
            completionHandler:completionHandler];
}

- (CALayer *)watermarkForImage:(UIImage *)image
                          size:(CGSize)size {
    //可设置水印动画
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.fromValue = [NSNumber numberWithInt:0];
    animation.toValue = [NSNumber numberWithInt:1];
    animation.repeatCount = 5;
    animation.duration = 2;
    animation.autoreverses = YES;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    animation.beginTime = AVCoreAnimationBeginTimeAtZero;
    
    CALayer *layer = [CALayer layer];
    layer.contents = (__bridge id _Nullable)(image.CGImage);
    //原点为左下角
    layer.frame = CGRectMake(GYKIT_GENERAL_H_MARGIN, size.height - 200, 100, 100);
    layer.opacity = 1.0;
    [layer addAnimation:animation forKey:@"zoom"];
    return layer;
}

- (CALayer *)watermarkForText:(NSString *)textString
                         size:(CGSize)size {
    CATextLayer *layer = [[CATextLayer alloc] init];
    layer.string = textString;
    layer.font = (__bridge CFTypeRef _Nullable)([UIFont gy_CNBoldFontWithFontSize:20]);
    layer.frame = CGRectMake(GYKIT_GENERAL_H_MARGIN * 2 + 100, size.height - 200 - 100, 100, 200);
    layer.wrapped = YES;
    layer.foregroundColor = [[UIColor gy_colorWithRGB:GYKIT_APP_MAIN_COLOR] CGColor];
    return layer;
}

#pragma mark - getter and setter
- (AVAssetWriterStatus)writerStatus {
    return self.assetWriter.status;
}

@end
