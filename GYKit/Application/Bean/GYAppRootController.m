//
//  GYAppRootController.m
//  GYFramework
//
//  Created by GeYang on 2018/6/1.
//  Copyright © 2018年 GeYang. All rights reserved.
//

#import "GYAppRootController.h"
#import "GYViewControllerTransition.h"
#import "GYViewControllerTransition.h"

@interface GYAppRootController () <UINavigationControllerDelegate>

@end

@implementation GYAppRootController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBarHidden = YES;
    self.delegate = self;
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
                return [self popAnimationForVC:(GYViewController *)toVC];
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
