//
//  GYRefreshErrorView.h
//  GYFramework
//
//  Created by GeYang on 2018/9/12.
//  Copyright © 2018年 GeYang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, GYFetchStatus) {
    GYFetchNone,
    GYFetchEmpty,
    GYFetchFailed,
    GYFetchTimeOutFailed,
    GYFetchNoInternetFailed,
    GYFetchOtherFailed,
};

@interface GYRefreshErrorView : UIView

@property (nonatomic, copy) GYVoidBlock retryBlock;
@property (nonatomic, strong) UIButton *btnAction;
@property (nonatomic, assign) GYFetchStatus status;
@property (nonatomic, assign) CGFloat ignoreTopInset;
@property (nonatomic, assign) CGFloat titleImageSpacing;
@property (nonatomic, assign) CGSize imageSize;

+ (instancetype)defaultErrorView;

- (void)setFetchStatus:(GYFetchStatus)status;
- (void)setErrorTitle:(NSString *)title forStatus:(GYFetchStatus)status;
- (void)setErrorInfo:(NSString *)info forStatus:(GYFetchStatus)status;
- (void)setErrorRetryEnable:(BOOL)enable forStatus:(GYFetchStatus)status;
- (void)setErrorActionEnable:(BOOL)enable forStatus:(GYFetchStatus)status;

@end
