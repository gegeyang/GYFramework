//
//  GYGalleryViewController.h
//  GYFramework
//
//  Created by Yang Ge on 2021/4/12.
//  Copyright © 2021 GeYang. All rights reserved.
//

#import "GYCollectionViewController.h"
#import "GYGalleryItemObject.h"

NS_ASSUME_NONNULL_BEGIN

@interface GYGalleryViewController : GYCollectionViewController

- (instancetype)initWithImageList:(NSArray<id<GYGalleryItemObject>>*)imageList;

@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

@end

NS_ASSUME_NONNULL_END
