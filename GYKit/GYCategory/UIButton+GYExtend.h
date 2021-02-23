//
//  UIButton+GYExtend.h
//  GYFramework
//
//  Created by Yang Ge on 2020/12/3.
//  Copyright © 2020 GeYang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (GYExtend)

/**
 计算按钮宽度
 */
- (CGFloat)gy_navigationWidth:(CGFloat)maxWidth;

/**
 计算按钮宽度，支持添加间距
 */
- (CGFloat)gy_contentWidth:(CGFloat)maxWidth
                   spacing:(CGFloat)spacing;
@end

NS_ASSUME_NONNULL_END
