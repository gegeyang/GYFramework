//
//  GYMineInfo.m
//  GYFramework
//
//  Created by Yang Ge on 2021/2/23.
//  Copyright © 2021 GeYang. All rights reserved.
//

#import "GYMineInfo.h"

@interface GYMineInfo ()

@property (nonatomic, copy) NSString *infoTitle;

@end

@implementation GYMineInfo

+ (instancetype)infoWithDictionary:(NSDictionary *)dict {
    if (!dict) {
        return nil;
    }
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        _infoTitle = [dict gy_stringValue:@"title"];
    }
    return self;
}

@end
