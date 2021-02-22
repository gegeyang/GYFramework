//
//  GYViewControllerTransition.h
//  GYFramework
//
//  Created by GeYang on 2018/7/12.
//  Copyright © 2018年 GeYang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, GYVCTransitionType) {
    GYVCPush,
    GYVCPop,
    GYVCFadeIn,
    GYVCFadeOut,
    GYVCGalleryPush,
    GYVCGalleryPop,
};

@interface GYViewControllerTransition : NSObject <UIViewControllerAnimatedTransitioning>

+ (instancetype)gyVCTransitionWithType:(GYVCTransitionType)type;

@end
