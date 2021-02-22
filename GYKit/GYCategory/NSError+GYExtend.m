//
//  NSError+GYExtend.m
//  GYFramework
//
//  Created by GeYang on 2018/9/12.
//  Copyright © 2018年 GeYang. All rights reserved.
//

#import "NSError+GYExtend.h"

@implementation NSError (GYExtend)

- (BOOL)gy_isResponseError {
    return [self.domain isEqualToString:GYNETWORK_SERVER_CODE_FAILDDOMAIN];
}

- (BOOL)gy_isNotConnectedToInternet {
    return [self.domain isEqualToString:NSURLErrorDomain] && self.code == NSURLErrorNotConnectedToInternet;
}

- (BOOL)gy_isTimeOut {
    return [self.domain isEqualToString:NSURLErrorDomain] && self.code == NSURLErrorTimedOut;
}

- (BOOL)gy_isCancelled {
    return [self.domain isEqualToString:NSURLErrorDomain] && self.code == NSURLErrorCancelled;
}

- (NSString *)gy_errorDescription {
    if ([self gy_isResponseError]) {
        return self.localizedDescription;
    } else if ([self gy_isNotConnectedToInternet]) {
        return NSLocalizedString(@"请检查网络", nil);
    } else if ([self gy_isTimeOut]) {
        return NSLocalizedString(@"请求超时", nil);
    }
    return nil;
}

@end
