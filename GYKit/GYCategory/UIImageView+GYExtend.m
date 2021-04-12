//
//  UIImageView+GYExtend.m
//  GYFramework
//
//  Created by Yang Ge on 2021/4/12.
//  Copyright © 2021 GeYang. All rights reserved.
//

#import "UIImageView+GYExtend.h"
#import "UIImageView+WebCache.h"
#import "UIView+WebCache.h"

@implementation UIImageView (GYExtend)

- (void)wj_setImageURLString:(NSString *)urlString {
    [self gy_setImageURLString:urlString
        normalPlaceholderImage:[UIImage imageNamed:@"common_image_normal"]
        failedPlaceholderImage:[UIImage imageNamed:@"common_image_failure"]
         emptyPlaceholderImage:[UIImage imageNamed:@"common_image_failure"]
                    completion:nil];
}

- (void)gy_setImageURLString:(NSString *)urlString
      normalPlaceholderImage:(UIImage *)normalPlaceholderImage
      failedPlaceholderImage:(UIImage *)failedPlaceholderImage
       emptyPlaceholderImage:(UIImage *)emptyPlaceholderImage
                  completion:(void(^)(UIImage *))completion {
    UIImage *imageCached = [UIImageView sd_cachedImageForURLString:urlString];
    normalPlaceholderImage = imageCached ?: normalPlaceholderImage;
    failedPlaceholderImage = imageCached ?: (failedPlaceholderImage ?: normalPlaceholderImage);
    emptyPlaceholderImage = imageCached ?: (emptyPlaceholderImage ?: normalPlaceholderImage);
    if (urlString == nil || urlString.length == 0) {
        self.image = emptyPlaceholderImage;
        if (completion) {
            completion(nil);
        }
        return;
    }
    
    __weak typeof(self) weakself = self;
    [self sd_setImageWithURL:[NSURL URLWithString:urlString]
            placeholderImage:normalPlaceholderImage
                   completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                       if (image == nil) {
                           weakself.image = failedPlaceholderImage;
                       }
                       if (completion) {
                           completion(image);
                       }
                   }];
}

@end
