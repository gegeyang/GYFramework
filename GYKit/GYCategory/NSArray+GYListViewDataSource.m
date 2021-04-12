//
//  NSArray+GYListViewDataSource.m
//  GYFramework
//
//  Created by Yang Ge on 2021/4/12.
//  Copyright © 2021 GeYang. All rights reserved.
//

#import "NSArray+GYListViewDataSource.h"

@implementation NSArray (GYListViewDataSource)

- (BOOL)itemIsArray {
    return [self.firstObject isKindOfClass:[NSArray class]];
}

- (BOOL)hasData {
    return YES;
}

- (BOOL)hasMoreData {
    return NO;
}

- (BOOL)dataNeedReload {
    return NO;
}

- (NSInteger)sectionCount {
    return self.itemIsArray ? self.count : 1;
}

- (NSInteger)numberOfDatasInSection:(NSInteger)section {
    if (!self.itemIsArray) {
        return self.count;
    }
    if (section < 0 || section >= self.count) {
        return 0;
    }
    
    NSArray *arrSection = [self objectAtIndex:section];
    return arrSection.count;
}

- (void)reloadDataWithCompletion:(void(^)(BOOL))completion {}
- (void)loadMoreDataWithCompletion:(void(^)(BOOL))completion {}
- (void)reset {}

- (id)sectionInfoAtIndex:(NSInteger)section {
    if (!self.itemIsArray) {
        return nil;
    }
    if (section < 0 || section >= self.count) {
        return 0;
    }
    return [self objectAtIndex:section];
}

- (id)itemInfoAtIndexPath:(NSIndexPath *)indexPath {
    const NSInteger row = indexPath.row;
    if (self.itemIsArray) {
        const NSInteger section = indexPath.section;
        NSArray *arrSection = [self objectAtIndex:section];
        if (row >= 0 && row < arrSection.count) {
            return [arrSection objectAtIndex:row];
        }
    } else {
        if (row >= 0 && row < self.count) {
            return [self objectAtIndex:row];
        }
    }
    return nil;
}

@end
