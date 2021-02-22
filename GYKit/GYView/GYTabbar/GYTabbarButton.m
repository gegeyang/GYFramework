//
//  GYTabbarButton.m
//  GYFramework
//
//  Created by GeYang on 2018/7/7.
//  Copyright © 2018年 GeYang. All rights reserved.
//

#import "GYTabbarButton.h"
#import "GYBadgeView.h"

@interface GYTabbarButton ()

@property (nonatomic, strong) GYBadgeView *badgeView;
@property (nonatomic, strong) UILabel *subLabelTitle;
@property (nonatomic, strong) UIImageView *subImageView;

@end

@implementation GYTabbarButton

- (instancetype)initWithTitle:(NSString *)title
                  normalImage:(UIImage *)normalImage
                selectedImage:(UIImage *)selectedImage {
    self = [super init];
    if (self) {
        [self addSubview:self.subLabelTitle];
        [self addSubview:self.subImageView];
        [self addSubview:self.badgeView];
        self.badgeView.hidden = YES;
        
        _subLabelTitle.text = title;
        _subImageView.image = normalImage;
        _subImageView.highlightedImage = selectedImage;
        
        [_subImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(6);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(CGSizeMake(24, 24));
        }];
        [_subLabelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.subImageView.mas_bottom).offset(3);
            make.left.right.mas_equalTo(0);
            make.height.mas_equalTo(self.subLabelTitle.font.lineHeight);
        }];
        [_badgeView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.subImageView.mas_top).offset(-3);
            make.centerX.equalTo(self).offset(12);
        }];
    }
    return self;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    [self.subImageView setHighlighted:selected];
    [self.subLabelTitle setTextColor:(selected ? [UIColor gy_colorWithRGB:GYKIT_APP_TABBAR_TITLE_COLOR_SELECTED] : [UIColor gy_colorWithRGB:GYKIT_APP_TABBAR_TITLE_COLOR_NORMAL])];
}

#pragma mark - getters and setters
- (UILabel *)subLabelTitle {
    if (!_subLabelTitle) {
        _subLabelTitle = [[UILabel alloc] init];
        [_subLabelTitle setTextAlignment:NSTextAlignmentCenter];
        [_subLabelTitle setFont:[UIFont gy_CNFontWithFontSize:GYKIT_APP_TABBAR_FONT_SIZE]];
    }
    return _subLabelTitle;
}

- (UIImageView *)subImageView {
    if (!_subImageView) {
        _subImageView = [[UIImageView alloc] init];
        _subImageView.contentMode = UIViewContentModeBottom;
    }
    return _subImageView;
}

- (GYBadgeView *)badgeView {
    if (!_badgeView) {
        _badgeView = [[GYBadgeView alloc] init];
    }
    return _badgeView;
}

- (void)setBadgeValue:(NSInteger)badgeValue {
    [self.badgeView setBadgeValue:badgeValue];
}

@end
