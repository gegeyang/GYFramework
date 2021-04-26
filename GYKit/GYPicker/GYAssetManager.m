//
//  GYAssetManager.m
//  GYFramework
//
//  Created by Yang Ge on 2021/4/25.
//  Copyright © 2021 GeYang. All rights reserved.
//

#import "GYAssetManager.h"
#import <Photos/Photos.h>
#import "GYAlbumInfo.h"

@interface GYAssetManager () <PHPhotoLibraryChangeObserver>

@property (nonatomic, assign) BOOL videoNeedReload;
@property (nonatomic, assign) BOOL allNeedReload;
@property (nonatomic, assign) BOOL photoNeedReload;
@property (nonatomic, copy) NSArray *photoAlbumList;
@property (nonatomic, strong) GYAlbumInfo *videoAlbumInfo;
@property (nonatomic, strong) GYAlbumInfo *allAlbumInfo;

@end

@implementation GYAssetManager

+ (instancetype)defaultManager  {
    static GYAssetManager *s_shareSingleton = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_shareSingleton = [[super allocWithZone:NULL] init];
    });
    return s_shareSingleton;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [GYAssetManager defaultManager];
}

- (instancetype)copyWithZone:(struct _NSZone *)zone {
    return [GYAssetManager defaultManager];
}

- (instancetype)mutableCopyWithZone:(nullable NSZone *)zone {
    return [GYAssetManager defaultManager];
}


- (instancetype)init {
    self = [super init];
    if (self) {
        _videoNeedReload = YES;
        _allNeedReload = YES;
        _photoNeedReload = YES;
        //相册变动通知
        [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
    }
    return self;
}

- (void)dealloc {
    [[PHPhotoLibrary sharedPhotoLibrary] unregisterChangeObserver:self];
}

#pragma mark - implementaction
- (void)fetchVideoAlbumInfo:(void(^)(GYAlbumInfo *))success
                    failure:(void(^)(NSError *))failure {
    if (!_videoNeedReload) {
        if (success) {
            success(self.videoAlbumInfo);
        }
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        PHFetchResult *cameraAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum
                                                                               subtype:PHAssetCollectionSubtypeSmartAlbumVideos
                                                                               options:nil];
        __block GYAlbumInfo *albumInfo = nil;
        [cameraAlbums enumerateObjectsUsingBlock:^(PHAssetCollection *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            //查找到第一个有数据的album
            albumInfo = [GYAlbumInfo photoAlbumInfoWithObject:obj];
            if (albumInfo) {
                *stop = YES;
            }
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.videoAlbumInfo = albumInfo;
            self.videoNeedReload = NO;
            if (success) {
                success(self.videoAlbumInfo);
            }
        });
    });
}

- (void)fetchAllAlbumInfo:(void(^)(GYAlbumInfo *albumInfo))success
                  failure:(void(^)(NSError *error))failure {
    if (!_allNeedReload) {
        if (success) {
            success(_allAlbumInfo);
        }
        return;
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        PHFetchResult *allAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum
                                                                            subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary
                                                                            options:nil];
        __block GYAlbumInfo *albumInfo = nil;
        [allAlbums enumerateObjectsUsingBlock:^(PHAssetCollection *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            albumInfo = [GYAlbumInfo photoAlbumInfoWithObject:obj];
            if (albumInfo) {
                *stop = YES;
            }
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.allAlbumInfo = albumInfo;
            self.allNeedReload = NO;
            if (success) {
                success(self.allAlbumInfo);
            }
        });
    });
}

- (void)fetchPhotoAlbumList:(void(^)(NSArray *albumList))success
                    failure:(void(^)(NSError *error))failure {
    if (!_photoNeedReload) {
        if (success) {
            success(_photoAlbumList);
        }
        return;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        NSMutableArray *arrSort = [@[
                                     @(PHAssetCollectionSubtypeSmartAlbumUserLibrary),
                                     @(PHAssetCollectionSubtypeAlbumMyPhotoStream),
                                     @(PHAssetCollectionSubtypeSmartAlbumRecentlyAdded),
                                     @(PHAssetCollectionSubtypeSmartAlbumFavorites),
                                     @(PHAssetCollectionSubtypeSmartAlbumPanoramas),
                                     @(PHAssetCollectionSubtypeSmartAlbumTimelapses),
                                     @(PHAssetCollectionSubtypeSmartAlbumBursts),
                                     @(PHAssetCollectionSubtypeAlbumRegular),
                                     @(PHAssetCollectionSubtypeAlbumCloudShared),
                                     ] mutableCopy];
        NSMutableDictionary *dictType = [@{
                                           @(PHAssetCollectionSubtypeSmartAlbumUserLibrary):@(PHAssetCollectionTypeSmartAlbum), // 系统相册-相机胶卷
                                           @(PHAssetCollectionSubtypeAlbumMyPhotoStream):@(PHAssetCollectionTypeAlbum), // 用户自定义相册-我的照片流
                                           @(PHAssetCollectionSubtypeSmartAlbumRecentlyAdded):@(PHAssetCollectionTypeSmartAlbum), // 系统相册-最近添加
                                           @(PHAssetCollectionSubtypeSmartAlbumFavorites):@(PHAssetCollectionTypeSmartAlbum), // 系统相册-个人收藏
                                           @(PHAssetCollectionSubtypeSmartAlbumPanoramas):@(PHAssetCollectionTypeSmartAlbum), // 系统相册-全景照片
                                           @(PHAssetCollectionSubtypeSmartAlbumTimelapses):@(PHAssetCollectionTypeSmartAlbum), // 系统相册-延时摄影
                                           @(PHAssetCollectionSubtypeSmartAlbumBursts):@(PHAssetCollectionTypeSmartAlbum), // 系统相册-连拍快照
                                           @(PHAssetCollectionSubtypeAlbumRegular):@(PHAssetCollectionTypeAlbum), // 用户自定义相册-
                                           @(PHAssetCollectionSubtypeAlbumCloudShared):@(PHAssetCollectionTypeAlbum), // 用户自定义相册-云端
                                           } mutableCopy];
        NSMutableArray *arrAlbum = [NSMutableArray array];
        for (NSNumber *numberSubType in arrSort) {
            PHAssetCollectionSubtype subType = [numberSubType integerValue];
            PHAssetCollectionType type = [[dictType objectForKey:numberSubType] integerValue];
            PHFetchResult *cameraAlbums = [PHAssetCollection fetchAssetCollectionsWithType:type subtype:subType options:nil];
            [cameraAlbums enumerateObjectsUsingBlock:^(PHAssetCollection *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                GYAlbumInfo *albumInfo = [GYAlbumInfo photoAlbumInfoWithObject:obj];
                if (albumInfo && (subType != PHAssetCollectionSubtypeAlbumCloudShared || albumInfo.albumCount > 0)) {
                    [arrAlbum addObject:albumInfo];
                }
            }];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self.photoAlbumList = [arrAlbum copy];
            self.photoNeedReload = NO;
            if (success) {
                success(self.photoAlbumList);
            }
        });
    });
}

#pragma mark - PHPhotoLibraryChangeObserver
- (void)photoLibraryDidChange:(PHChange *)changeInstance {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.videoNeedReload = YES;
        [self.videoAlbumInfo reloadAssetList];
        self.allNeedReload = YES;
        [self.allAlbumInfo reloadAssetList];
        self.photoNeedReload = YES;
        for (GYAlbumInfo *photoAlbumInfo in self.photoAlbumList) {
            [photoAlbumInfo reloadAssetList];
        }
    });
}

@end
