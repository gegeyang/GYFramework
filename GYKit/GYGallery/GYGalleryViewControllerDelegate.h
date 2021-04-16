//
//  GYGalleryViewControllerDelegate.h
//  GYFramework
//
//  Created by Yang Ge on 2021/4/16.
//  Copyright © 2021 GeYang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class GYGalleryViewController;
@protocol GYGalleryViewControllerDelegate <NSObject>

- (void)galleryViewController:(GYGalleryViewController *)galleryViewController
              moveToIndexPath:(NSIndexPath *)indexPath;
- (CGRect)galleryViewController:(GYGalleryViewController *)galleryViewController
             convertFrameToView:(UIView *)view
                    atIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
