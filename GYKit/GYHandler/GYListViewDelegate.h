//
//  GYListViewDelegate.h
//  GYFramework
//
//  Created by GeYang on 2018/9/12.
//  Copyright © 2018年 GeYang. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GYListViewDelegate <NSObject>

@optional
- (void)onDataModelLoading;
- (void)onDataModelLoadSuccess;
- (void)onDataModelLoadFailed:(NSError *)error;

@end
