//
//  GYViewController+GYNavBarExtend.m
//  GYFramework
//
//  Created by GeYang on 2018/7/12.
//  Copyright © 2018年 GeYang. All rights reserved.
//

#import "GYViewController+GYNavBarExtend.h"

@implementation GYViewController (GYNavBarExtend)

- (void)gy_initNavBackButton {
    
}

- (void)gy_onBackClicked:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
