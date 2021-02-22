//
//  GYLoadStatusObject.m
//  GYFramework
//
//  Created by GeYang on 2018/9/12.
//  Copyright © 2018年 GeYang. All rights reserved.
//

#import "GYLoadStatusObject.h"

@interface GYLoadStatusObject ()

@property (nonatomic, assign) GYLoadStatus loadStatus;
@property (nonatomic, strong) NSError *error;

@end

@implementation GYLoadStatusObject

+ (GYLoadStatusObject *)statusObjectWithStatus:(GYLoadStatus)status {
    GYLoadStatusObject *fetchStatus = [[GYLoadStatusObject alloc] initWithStatus:status error:nil];
    return fetchStatus;
}

+ (GYLoadStatusObject *)failedObjectWithError:(NSError *)error {
    GYLoadStatusObject *fetchStatus = [[GYLoadStatusObject alloc] initWithStatus:GYLoadFailed error:error];
    return fetchStatus;
}

- (instancetype)initWithStatus:(GYLoadStatus)status error:(NSError *)error {
    if (self = [super init]) {
        self.loadStatus = status;
        self.error = error;
    }
    return self;
}

- (BOOL)loadSuccess {
    return _loadStatus == GYLoadSuccess;
}

- (BOOL)loadFailed {
    return _loadStatus == GYLoadFailed;
}

- (BOOL)isLoading {
    return _loadStatus == GYLoading;
}

- (BOOL)needReload {
    return _loadStatus == GYLoadFailed || _loadStatus == GYLoadNone;
}

@end
