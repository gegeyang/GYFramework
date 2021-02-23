//
//  GYRefreshFooter.h
//  GYFramework
//
//  Created by GeYang on 2018/9/12.
//  Copyright © 2018年 GeYang. All rights reserved.
//

#import "MJRefreshBackFooter.h"

@interface GYRefreshFooter : MJRefreshBackFooter

+ (GYRefreshFooter *)refreshFooterWithRefreshBlock:(MJRefreshComponentRefreshingBlock)refreshingBlock;

@end
