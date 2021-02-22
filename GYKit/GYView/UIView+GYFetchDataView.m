//
//  UIView+GYFetchDataView.m
//  GYFramework
//
//  Created by GeYang on 2018/9/12.
//  Copyright © 2018年 GeYang. All rights reserved.
//

#import "UIView+GYFetchDataView.h"
#import "GYRefreshErrorView.h"
#import <objc/runtime.h>
#import "NSError+GYExtend.h"
#import "UIScrollView+GYRefresh.h"

static char kErrorViewkey;
@implementation UIView (GYFetchDataView)

- (void)setErrorView:(GYRefreshErrorView *)errorView {
    if (errorView != self.errorView) {
        [self.errorView removeFromSuperview];
        
        [self willChangeValueForKey:@"dictImage"];
        objc_setAssociatedObject(self, &kErrorViewkey, errorView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self didChangeValueForKey:@"dictImage"];
        
        self.errorView.frame = self.bounds;
        self.errorView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:self.errorView];
    }
}

- (GYRefreshErrorView *)errorView {
    return objc_getAssociatedObject(self, &kErrorViewkey);
}

- (void)gy_hideErrorView {
    [self setFetchStatus:GYFetchNone error:nil];
}

- (void)gy_showEmptyErrorView {
    [self setFetchStatus:GYFetchEmpty error:nil];
}

- (void)gy_showErrorView:(NSError *)error {
    [self setFetchStatus:GYFetchFailed error:error];
}

- (void)setFetchStatus:(GYFetchStatus)status error:(NSError *)error {
    GYFetchStatus newStatus = status;
    if ((status == GYFetchFailed) && error) {
        if ([error gy_isNotConnectedToInternet]) {
            newStatus = GYFetchNoInternetFailed;
        } else if ([error gy_isTimeOut]) {
            newStatus = GYFetchTimeOutFailed;
        } else if ([error gy_isResponseError] && error.localizedDescription) {
            newStatus = GYFetchOtherFailed;
            [self.errorView setErrorTitle:error.localizedDescription
                                forStatus:newStatus];
            [self.errorView setErrorInfo:nil
                               forStatus:newStatus];
        }
    }
    [self.errorView setFetchStatus:newStatus];
}

- (void)gy_setDefaultErrorView {
    self.errorView = [GYRefreshErrorView defaultErrorView];
    if ([self isKindOfClass:[UIScrollView class]]) {
        __weak UIScrollView *weakScrollView = (UIScrollView *)self;
        self.errorView.retryBlock = ^{
            [weakScrollView.gy_refreshHeader beginRefreshing];
        };
    }
}

- (void)gy_setDefaultErrorViewWithRetryBlock:(GYVoidBlock)retryBlock{
    self.errorView = [GYRefreshErrorView defaultErrorView];
    self.errorView.retryBlock = retryBlock;
}

@end
