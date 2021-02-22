//
//  NSError+GYExtend.h
//  GYFramework
//
//  Created by GeYang on 2018/9/12.
//  Copyright © 2018年 GeYang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSError (GYExtend)

- (BOOL)gy_isResponseError;
- (BOOL)gy_isNotConnectedToInternet;
- (BOOL)gy_isTimeOut;
- (BOOL)gy_isCancelled;
- (NSString *)gy_errorDescription;

@end
