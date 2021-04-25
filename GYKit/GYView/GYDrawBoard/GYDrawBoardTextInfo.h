//
//  GYDrawBoardTextInfo.h
//  GYZF
//
//  Created by Yang Ge on 2020/11/20.
//  Copyright © 2020 网家科技有限责任公司. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class GYDrawBoardTextInfo;
@protocol GYDrawBoardTextDelegete <NSObject>

- (void)gy_drawBoradTextDidPan:(UIPanGestureRecognizer *)pan
                      textInfo:(GYDrawBoardTextInfo *)textInfo;

- (void)gy_drawBoradTextDidTap:(UITapGestureRecognizer *)tap
                      textInfo:(GYDrawBoardTextInfo *)textInfo;

@end

@interface GYDrawBoardTextInfo : NSObject

- (instancetype)initWithOriginalPoint:(CGPoint)originalPoint
                       originalString:(NSString *)originalString;

@property (nonatomic, readonly) UILabel *textLabel;
@property (nonatomic, weak) id <GYDrawBoardTextDelegete> delegate;
//label的颜色
@property (nonatomic, strong) UIColor *textColor;
//label的中心位置
@property (nonatomic, assign) CGPoint textPoint;
//label的文案
@property (nonatomic, strong) NSString *textString;

//添加移动位置
- (void)addMovePoint:(CGPoint)point;
//添加文字编辑
- (void)addTextEdit:(NSString *)string;
//检查并撤销最后一次操作 yes：存在最后一次操作，并撤销 no:表示未操作
- (BOOL)checkAndRepealLastAction;

@end

NS_ASSUME_NONNULL_END
