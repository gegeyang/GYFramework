//
//  GYListViewDataSource.h
//  GYFramework
//
//  Created by GeYang on 2018/9/12.
//  Copyright © 2018年 GeYang. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GYListViewDataSource <NSObject>

@property (nonatomic, readonly) BOOL hasData;
@property (nonatomic, readonly) BOOL hasMoreData;
@property (nonatomic, readonly) BOOL dataNeedReload;

- (NSInteger)sectionCount;
- (NSInteger)numberOfDatasInSection:(NSInteger)section;
- (void)reloadDataWithCompletion:(void(^)(BOOL))completion;
- (void)loadMoreDataWithCompletion:(void(^)(BOOL))completion;
- (void)reset;
- (id)sectionInfoAtIndex:(NSInteger)section;
- (id)itemInfoAtIndexPath:(NSIndexPath *)indexPath;

@end
