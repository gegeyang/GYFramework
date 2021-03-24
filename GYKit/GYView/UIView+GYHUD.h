//
//  UIView+GYHUD.h
//  GYFramework
//
//  Created by Yang Ge on 2021/3/23.
//  Copyright © 2021 GeYang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (GYHUD)

/**
 静态HUD
 */
- (void)gy_showStaticHUD:(NSString *)title;
- (void)gy_showStaticHUD:(NSString *)title
         completionBlock:(void(^_Nullable)(void))completionBlock;
- (void)gy_showStaticHUD:(NSString *)title
                duration:(CGFloat)duration
         completionBlock:(void(^_Nullable)(void))completionBlock;

/**
 进度HUD
 */
- (void)gy_showProgressHUD:(NSString * _Nullable)title;
- (void)gy_showProgressHUD:(NSString * _Nullable)title
      allowUserInteraction:(BOOL)allowUserInteraction;

/**
 隐藏HUD
 */
- (void)gy_hideHUD;
- (void)gy_hideHUDWithCompletion:(void(^_Nullable)(void))completionBlock;

@end

NS_ASSUME_NONNULL_END
