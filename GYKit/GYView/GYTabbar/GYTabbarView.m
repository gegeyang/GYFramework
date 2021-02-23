//
//  GYTabbarView.m
//  GYFramework
//
//  Created by GeYang on 2018/6/4.
//  Copyright © 2018年 GeYang. All rights reserved.
//

#import "GYTabbarView.h"
#import "GYTabbarButton.h"

@interface GYTabbarView ()

@property (nonatomic, copy) NSDictionary *itemMap;
@property (nonatomic, copy) NSArray *itemList;

@end

@implementation GYTabbarView
- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor gy_colorWithRGB:GYKIT_APP_TABBAR_BG_COLOR_HEX];
        [self gy_drawBorderWithColor:[UIColor gy_colorWithRGB:GYKIT_APP_TABBAR_TOPLINE_COLOR_HEX]
                            lineType:GYDrawLineTop];
    }
    return self;
}

#pragma mark - implementation
- (void)updateItems:(NSArray<GYTabbarButton *> *)items {
    if (items == 0) {
        return;
    }
    for (UIView *subItemView in items) {
        [subItemView removeFromSuperview];
    }
    NSMutableArray *itemList = [NSMutableArray array];
    NSMutableDictionary *itemMap = [NSMutableDictionary dictionary];
    for (GYTabbarButton *item in items) {
        [item addTarget:self
                 action:@selector(onToolBarItemClicked:)
       forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:item];
        [itemList addObject:item];
        [itemMap setValue:item forKey:[@(item.tag) stringValue]];
    }
    _itemList = [itemList copy];
    _itemMap = [itemMap copy];
    if (_itemList.count >= 2) {
        [_itemList mas_distributeViewsAlongAxis:MASAxisTypeHorizontal
                               withFixedSpacing:0
                                    leadSpacing:0
                                    tailSpacing:0];
        [_itemList mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(0);
        }];
    } else if (_itemList.count >= 1) {
        UIView *item = _itemList.firstObject;
        [item mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.right.left.mas_equalTo(0);
        }];
    }
}

- (void)selectAtItem:(NSInteger)tag {
    for (UIView *subView in _itemList) {
        if ([subView isKindOfClass:[GYTabbarButton class]]) {
            GYTabbarButton *tabButton = (GYTabbarButton *)subView;
            const BOOL isSelected = (tabButton.tag == tag);
            [tabButton setSelected:isSelected];
        }
    }
}

- (GYTabbarButton *)tabBarItemForTag:(NSInteger)tag {
    return [_itemMap objectForKey:[@(tag) stringValue]];
}

- (void)onToolBarItemClicked:(GYTabbarButton *)item {
    if (self.selectItemBlock) {
        self.selectItemBlock(item.tag);
    }
}

// 在自定义UITabBar中重写以下方法，其中self.button就是那个希望被触发点击事件的按钮
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    if (view) {
        return view;
    }
    for (UIView *item in [self subviews]) {
        if ([item isKindOfClass:[GYTabbarButton class]]) {
            GYTabbarButton *btn = (GYTabbarButton *)item;
            // 转换坐标系
            CGPoint newPoint = [self convertPoint:point toView:btn];
            // 判断触摸点是否在button上
            if (CGRectContainsPoint(btn.bounds, newPoint)) {
                return item;
            }
        }
    }
    return nil;
}


@end
