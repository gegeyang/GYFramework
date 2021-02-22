//
//  GYHandler.m
//  GYFramework
//
//  Created by GeYang on 2018/7/11.
//  Copyright © 2018年 GeYang. All rights reserved.
//

#import "GYHandler.h"

#ifdef DEBUG
GYLogType const kSupportLogType =
GYLogNormalType
;
#else
GYLogType const kSupportLogType = GYLogNone;
#endif

#ifdef DEBUG
void GYKitInnerLog(NSInteger type, NSString *format, ...) {
    if (type & kSupportLogType) {
        va_list args;
        va_start(args,format);
        NSLogv(format, args);
        va_end(args);
    }
}
#endif
