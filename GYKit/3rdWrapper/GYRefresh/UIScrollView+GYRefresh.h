//
//  UIScrollView+GYRefresh.h
//  GYFramework
//
//  Created by GeYang on 2018/9/12.
//  Copyright © 2018年 GeYang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYRefreshFooter.h"
#import "GYRefreshHeader.h"

@interface UIScrollView (GYRefresh)

@property (strong, nonatomic) GYRefreshHeader *gy_refreshHeader;
@property (strong, nonatomic) GYRefreshFooter *gy_refreshFooter;

@end
