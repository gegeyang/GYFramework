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
@property (nonatomic, assign) CGFloat imageWidth;
@property (nonatomic, assign) CGFloat imageHeight;

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
        _imageWidth = [[dict gy_stringValue:@"width"] floatValue];
        _imageHeight = [[dict gy_stringValue:@"height"] floatValue];
    }
    return self;
}

#pragma mark - GYGalleryItemObject
- (CGFloat)galleryImageRadio {
    if (_imageWidth == 0.0 | _imageHeight == 0.0) {
        return 1;
    } else {
        return _imageHeight / _imageWidth;
    }
}

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
