//
//  GYRefreshErrorView.m
//  GYFramework
//
//  Created by GeYang on 2018/9/12.
//  Copyright © 2018年 GeYang. All rights reserved.
//

#import "GYRefreshErrorView.h"
#import "UIScrollView+GYRefresh.h"

#define GYKitFetchDataViewKeyPathContentInset     @"contentInset"

@interface GYRefreshErrorView ()

@property (nonatomic, strong) NSMutableArray *arrConstraints;
@property (nonatomic, strong) NSMutableDictionary *dictImage;
@property (nonatomic, strong) NSMutableDictionary *dictTitle;
@property (nonatomic, strong) NSMutableDictionary *dictInfo;
@property (nonatomic, strong) NSMutableDictionary *dictRetryEnable;
@property (nonatomic, strong) NSMutableDictionary *dictActionEnable;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *labelTitle;
@property (nonatomic, strong) UILabel *labelInfo;
@property (nonatomic, strong) UIButton *btnRetry;

- (void)setErrorDefault;
- (void)onRetryClicked:(id)sender;

@end

@implementation GYRefreshErrorView

+ (instancetype)defaultErrorView {
    GYRefreshErrorView *errorView = [[GYRefreshErrorView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    if (errorView) {
        [errorView setErrorDefault];
        [errorView setFetchStatus:GYFetchNone];
    }
    return errorView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _ignoreTopInset = 0;
        _titleImageSpacing = GYKIT_GENERAL_SPACING4;
        _imageSize = CGSizeMake(80, 80);
        self.imageView = [[UIImageView alloc] init];
        self.imageView.translatesAutoresizingMaskIntoConstraints = NO;
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:self.imageView];
        
        self.labelTitle = [[UILabel alloc] init];
        self.labelTitle.translatesAutoresizingMaskIntoConstraints = NO;
        self.labelTitle.textAlignment = NSTextAlignmentCenter;
        [self.labelTitle setNumberOfLines:3];
        self.labelTitle.font = [UIFont gy_CNFontSizeS2];
        self.labelTitle.textColor = [UIColor gy_color9];
        [self addSubview:self.labelTitle];
        
        self.labelInfo = [[UILabel alloc] init];
        self.labelInfo.translatesAutoresizingMaskIntoConstraints = NO;
        self.labelInfo.textAlignment = NSTextAlignmentCenter;
        [self.labelInfo setNumberOfLines:3];
        self.labelInfo.font = [UIFont gy_CNFontSizeS3];
        self.labelInfo.textColor = [UIColor gy_colorC];
        [self addSubview:self.labelInfo];
        
        self.btnRetry = [[UIButton alloc] initWithFrame:self.bounds];
        self.btnRetry.translatesAutoresizingMaskIntoConstraints = NO;
        [self.btnRetry addTarget:self action:@selector(onRetryClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.btnRetry];
        
        [self setupFixedContraints];
    }
    return self;
}

- (void)setFetchStatus:(GYFetchStatus)status {
    _status = status;
    switch (status) {
        case GYFetchNone: {
            self.hidden = YES;
        }
            break;
        case GYFetchEmpty:
        case GYFetchFailed:
        case GYFetchTimeOutFailed:
        case GYFetchNoInternetFailed:
        case GYFetchOtherFailed: {
            self.hidden = NO;
            self.btnRetry.enabled = self.retryBlock && [[self.dictRetryEnable objectForKey:@(status)] boolValue];
            self.btnAction.hidden = ![[self.dictActionEnable objectForKey:@(status)] boolValue];
            
            UIImage *curImage = [self.dictImage objectForKey:@(status)];
            self.imageView.image = curImage;
            self.imageView.hidden = curImage == nil;
            
            NSString *curTitle = [self.dictTitle objectForKey:@(status)];
            self.labelTitle.text = curTitle;
            self.labelTitle.hidden = curTitle == nil || curTitle.length == 0;
            
            NSString *curInfo = self.btnRetry.enabled ? NSLocalizedString(@"点击屏幕重试", nil) : [self.dictInfo objectForKey:@(status)];
            self.labelInfo.text = curInfo;
            self.labelInfo.hidden = curInfo == nil || curInfo.length == 0;
            
            [self setupConstraints];
            self.userInteractionEnabled = self.btnRetry.enabled || (self.btnAction && !self.btnAction.hidden);
        }
            break;
    }
}

- (void)onRetryClicked:(id)sender {
    if (self.retryBlock) {
        self.retryBlock();
    }
}

- (void)setErrorDefault {
    UIImage *imageFailed = [UIImage imageNamed:@"common_fetch_failed"];
    UIImage *imageEmpty = [UIImage imageNamed:@"common_fetch_empty"];
    UIImage *imageNetWorkError = [UIImage imageNamed:@"common_fetch_failed"];
    
    //请求成功，返回失败
    [self setErrorImage:imageFailed
              forStatus:GYFetchOtherFailed];
    
    //为空
    [self setErrorImage:imageEmpty
              forStatus:GYFetchEmpty];
    [self setErrorTitle:NSLocalizedString(@"没有相关内容", nil)
              forStatus:GYFetchEmpty];
    [self setErrorInfo:NSLocalizedString(@"", nil)
             forStatus:GYFetchEmpty];
    
    //网络连接失败
    [self setErrorTitle:NSLocalizedString(@"无法联接到网络", nil)
              forStatus:GYFetchNoInternetFailed];
    [self setErrorInfo:NSLocalizedString(@"请检查网络设置", nil)
             forStatus:GYFetchNoInternetFailed];
    [self setErrorImage:imageNetWorkError
              forStatus:GYFetchNoInternetFailed];
    [self setErrorRetryEnable:YES
                    forStatus:GYFetchNoInternetFailed];
    
    //网络超时
    [self setErrorTitle:NSLocalizedString(@"网络连接超时", nil)
              forStatus:GYFetchTimeOutFailed];
    [self setErrorInfo:NSLocalizedString(@"请检查网络设置", nil)
             forStatus:GYFetchTimeOutFailed];
    [self setErrorImage:imageNetWorkError
              forStatus:GYFetchTimeOutFailed];
    [self setErrorRetryEnable:YES
                    forStatus:GYFetchTimeOutFailed];
    
    //接口请求失败
    [self setErrorImage:imageFailed
              forStatus:GYFetchFailed];
    [self setErrorTitle:NSLocalizedString(@"数据加载失败", nil)
              forStatus:GYFetchFailed];
    [self setErrorInfo:NSLocalizedString(@"请稍后重试", nil)
             forStatus:GYFetchFailed];
    [self setErrorRetryEnable:YES
                    forStatus:GYFetchFailed];
}

- (void)setErrorImage:(UIImage *)image forStatus:(GYFetchStatus)status {
    if (image) {
        [self.dictImage setObject:image
                           forKey:@(status)];
    } else {
        [self.dictImage removeObjectForKey:@(status)];
    }
}

- (void)setErrorTitle:(NSString *)title forStatus:(GYFetchStatus)status {
    if (title && title.length > 0) {
        [self.dictTitle setObject:title
                           forKey:@(status)];
    } else {
        [self.dictTitle removeObjectForKey:@(status)];
    }
}

- (void)setErrorInfo:(NSString *)info forStatus:(GYFetchStatus)status {
    if (info && info.length > 0) {
        [self.dictInfo setObject:info
                          forKey:@(status)];
    } else {
        [self.dictInfo removeObjectForKey:@(status)];
    }
}

- (void)setErrorRetryEnable:(BOOL)enable forStatus:(GYFetchStatus)status {
    [self.dictRetryEnable setObject:@(enable) forKey:@(status)];
}

- (void)setErrorActionEnable:(BOOL)enable forStatus:(GYFetchStatus)status {
    [self.dictActionEnable setObject:@(enable) forKey:@(status)];
}

- (void)setupFixedContraints {
    NSMutableArray *arrConstraints = [NSMutableArray array];
    const CGFloat margin = GYKIT_GENERAL_SPACING1;
    NSAssert(_imageSize.width > 0 && _imageSize.height > 0, @"!!!!sizeForErrorImage is nil");
    [arrConstraints addObject:[NSLayoutConstraint constraintWithItem:self.imageView
                                                           attribute:NSLayoutAttributeWidth
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:nil
                                                           attribute:NSLayoutAttributeNotAnAttribute
                                                          multiplier:1.0
                                                            constant:_imageSize.width]];
    [arrConstraints addObject:[NSLayoutConstraint constraintWithItem:self.imageView
                                                           attribute:NSLayoutAttributeHeight
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:nil
                                                           attribute:NSLayoutAttributeNotAnAttribute
                                                          multiplier:1.0
                                                            constant:_imageSize.height]];
    [arrConstraints addObject:[NSLayoutConstraint constraintWithItem:self.imageView
                                                           attribute:NSLayoutAttributeCenterX
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:self
                                                           attribute:NSLayoutAttributeCenterX
                                                          multiplier:1.0
                                                            constant:0]];
    
    [arrConstraints addObject:[NSLayoutConstraint constraintWithItem:self.labelTitle
                                                           attribute:NSLayoutAttributeLeft
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:self
                                                           attribute:NSLayoutAttributeLeft
                                                          multiplier:1.0
                                                            constant:margin]];
    [arrConstraints addObject:[NSLayoutConstraint constraintWithItem:self.labelTitle
                                                           attribute:NSLayoutAttributeRight
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:self
                                                           attribute:NSLayoutAttributeRight
                                                          multiplier:1.0
                                                            constant:-margin]];
    
    [arrConstraints addObject:[NSLayoutConstraint constraintWithItem:self.labelInfo
                                                           attribute:NSLayoutAttributeLeft
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:self
                                                           attribute:NSLayoutAttributeLeft
                                                          multiplier:1.0
                                                            constant:margin]];
    [arrConstraints addObject:[NSLayoutConstraint constraintWithItem:self.labelInfo
                                                           attribute:NSLayoutAttributeRight
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:self
                                                           attribute:NSLayoutAttributeRight
                                                          multiplier:1.0
                                                            constant:-margin]];
    
    [arrConstraints addObject:[NSLayoutConstraint constraintWithItem:self.btnRetry
                                                           attribute:NSLayoutAttributeLeft
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:self
                                                           attribute:NSLayoutAttributeLeft
                                                          multiplier:1.0
                                                            constant:0]];
    [arrConstraints addObject:[NSLayoutConstraint constraintWithItem:self.btnRetry
                                                           attribute:NSLayoutAttributeRight
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:self
                                                           attribute:NSLayoutAttributeRight
                                                          multiplier:1.0
                                                            constant:0]];
    [arrConstraints addObject:[NSLayoutConstraint constraintWithItem:self.btnRetry
                                                           attribute:NSLayoutAttributeTop
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:self
                                                           attribute:NSLayoutAttributeTop
                                                          multiplier:1.0
                                                            constant:0]];
    [arrConstraints addObject:[NSLayoutConstraint constraintWithItem:self.btnRetry
                                                           attribute:NSLayoutAttributeBottom
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:self
                                                           attribute:NSLayoutAttributeBottom
                                                          multiplier:1.0
                                                            constant:0]];
    [self addConstraints:arrConstraints];
}

- (void)setupConstraints {
    [self removeConstraints:self.arrConstraints];
    [self.arrConstraints removeAllObjects];
    
    const CGFloat margin = GYKIT_GENERAL_H_MARGIN;
    const CGFloat spacing1 = _titleImageSpacing;
    const CGFloat spacing2 = spacing1 - 2;
    const CGFloat allWidth = self.gy_width - margin * 2;
    const CGFloat allHeight = self.gy_height;
    const BOOL showImage = !self.imageView.hidden;
    const BOOL showTitle = !self.labelTitle.hidden;
    const BOOL showInfo = !self.labelInfo.hidden;
    const BOOL showAction = self.btnAction && !self.btnAction.hidden;
    
    const CGFloat titleHeight = showTitle ? ceilf([self.labelTitle textRectForBounds:CGRectMake(0, 0, allWidth, allHeight) limitedToNumberOfLines:0].size.height) : 0;
    const CGFloat infoHeight = showInfo ? ceilf([self.labelInfo textRectForBounds:CGRectMake(0, 0, allWidth, allHeight)
                                                           limitedToNumberOfLines:0].size.height) : 0;
    const CGFloat actionHeight = showAction ? self.btnAction.gy_height : 0;
    
    if (showImage) {
        [self.arrConstraints addObject:[NSLayoutConstraint constraintWithItem:self.imageView
                                                                    attribute:NSLayoutAttributeCenterY
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self
                                                                    attribute:NSLayoutAttributeCenterY
                                                                   multiplier:1.0
                                                                     constant:-(titleHeight + infoHeight) - _ignoreTopInset]];
    }
    
    if (showTitle) {
        if (showImage) {
            [self.arrConstraints addObject:[NSLayoutConstraint constraintWithItem:self.labelTitle
                                                                        attribute:NSLayoutAttributeTop
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.imageView
                                                                        attribute:NSLayoutAttributeBottom
                                                                       multiplier:1.0
                                                                         constant:spacing1]];
        } else {
            [self.arrConstraints addObject:[NSLayoutConstraint constraintWithItem:self.labelTitle
                                                                        attribute:NSLayoutAttributeCenterY
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self
                                                                        attribute:NSLayoutAttributeCenterY
                                                                       multiplier:1.0
                                                                         constant:-infoHeight]];
        }
    }
    
    if (showInfo) {
        if (showTitle) {
            [self.arrConstraints addObject:[NSLayoutConstraint constraintWithItem:self.labelInfo
                                                                        attribute:NSLayoutAttributeTop
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.labelTitle
                                                                        attribute:NSLayoutAttributeBottom
                                                                       multiplier:1.0
                                                                         constant:spacing2]];
        } else if (showImage) {
            [self.arrConstraints addObject:[NSLayoutConstraint constraintWithItem:self.labelInfo
                                                                        attribute:NSLayoutAttributeTop
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.imageView
                                                                        attribute:NSLayoutAttributeBottom
                                                                       multiplier:1.0
                                                                         constant:spacing1]];
        } else {
            [self.arrConstraints addObject:[NSLayoutConstraint constraintWithItem:self.labelInfo
                                                                        attribute:NSLayoutAttributeCenterY
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self
                                                                        attribute:NSLayoutAttributeCenterY
                                                                       multiplier:1.0
                                                                         constant:-actionHeight]];
        }
    }
    
    if (showAction) {
        self.btnAction.translatesAutoresizingMaskIntoConstraints = NO;
        [self.arrConstraints addObject:[NSLayoutConstraint constraintWithItem:self.btnAction
                                                                    attribute:NSLayoutAttributeWidth
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:nil
                                                                    attribute:NSLayoutAttributeNotAnAttribute
                                                                   multiplier:1.0
                                                                     constant:self.btnAction.gy_width]];
        [self.arrConstraints addObject:[NSLayoutConstraint constraintWithItem:self.btnAction
                                                                    attribute:NSLayoutAttributeHeight
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:nil
                                                                    attribute:NSLayoutAttributeNotAnAttribute
                                                                   multiplier:1.0
                                                                     constant:self.btnAction.gy_height]];
        [self.arrConstraints addObject:[NSLayoutConstraint constraintWithItem:self.btnAction
                                                                    attribute:NSLayoutAttributeCenterX
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self
                                                                    attribute:NSLayoutAttributeCenterX
                                                                   multiplier:1.0
                                                                     constant:0]];
        if (showInfo) {
            [self.arrConstraints addObject:[NSLayoutConstraint constraintWithItem:self.btnAction
                                                                        attribute:NSLayoutAttributeTop
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.labelInfo
                                                                        attribute:NSLayoutAttributeBottom
                                                                       multiplier:1.0
                                                                         constant:spacing2]];
        } else if (showTitle) {
            [self.arrConstraints addObject:[NSLayoutConstraint constraintWithItem:self.btnAction
                                                                        attribute:NSLayoutAttributeTop
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.labelTitle
                                                                        attribute:NSLayoutAttributeBottom
                                                                       multiplier:1.0
                                                                         constant:spacing2]];
        } else if (showImage) {
            [self.arrConstraints addObject:[NSLayoutConstraint constraintWithItem:self.btnAction
                                                                        attribute:NSLayoutAttributeTop
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.imageView
                                                                        attribute:NSLayoutAttributeBottom
                                                                       multiplier:1.0
                                                                         constant:spacing1]];
        } else {
            [self.arrConstraints addObject:[NSLayoutConstraint constraintWithItem:self.btnAction
                                                                        attribute:NSLayoutAttributeCenterY
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self
                                                                        attribute:NSLayoutAttributeCenterY
                                                                       multiplier:1.0
                                                                         constant:0]];
        }
        [self addSubview:self.btnAction];
    }
    
    [self addConstraints:self.arrConstraints];
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    [self removeObservers];
    if (newSuperview == nil) {
        return;
    }
    if ([newSuperview isKindOfClass:[UIScrollView class]]) {
        UIScrollView *scrollView = (UIScrollView *)newSuperview;
        [self addObservers:scrollView];
        UIEdgeInsets insets = scrollView.contentInset;
        self.frame = CGRectMake(0,
                                0,
                                scrollView.gy_width - insets.left - insets.right,
                                scrollView.gy_height - insets.top - insets.bottom);
    } else {
        self.frame = newSuperview.bounds;
    }
}

#pragma mark - KVO监听
- (void)addObservers:(UIScrollView *)scrollView {
    NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
    [scrollView addObserver:self forKeyPath:GYKitFetchDataViewKeyPathContentInset options:options context:nil];
}

- (void)removeObservers {
    if ([self.superview isKindOfClass:[UIScrollView class]]) {
        [self.superview removeObserver:self forKeyPath:GYKitFetchDataViewKeyPathContentInset];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (self.isHidden) {
        return;
    }
    if ([keyPath isEqualToString:GYKitFetchDataViewKeyPathContentInset]) {
        UIScrollView *scrollView = (UIScrollView *)self.superview;
        if ([scrollView.gy_refreshHeader isRefreshing]) {
            return;
        }
        UIEdgeInsets insets = [[change objectForKey:NSKeyValueChangeNewKey] UIEdgeInsetsValue];
        self.frame = CGRectMake(0,
                                0,
                                scrollView.gy_width - insets.left - insets.right,
                                scrollView.gy_height - insets.top - insets.bottom);
    }
}

#pragma mark - getter and setter
- (NSMutableArray *)arrConstraints {
    if (!_arrConstraints) {
        _arrConstraints = [NSMutableArray array];
    }
    return _arrConstraints;
}

- (NSMutableDictionary *)dictImage {
    if (!_dictImage) {
        _dictImage = [NSMutableDictionary dictionary];
    }
    return _dictImage;
}

- (NSMutableDictionary *)dictTitle {
    if (!_dictTitle) {
        _dictTitle = [NSMutableDictionary dictionary];
    }
    return _dictTitle;
}

- (NSMutableDictionary *)dictInfo {
    if (!_dictInfo) {
        _dictInfo = [NSMutableDictionary dictionary];
    }
    return _dictInfo;
}

- (NSMutableDictionary *)dictRetryEnable {
    if (!_dictRetryEnable) {
        _dictRetryEnable = [NSMutableDictionary dictionary];
    }
    return _dictRetryEnable;
}

- (NSMutableDictionary *)dictActionEnable {
    if (!_dictActionEnable) {
        _dictActionEnable = [NSMutableDictionary dictionary];
    }
    return _dictActionEnable;
}
@end
