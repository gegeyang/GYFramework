//
//  GYViewController+MediaPickerExtend.m
//  GYFramework
//
//  Created by Yang Ge on 2021/3/23.
//  Copyright © 2021 GeYang. All rights reserved.
//

#import "GYViewController+MediaPickerExtend.h"

@implementation GYViewController (MediaPickerExtend)

#pragma mark - 保存图片
- (void)gy_saveWithImage:(UIImage *)image
           resultHandler:(void (^ __nullable)(PHAsset *asset))resultHandler {
    [self gy_privacy_checkAndOpenPhotoLibWithCompletion:^{
        __block NSString *assetID = nil;
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
            assetID = [PHAssetChangeRequest creationRequestForAssetFromImage:image].placeholderForCreatedAsset.localIdentifier;
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            PHAsset *asset = assetID.length > 0? [PHAsset fetchAssetsWithLocalIdentifiers:@[assetID] options:nil].firstObject : nil;
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    if (resultHandler) {
                        resultHandler(nil);
                    }
                    return;
                }
                if (resultHandler) {
                    resultHandler(asset);
                }
            });
        }];
    }];
}

#pragma mark - 保存视频
- (void)gy_saveWithVideo:(NSString *)localPath
           resultHandler:(void (^)(PHAsset *asset))resultHandler {
    [self gy_privacy_checkAndOpenPhotoLibWithCompletion:^{
        __block NSString *assetId = nil;
        [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
                    assetId = [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:[NSURL fileURLWithPath:localPath]].placeholderForCreatedAsset.localIdentifier;
        } completionHandler:^(BOOL success, NSError * _Nullable error) {
            PHAsset *asset = assetId.length > 0 ? [PHAsset fetchAssetsWithLocalIdentifiers:@[assetId] options:nil].firstObject : nil;
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    if (resultHandler) {
                        resultHandler(nil);
                    }
                    return;
                }
                if (resultHandler) {
                    resultHandler(asset);
                }
            });
        }];
    }];
}

@end
