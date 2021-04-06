//
//  NSDate+GYExtend.m
//  GYFramework
//
//  Created by Yang Ge on 2021/4/6.
//  Copyright © 2021 GeYang. All rights reserved.
//

#import "NSDate+GYExtend.h"

@implementation NSDate (GYExtend)

+ (NSDate *)gy_dateFromString:(NSString *)string
                       format:(NSString *)format {
    if (string.length != format.length) {
        return nil;
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    return [formatter dateFromString:string];
}

- (NSString *)gy_formatString:(NSString *)format {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:format];
    return [formatter stringFromDate:self];
}

@end
