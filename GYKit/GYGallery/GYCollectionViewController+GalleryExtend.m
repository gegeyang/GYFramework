//
//  GYCollectionViewController+GalleryExtend.m
//  GYFramework
//
//  Created by Yang Ge on 2021/4/13.
//  Copyright © 2021 GeYang. All rights reserved.
//

#import "GYCollectionViewController+GalleryExtend.h"
#import "GYGalleryViewController.h"
#import <objc/runtime.h>

@implementation GYCollectionViewController (GalleryExtend)

static char kGalleryInCollection;

- (NSIndexPath *)galleryIndexPathInCollection {
    return objc_getAssociatedObject(self, &kGalleryInCollection);
}

- (void)setGalleryIndexPathInCollection:(NSIndexPath *)galleryIndexPathInCollection {
    [self willChangeValueForKey:@"galleryIndexPathInCollection"];
    objc_setAssociatedObject(self, &kGalleryInCollection, galleryIndexPathInCollection, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"galleryIndexPathInCollection"];
}

- (void)gy_gallery_beginGallery:(NSArray *)dataList
          indexPathInCollection:(NSIndexPath *)indexPathInCollection {
    self.galleryIndexPathInCollection = indexPathInCollection;
    GYGalleryViewController *galleryVC = [[GYGalleryViewController alloc] initWithImageList:dataList];
    galleryVC.selectedIndexPath = [NSIndexPath indexPathForRow:indexPathInCollection.row
                                                     inSection:0];
    [self.navigationController pushViewController:galleryVC animated:YES];
}

@end
