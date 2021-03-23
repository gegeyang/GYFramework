//
//  UIView+GYHUD.m
//  GYFramework
//
//  Created by Yang Ge on 2021/3/23.
//  Copyright © 2021 GeYang. All rights reserved.
//

#import "UIView+GYHUD.h"
#import "SVProgressHUD.h"

@implementation UIView (GYHUD)

#pragma mark - 静态HUD
- (void)gy_showStaticHUD:(NSString *)title {
    [self gy_showStaticHUD:title
           completionBlock:nil];
}

- (void)gy_showStaticHUD:(NSString *)title
         completionBlock:(void(^)(void))completionBlock {
    [self gy_showStaticHUD:title
                  duration:1.0f
           completionBlock:completionBlock];
}

- (void)gy_showStaticHUD:(NSString *)title
                duration:(CGFloat)duration
         completionBlock:(void(^)(void))completionBlock {
    [SVProgressHUD setViewForExtension:self];
    [SVProgressHUD setCornerRadius:5.0f];
    [SVProgressHUD setMinimumDismissTimeInterval:duration];
    [SVProgressHUD setDismissCompletion:completionBlock];
    [SVProgressHUD setBackgroundColor:[UIColor gy_color3]];
    if (completionBlock) {
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    } else {
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    }
    [SVProgressHUD showTipsWithStatus:title];
}


#pragma mark - 进度HUD
- (void)gy_showProgressHUD:(NSString *)title {
    [self gy_showProgressHUD:title
        allowUserInteraction:NO];
}

- (void)gy_showProgressHUD:(NSString *)title
      allowUserInteraction:(BOOL)allowUserInteraction {
    [SVProgressHUD setViewForExtension:self];
    [SVProgressHUD setCornerRadius:14.0f];
    [SVProgressHUD setBackgroundColor:[UIColor gy_color3]];
    if (allowUserInteraction) {
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    } else {
        [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    }
    [SVProgressHUD showWithStatus:title];
}


- (void)gy_hideHUD {
    [self gy_hideHUDWithCompletion:nil];
}

- (void)gy_hideHUDWithCompletion:(void(^)(void))completionBlock {
    [SVProgressHUD dismissWithCompletion:completionBlock];
}

@end
