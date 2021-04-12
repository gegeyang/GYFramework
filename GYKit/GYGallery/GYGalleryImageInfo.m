//
//  GYGalleryImageInfo.m
//  GYFramework
//
//  Created by Yang Ge on 2021/4/12.
//  Copyright © 2021 GeYang. All rights reserved.
//

#import "GYGalleryImageInfo.h"

@interface GYGalleryImageInfo ()

@property (nonatomic, copy) NSString *galleryImageUrl;

@end

@implementation GYGalleryImageInfo

+ (instancetype)infoWithDictionary:(NSDictionary *)dict {
    if (!dict) {
        return nil;
    }
    return [[self alloc] initWithDictionary:dict];
}

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    if (self = [super init]) {
        _galleryImageUrl = [dict gy_stringValue:@"cover"];
    }
    return self;
}

#pragma mark - GYGalleryItemObject
- (GYGalleryItemType)galleryItemType {
    return GYGalleryItemTypeUrl;
}

- (NSString *)gallerySmallUrlString {
    return _galleryImageUrl;
}

- (NSString *)galleryBigUrlString {
    return _galleryImageUrl;
}

@end
