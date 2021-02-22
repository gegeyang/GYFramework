//
//  GYTabbarItemInfo.m
//  GYFramework
//
//  Created by GeYang on 2018/7/7.
//  Copyright © 2018年 GeYang. All rights reserved.
//

#import "GYTabbarItemInfo.h"
#import "GYTabbarButton.h"

@interface GYTabbarItemInfo ()

@property (nonatomic, strong) GYTabbarButton *barItem;
@property (nonatomic, strong) GYViewController *viewController;

- (instancetype)initWithTitle:(NSString *)title
                  normalImage:(UIImage *)normalImage
                selectedImage:(UIImage *)selectedImage
                      itemTag:(NSInteger)itemTag
               viewController:(GYViewController *)viewController;

@end

@implementation GYTabbarItemInfo

+ (instancetype)mainBarItemInfoWithTitle:(NSString *)title
                             normalImage:(UIImage *)normalImage
                           selectedImage:(UIImage *)selectedImage
                                 itemTag:(NSInteger)itemTag
                          viewController:(GYViewController *)viewController {
    return [[GYTabbarItemInfo alloc] initWithTitle:title
                                        normalImage:normalImage
                                      selectedImage:selectedImage
                                            itemTag:itemTag
                                     viewController:viewController];
}

- (instancetype)initWithTitle:(NSString *)title
                  normalImage:(UIImage *)normalImage
                selectedImage:(UIImage *)selectedImage
                      itemTag:(NSInteger)itemTag
               viewController:(GYViewController *)viewController {
    if (self = [super init]) {
        self.barItem = [[GYTabbarButton alloc] initWithTitle:title
                                                  normalImage:normalImage
                                                selectedImage:selectedImage];
        self.barItem.tag = itemTag;
        self.viewController = viewController;
        self.viewController.view.tag = itemTag;
    }
    return self;
}

@end
