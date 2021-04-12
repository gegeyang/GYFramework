//
//  UIImageView+GYExtend.h
//  GYFramework
//
//  Created by Yang Ge on 2021/4/12.
//  Copyright © 2021 GeYang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImageView (GYExtend)

- (void)wj_setImageURLString:(NSString *)urlString;

- (void)gy_setImageURLString:(NSString *)urlString
      normalPlaceholderImage:(UIImage *)normalPlaceholderImage
      failedPlaceholderImage:(UIImage *)failedPlaceholderImage
       emptyPlaceholderImage:(UIImage *)emptyPlaceholderImage
                  completion:(void(^)(UIImage *))completion;

@end

NS_ASSUME_NONNULL_END
