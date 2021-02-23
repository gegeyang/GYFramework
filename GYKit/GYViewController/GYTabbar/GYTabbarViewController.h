//
//  GYTabbarViewController.h
//  GYFramework
//
//  Created by GeYang on 2018/6/1.
//  Copyright © 2018年 GeYang. All rights reserved.
//

#import "GYViewController.h"

@interface GYTabbarViewController : GYViewController

@property (nonatomic, readonly) UIView *toolBar;

- (void)switchToHomePage:(NSDictionary *)params;
- (void)switchToViewController:(NSInteger)tag
                        params:(NSDictionary *)params;

@end
