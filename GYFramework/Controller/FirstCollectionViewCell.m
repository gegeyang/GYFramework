//
//  FirstCollectionViewCell.m
//  GYFramework
//
//  Created by Yang Ge on 2021/2/24.
//  Copyright © 2021 GeYang. All rights reserved.
//

#import "FirstCollectionViewCell.h"

@interface FirstCollectionViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *arrowImageView;

@end

@implementation FirstCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.titleLabel];
        [self addSubview:self.arrowImageView];
        
        [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(-GYKIT_GENERAL_H_MARGIN);
            make.centerY.mas_equalTo(self.mas_centerY);
            make.size.mas_equalTo(self.arrowImageView.image.size);
        }];
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(0);
            make.left.mas_equalTo(GYKIT_GENERAL_H_MARGIN);
            make.right.equalTo(self.arrowImageView.mas_left).offset(-GYKIT_GENERAL_SPACING1);
        }];
    }
    return self;
}

- (void)updateCellInfo:(NSString *)title {
    self.titleLabel.text = title;
}

#pragma mark - getter and setter
- (UILabel *)titleLabel {
    if(!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont gy_CNFontSizeS1];
        _titleLabel.textColor = [UIColor gy_color3];
    }
    return _titleLabel;
}

- (UIImageView *)arrowImageView {
    if (!_arrowImageView) {
        _arrowImageView = [[UIImageView alloc] init];
        _arrowImageView.image = [UIImage imageNamed:@"common_arrow_right"];
    }
    return _arrowImageView;
}
@end
