//
//  GYFetchListModel.m
//  GYFramework
//
//  Created by GeYang on 2018/9/12.
//  Copyright © 2018年 GeYang. All rights reserved.
//

#import "GYFetchListModel.h"
#import "GYLoadStatusObject.h"

@interface GYFetchListModel ()

@property (nonatomic, strong) NSMutableArray *arrFetchResult;
@property (nonatomic, assign) NSInteger currentPageIndex;
@property (nonatomic, strong) GYLoadStatusObject *statusObject;

@end

@implementation GYFetchListModel

- (NSMutableArray *)arrFetchResult {
    if (!_arrFetchResult) {
        _arrFetchResult = [NSMutableArray array];
    }
    return _arrFetchResult;
}

- (instancetype)init {
    if (self = [super init]) {
        _statusObject = [GYLoadStatusObject statusObjectWithStatus:GYLoadNone];
        _currentPageIndex = 1;
        _hasMoreData = NO;
    }
    return self;
}

- (void)dealloc {
    [self.task cancel];
    self.task = nil;
}

- (void)fetchDataWithSuccess:(void (^)(void))success
                     failure:(void (^)(NSError *))failure {
    
}

- (void)setStatusObject:(GYLoadStatusObject *)statusObject {
    _statusObject = statusObject;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.statusObject.isLoading) {
            if ([self.delegate respondsToSelector:@selector(onDataModelLoading)]) {
                [self.delegate onDataModelLoading];
            }
        } else if (self.statusObject.loadSuccess) {
            if ([self.delegate respondsToSelector:@selector(onDataModelLoadSuccess)]) {
                [self.delegate onDataModelLoadSuccess];
            }
        } else if (self.statusObject.loadFailed) {
            if ([self.delegate respondsToSelector:@selector(onDataModelLoadFailed:)]) {
                [self.delegate onDataModelLoadFailed:self.statusObject.error];
            }
        }
    });
}

- (BOOL)loadSuccess {
    return self.statusObject.loadSuccess;
}

#pragma mark - GYListViewDataSource
- (void)reset {
    [self.task cancel];
    self.task = nil;
    [self.arrFetchResult removeAllObjects];
    self.statusObject = [GYLoadStatusObject statusObjectWithStatus:GYLoadNone];
}

- (BOOL)hasData {
    return self.arrFetchResult.count > 0;
}

- (BOOL)dataNeedReload {
    return self.statusObject == nil || self.statusObject.needReload;
}

- (NSInteger)sectionCount {
    return self.arrFetchResult.count > 0 ? 1 : 0;
}

- (NSInteger)numberOfDatasInSection:(NSInteger)section {
    return self.arrFetchResult.count;
}

- (void)reloadDataWithCompletion:(void (^)(BOOL))completion {
    if (self.statusObject.isLoading) {
        return;
    }
    self.currentPageIndex = 1;
    self.statusObject = [GYLoadStatusObject statusObjectWithStatus:GYLoading];
    __weak typeof(self) weakself = self;
    [self fetchDataWithSuccess:^{
        __strong typeof(weakself) strongself = weakself;
        strongself.statusObject = [GYLoadStatusObject statusObjectWithStatus:GYLoadSuccess];
        if (completion) {
            completion(YES);
        }
    } failure:^(NSError *error) {
        __strong typeof(weakself) strongself = weakself;
        strongself.statusObject = [GYLoadStatusObject failedObjectWithError:error];
        if (completion) {
            completion(NO);
        }
    }];
}

- (void)loadMoreDataWithCompletion:(void (^)(BOOL))completion {
    if (self.statusObject.isLoading) {
        return;
    }
    self.currentPageIndex++;
    self.statusObject = [GYLoadStatusObject statusObjectWithStatus:GYLoading];
    __weak typeof(self) weakself = self;
    [self fetchDataWithSuccess:^{
        __strong typeof(weakself) strongself = weakself;
        strongself.statusObject = [GYLoadStatusObject statusObjectWithStatus:GYLoadSuccess];
        if (completion) {
            completion(YES);
        }
    } failure:^(NSError *error) {
       __strong typeof(weakself) strongself = weakself;
        strongself.statusObject = [GYLoadStatusObject failedObjectWithError:error];
        if (completion) {
            completion(NO);
        }
    }];
}

- (id)sectionInfoAtIndex:(NSInteger)section {
    return nil;
}

- (id)itemInfoAtIndexPath:(NSIndexPath *)indexPath {
    const NSInteger row = indexPath.row;
    if ((row >= 0 && row < self.arrFetchResult.count)) {
        return [self.arrFetchResult objectAtIndex:row];
    }
    return nil;
}

@end
