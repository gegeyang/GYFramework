//
//  GYAlbumModel.m
//  GYFramework
//
//  Created by Yang Ge on 2021/4/26.
//  Copyright © 2021 GeYang. All rights reserved.
//

#import "GYAlbumModel.h"
#import "GYAssetManager.h"

@interface GYAlbumModel ()

@end

@implementation GYAlbumModel

- (void)fetchDataWithSuccess:(void (^)(void))success failure:(void (^)(NSError *))failure {
    __weak typeof(self) weakself = self;
    [[GYAssetManager defaultManager] fetchPhotoAlbumList:^(NSArray * _Nonnull albumList) {
        __strong typeof(weakself) strongself = weakself;
        [strongself.arrFetchResult addObjectsFromArray:albumList];
        if (success) {
            success();
        }
    } failure:failure];
}

@end
