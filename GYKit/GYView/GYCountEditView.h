//
//  GYCountEditView.h
//  GYZF
//
//  Created by 琚冠辉 on 2020/3/24.
//  Copyright © 2020 网家科技有限责任公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYTextField.h"

#define kCountEditSize  CGSizeMake(100, 25)

NS_ASSUME_NONNULL_BEGIN

@interface GYCountEditView : UIView

@property (nonatomic, copy) void(^subBlock)(void);
@property (nonatomic, copy) void(^addBlock)(void);
@property (nonatomic, copy) void(^endEditBlock)(NSDecimalNumber *countValue);
@property (nonatomic, strong) UIColor *countColor;
@property (nonatomic, strong) NSDecimalNumber *countValue;
@property (nonatomic, assign) BOOL inputEnable;
@property (nonatomic, readonly) GYTextField *countTextField;

- (instancetype)initWithMinValue:(NSDecimalNumber *)minValue
                        maxValue:(NSDecimalNumber *)maxValue
                     maximumDecimals:(NSUInteger)maximumDecimals;

- (instancetype)initWithMinValue:(NSDecimalNumber *)minValue
                        maxValue:(NSDecimalNumber *)maxValue
                 maximumDecimals:(NSUInteger)maximumDecimals
                    defaultValue:(NSDecimalNumber *)defaultValue;

- (void)updateMinValue:(NSDecimalNumber *)minValue
              maxValue:(NSDecimalNumber *)maxValue
         allowMaxInPut:(BOOL)allowMaxInPut
           maxErrorTip:(NSString * __nullable)maxErrorTip;

@end

NS_ASSUME_NONNULL_END
