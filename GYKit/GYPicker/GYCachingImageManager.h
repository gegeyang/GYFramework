//
//  GYCachingImageManager.h
//  GYFramework
//
//  Created by Yang Ge on 2021/4/26.
//  Copyright © 2021 GeYang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface GYCachingImageManager : NSObject

+ (GYCachingImageManager *)defaultManager;

/**
 通过localIdentifier获取Asset中的Image
 */
- (UIImage *)syncRequestThumeImageWithLocalIdentifier:(NSString *)localIdentifier;
/**
 通过localIdentifier获取Asset中的Data
 */
- (NSData *)syncRequestImageData:(NSString *)localIdentifier;

/**
 通过Asset获取Image
 */
- (UIImage *)syncRequestThumeImageForAsset:(PHAsset *)asset;

/**
 异步Asset获取Image
 */
- (void)asyncRequestImageDataForAsset:(PHAsset *)asset
                        resultHandler:(void (^)(NSData *imageData))resultHandler;

/**
 异步获取视频时长
 */
- (void)asyncRequestVideoDuration:(PHAsset *)asset
                    resultHandler:(void (^)(NSString *duration))resultHandler;

- (void)cancelVideoDurationRequest:(PHAsset *)asset;
/**
 异步获取相册视频
 */
- (void)asyncRequestVideoAsset:(PHAsset *)asset
                 resultHandler:(void (^)(AVURLAsset *avAsset))resultHandler;

/**
 异步通过localIdentifier获取Asset中的Image
 */
- (void)asyncRequestThumbImage:(NSString *)localIdentifier
                 resultHandler:(void (^)(UIImage *image))resultHandler;

- (void)asyncRequestGalleryImageWithLocalIdentifier:(NSString *)localIdentifier
                                      resultHandler:(void (^)(UIImage * _Nullable image))resultHandler;

- (void)asyncRequestGalleryImage:(PHAsset *)asset
                   resultHandler:(void (^)(UIImage *image))resultHandler;

@end

NS_ASSUME_NONNULL_END
