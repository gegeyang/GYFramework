//
//  GYAlbumItemCell.m
//  GYFramework
//
//  Created by Yang Ge on 2021/4/26.
//  Copyright © 2021 GeYang. All rights reserved.
//

#import "GYAlbumItemCell.h"
#import <Photos/Photos.h>
#import "GYCachingImageManager.h"
#import "GYAlbumInfo.h"

@interface GYAlbumItemCell (){
    PHAsset *_asset;
}

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *labelTitle;
@property (nonatomic, strong) UIView *viewContent;
@property (nonatomic, strong) UIImageView *arrowImageview;

@end

@implementation GYAlbumItemCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.viewContent];
        [self.viewContent addSubview:self.imageView];
        [self.viewContent addSubview:self.labelTitle];
        [self.viewContent addSubview:self.arrowImageview];
        
        [self.viewContent mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(GYKIT_GENERAL_H_MARGIN);
            make.right.mas_equalTo(-GYKIT_GENERAL_H_MARGIN);
            make.top.mas_equalTo(GYKIT_GENERAL_SPACING1);
            make.bottom.mas_equalTo(-GYKIT_GENERAL_SPACING1);
        }];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.mas_equalTo(0);
            make.width.mas_equalTo(roundf(self.gy_height * 1.3));
        }];
        [self.labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.imageView.mas_right).offset(GYKIT_GENERAL_SPACING1);
            make.right.equalTo(self.arrowImageview.mas_left).offset(-GYKIT_GENERAL_SPACING1);
            make.top.bottom.mas_equalTo(0);
        }];
        [self.arrowImageview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(0);
            make.size.mas_equalTo(self.arrowImageview.image.size);
            make.centerY.mas_equalTo(self.imageView.mas_centerY);
        }];
    }
    return self;
}

- (void)updateAlbumItem:(GYAlbumInfo *)itemObject {
    _asset = itemObject.albumCoverAsset;
    if (_asset) {
        self.imageView.image = [UIImage imageNamed:@"common_image_normal"];
        [[GYCachingImageManager defaultManager] asyncRequestThumbImage:_asset.localIdentifier
                                                         resultHandler:^(UIImage * _Nonnull image) {
            self.imageView.image = image ?: [UIImage imageNamed:@"common_image_normal"];
        }];
    } else {
        self.imageView.image = [UIImage imageNamed:@"common_image_normal"];
    }
    NSString *albumTitle = itemObject.albumTitle;
    NSString *albumCount = [NSString stringWithFormat:@"(%@)", @(itemObject.albumCount)];
    NSString *allAlbumString = [NSString stringWithFormat:@"%@  %@", albumTitle, albumCount];
    NSRange rangeTitle = [allAlbumString rangeOfString:albumTitle];
    NSRange rangeCount = [allAlbumString rangeOfString:albumCount];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:allAlbumString];
    [attributedString addAttribute:NSForegroundColorAttributeName
                             value:[UIColor gy_color6]
                             range:rangeTitle];
    [attributedString addAttribute:NSForegroundColorAttributeName
                             value:[UIColor gy_color9]
                             range:rangeCount];
    self.labelTitle.attributedText = attributedString;
}

#pragma mark - getter and setter
- (UIView *)viewContent {
    if (!_viewContent) {
        _viewContent = [[UIView alloc] init];
        
        _imageView = [[UIImageView alloc] init];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.layer.cornerRadius = 5;
        _imageView.clipsToBounds = YES;

        _labelTitle = [[UILabel alloc] init];
        _labelTitle.font = [UIFont gy_CNFontSizeS1];
        
        _arrowImageview = [[UIImageView alloc] init];
        _arrowImageview.image = [UIImage imageNamed:@"common_arrow_right"];
    }
    return _viewContent;
}

@end
