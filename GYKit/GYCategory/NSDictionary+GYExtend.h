//
//  NSDictionary+GYExtend.h
//  GYFramework
//
//  Created by Yang Ge on 2021/2/23.
//  Copyright © 2021 GeYang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (GYExtend)

- (NSString *)gy_stringValue:(NSString *)stringKey;
- (NSString *)gy_stringValue:(NSString *)stringKey
                  valueIfNil:(NSString *)valueIfNil;

- (NSInteger)gy_integerValue:(NSString *)stringKey
                  valueIfNil:(NSInteger)valueIfNil;

- (BOOL)gy_boolValue:(NSString *)stringKey
          valueIfNil:(BOOL)valueIfNil;

@end

NS_ASSUME_NONNULL_END
