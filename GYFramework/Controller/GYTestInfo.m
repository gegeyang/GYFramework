//
//  GYTestInfo.m
//  GYFramework
//
//  Created by Yang Ge on 2021/6/8.
//  Copyright © 2021 GeYang. All rights reserved.
//

#import "GYTestInfo.h"

@implementation GYTestInfo

+ (instancetype)defaultManager {
    static dispatch_once_t onceToken;
    static GYTestInfo *info = nil;
    dispatch_once(&onceToken, ^{
        info = [[super allocWithZone:nil] init];
    });
    return info;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [GYTestInfo defaultManager];
}

- (id)copyWithZone:(NSZone *)zone {
    return [GYTestInfo defaultManager];
}

- (id)mutableCopyWithZone:(NSZone *)zone {
    return [GYTestInfo defaultManager];
}

@end
