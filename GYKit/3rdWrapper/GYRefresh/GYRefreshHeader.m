//
//  GYRefreshHeader.m
//  GYFramework
//
//  Created by GeYang on 2018/9/12.
//  Copyright © 2018年 GeYang. All rights reserved.
//

#import "GYRefreshHeader.h"

@interface GYRefreshHeader ()

@property (nonatomic, strong) UILabel *labelTitle;
@property (nonatomic, strong) UIImageView *viewRefresh;

#define GYKIT_REFRESH_IMAGE_SIZE    CGSizeMake(20, 20)

@end

@implementation GYRefreshHeader

+ (GYRefreshHeader *)refreshHeaderWithRefreshBlock:(MJRefreshComponentRefreshingBlock)refreshingBlock {
    GYRefreshHeader *refreshHeader = [[GYRefreshHeader alloc] init];
    if (refreshHeader) {
        UIImage *image = [UIImage imageNamed:@"common_refresh_loading"];
        [refreshHeader setAnimationImage:image];
        refreshHeader.refreshingBlock = refreshingBlock;
    }
    return refreshHeader;
}

- (UIImageView *)viewRefresh {
    if (!_viewRefresh) {
        const CGSize imageSize = GYKIT_REFRESH_IMAGE_SIZE;
        const CGFloat allWidth = CGRectGetWidth(self.bounds);
        const CGFloat allHeight = CGRectGetHeight(self.bounds);
        _viewRefresh = [[UIImageView alloc] initWithFrame:CGRectMake(roundf((allWidth - imageSize.width) / 2),
                                                                     roundf(allHeight / 2) - imageSize.height,
                                                                     imageSize.width,
                                                                     imageSize.height)];
        _viewRefresh.contentMode = UIViewContentModeScaleToFill;
        _viewRefresh.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        _viewRefresh.animationDuration = 0.2;
        [self addSubview:_viewRefresh];
    }
    return _viewRefresh;
}

- (UILabel *)labelTitle {
    if (!_labelTitle) {
        const CGFloat allWidth = CGRectGetWidth(self.bounds);
        const CGFloat allHeight = CGRectGetHeight(self.bounds);
        const CGFloat topMargin = roundf(allHeight / 2);
        _labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, topMargin, allWidth, allHeight - topMargin)];
        _labelTitle.font = [UIFont gy_CNFontSizeS2];
        _labelTitle.textColor = [UIColor gy_color6];
        _labelTitle.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
        _labelTitle.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_labelTitle];
    }
    return _labelTitle;
}

#pragma mark 在这里设置子控件的位置和尺寸
- (void)placeSubviews {
    [super placeSubviews];
    const CGSize imageSize = GYKIT_REFRESH_IMAGE_SIZE;
    const CGFloat allWidth = CGRectGetWidth(self.bounds);
    const CGFloat allHeight = CGRectGetHeight(self.bounds);
    
    self.viewRefresh.frame = CGRectMake(roundf((allWidth - imageSize.width) / 2),
                                        roundf(allHeight / 2) - imageSize.height,
                                        imageSize.width,
                                        imageSize.height);
    
    const CGFloat topMargin = roundf(allHeight / 2);
    self.labelTitle.frame = CGRectMake(0, topMargin, allWidth, allHeight - topMargin);
}

- (void)setAnimationImage:(UIImage *)animationImage {
    self.viewRefresh.image = animationImage;
}

#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state {
    MJRefreshCheckState;
    switch (state) {
        case MJRefreshStateIdle:
            [self.viewRefresh stopAnimating];
            self.labelTitle.text = NSLocalizedString(@"下拉可以刷新", nil);
            break;
        case MJRefreshStatePulling:
            [self.viewRefresh stopAnimating];
            self.labelTitle.text = NSLocalizedString(@"松开立即刷新", nil);
            break;
        case MJRefreshStateRefreshing:
            self.labelTitle.text = NSLocalizedString(@"正在刷新...", nil);
            [self didAnimation];
            break;
        default:
            break;
    }
}

- (void)didAnimation {
    if ([self isRefreshing]) {
        __weak typeof(self) weakself = self;
        [UIView animateWithDuration:0.1
                         animations:^{
                             weakself.viewRefresh.transform = CGAffineTransformRotate(self.viewRefresh.transform, M_PI / 2);
                         }
                         completion:^(BOOL finished) {
                             [weakself didAnimation];
                         }];
    }
}

@end
