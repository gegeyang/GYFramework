//
//  GYDrawBoardView.h
//  WJZF
//
//  Created by Yang Ge on 2020/11/19.
//  Copyright © 2020 网家科技有限责任公司. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface GYDrawBoardView : UIView

#pragma mark - 设置线条宽度
- (void)updateLineWidth:(CGFloat)lineWidth;

#pragma mark - 设置线条颜色
- (void)updateLineColor:(UIColor *)lineColor;

#pragma mark - 撤销
- (void)gy_drawBoardRepealAction;

#pragma mark - 添加文字
- (void)gy_drawBoardAddText:(NSString *)textString;

@end

NS_ASSUME_NONNULL_END
