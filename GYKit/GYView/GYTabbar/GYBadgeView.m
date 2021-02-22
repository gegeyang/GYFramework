//
//  GYBadgeView.m
//  GYFramework
//
//  Created by GeYang on 2018/7/7.
//  Copyright © 2018年 GeYang. All rights reserved.
//

#import "GYBadgeView.h"

@implementation GYBadgeView

- (instancetype)init {
    const CGSize badgeSize = CGSizeMake(8, 8);
    self = [super initWithFrame:CGRectMake(0,
                                           0,
                                           badgeSize.width,
                                           badgeSize.height)];
    if (self) {
        self.backgroundColor = [UIColor redColor];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = roundf(MIN(badgeSize.width, badgeSize.height) / 2);
        self.userInteractionEnabled = NO;
    }
    return self;
}

- (void)setBadgeValue:(NSInteger)value {
    _badgeValue = value;
    self.hidden = (value <= 0);
}

@end
