//
//  GYRefreshFooter.m
//  GYFramework
//
//  Created by GeYang on 2018/9/12.
//  Copyright © 2018年 GeYang. All rights reserved.
//

#import "GYRefreshFooter.h"

@interface GYRefreshFooter ()

@property (nonatomic, strong) UILabel *labelTitle;

@end

@implementation GYRefreshFooter

+ (GYRefreshFooter *)refreshFooterWithRefreshBlock:(MJRefreshComponentRefreshingBlock)refreshingBlock {
    GYRefreshFooter *refreshFooter = [[GYRefreshFooter alloc] init];
    if (refreshFooter) {
        refreshFooter.refreshingBlock = refreshingBlock;
    }
    return refreshFooter;
}

- (UILabel *)labelTitle {
    if (!_labelTitle) {
        _labelTitle = [[UILabel alloc] initWithFrame:self.bounds];
        _labelTitle.font = [UIFont gy_CNFontSizeS2];
        _labelTitle.textColor = [UIColor gy_color6];
        _labelTitle.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        _labelTitle.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_labelTitle];
    }
    return _labelTitle;
}

#pragma mark 监听控件的刷新状态
- (void)setState:(MJRefreshState)state {
    MJRefreshCheckState;
    switch (state) {
        case MJRefreshStateIdle:
            self.labelTitle.text = NSLocalizedString(@"上拉加载更多", nil);
            break;
        case MJRefreshStatePulling:
            self.labelTitle.text = NSLocalizedString(@"松开立即加载", nil);
            break;
        case MJRefreshStateRefreshing:
            self.labelTitle.text = NSLocalizedString(@"正在加载...", nil);
            break;
        case MJRefreshStateNoMoreData:
            self.labelTitle.text = NSLocalizedString(@"没有更多数据了", nil);
        default:
            break;
    }
}

@end
