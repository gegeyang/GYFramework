//
//  GYAppRootController.m
//  GYFramework
//
//  Created by GeYang on 2018/6/1.
//  Copyright © 2018年 GeYang. All rights reserved.
//

#import "GYAppRootController.h"
#import "GYViewControllerTransition.h"
#import "GYCoordinatingMediator.h"

@interface GYAppRootController () <UINavigationControllerDelegate, UIGestureRecognizerDelegate> {
    BOOL _allowFullPopGesture;  //支持全屏侧滑返回
}

@end

@implementation GYAppRootController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBarHidden = YES;
    self.delegate = self;
    _allowFullPopGesture = NO;
    if (_allowFullPopGesture) {
        /**
         系统侧滑 UIScreenEdgePanGestureRecognizer类型 替换为 UIPanGestureRecognizer类型
         */
        SEL handelTransition = NSSelectorFromString(@"handleNavigationTransition:");
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self.interactivePopGestureRecognizer.delegate
                                                                              action:handelTransition];
        pan.delegate = self;
        [self.view addGestureRecognizer:pan];
        //禁用系统默认返回方式
        self.interactivePopGestureRecognizer.enabled = NO;
    } else {
        self.interactivePopGestureRecognizer.delegate = self;
        self.interactivePopGestureRecognizer.enabled = YES;
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    //非根控制器 和 WJVCPushNormalMode类型的页面
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    if (_allowFullPopGesture) {
        GYViewController *activeViewController = [GYCoordinatingMediator shareInstance].activeViewController;
        if (self.childViewControllers.count > 1
            && activeViewController.handleNavigationTransitionEnabled) {
            return YES;
        }
    } else {
        if (self.childViewControllers.count > 1) {
            return YES;
        }
    }
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    [super pushViewController:viewController animated:animated];
    if ([viewController isKindOfClass:[GYViewController class]] &&
        ![viewController isKindOfClass:[GYTabbarViewController class]]) {
        [[GYCoordinatingMediator shareInstance] didPushViewController:(GYViewController *)viewController];
    }
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ([viewController isKindOfClass:[GYViewController class]]) {
        [[GYCoordinatingMediator shareInstance] popToViewController:(GYViewController *)viewController];
    }
}

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    switch (operation) {
        case UINavigationControllerOperationPush:
            if ([toVC isKindOfClass:[GYViewController class]]) {
                return [self pushAnimationForVC:(GYViewController *)toVC];
            }
            break;
        case UINavigationControllerOperationPop:
            if ([fromVC isKindOfClass:[GYViewController class]]) {
                return [self popAnimationForVC:(GYViewController *)fromVC];
            }
            break;
        default:
            break;
    }
    return nil;
}

#pragma action
- (id<UIViewControllerAnimatedTransitioning>)pushAnimationForVC:(GYViewController *)viewController {
    NSAssert([viewController isKindOfClass:[GYViewController class]], @"!!!!!%@ pushAnimationMode?", [viewController class]);
    GYVCPushAnimationMode pushMode = viewController.preferredPushAnimationMode;
    switch (pushMode) {
        case GYVCPushPresentMode:
            return [GYViewControllerTransition gyVCTransitionWithType:GYVCPush];
            break;
        case GYVCPushGalleryMode:
            return [GYViewControllerTransition gyVCTransitionWithType:GYVCGalleryPush];
            break;
        case GYVCPushFadeMode:
            return [GYViewControllerTransition gyVCTransitionWithType:GYVCFadeIn];
            break;
        default:
            break;
    }
    return nil;
}

- (id<UIViewControllerAnimatedTransitioning>)popAnimationForVC:(GYViewController *)viewController {
    NSAssert([viewController isKindOfClass:[GYViewController class]], @"!!!!!%@ pushAnimationMode?", [viewController class]);
    GYVCPushAnimationMode pushMode = viewController.preferredPushAnimationMode;
    switch (pushMode) {
        case GYVCPushGalleryMode:
            return [GYViewControllerTransition gyVCTransitionWithType:GYVCGalleryPop];
            break;
        case GYVCPushPresentMode:
            return [GYViewControllerTransition gyVCTransitionWithType:GYVCPop];
            break;
        case GYVCPushFadeMode:
            return [GYViewControllerTransition gyVCTransitionWithType:GYVCFadeOut];
            break;
        default:
            break;
    }
    return nil;
}


@end
