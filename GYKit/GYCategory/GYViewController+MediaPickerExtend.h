//
//  GYViewController+MediaPickerExtend.h
//  GYFramework
//
//  Created by Yang Ge on 2021/3/23.
//  Copyright © 2021 GeYang. All rights reserved.
//

#import "GYViewController.h"
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <Photos/PHAsset.h>
#import "NSObject+GYPrivacyExtend.h"
#import <Photos/PHAssetChangeRequest.h>

NS_ASSUME_NONNULL_BEGIN

@interface GYViewController (MediaPickerExtend)

/**
 保存图片
 */
- (void)gy_saveWithImage:(UIImage *)image
           resultHandler:(void (^ __nullable)(PHAsset *asset))resultHandler;

/**
 保存视频
 */
- (void)gy_saveWithVideo:(NSString *)localPath
           resultHandler:(void (^)(PHAsset *asset))resultHandler;

@end

NS_ASSUME_NONNULL_END
