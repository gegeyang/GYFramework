//
//  GYAlgorithmInfo.m
//  GYFramework
//
//  Created by Yang Ge on 2021/7/14.
//  Copyright © 2021 GeYang. All rights reserved.
//

#import "GYAlgorithmInfo.h"

@implementation GYAlgorithmInfo

- (instancetype)init {
    if (self = [super init]) {
        NSMutableArray *array = [NSMutableArray arrayWithArray:@[@(5), @(2), @(3), @(7), @(1)]];
        NSLog(@"%@", [self sortByChaRu:array]);
    }
    return self;
}

#pragma mark - 冒泡排序
- (NSArray *)sortByMaoPao:(NSMutableArray *)array {
    for (NSInteger i = 0; i < array.count - 1; i++) {
        for (NSInteger j = 0; j < array.count - 1 - i; j++) {
            if ([array[j] integerValue] > [array[j + 1] integerValue]) {
                NSInteger temp = [array[j + 1] integerValue];
                array[j + 1] = array[j];
                array[j] = @(temp);
            }
        }
    }
    return [array copy];
}

#pragma mark - 选择排序
- (NSArray *)sortByXuanZe:(NSMutableArray *)array {
    for (NSInteger i = 0; i < array.count - 1; i++) {
        //默认最小值下标
        NSInteger minIndex = i;
        for (NSInteger j = i + 1; j < array.count; j++) {
            //找到更小值，更换下标
            if ([array[j] integerValue] < [array[minIndex] integerValue]) {
                minIndex = j;
            }
        }
        if (i != minIndex) {
            //交换位置
            NSInteger temp = [array[i] integerValue];
            array[i] = array[minIndex];
            array[minIndex] = @(temp);
        }
    }
    return [array copy];
}

#pragma mark - 插入排序
- (NSArray *)sortByChaRu:(NSMutableArray *)array {
    for (NSInteger i = 1; i < array.count; i++) {
        //记录当前的值
        NSInteger temp = [array[i] integerValue];
        NSInteger j = i;
        //从当前值遍历到最前面，561
        while (j > 0 && temp < [array[j - 1] integerValue]) {
            array[j] = array[j - 1];
            j--;
        }
        array[j] = @(temp);
    }
    return [array copy];
}

@end
