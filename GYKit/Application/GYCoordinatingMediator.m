//
//  GYCoordinatingMediator.m
//  GYFramework
//
//  Created by GeYang on 2018/6/1.
//  Copyright © 2018年 GeYang. All rights reserved.
//

#import "GYCoordinatingMediator.h"
#import "GYTabbarViewController.h"
#import "GYAppRootController.h"
#import "NewViewController.h"

@interface GYCoordinatingMediator()

@property (nonatomic, strong) GYAppRootController *appRootController;
@property (nonatomic, strong) GYTabbarViewController *tabbarViewController;

@end

@implementation GYCoordinatingMediator

+ (GYCoordinatingMediator *)shareInstance {
    static GYCoordinatingMediator *s_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_instance = [[GYCoordinatingMediator alloc] init];
        s_instance.tabbarViewController = [[GYTabbarViewController alloc] init];
        s_instance.appRootController = [[GYAppRootController alloc] initWithRootViewController:s_instance.tabbarViewController];
        s_instance.activeViewController = s_instance.tabbarViewController;
        [s_instance.tabbarViewController switchToHomePage:nil];
    });
    return s_instance;
}

- (void)didPushViewController:(GYViewController *)aViewController {
    _activeViewController = aViewController;
}

- (void)popToViewController:(GYViewController *)toViewController {
    _activeViewController = toViewController;
}

- (BOOL)requestWithTag:(NSInteger)tag
                params:(NSDictionary *)params {
    switch (tag) {
        case GYCoordinatingControllerTagNew:
            [self.appRootController  pushViewController:[[NewViewController alloc] init] animated:YES];
            break;
        default:
            if (self.activeViewController != self.tabbarViewController) {
                [self.appRootController popToRootViewControllerAnimated:YES];
            }
            [self.tabbarViewController switchToViewController:tag params:params];
            self.activeViewController = self.tabbarViewController;
            return YES;
            break;
    }
    return NO;
}

@end
