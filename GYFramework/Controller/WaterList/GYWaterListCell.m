//
//  GYWaterListCell.m
//  GYFramework
//
//  Created by Yang Ge on 2021/4/9.
//  Copyright © 2021 GeYang. All rights reserved.
//

#import "GYWaterListCell.h"

@interface GYWaterListCell ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation GYWaterListCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor gy_colorWithRGB:GYKIT_APP_MAIN_COLOR] colorWithAlphaComponent:0.3];
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor gy_color6];
        _titleLabel.font = [UIFont gy_CNFontSizeS2];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0);
        }];
    }
    return self;
}

- (void)updateCellInfo:(NSIndexPath *)indexPath {
    _titleLabel.text = [NSString stringWithFormat:@"%@ - %@", @(indexPath.section), @(indexPath.row)];
}

@end
