//
//  GYTabbarButton.h
//  GYFramework
//
//  Created by GeYang on 2018/7/7.
//  Copyright © 2018年 GeYang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GYTabbarButton : UIButton

- (instancetype)initWithTitle:(NSString *)title
                  normalImage:(UIImage *)normalImage
                selectedImage:(UIImage *)selectedImage;

- (void)setBadgeValue:(NSInteger)badgeValue;

@end
