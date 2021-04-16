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

@implementation UIView(GalleryExtend)

- (CGRect)imageFrameAtIndex:(NSInteger)index {
    return self.bounds;
}

@end

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
    galleryVC.delegate = self;
    galleryVC.needExecuteAnimation = YES;
    [self.navigationController pushViewController:galleryVC animated:YES];
}

#pragma mark - GYGalleryViewControllerDelegate
- (void)galleryViewController:(GYGalleryViewController *)galleryViewController
              moveToIndexPath:(NSIndexPath *)indexPath {
    
}

- (CGRect)galleryViewController:(GYGalleryViewController *)galleryViewController
             convertFrameToView:(UIView *)view
                    atIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:self.galleryIndexPathInCollection];
    if (!cell) {
        return CGRectNull;
    }
    CGRect frame = [cell imageFrameAtIndex:indexPath.row];
    return [cell convertRect:frame
                      toView:view];
}

@end
