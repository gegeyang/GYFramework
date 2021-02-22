//
//  GYAPIClient.h
//  GYFramework
//
//  Created by GeYang on 2018/9/12.
//  Copyright © 2018年 GeYang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GYMultipartFormData.h"

NS_ASSUME_NONNULL_BEGIN
@interface GYAPIClient : NSObject

+ (GYAPIClient *)sharedClient;

- (nullable NSURLSessionDataTask *)POST:(NSString *)URLString
                             parameters:(nullable NSDictionary *)params
                                success:(void (^)(id))success
                                failure:(void (^)(NSError *error))failure;

- (nullable NSURLSessionDataTask *)POST:(NSString *)URLString
                             parameters:(nullable NSDictionary *)params
              constructingBodyWithBlock:(nullable void (^)(id <AFMultipartFormData> formData))block
                               progress:(nullable void (^)(NSProgress *))uploadProgress
                                success:(nullable void (^)(id))success
                                failure:(nullable void (^)(NSError *error))failure;

- (nullable NSURLSessionDataTask *)GET:(NSString *)URLString
                            parameters:(nullable NSDictionary *)params
                               success:(nullable void (^)(id))success
                               failure:(nullable void (^)(NSError *error))failure;

- (nullable NSURLSessionDataTask *)GET:(NSString *)URLString
                            parameters:(nullable NSDictionary *)params
                          cacheSeconds:(NSInteger)cacheSeconds
                               success:(nullable void (^)(id))success
                               failure:(nullable void (^)(NSError *error))failure;

@end
NS_ASSUME_NONNULL_END
