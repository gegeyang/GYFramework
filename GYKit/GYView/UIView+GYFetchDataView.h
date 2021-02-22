//
//  UIView+GYFetchDataView.h
//  GYFramework
//
//  Created by GeYang on 2018/9/12.
//  Copyright © 2018年 GeYang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GYRefreshErrorView;
@interface UIView (GYFetchDataView)

@property (nonatomic, strong) GYRefreshErrorView *errorView;

- (void)gy_showErrorView:(NSError *)error;
- (void)gy_showEmptyErrorView;
- (void)gy_hideErrorView;
- (void)gy_setDefaultErrorView;
- (void)gy_setDefaultErrorViewWithRetryBlock:(GYVoidBlock)retryBlock;

@end
