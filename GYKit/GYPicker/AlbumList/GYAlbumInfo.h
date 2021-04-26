//
//  GYAlbumInfo.h
//  GYFramework
//
//  Created by Yang Ge on 2021/4/25.
//  Copyright © 2021 GeYang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GYAlbumInfo : NSObject

@property (nonatomic, readonly) NSString *albumIdentifier;
@property (nonatomic, readonly) NSString *albumTitle;
@property (nonatomic, readonly) NSUInteger albumCount;
@property (nonatomic, readonly) id albumCoverAsset;

+ (instancetype)photoAlbumInfoWithObject:(id)object;
- (NSUInteger)indexOfObject:(id)object;

- (void)reloadAssetList;

@end

NS_ASSUME_NONNULL_END
