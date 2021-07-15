//
//  GYWaterListCell.m
//  GYFramework
//
//  Created by Yang Ge on 2021/4/9.
//  Copyright © 2021 GeYang. All rights reserved.
//

#import "GYWaterListCell.h"
#import "GYAsyncLabel.h"

@interface GYWaterListCell ()

@property (nonatomic, strong) GYAsyncLabel *titleLabel;

@end

@implementation GYWaterListCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor gy_colorWithRGB:GYKIT_APP_MAIN_COLOR] colorWithAlphaComponent:0.3];
        _titleLabel = [[GYAsyncLabel alloc] init];
        [self addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0);
        }];
    }
    return self;
}

- (void)updateCellInfo:(NSIndexPath *)indexPath {
    _titleLabel.text = [NSString stringWithFormat:@"%@ - %@", @(indexPath.section), @(indexPath.row)];
    _titleLabel.font = [UIFont gy_CNFontSizeS2];
    [_titleLabel.layer setNeedsDisplay];
}

@end
