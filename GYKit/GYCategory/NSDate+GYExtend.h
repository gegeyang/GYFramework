//
//  NSDate+GYExtend.h
//  GYFramework
//
//  Created by Yang Ge on 2021/4/6.
//  Copyright © 2021 GeYang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDate (GYExtend)

/**
 将字符串时间转换为NSDate
 */
+ (NSDate *)gy_dateFromString:(NSString *)string
                       format:(NSString *)format;
/**
 将NSDate转换为字符串时间
 */
- (NSString *)gy_formatString:(NSString *)format;

@end

NS_ASSUME_NONNULL_END
