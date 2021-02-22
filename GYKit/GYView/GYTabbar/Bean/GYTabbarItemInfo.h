
//  GYTabbarItemInfo.h
//  GYFramework
//
//  Created by GeYang on 2018/7/7.
//  Copyright © 2018年 GeYang. All rights reserved.
//

#import "GYViewController.h"

@class GYTabbarButton;
@interface GYTabbarItemInfo : NSObject

@property (nonatomic, strong, readonly) GYTabbarButton *barItem;
@property (nonatomic, strong, readonly) GYViewController *viewController;

+ (instancetype)mainBarItemInfoWithTitle:(NSString *)title
                             normalImage:(UIImage *)normalImage
                           selectedImage:(UIImage *)selectedImage
                                 itemTag:(NSInteger)itemTag
                          viewController:(GYViewController *)viewController;

@end
