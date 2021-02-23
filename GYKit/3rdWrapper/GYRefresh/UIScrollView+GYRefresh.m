//
//  UIScrollView+GYRefresh.m
//  GYFramework
//
//  Created by GeYang on 2018/9/12.
//  Copyright © 2018年 GeYang. All rights reserved.
//

#import "UIScrollView+GYRefresh.h"
#import "UIScrollView+MJRefresh.h"

@implementation UIScrollView (GYRefresh)

- (void)setGy_refreshHeader:(GYRefreshHeader *)gy_refreshHeader {
    self.mj_header = gy_refreshHeader;
}

- (GYRefreshHeader *)gy_refreshHeader {
    return (GYRefreshHeader *)self.mj_header;
}

- (void)setGy_refreshFooter:(GYRefreshFooter *)gy_refreshFooter {
    self.mj_footer = gy_refreshFooter;
}

- (GYRefreshFooter *)gy_refreshFooter {
    return (GYRefreshFooter *)self.mj_footer;
}

@end
