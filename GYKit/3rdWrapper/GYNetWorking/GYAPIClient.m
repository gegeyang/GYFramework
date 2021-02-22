//
//  GYAPIClient.m
//  GYFramework
//
//  Created by GeYang on 2018/9/12.
//  Copyright © 2018年 GeYang. All rights reserved.
//

#import "GYAPIClient.h"
#import "AFHTTPSessionManager.h"
#import "JSONKit.h"

#define GYNETWORK_CACHED_TIME_KEY           @"GY-Cache-Expiration-Time"

@interface GYAPIClient ()

@property (nonatomic, strong) AFHTTPSessionManager *httpSessionManager;

@end

@implementation GYAPIClient

+ (GYAPIClient *)sharedClient {
    static GYAPIClient *client = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        client = [[GYAPIClient sharedClient] init];
        client.httpSessionManager = [[AFHTTPSessionManager alloc] initWithBaseURL:nil];
        client.httpSessionManager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        client.httpSessionManager.securityPolicy.allowInvalidCertificates = YES;
        client.httpSessionManager.securityPolicy.validatesDomainName = NO;
        client.httpSessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        client.httpSessionManager.requestSerializer.cachePolicy = NSURLRequestReturnCacheDataElseLoad;
        client.httpSessionManager.requestSerializer.timeoutInterval = 30.0f;
    });
    return client;
}

- (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(NSDictionary *)params
                       success:(void (^)(id))success
                       failure:(void (^)(NSError *))failure {
    [self.httpSessionManager.requestSerializer setValue:@"0" forHTTPHeaderField:GYNETWORK_CACHED_TIME_KEY];
    return [self.httpSessionManager POST:URLString
                              parameters:params
                                 headers:nil
                                progress:nil
                                 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            NSDictionary *dictInfo = [responseObject objectFromJSONData];
            success(dictInfo);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        GYLog(@"%@", error.description);
        if (failure) {
            failure(error);
        }
    }];
}

- (nullable NSURLSessionDataTask *)POST:(NSString *)URLString
                             parameters:(nullable NSDictionary *)params
              constructingBodyWithBlock:(nullable void (^)(id <AFMultipartFormData> formData))block
                               progress:(nullable void (^)(NSProgress *))uploadProgress
                                success:(nullable void (^)(id))success
                                failure:(nullable void (^)(NSError *error))failure {
    [self.httpSessionManager.requestSerializer setValue:@"0" forHTTPHeaderField:GYNETWORK_CACHED_TIME_KEY];
    return [self.httpSessionManager POST:URLString
                              parameters:params
                                 headers:nil
               constructingBodyWithBlock:block
                                progress:nil
                                 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                     if (success) {
                                         NSDictionary *dictInfo = [responseObject objectFromJSONData];
                                         success(dictInfo);
                                     }
                                 }
                                 failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                     GYLog(@"%@", error.description);
                                     if (failure) {
                                         failure(error);
                                     }
                                 }];
}

- (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(NSDictionary *)params
                      success:(void (^)(id))success
                      failure:(void (^)(NSError *error))failure {
    return [self GET:URLString parameters:params cacheSeconds:0 success:success failure:failure];
}

- (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(NSDictionary *)params
                 cacheSeconds:(NSInteger)cacheSeconds
                      success:(void (^)(id))success
                      failure:(void (^)(NSError *error))failure {
    NSString *secondStr = [NSString stringWithFormat:@"%@", @(cacheSeconds)];
    [self.httpSessionManager.requestSerializer setValue:secondStr forHTTPHeaderField:GYNETWORK_CACHED_TIME_KEY];
    return [self.httpSessionManager GET:URLString
                             parameters:params
                                headers:nil
                               progress:nil
                                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                    if (success) {
                                        NSDictionary *dictInfo = [responseObject objectFromJSONData];
                                        success(dictInfo);
                                    }
                                }
                                failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                    GYLog(@"%@", error.description);
                                    if (failure) {
                                        failure(error);
                                    }
                                }];
}
@end
