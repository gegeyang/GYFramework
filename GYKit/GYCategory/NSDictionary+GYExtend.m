//
//  NSDictionary+GYExtend.m
//  GYFramework
//
//  Created by Yang Ge on 2021/2/23.
//  Copyright © 2021 GeYang. All rights reserved.
//

#import "NSDictionary+GYExtend.h"

@implementation NSDictionary (GYExtend)

- (NSString *)gy_stringValue:(NSString *)stringKey {
    return [self gy_stringValue:stringKey
                     valueIfNil:@""];
}

- (NSString *)gy_stringValue:(NSString *)stringKey
                  valueIfNil:(NSString *)valueIfNil {
    id value = [self objectForKey:stringKey];
    return value ? [NSString stringWithFormat:@"%@", value] : valueIfNil;
}

- (NSInteger)gy_integerValue:(NSString *)stringKey
                  valueIfNil:(NSInteger)valueIfNil {
    id value = [self objectForKey:stringKey];
    return value ? [value integerValue] : valueIfNil;
}

- (BOOL)gy_boolValue:(NSString *)stringKey
          valueIfNil:(BOOL)valueIfNil {
    id value = [self objectForKey:stringKey];
    return value ? [value boolValue] : valueIfNil;
}
@end
