//
//  GYBadgeView.m
//  GYFramework
//
//  Created by GeYang on 2018/7/7.
//  Copyright © 2018年 GeYang. All rights reserved.
//

#import "GYBadgeView.h"
#import "GYTagAppearanceObject.h"

#define kGYBadgeWidthBigMoreWidth  20
#define kGYBadgeWidthBig    15
#define kGYBadgeWidthSmall  8

@interface GYBadgeView () <GYTagAppearanceObject>

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation GYBadgeView

- (instancetype)init {
    const CGSize badgeSize = CGSizeMake(8, 8);
    self = [super initWithFrame:CGRectMake(0,
                                           0,
                                           badgeSize.width,
                                           badgeSize.height)];
    if (self) {
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeCenter;
        _imageView.clipsToBounds = YES;
        [self addSubview:_imageView];
        
        [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(UIEdgeInsetsZero);
        }];
    }
    return self;
}

- (void)setBadgeValue:(NSInteger)value {
    _badgeValue = value;
    self.hidden = (value <= 0);
    self.gy_size = self.tagFixedSize;
    if (value <= 99) {
        _imageView.image = [UIImage gy_imageWithTitle:[@(value) stringValue]
                                               radius:7
                                     appearanceObject:self];
    } else {
        _imageView.image = [UIImage gy_imageWithTitle:@"99+"
                                               radius:7
                                     appearanceObject:self];
    }
}

#pragma mark - GYTagAppearanceObject
- (UIColor *)tagBorderColor {
    return [UIColor redColor];
}

- (UIColor *)tagFillColor {
    return [UIColor redColor];
}

- (UIColor *)tagNameColor {
    return [UIColor whiteColor];
}

- (UIFont *)tagNameFont {
    return [UIFont gy_CNFontWithFontSize:8];
}

- (CGSize)tagFixedSize {
    if (self.badgeValue > 99) {
        return CGSizeMake(kGYBadgeWidthBigMoreWidth, kGYBadgeWidthBig);
    }
    return CGSizeMake(kGYBadgeWidthBig, kGYBadgeWidthBig);
}


@end
