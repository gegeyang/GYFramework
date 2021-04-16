//
//  GYGalleryCollectionCell.m
//  GYFramework
//
//  Created by Yang Ge on 2021/4/12.
//  Copyright © 2021 GeYang. All rights reserved.
//

#import "GYGalleryCollectionCell.h"
#import "GYImageZoomingScrollView.h"
#import "UIImageView+WebCache.h"
#import "UIImageView+GYExtend.h"

@interface GYGalleryCollectionCell ()

@property (nonatomic, strong) GYImageZoomingScrollView *scrollView;
@property (nonatomic, strong) UIImageView *currentImageview;
@property (nonatomic, strong) UIImage *currentImage;

@end

@implementation GYGalleryCollectionCell
- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.scrollView];
        [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0);
        }];
    }
    return self;
}

#pragma mark - implementaction
- (void)updateCellInfo:(id<GYGalleryItemObject>)itemObject {
    NSAssert([itemObject conformsToProtocol:@protocol(GYGalleryItemObject)], @"not realize GYGalleryItemObject...");
    switch (itemObject.galleryItemType) {
        case GYGalleryItemTypeNone:
            break;
        case GYGalleryItemTypeImage: {
            id<GYGalleryImageObject> imageObject = (id)itemObject;
            _currentImage = imageObject.galleryImage ?: [UIImage imageNamed:@"common_image_failure"];
            [self.scrollView displayImage:_currentImage];
        }
            break;
        case GYGalleryItemTypeUrl: {
            id<GYGalleryUrlObject> urlObject = (id)itemObject;
            UIImage *placeImage = [UIImage imageNamed:@"common_image_normal"];
            UIImage *failedImage = [UIImage imageNamed:@"common_image_failure"];
            UIImage *cachedImage = [UIImageView sd_cachedImageForURLString:urlObject.galleryBigUrlString] ? : [UIImageView sd_cachedImageForURLString:urlObject.gallerySmallUrlString];
            if (cachedImage) {
                placeImage = cachedImage;
                failedImage = cachedImage;
            }
            _currentImage = placeImage;
            [self.scrollView displayImage:placeImage];
            __weak typeof(self) weakself = self;
            [self.currentImageview gy_setImageURLString:urlObject.galleryBigUrlString
                                 normalPlaceholderImage:placeImage
                                 failedPlaceholderImage:failedImage
                                  emptyPlaceholderImage:failedImage
                                             completion:^(UIImage * _Nonnull image) {
                if (image) {
                    __strong typeof(weakself) strongself = weakself;
                    strongself.currentImage = image;
                    [strongself.scrollView displayImage:image];
                }
            }];
        }
            break;
        case GYGalleryItemTypeVideo: {
            NSAssert(NO, @"!!!! please use GYGalleryVideoCell ...");
        }
            break;
        default:
            break;
    }
}

- (void)doubleTapOnPoint:(CGPoint)aPoint {
    [self.scrollView doubleTapOnPoint:[self convertPoint:aPoint toView:self.scrollView]];
}

#pragma mark - getter and setter
- (UIImageView *)currentImageview {
    if (!_currentImageview) {
        _currentImageview = [[UIImageView alloc] init];
    }
    return _currentImageview;
}

- (GYImageZoomingScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[GYImageZoomingScrollView alloc] initWithFrame:self.bounds];
    }
    return _scrollView;
}

- (CGRect)imageViewFrame {
    return [self convertRect:self.scrollView.imageView.frame
                    fromView:self.scrollView];
}

@end
