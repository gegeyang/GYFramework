//
//  GYCoordinatingMediator.h
//  GYFramework
//
//  Created by GeYang on 2018/6/1.
//  Copyright © 2018年 GeYang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class GYAppRootController;
@class GYViewController;
@class GYTabbarViewController;

@interface GYCoordinatingMediator : NSObject

@property (nonatomic, readonly) GYAppRootController *appRootController;
@property (nonatomic, readonly) GYTabbarViewController *tabbarViewController;
@property (nonatomic, weak) GYViewController *activeViewController;

+ (GYCoordinatingMediator *)shareInstance;
- (void)didPushViewController:(GYViewController *)aViewController;
- (void)popToViewController:(GYViewController *)toViewController;
- (BOOL)requestWithTag:(NSInteger)tag
                params:(NSDictionary *)params;

@end
