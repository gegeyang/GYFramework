//
//  GYScrollPageViewController.h
//  GYFramework
//
//  Created by Yang Ge on 2021/2/24.
//  Copyright © 2021 GeYang. All rights reserved.
//

#import "GYViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface GYScrollPageViewController : GYViewController <UIScrollViewDelegate>

@property (nonatomic, strong, readonly) UIScrollView *scrollView;

- (void)addHorizontalViewControllers:(NSArray *)viewControllers;
- (void)updateHorizontalViewControllersContentInsetFromRoot:(UIEdgeInsets)contentInsetFromRoot;

@end

NS_ASSUME_NONNULL_END
