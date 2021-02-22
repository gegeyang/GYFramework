//
//  GYLoadStatusObject.h
//  GYFramework
//
//  Created by GeYang on 2018/9/12.
//  Copyright © 2018年 GeYang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, GYLoadStatus) {
    GYLoadNone,
    GYLoading,
    GYLoadSuccess,
    GYLoadFailed,
};

@interface GYLoadStatusObject : NSObject

@property (nonatomic, strong, readonly) NSError *error;
@property (nonatomic, readonly) BOOL loadSuccess;
@property (nonatomic, readonly) BOOL isLoading;
@property (nonatomic, readonly) BOOL loadFailed;
@property (nonatomic, readonly) BOOL needReload;

+ (GYLoadStatusObject *)statusObjectWithStatus:(GYLoadStatus)status;
+ (GYLoadStatusObject *)failedObjectWithError:(NSError *)error;
- (instancetype)initWithStatus:(GYLoadStatus)status error:(NSError *)error;

@end
