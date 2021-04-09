//
//  GYWaterListModel.m
//  GYFramework
//
//  Created by Yang Ge on 2021/4/9.
//  Copyright © 2021 GeYang. All rights reserved.
//

#import "GYWaterListModel.h"

@implementation GYWaterListModel

- (void)fetchDataWithSuccess:(void (^)(void))success failure:(void (^)(NSError *))failure {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.arrFetchResult addObjectsFromArray:@[@"50", @"30", @"70", @"150", @"40", @"50", @"60", @"70", @"30", @"70", @"80", @"50", @"50", @"30", @"70", @"40", @"40", @"50", @"40", @"50", @"60", @"70", @"30"]];
        if (success) {
            success();
        }
    });
}


@end
