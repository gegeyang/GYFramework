//
//  GYWaterGalleryCell.m
//  GYFramework
//
//  Created by Yang Ge on 2021/4/13.
//  Copyright © 2021 GeYang. All rights reserved.
//

#import "GYWaterGalleryCell.h"
#import "UIImageView+GYExtend.h"

@interface GYWaterGalleryCell ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation GYWaterGalleryCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.imageView];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0);
        }];
    }
    return self;
}

- (void)updateCellInfo:(id<GYGalleryUrlObject>)itemInfo {
    [self.imageView gy_setImageURLString:itemInfo.galleryBigUrlString
                  normalPlaceholderImage:[UIImage imageNamed:@"common_image_normal"]
                  failedPlaceholderImage:[UIImage imageNamed:@"common_image_failure"]
                   emptyPlaceholderImage:[UIImage imageNamed:@"common_image_failure"]
                                     completion:nil];
}

- (CGRect)imageFrameAtIndex:(NSInteger)index {
    return [self convertRect:self.imageView.frame
                    fromView:self.imageView];
}


#pragma mark - getter and setter
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}

@end
