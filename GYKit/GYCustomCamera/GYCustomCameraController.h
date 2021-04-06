//
//  GYCustomCameraController.h
//  GYFramework
//
//  Created by Yang Ge on 2021/3/23.
//  Copyright © 2021 GeYang. All rights reserved.
//

#import "GYViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface GYCustomCameraController : GYViewController

- (instancetype)initWithSupportVideo:(BOOL)supportVideo;

/**
 视频录制完成回调
 */
@property (nonatomic, copy) void(^finishVideoShoot)(NSString *videoName);

@end

NS_ASSUME_NONNULL_END
