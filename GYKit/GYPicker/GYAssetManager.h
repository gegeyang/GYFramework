//
//  GYAssetManager.h
//  GYFramework
//
//  Created by Yang Ge on 2021/4/25.
//  Copyright © 2021 GeYang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GYAlbumInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface GYAssetManager : NSObject

+ (instancetype)defaultManager;

/**
 获取所有视频
 */
- (void)fetchVideoAlbumInfo:(void(^)(GYAlbumInfo *))success
                    failure:(void(^)(NSError *))failure;

/**
 获取所有照片
 */
- (void)fetchAllAlbumInfo:(void(^)(GYAlbumInfo *albumInfo))success
                  failure:(void(^)(NSError *error))failure;


/**
 获取所有相册
 */
- (void)fetchPhotoAlbumList:(void(^)(NSArray *albumList))success
                    failure:(void(^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
