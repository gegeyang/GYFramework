//
//  GYGalleryImageInfo.h
//  GYFramework
//
//  Created by Yang Ge on 2021/4/12.
//  Copyright © 2021 GeYang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GYGalleryItemObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface GYGalleryImageInfo : NSObject <GYGalleryItemObject>

+ (instancetype)infoWithDictionary:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
