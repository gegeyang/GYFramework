//
//  GYVideoPreviewController.h
//  GYFramework
//
//  Created by Yang Ge on 2021/3/24.
//  Copyright © 2021 GeYang. All rights reserved.
//

#import "GYViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface GYVideoPreviewController : GYViewController

@property (nonatomic, copy) void(^onClickFinish)(void);
@property (nonatomic, copy) void(^onClickCancel)(void);
@property (nonatomic, copy) void(^onReadyToPlay)(void);

- (instancetype)initWithVideoUrl:(NSURL *)url
                     allowRepeat:(BOOL)allowRepeat;

- (instancetype)initWithAllowRepeat:(BOOL)allowRepeat;

- (void)updateVideoInfoWithUrl:(NSURL *)url;

- (void)videoPause;

@end

@interface GYViewController(VideoPlayerExtend)

- (void)gy_videoplayer_openUrl:(NSURL *)url
                   allowRepeat:(BOOL)allowRepeat;

- (void)gy_videoplayer_openUrl:(NSURL *)url
                   allowRepeat:(BOOL)allowRepeat
                   cancelBlock:(void(^ _Nullable)(void))cancelBlock
                   finishBlock:(void(^ _Nullable)(void))finishBlock;

@end


NS_ASSUME_NONNULL_END
