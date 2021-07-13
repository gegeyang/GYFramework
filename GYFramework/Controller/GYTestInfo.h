//
//  GYTestInfo.h
//  GYFramework
//
//  Created by Yang Ge on 2021/6/8.
//  Copyright © 2021 GeYang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GYTestInfo : NSObject <NSCopying, NSMutableCopying>

@property (nonatomic, copy) void(^onClick)(void);

+ (instancetype)defaultManager;

@end

NS_ASSUME_NONNULL_END
