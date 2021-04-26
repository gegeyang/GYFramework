//
//  GYCachingImageManager.m
//  GYFramework
//
//  Created by Yang Ge on 2021/4/26.
//  Copyright © 2021 GeYang. All rights reserved.
//

#import "GYCachingImageManager.h"
#import <MobileCoreServices/UTCoreTypes.h>

#define kGYCachingThumbImageCount    30

@interface GYCachingImageManager () {
    dispatch_queue_t _serialCachingQueue;
}

@property (nonatomic, strong) NSOperationQueue *requestBigDataQueue;
@property (nonatomic, strong) NSOperationQueue *listWriteQueue;
@property (nonatomic, strong) NSOperationQueue *requestQueue;
@property (nonatomic, assign) CGSize thumbSize;
@property (nonatomic, assign) CGSize gallerySize;
@property (nonatomic, strong) NSMutableArray *videoDurationRequestList;
@property (nonatomic, strong) NSMutableArray *imageThumbRequestList;
@property (nonatomic, strong) NSMutableDictionary *imageThumbRequestBlockMap;

@end


@implementation GYCachingImageManager

+ (GYCachingImageManager *)defaultManager {
    static GYCachingImageManager *s_shareSingleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_shareSingleton = [[super allocWithZone:NULL] init];
    });
    return s_shareSingleton;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [GYCachingImageManager defaultManager];
}

- (instancetype)copyWithZone:(struct _NSZone *)zone {
    return [GYCachingImageManager defaultManager];
}

- (instancetype)mutableCopyWithZone:(nullable NSZone *)zone {
    return [GYCachingImageManager defaultManager];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        NSString *queueName = [NSString stringWithFormat:@"%@.%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"], [self class]];
        _serialCachingQueue = dispatch_queue_create(queueName.UTF8String, DISPATCH_QUEUE_SERIAL);
        
        _requestBigDataQueue = [[NSOperationQueue alloc] init];
        _requestBigDataQueue.maxConcurrentOperationCount = 1;
        
        _listWriteQueue = [[NSOperationQueue alloc] init];
        _listWriteQueue.maxConcurrentOperationCount = 1;
        
        _requestQueue = [[NSOperationQueue alloc] init];
        _requestQueue.maxConcurrentOperationCount = 1;
        
        const CGSize boundSize = [UIScreen mainScreen].bounds.size;
        const CGFloat scale = [UIScreen mainScreen].scale;
        const CGFloat thumbWidth = roundf(boundSize.width * 0.34 * scale);
        _thumbSize = CGSizeMake(thumbWidth,
                                thumbWidth);
        _gallerySize = CGSizeMake(boundSize.width * scale,
                                  boundSize.height * scale);
        
        _videoDurationRequestList = [NSMutableArray array];
        _imageThumbRequestList = [NSMutableArray array];
        _imageThumbRequestBlockMap = [NSMutableDictionary dictionary];
    }
    return self;
}

- (UIImage *)syncRequestThumeImageWithLocalIdentifier:(NSString *)localIdentifier {
    PHAsset *asset = localIdentifier.length > 0 ? [PHAsset fetchAssetsWithLocalIdentifiers:@[localIdentifier] options:nil].firstObject : nil;
    if (!asset) {
        return nil;
    }
    return [self syncRequestThumeImageForAsset:asset];
}

- (UIImage *)syncRequestThumeImageForAsset:(PHAsset *)asset {
    NSAssert([asset isKindOfClass:[PHAsset class]], @"!!!! error...");
    PHImageRequestOptions *imageOption = [[PHImageRequestOptions alloc] init];
    imageOption.resizeMode = PHImageRequestOptionsResizeModeFast;
    imageOption.synchronous = YES;
    imageOption.networkAccessAllowed = YES;

    __block UIImage *thumbImage = nil;
    [[PHCachingImageManager defaultManager] requestImageForAsset:asset
                                                      targetSize:CGSizeZero
                                                     contentMode:PHImageContentModeAspectFit
                                                         options:imageOption
                                                   resultHandler:^(UIImage * _Nullable image, NSDictionary * _Nullable info) {
                                                       thumbImage = image;
                                                   }];
    return thumbImage;
}

- (void)asyncRequestImageDataForAsset:(PHAsset *)asset
                        resultHandler:(void (^)(NSData *imageData))resultHandler {
    NSAssert([asset isKindOfClass:[PHAsset class]], @"!!!! error...");
    NSBlockOperation *operationRequest = [NSBlockOperation blockOperationWithBlock:^{
        PHImageRequestOptions *imageOption = [[PHImageRequestOptions alloc] init];
        imageOption.resizeMode = PHImageRequestOptionsResizeModeFast;
        imageOption.synchronous = YES;
        imageOption.networkAccessAllowed = YES;
        
        [[PHCachingImageManager defaultManager] requestImageDataForAsset:asset
                                                                 options:imageOption
                                                           resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
            const BOOL downloadFinined = ![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey] && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue];
            if (downloadFinined && imageData) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (resultHandler) {
                        resultHandler(imageData);
                    }
                });
            }
        }];
    }];
    [_requestBigDataQueue addOperation:operationRequest];
}

- (NSData *)syncRequestImageData:(NSString *)localIdentifier {
    PHAsset *asset = localIdentifier.length > 0 ? [PHAsset fetchAssetsWithLocalIdentifiers:@[localIdentifier] options:nil].firstObject : nil;
    if (!asset) {
        return nil;
    }
    PHImageRequestOptions *imageOption = [[PHImageRequestOptions alloc] init];
    imageOption.resizeMode = PHImageRequestOptionsResizeModeFast;
    imageOption.synchronous = YES;
    imageOption.networkAccessAllowed = YES;
    __block NSData *data = nil;
    [[PHCachingImageManager defaultManager] requestImageDataForAsset:asset
                                                             options:imageOption
                                                       resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
        const BOOL downloadFinined = ![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey] && ![[info objectForKey:PHImageResultIsDegradedKey] boolValue];
        if (downloadFinined && imageData) {
            data = imageData;
        }
    }];
    return data;
}

- (void)asyncRequestVideoDuration:(PHAsset *)asset
                    resultHandler:(void (^)(NSString *duration))resultHandler {
    NSAssert([asset isKindOfClass:[PHAsset class]], @"!!!! error...");
    NSString *localIdentifier = asset.localIdentifier;
    if (![_videoDurationRequestList containsObject:localIdentifier]) {
        [_videoDurationRequestList addObject:localIdentifier];
    }
    dispatch_async(_serialCachingQueue, ^{
        __block BOOL isCancel = NO;
        dispatch_sync(dispatch_get_main_queue(), ^{
            isCancel = ![self.videoDurationRequestList containsObject:localIdentifier];
        });
        if (isCancel) {
            return;
        }
        PHVideoRequestOptions *videoOption = [[PHVideoRequestOptions alloc] init];
        videoOption.deliveryMode = PHVideoRequestOptionsDeliveryModeFastFormat;
        videoOption.version = PHVideoRequestOptionsVersionOriginal;
        videoOption.networkAccessAllowed = YES;
        [[PHCachingImageManager defaultManager] requestAVAssetForVideo:asset
                                                               options:videoOption
                                                         resultHandler:^(AVAsset * _Nullable avAsset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
            if (avAsset) {
                CMTime time = [avAsset duration];
                int seconds = ceil(time.value/time.timescale);
                //format of minute
                NSString *minute = [NSString stringWithFormat:@"%d",seconds / 60];
                //format of second
                NSString *second = [NSString stringWithFormat:@"%.2d",seconds % 60];
                //format of time
                NSString *formatTime = [NSString stringWithFormat:@"%@:%@",minute, second];
                AVAssetImageGenerator *assetGen = [[AVAssetImageGenerator alloc] initWithAsset:avAsset];
                assetGen.appliesPreferredTrackTransform = YES;
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (resultHandler) {
                        resultHandler(formatTime);
                    }
                });
            }
        }];
    });
}

- (void)cancelVideoDurationRequest:(PHAsset *)asset {
    NSAssert([asset isKindOfClass:[PHAsset class]], @"!!!! error...");
    [_videoDurationRequestList removeObject:asset.localIdentifier];
}

- (void)asyncRequestVideoAsset:(PHAsset *)asset
                 resultHandler:(void (^)(AVURLAsset *avAsset))resultHandler {
    NSAssert([asset isKindOfClass:[PHAsset class]], @"!!!! error...");
    NSBlockOperation *operationRequest = [NSBlockOperation blockOperationWithBlock:^{
        PHVideoRequestOptions *videoOption = [[PHVideoRequestOptions alloc] init];
        videoOption.version = PHVideoRequestOptionsVersionOriginal;
        videoOption.networkAccessAllowed = YES;
        [[PHCachingImageManager defaultManager] requestAVAssetForVideo:asset
                                                               options:videoOption
                                                         resultHandler:^(AVAsset * _Nullable avAsset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
            if (avAsset) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (resultHandler) {
                        resultHandler((AVURLAsset *)avAsset);
                    }
                });
            }
        }];
    }];
    [_requestBigDataQueue addOperation:operationRequest];
}

- (void)asyncRequestThumbImage:(NSString *)localIdentifier
                 resultHandler:(void (^)(UIImage *image))resultHandler {
    NSBlockOperation *operationAdd = [NSBlockOperation blockOperationWithBlock:^{
        @synchronized (self.imageThumbRequestList) {
            [self.imageThumbRequestList removeObject:localIdentifier];
            [self.imageThumbRequestList addObject:localIdentifier];
            [self.imageThumbRequestBlockMap setValue:resultHandler
                                              forKey:localIdentifier];
            if (self.imageThumbRequestList.count > kGYCachingThumbImageCount) {
                NSString *removeIdentifier = self.imageThumbRequestList.firstObject;
                [self.imageThumbRequestBlockMap removeObjectForKey:removeIdentifier];
                [self.imageThumbRequestList removeObject:removeIdentifier];
            }
        }
    }];
    operationAdd.queuePriority = NSOperationQueuePriorityHigh;
    [_listWriteQueue addOperation:operationAdd];
    
    NSBlockOperation *operationRequest = [NSBlockOperation blockOperationWithBlock:^{
        @synchronized (self.imageThumbRequestList) {
            if (self.imageThumbRequestList.count == 0) {
                return;
            }
            for (NSString *identifier in self.imageThumbRequestList) {
                PHAsset *asset = identifier.length > 0 ? [PHAsset fetchAssetsWithLocalIdentifiers:@[identifier] options:nil].firstObject : nil;
                if (asset) {
                    void (^currentHandler)(UIImage *image) = [self.imageThumbRequestBlockMap objectForKey:identifier];
                    PHImageRequestOptions *imageOption = [[PHImageRequestOptions alloc] init];
                    imageOption.resizeMode = PHImageRequestOptionsResizeModeFast;
                    imageOption.synchronous = NO;
                    imageOption.networkAccessAllowed = YES;
                    [[PHCachingImageManager defaultManager] requestImageForAsset:asset
                                                                      targetSize:self.thumbSize
                                                                     contentMode:PHImageContentModeAspectFit
                                                                         options:imageOption
                                                                   resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (result
                                && currentHandler) {
                                currentHandler(result);
                            }
                        });
                    }];
                }
            }
            [self.imageThumbRequestList removeAllObjects];
            [self.imageThumbRequestBlockMap removeAllObjects];
        }
    }];
    [operationRequest addDependency:operationAdd];
    [_requestQueue cancelAllOperations];
    [_requestQueue addOperation:operationRequest];
}

- (void)asyncRequestGalleryImageWithLocalIdentifier:(NSString *)localIdentifier
                                      resultHandler:(void (^)(UIImage *image))resultHandler {
    PHAsset *asset = localIdentifier.length > 0 ? [PHAsset fetchAssetsWithLocalIdentifiers:@[localIdentifier] options:nil].firstObject : nil;
    if (!asset) {
        if (resultHandler) {
            resultHandler(nil);
        }
        return;
    }
    [self asyncRequestGalleryImage:asset
                     resultHandler:resultHandler];
}

- (void)asyncRequestGalleryImage:(PHAsset *)asset
                   resultHandler:(void (^)(UIImage *image))resultHandler {
    NSAssert([asset isKindOfClass:[PHAsset class]], @"!!!! error...");
    NSBlockOperation *operationRequest = [NSBlockOperation blockOperationWithBlock:^{
        // thumb
        PHImageRequestOptions *imageThumbOption = [[PHImageRequestOptions alloc] init];
        imageThumbOption.resizeMode = PHImageRequestOptionsResizeModeFast;
        imageThumbOption.synchronous = YES;
        imageThumbOption.networkAccessAllowed = YES;
        [[PHCachingImageManager defaultManager] requestImageForAsset:asset
                                                          targetSize:CGSizeZero
                                                         contentMode:PHImageContentModeAspectFit
                                                             options:imageThumbOption
                                                       resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (result && resultHandler) {
                    resultHandler(result);
                }
            });
        }];
        
        // UIScreen
        PHImageRequestOptions *imageOption = [[PHImageRequestOptions alloc] init];
        imageOption.resizeMode = PHImageRequestOptionsResizeModeFast;
        imageOption.synchronous = YES;
        imageOption.networkAccessAllowed = YES;
        [[PHCachingImageManager defaultManager] requestImageForAsset:asset
                                                          targetSize:self.gallerySize
                                                         contentMode:PHImageContentModeAspectFit
                                                             options:imageOption
                                                       resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (result && resultHandler) {
                    resultHandler(result);
                }
            });
        }];
    }];
    [_requestBigDataQueue addOperation:operationRequest];
}

@end
