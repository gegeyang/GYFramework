//
//  GYDrawBoardLineInfo.h
//  GYZF
//
//  Created by Yang Ge on 2020/11/19.
//  Copyright © 2020 网家科技有限责任公司. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GYDrawBoardLineInfo : NSObject

@property (nonatomic, readonly) NSArray *pointArr;
@property (nonatomic, readonly) UIColor *lineColor;
@property (nonatomic, readonly) CGFloat lineWidth;

+ (instancetype)initWithPointArr:(NSArray *)pointArr
                       lineColor:(UIColor *)lineColor
                       lineWidth:(CGFloat)lineWidth;

@end

NS_ASSUME_NONNULL_END
