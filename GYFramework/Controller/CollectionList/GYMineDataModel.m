//
//  GYMineDataModel.m
//  GYFramework
//
//  Created by Yang Ge on 2021/2/23.
//  Copyright © 2021 GeYang. All rights reserved.
//

#import "GYMineDataModel.h"
#import "GYMineInfo.h"

@implementation GYMineDataModel

- (void)fetchDataWithSuccess:(void (^)(void))success failure:(void (^)(NSError *))failure {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSArray *list = @[
            @{@"title" : @"A"},
            @{@"title" : @"B"},
            @{@"title" : @"C"},
            @{@"title" : @"D"},
            @{@"title" : @"E"},
            @{@"title" : @"F"},
            @{@"title" : @"G"},
            @{@"title" : @"H"},
            @{@"title" : @"I"},
            @{@"title" : @"J"},
            @{@"title" : @"K"},
            @{@"title" : @"L"},
            @{@"title" : @"M"},
            @{@"title" : @"N"},
            @{@"title" : @"O"},
            @{@"title" : @"P"},
            @{@"title" : @"Q"},
            @{@"title" : @"R"},
            @{@"title" : @"S"},
            @{@"title" : @"T"},
            @{@"title" : @"U"},
            @{@"title" : @"V"},
            @{@"title" : @"W"},
            @{@"title" : @"X"},
            @{@"title" : @"Y"},
            @{@"title" : @"Z"},
        ];
        if (self.currentPageIndex == 1) {
            [self.arrFetchResult removeAllObjects];
        }
        NSArray *currentIndexList = @[];
        NSInteger rangeLen = 20;
        NSInteger rangeLoc = (self.currentPageIndex - 1) * rangeLen;
        if (rangeLoc + rangeLen > list.count) {
            rangeLen = list.count - rangeLoc;
        }
        currentIndexList = [list subarrayWithRange:NSMakeRange(rangeLoc, rangeLen)];
        for (NSDictionary *subItem in currentIndexList) {
            GYMineInfo *info = [GYMineInfo infoWithDictionary:subItem];
            if (info) {
                [self.arrFetchResult addObject:info];
            }
        }
        self.totalCount = list.count;
        self.hasMoreData = (currentIndexList == 0) ? NO : (self.arrFetchResult.count < self.totalCount);
        if (success) {
            success();
        }
    });
}
@end
