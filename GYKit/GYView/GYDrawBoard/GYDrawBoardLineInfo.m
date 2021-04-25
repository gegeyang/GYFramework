//
//  GYDrawBoardLineInfo.m
//  GYZF
//
//  Created by Yang Ge on 2020/11/19.
//  Copyright © 2020 网家科技有限责任公司. All rights reserved.
//

#import "GYDrawBoardLineInfo.h"

@interface GYDrawBoardLineInfo ()

@property (nonatomic, strong) NSArray *pointArr;
@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, assign) CGFloat lineWidth;

@end

@implementation GYDrawBoardLineInfo

+ (instancetype)initWithPointArr:(NSArray *)pointArr
                       lineColor:(UIColor *)lineColor
                       lineWidth:(CGFloat)lineWidth {
    GYDrawBoardLineInfo *info = [[GYDrawBoardLineInfo alloc] init];
    info.pointArr = pointArr;
    info.lineColor = lineColor;
    info.lineWidth = lineWidth;
    return info;
}

@end
