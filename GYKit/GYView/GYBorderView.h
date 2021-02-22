//
//  GYBorderView.h
//  GYFramework
//
//  Created by GeYang on 2018/7/9.
//  Copyright © 2018年 GeYang. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, GYBorderType) {
    GYBorderNone = 0x0,
    GYBorderTop = 0x1,
    GYBorderBottom = 0x2,
    GYBorderLeft = 0x4,
    GYBorderRight = 0x8,
    GYBorderCenterX = 0x10,
    GYBorderCenterY = 0x20,
    
    GYBorderVertical = GYBorderTop | GYBorderBottom,
    GYBorderHorizontal = GYBorderLeft | GYBorderRight,
    GYBorderCenter = GYBorderCenterX | GYBorderCenterY,
    GYBorderBorder = GYBorderTop | GYBorderBottom | GYBorderLeft | GYBorderRight,
};

@interface GYBorderView : UIView

@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, assign) GYBorderType borderType;

@end
