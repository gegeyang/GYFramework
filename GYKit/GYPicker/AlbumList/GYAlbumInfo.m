//
//  GYAlbumInfo.m
//  GYFramework
//
//  Created by Yang Ge on 2021/4/25.
//  Copyright © 2021 GeYang. All rights reserved.
//

#import "GYAlbumInfo.h"
#import <Photos/Photos.h>

@interface GYAlbumInfo ()

@property (nonatomic, strong) PHAssetCollection *assetCollection;
@property (nonatomic, strong) PHAsset *albumCoverAsset;
@property (nonatomic, strong) PHFetchResult *albumAssets;

@end

@implementation GYAlbumInfo

+ (instancetype)photoAlbumInfoWithObject:(id)object {
    if (!object || ![object isKindOfClass:[PHAssetCollection class]]) {
        return nil;
    }
    return [[self alloc] initWithObject:object];
}

- (instancetype)initWithObject:(PHAssetCollection *)assetCollection {
    self = [super init];
    if (self) {
        self.assetCollection = assetCollection;
        [self reloadAssetList];
    }
    return self;
}

- (void)reloadAssetList {
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    //按创建时间排序
    option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    self.albumAssets = [PHAsset fetchAssetsInAssetCollection:_assetCollection
                                                     options:option];
    self.albumCoverAsset = self.albumAssets.firstObject;
}

- (NSString *)albumIdentifier {
    return self.assetCollection.localIdentifier;
}

- (NSString *)albumTitle {
    return self.assetCollection.localizedTitle;
}

- (NSUInteger)albumCount {
    return self.albumAssets.count;
}

- (NSUInteger)indexOfObject:(id)object {
    return [self.albumAssets indexOfObject:object];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@: %@", self.assetCollection.localizedTitle, @(self.assetCollection.estimatedAssetCount)];
}

#pragma mark - WJListViewDataSource
- (BOOL)hasData {
    return self.albumAssets.count > 0;
}

- (BOOL)hasMoreData {
    return 0;
}

- (BOOL)dataNeedReload {
    return NO;
}

- (NSInteger)sectionCount {
    return 1;
}

- (NSInteger)numberOfDatasInSection:(NSInteger)section {
    return self.albumAssets.count;
}

- (void)reloadDataWithCompletion:(void(^)(BOOL))completion {
    [self reloadAssetList];
    if (completion) {
        completion(YES);
    }
}

- (void)loadMoreDataWithCompletion:(void(^)(BOOL))completion {}
- (void)reset {}
- (id)sectionInfoAtIndex:(NSInteger)section { return nil; }

- (id)itemInfoAtIndexPath:(NSIndexPath *)indexPath {
    return [self.albumAssets objectAtIndex:indexPath.row];
}

@end
