//
//  GYCameraShootButton.h
//  GYFramework
//
//  Created by Yang Ge on 2021/3/23.
//  Copyright © 2021 GeYang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GYCameraShootButton : UIView

- (instancetype)initWithSupportVideo:(BOOL)supportVideo;

@property (nonatomic, assign) CGSize buttonSize;
@property (nonatomic, copy) void(^finishTakePhoto)(void); //拍照
@property (nonatomic, copy) void(^beginShootVideo)(void); //开始视频拍摄
@property (nonatomic, copy) void(^finishShootVideo)(void); //结束视频拍摄

@end

NS_ASSUME_NONNULL_END
