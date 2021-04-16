//
//  GYViewControllerTransition.m
//  GYFramework
//
//  Created by GeYang on 2018/7/12.
//  Copyright © 2018年 GeYang. All rights reserved.
//

#import "GYViewControllerTransition.h"
#import "GYGalleryAnimationDelegate.h"
#import "GYCoordinatingMediator.h"

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

#pragma mark - GYVCPushNormalMode转场动画
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

#pragma mark - GYVCPushGalleryMode转场动画
- (void)doGalleryPushAnimation:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIView *containerView = [transitionContext containerView];
    GYViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    GYViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    NSAssert([toVC conformsToProtocol:@protocol(GYGalleryAnimationDelegate)], @"!!!!%@ must conformsToProtocol GYGalleryAnimationDelegate", toVC);
    id<GYGalleryAnimationDelegate> animationDelegate = (id)toVC;
    UIView *collectionView = [toVC valueForKeyPath:@"collectionView"];
    //获取点击的图片
    UIImage *galleryImage = animationDelegate.galleryImage;
    if (!galleryImage) {
        galleryImage = [UIImage imageNamed:@"common_image_normal"];
    }
    //获取当前图片的frame
    const CGRect fromRect = [animationDelegate galleryConvertFrameToView:fromVC.view];
    UIImageView *tempView = [[UIImageView alloc] init];
    tempView.image = galleryImage;
    
    const CGSize boundsSize = toVC.view.bounds.size;
    CGSize imageSize = galleryImage ? galleryImage.size : boundsSize;
    //获取图片与目标控制器的最大缩放比
    CGFloat rate = MAX(imageSize.width / boundsSize.width, imageSize.height / boundsSize.height);
    CGRect rcTarget; //进入gallery后的正常图片位置。
    rcTarget.size.width = roundf(imageSize.width / rate);
    rcTarget.size.height = roundf(imageSize.height / rate);
    rcTarget.origin.x = roundf((boundsSize.width - rcTarget.size.width) / 2);
    rcTarget.origin.y = roundf((boundsSize.height - rcTarget.size.height) / 2);
    tempView.frame = CGRectIsNull(fromRect) ? rcTarget : fromRect;
    
    toVC.view.alpha = 0;
    collectionView.hidden = YES;
    [containerView addSubview:toVC.view];
    [containerView addSubview:tempView];
    //开始动画
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                     animations:^{
        tempView.frame = rcTarget;
        toVC.view.alpha = 1;
    } completion:^(BOOL finished) {
        collectionView.hidden = NO;
        [tempView removeFromSuperview];
        //如果动画过渡取消了就标记不完成，否则才完成，这里可以直接写YES，如果有手势过渡才需要判断，必须标记，否则系统不会中动画完成的部署，会出现无法交互之类的bug
        [transitionContext completeTransition:YES];
    }];
}

- (void)doGalleryPopAnimation:(id<UIViewControllerContextTransitioning>)transitionContext {
    UIView *containerView = [transitionContext containerView];
    GYViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    GYViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    NSAssert([fromVC conformsToProtocol:@protocol(GYGalleryAnimationDelegate)], @"!!!!%@ must conformsToProtocol GYGalleryAnimationDelegate", fromVC);
    id<GYGalleryAnimationDelegate> animationDelegate = (id)fromVC;
    UIView *collectionView = [fromVC valueForKeyPath:@"collectionView"];
    //获取当前gallery页面展示的图片
    UIImageView *tempView = [[UIImageView alloc] initWithImage:animationDelegate.galleryImage];
    tempView.contentMode = UIViewContentModeScaleAspectFill;
    //获取转换到window上的frame
    tempView.frame = animationDelegate.galleryImageViewFrameToWindow;
    collectionView.hidden = YES;
    //将列表生成一张快照。动画结束后[tempToView removeFromSuperview]移除的是快照。
    UIView *tempToView = [toVC.view snapshotViewAfterScreenUpdates:NO];
    [containerView insertSubview:tempToView atIndex:0];
    [containerView insertSubview:toVC.view atIndex:0];
    [containerView addSubview:tempView];
    //获取列表上当前图片的位置。 [GYCoordinatingMediator shareInstance].tabbarViewController.view
    CGRect toFrame = [animationDelegate galleryConvertFrameToView:toVC.view];
    if (CGRectIsNull(toFrame)) {
        toFrame = tempView.frame;
    }
    [UIView animateWithDuration:[self transitionDuration:transitionContext]
                     animations:^{
        tempView.frame = toFrame;
        fromVC.view.alpha = 0;
    } completion:^(BOOL finished) {
        //由于加入了手势必须判断
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        [tempView removeFromSuperview];
        [tempToView removeFromSuperview];
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
        case GYVCGalleryPush:
            [self doGalleryPushAnimation:transitionContext];
            break;
        case GYVCGalleryPop:
            [self doGalleryPopAnimation:transitionContext];
            break;
        default:
            break;
    }
}
@end
