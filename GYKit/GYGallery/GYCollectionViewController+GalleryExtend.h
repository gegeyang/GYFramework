//
//  GYCollectionViewController+GalleryExtend.h
//  GYFramework
//
//  Created by Yang Ge on 2021/4/13.
//  Copyright © 2021 GeYang. All rights reserved.
//

#import "GYCollectionViewController.h"
#import "GYGalleryViewControllerDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface GYCollectionViewController (GalleryExtend) <GYGalleryViewControllerDelegate>

@property (nonatomic, strong) NSIndexPath *galleryIndexPathInCollection;

- (void)gy_gallery_beginGallery:(NSArray *)dataList
          indexPathInCollection:(NSIndexPath *)indexPathInCollection;

@end

NS_ASSUME_NONNULL_END
