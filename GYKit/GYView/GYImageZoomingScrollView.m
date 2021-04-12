//
//  GYImageZoomingScrollView.m
//  GYFramework
//
//  Created by Yang Ge on 2021/4/12.
//  Copyright © 2021 GeYang. All rights reserved.
//

#import "GYImageZoomingScrollView.h"

@interface GYImageZoomingScrollView ()

@property (nonatomic, strong) UIImageView *imageView;

@end

@implementation GYImageZoomingScrollView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.imageView];
        self.scrollEnabled = NO;
        // Setup
        self.backgroundColor = [UIColor clearColor];
        self.delegate = self;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.decelerationRate = UIScrollViewDecelerationRateFast;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return self;
}

- (void)prepareForReuse {
    self.imageView.image = nil;
}

- (void)displayImage:(UIImage *)image {
    // Reset
    self.maximumZoomScale = 1;
    self.minimumZoomScale = 1;
    self.zoomScale = 1;
    self.contentSize = CGSizeMake(0, 0);
    // Set image
    self.imageView.image = image;
    self.imageView.hidden = NO;
    // Setup photo frame
    CGRect photoImageViewFrame;
    photoImageViewFrame.origin = CGPointZero;
    photoImageViewFrame.size = image.size;
    self.imageView.frame = photoImageViewFrame;
    self.contentSize = photoImageViewFrame.size;
    // Bail if no image
    if (self.imageView.image != nil) {
        // Disable scrolling initially until the first pinch to fix issues with swiping on an initally zoomed in photo
        self.scrollEnabled = NO;
        // Sizes
        CGSize boundsSize = self.bounds.size;
        CGSize imageSize = image.size;
        // Calculate Min
        CGFloat xScale = boundsSize.width / imageSize.width;    // the scale needed to perfectly fit the image width-wise
        CGFloat yScale = boundsSize.height / imageSize.height;  // the scale needed to perfectly fit the image height-wise
        CGFloat minScale = MIN(xScale, yScale);                 // use minimum of these to allow the image to become fully visible
        CGFloat maxScale = MAX(xScale, yScale);
        NSInteger imageVerticalScale = roundf((image.size.height / image.size.width) * 100);
        NSInteger boundsVerticalScale = roundf((boundsSize.height / boundsSize.width) * 200);
        // Set min/max zoom
        self.maximumZoomScale = maxScale;
        self.minimumZoomScale = minScale;
        // Initial zoom
        if (imageVerticalScale  > boundsVerticalScale) {
            self.zoomScale = self.maximumZoomScale;
            self.contentOffset = CGPointMake(0, 0);
            dispatch_async(dispatch_get_main_queue(), ^{
                self.scrollEnabled = YES;
            });
        } else {
            self.zoomScale = self.minimumZoomScale;
            // If we're zooming to fill then centralise
            if (self.zoomScale != minScale) {
                // Centralise
                self.contentOffset = CGPointMake((imageSize.width * self.zoomScale - boundsSize.width) / 2.0,
                                                 (imageSize.height * self.zoomScale - boundsSize.height) / 2.0);
            }
        }
    }
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    // Super
    [super layoutSubviews];
    // Center the image as it becomes smaller than the size of the screen
    CGSize boundsSize = self.bounds.size;
    CGRect frameToCenter = self.imageView.frame;
    // Horizontally
    if (frameToCenter.size.width < boundsSize.width) {
        frameToCenter.origin.x = floorf((boundsSize.width - frameToCenter.size.width) / 2.0);
    } else {
        frameToCenter.origin.x = 0;
    }
    // Vertically
    if (frameToCenter.size.height < boundsSize.height) {
        frameToCenter.origin.y = floorf((boundsSize.height - frameToCenter.size.height) / 2.0);
    } else {
        frameToCenter.origin.y = 0;
    }
    // Center
    if (!CGRectEqualToRect(self.imageView.frame, frameToCenter))
        self.imageView.frame = frameToCenter;
}

- (void)doubleTapOnPoint:(CGPoint)aPoint {
    CGFloat touchX = aPoint.x;
    CGFloat touchY = aPoint.y;
    touchX *= 1 / self.zoomScale;
    touchY *= 1 / self.zoomScale;
    touchX += self.contentOffset.x;
    touchY += self.contentOffset.y;
    // Zoom
    if (self.zoomScale != self.minimumZoomScale && self.zoomScale != self.minimumZoomScale) {
        // Zoom out
        [self setZoomScale:self.minimumZoomScale animated:YES];
    } else {
        // Zoom in to twice the size
        CGFloat newZoomScale = ((self.maximumZoomScale + self.minimumZoomScale) / 2);
        CGFloat xsize = self.bounds.size.width / newZoomScale;
        CGFloat ysize = self.bounds.size.height / newZoomScale;
        [self zoomToRect:CGRectMake(touchX - xsize / 2, touchY - ysize / 2, xsize, ysize) animated:YES];
    }
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _imageView;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view {
    self.scrollEnabled = YES; // reset
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    if (self.scrollEnabled) {
        [self setNeedsLayout];
        [self layoutIfNeeded];
    }
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(nullable UIView *)view atScale:(CGFloat)scale {
}

#pragma mark - getter and setter
- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}
@end
