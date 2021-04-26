//
//  GYAlbumListController.h
//  GYFramework
//
//  Created by Yang Ge on 2021/4/26.
//  Copyright © 2021 GeYang. All rights reserved.
//

#import "GYCollectionViewController.h"
#import "GYAlbumInfo.h"

NS_ASSUME_NONNULL_BEGIN

@interface GYAlbumListController : GYCollectionViewController

@property (nonatomic, copy) void(^itemClickBlock)(GYAlbumInfo *info);

@end

NS_ASSUME_NONNULL_END
