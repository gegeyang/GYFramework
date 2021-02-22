//
//  GYHandler.h
//  GYFramework
//
//  Created by GeYang on 2018/7/11.
//  Copyright © 2018年 GeYang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, GYLogType) {
    GYLogNone = 0x0,
    GYLogNormalType = 1 << 0,
};

UIKIT_EXTERN GYLogType const kSupportLogType;

#ifdef DEBUG
UIKIT_EXTERN void GYKitInnerLog(NSInteger type, NSString *format, ...);
#define GYTypeLog(type,format,...)  GYKitInnerLog(type,format,##__VA_ARGS__);
#else
#define GYTypeLog(type,format,...)
#endif

#define GYLog(format,...)           GYTypeLog(GYLogNormalType, format, ##__VA_ARGS__)
