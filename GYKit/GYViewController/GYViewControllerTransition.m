//
//  GYViewControllerTransition.m
//  GYFramework
//
//  Created by GeYang on 2018/7/12.
//  Copyright © 2018年 GeYang. All rights reserved.
//

#import "GYViewControllerTransition.h"

@interface GYViewControllerTransition ()

@property (nonatomic, assign) GYVCTransitionType transitionType;

- (instancetype)initWithVCTransitionType:(GYVCTransitionType)type;

@end

@implementation GYViewControllerTransition

+ (instancetype)gyVCTransitionWithType:(GYVCTransitionType)type {
    return [[GYViewControllerTransition alloc] initWithVCTransitionType:type];
}

- (instancetype)initWithVCTransitionType:(GYVCTransitionType)type {
    if (self = [super init]) {
        _transitionType = type;
    }
    return self;
}

- (void)doPushAnimation:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIView *containerView = [transitionContext containerView];
    GYViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    GYViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    [containerView insertSubview:toVC.view aboveSubview:fromVC.view];
    
    toVC.view.frame = CGRectMake(fromVC.view.gy_x0, fromVC.view.gy_y1, fromVC.view.gy_width, fromVC.view.gy_height);
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        fromVC.view.frame = CGRectMake(toVC.view.gy_x0, toVC.view.gy_y1, toVC.view.gy_width, toVC.view.gy_height);
    } completion:^(BOOL finished) {
        toVC.navigationController.interactivePopGestureRecognizer.enabled = NO;
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

- (void)doPopAnimation:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIView *containerView = [transitionContext containerView];
    GYViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    GYViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    [containerView insertSubview:toVC.view belowSubview:fromVC.view];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        fromVC.view.frame = CGRectMake(toVC.view.gy_x0, toVC.view.gy_y1, toVC.view.gy_width, toVC.view.gy_height);
    } completion:^(BOOL finished) {
        toVC.navigationController.interactivePopGestureRecognizer.enabled = NO;
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
    }];
}

#pragma mark - UIViewControllerAnimatedTransitioning
- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.3;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    switch (_transitionType) {
        case GYVCPush:
            [self doPushAnimation:transitionContext];
            break;
        case GYVCPop:
            [self doPopAnimation:transitionContext];
            break;
        default:
            break;
    }
}
@end
