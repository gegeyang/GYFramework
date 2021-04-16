//
//  GYGalleryViewController.h
//  GYFramework
//
//  Created by Yang Ge on 2021/4/12.
//  Copyright © 2021 GeYang. All rights reserved.
//

#import "GYCollectionViewController.h"
#import "GYGalleryItemObject.h"

@protocol GYGalleryAnimationDelegate, GYGalleryViewControllerDelegate;
NS_ASSUME_NONNULL_BEGIN

@interface GYGalleryViewController : GYCollectionViewController <GYGalleryAnimationDelegate>

- (instancetype)initWithImageList:(NSArray<id<GYGalleryItemObject>>*)imageList;

@property (nonatomic, assign) BOOL needExecuteAnimation;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@property (nonatomic, weak) id<GYGalleryViewControllerDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
