//
//  GYGalleryItemObject.h
//  GYFramework
//
//  Created by Yang Ge on 2021/4/12.
//  Copyright © 2021 GeYang. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, GYGalleryItemType) {
    GYGalleryItemTypeNone        = 0,
    GYGalleryItemTypeImage       = 1,
    GYGalleryItemTypeUrl         = 2,
    GYGalleryItemTypeVideo       = 3,
};

NS_ASSUME_NONNULL_BEGIN

@protocol GYGalleryItemObject <NSObject>

- (GYGalleryItemType)galleryItemType;

@optional
- (CGFloat)galleryImageRadio;

@end


@protocol GYGalleryImageObject <GYGalleryItemObject>

- (UIImage *)galleryImage;

@end

@protocol GYGalleryUrlObject <GYGalleryItemObject>

- (NSString *)gallerySmallUrlString;
- (NSString *)galleryBigUrlString;

@end

@protocol GYGalleryVideoObject <GYGalleryItemObject>

- (NSURL *)galleryVideoUrl;
- (NSString *)galleryVideoCover;

@end
NS_ASSUME_NONNULL_END
