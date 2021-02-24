//
//  GYViewController.h
//  GYFramework
//
//  Created by GeYang on 2018/6/1.
//  Copyright © 2018年 GeYang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, GYVCPushAnimationMode) {
    GYVCPushNormalMode,
    GYVCPushPresentMode,
    GYVCPushGalleryMode,
    GYVCPushFadeMode,
};

typedef NS_OPTIONS(NSInteger, GYAutoAdjust) {
    GYAutoAdjustNone = 0,
    GYAutoAdjustScrollContentInsetFromParent = 1 << 0,
    GYAutoAdjustScrollContentInsetFromSelf = 1 << 1,
};

@interface GYViewController : UIViewController

@property (nonatomic, strong, readonly) UIView *navigationBar;
@property (nonatomic, strong, readonly) UILabel *titleLabel;
@property (nonatomic, readonly) UIEdgeInsets safeAreaInsets;
@property (nonatomic, assign) UIEdgeInsets contentInsetsFromParent;

- (void)forceRefresh:(BOOL)ignoreIsRefresh;
- (void)switchToParams:(NSDictionary *)params;
- (void)viewContentInsetDidChanged NS_REQUIRES_SUPER;

@end

@interface GYViewController(GYAnimatedTransitioningExtend)

- (GYVCPushAnimationMode)preferredPushAnimationMode; // Defaults to GYVCPushNormalMode

@end

@interface GYViewController(HandleNavigationTransitionExtend)

- (BOOL)handleNavigationTransitionEnabled;

@end

@interface GYViewController(NavigationExtend)

- (UIButton *)gy_navigation_leftBtnAtIndex:(NSInteger)index;
- (UIButton *)gy_navigation_rightBtnAtIndex:(NSInteger)index;

- (void)gy_navigation_initLeftBackBtn:(void(^)(void))backBlock;

- (void)gy_navigation_insertLeftBtn:(UIButton *)btn
                            atIndex:(NSInteger)index;
- (void)gy_navigation_removeLeftBtnAtIndex:(NSInteger)index;

- (void)gy_navigation_insertRightBtn:(UIButton *)btn
                             atIndex:(NSInteger)index;
- (void)gy_navigation_removeRightBtnAtIndex:(NSInteger)index;

- (void)gy_navigation_initTitle:(NSString *)title;
- (void)gy_navigation_layoutSubView;

- (void)gy_navigation_onBackClicked:(id)sender;

- (void)gy_navigation_setLeftHidden:(BOOL)hidden;
- (void)gy_navigation_setRightHidden:(BOOL)hidden;

@end
