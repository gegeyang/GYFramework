//
//  GYFetchListModel.h
//  GYFramework
//
//  Created by GeYang on 2018/9/12.
//  Copyright © 2018年 GeYang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GYListViewDataSource.h"
#import "GYListViewDelegate.h"

@interface GYFetchListModel : NSObject <GYListViewDataSource>

@property (nonatomic, readonly) NSInteger currentPageIndex;
@property (nonatomic, readonly) NSMutableArray *arrFetchResult;
@property (nonatomic, weak) id <GYListViewDelegate> delegate;
@property (nonatomic, strong) NSURLSessionDataTask *task;
@property (nonatomic, assign) NSInteger totalCount;
@property (nonatomic, assign) BOOL hasMoreData;
@property (nonatomic, assign) BOOL pageIndexChangeEnable;
@property (nonatomic, assign) BOOL loadSuccess;

- (void)fetchDataWithSuccess:(void(^)(void))success
                     failure:(void(^)(NSError *))failure;

@end
