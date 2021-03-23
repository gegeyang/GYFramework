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
         completionBlock:(void(^)(void))completionBlock;
- (void)gy_showStaticHUD:(NSString *)title
                duration:(CGFloat)duration
         completionBlock:(void(^)(void))completionBlock;

/**
 进度HUD
 */
- (void)gy_showProgressHUD:(NSString *)title;
- (void)gy_showProgressHUD:(NSString *)title
      allowUserInteraction:(BOOL)allowUserInteraction;

/**
 隐藏HUD
 */
- (void)gy_hideHUD;
- (void)gy_hideHUDWithCompletion:(void(^)(void))completionBlock;

@end

NS_ASSUME_NONNULL_END
