//
//  GYToolBar.h
//  GYFramework
//
//  Created by GeYang on 2018/6/4.
//  Copyright © 2018年 GeYang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GYTabbarButton;

@interface GYTabbarView : UIView

@property (nonatomic, copy) void(^selectItemBlock)(NSInteger tag);

- (void)updateItems:(NSArray<GYTabbarButton *> *)items;
- (GYTabbarButton *)tabBarItemForTag:(NSInteger)tag;
- (void)selectAtItem:(NSInteger)tag;

@end
