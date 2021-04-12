//
//  GYMineInfo.h
//  GYFramework
//
//  Created by Yang Ge on 2021/2/23.
//  Copyright © 2021 GeYang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GYMineInfoObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface GYMineInfo : NSObject <GYMineInfoObject, NSCoding, NSCopying>

+ (instancetype)infoWithDictionary:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
