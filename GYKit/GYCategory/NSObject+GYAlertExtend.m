//
//  NSObject+GYAlertExtend.m
//  GYFramework
//
//  Created by Yang Ge on 2021/3/23.
//  Copyright © 2021 GeYang. All rights reserved.
//

#import "NSObject+GYAlertExtend.h"

static GYAlertController *s_alertVC = nil;
static UIButton *s_maskView = nil;

@implementation NSObject (GYAlertExtend)
- (void)gy_alertWithTitle:(NSString *)title
                  message:(NSString *)message
               alertStyle:(GYAlertControllerStyle)alertStyle
             cancelAction:(GYAlertAction *)cancelAction
             otherAction:(GYAlertAction *)otherAction, ...NS_REQUIRES_NIL_TERMINATION {
    NSMutableArray *otherActions = [NSMutableArray array];
    GYAlertAction *eachItem;
    va_list argumentList;
    if (otherAction) {
        [otherActions addObject:otherAction];
        va_start(argumentList, otherAction);
        while((eachItem = va_arg(argumentList, GYAlertAction *))) {
            [otherActions addObject:eachItem];
        }
        va_end(argumentList);
    }
    [self gy_alertWithAttributedTitle:[NSAttributedString gy_alert_attributedString:title
                                                                            message:message]
                           alertStyle:alertStyle
                         cancelAction:cancelAction
                         otherActions:otherActions
                               inView:nil];
}

- (void)gy_alertWithAttributedTitle:(NSAttributedString *)attributedTitle
                         alertStyle:(GYAlertControllerStyle)alertStyle
                       cancelAction:(GYAlertAction *)cancelAction
                       otherActions:(NSArray<GYAlertAction *> *)otherActions
                             inView:(UIView *)inView {
    [s_maskView.layer removeAllAnimations];
    [s_alertVC.view.layer removeAllAnimations];
    [self gy_alert_hideAlert];
    GYAlertController *alertController = [GYAlertController alertControllerWithAttributedTitle:attributedTitle
                                                                                preferredStyle:alertStyle];
    if (cancelAction) {
        [alertController addCancelAction:cancelAction];
    }
    [alertController addOtherActions:otherActions];
    s_alertVC = alertController;
    UIView *fromView = inView ?: [UIApplication sharedApplication].keyWindow;
    s_maskView = [[UIButton alloc] initWithFrame:fromView.bounds];
    s_maskView.backgroundColor = [UIColor gy_colorWithRGB:0x000000 alpha:0.4];
    if (alertStyle == GYAlertControllerStyleActionSheet) {
        [s_maskView addTarget:self
                       action:@selector(gy_alert_maskClicked:)
             forControlEvents:UIControlEventTouchUpInside];
    }
    s_maskView.alpha = 0;
    [fromView addSubview:s_maskView];
    
    switch (alertStyle) {
        case GYAlertControllerStyleActionSheet: {
            const CGFloat width = fromView.gy_width;
            const CGFloat height = MIN(fromView.gy_height, [alertController calcAllHeight:width]);
            
            s_alertVC.view.frame = CGRectMake(0, fromView.gy_height, width, height);
            [fromView addSubview:s_alertVC.view];
            
            [UIView animateWithDuration:0.3 animations:^{
                s_maskView.alpha = 1;
                s_alertVC.view.frame = CGRectMake(0, fromView.gy_height - height, width, height);
            } completion:^(BOOL finished) {
                
            }];
        }
            break;
        case GYAlertControllerStyleAlert: {
            const CGFloat width = MIN(roundf(fromView.gy_width * 0.7), 270);
            const CGFloat height = MIN(fromView.gy_height - 100, [alertController calcAllHeight:width]);
            
            s_alertVC.view.frame = CGRectMake(roundf((fromView.gy_width - width) * 0.5),
                                              roundf((fromView.gy_height - height) * 0.5),
                                              width,
                                              height);
           
            s_alertVC.view.layer.masksToBounds = YES;
            s_alertVC.view.layer.cornerRadius = 10;
            [fromView addSubview:s_alertVC.view];
            s_alertVC.view.transform = CGAffineTransformMakeScale(1, 1);
            
            [UIView animateWithDuration:0.3 animations:^{
                s_maskView.alpha = 1;
                s_alertVC.view.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                
            }];
        }
            break;
    }
}

- (void)gy_hideAlertController {
    [self gy_hideAlertController:YES];
}

- (void)gy_hideAlertController:(BOOL)animated {
    if (animated) {
        switch (s_alertVC.preferredStyle) {
            case GYAlertControllerStyleActionSheet: {
                [UIView animateWithDuration:0.3 animations:^{
                    s_maskView.alpha = 0;
                    s_alertVC.view.gy_y0 = s_alertVC.view.superview.gy_height;
                } completion:^(BOOL finished) {
                    if (finished) {
                        [self gy_alert_hideAlert];
                    }
                }];
            }
                break;
            case GYAlertControllerStyleAlert: {
                [UIView animateWithDuration:0.3 animations:^{
                    s_maskView.alpha = 0;
                    s_alertVC.view.alpha = 0;
                } completion:^(BOOL finished) {
                    if (finished) {
                        [self gy_alert_hideAlert];
                    }
                }];
            }
                break;
        }
    } else {
        [self gy_alert_hideAlert];
    }
}

- (void)gy_alert_hideAlert {
    [s_maskView removeFromSuperview];
    s_maskView = nil;
    [s_alertVC.view removeFromSuperview];
    s_alertVC = nil;
}

- (void)gy_alert_maskClicked:(UIButton *)sender {
    [self gy_hideAlertController];
}

- (void)gy_alertWithTitle:(NSString * _Nullable)title
                  message:(NSString * _Nullable)message
             cancelEnable:(BOOL)cancelEnable
            confirmAction:(GYAlertAction * _Nonnull)confirmAction {
    [self gy_alertWithTitle:title
                    message:message
                 alertStyle:GYAlertControllerStyleAlert
               cancelAction:(cancelEnable ? [GYAlertAction cancelAction] : nil)
                otherAction:confirmAction, nil];
}
@end

