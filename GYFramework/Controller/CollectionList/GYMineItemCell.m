//
//  GYMineItemCell.m
//  GYFramework
//
//  Created by Yang Ge on 2021/2/23.
//  Copyright © 2021 GeYang. All rights reserved.
//

#import "GYMineItemCell.h"
#import "GYMineInfoObject.h"

@interface GYMineItemCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation GYMineItemCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.titleLabel];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0);
        }];
    }
    return self;
}

- (void)updateCellInfo:(id<GYMineInfoObject>)infoObject {
    self.titleLabel.text = infoObject.infoTitle;
}

#pragma mark - getter and setter
- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor gy_color3];
        _titleLabel.font = [UIFont gy_CNBoldFontWithFontSize:30];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

@end
