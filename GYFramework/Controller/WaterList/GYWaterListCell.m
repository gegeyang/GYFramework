//
//  GYWaterListCell.m
//  GYFramework
//
//  Created by Yang Ge on 2021/4/9.
//  Copyright © 2021 GeYang. All rights reserved.
//

#import "GYWaterListCell.h"

@interface GYWaterListCell ()

@end

@implementation GYWaterListCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor gy_colorWithRGB:GYKIT_APP_MAIN_COLOR] colorWithAlphaComponent:0.3];
    }
    return self;
}

@end
