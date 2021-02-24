//
//  GYScrollPageViewController.m
//  GYFramework
//
//  Created by Yang Ge on 2021/2/24.
//  Copyright © 2021 GeYang. All rights reserved.
//

#import "GYScrollPageViewController.h"

@interface GYScrollPageViewController ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, copy) NSArray *horizontalViewControllers;

@end

@implementation GYScrollPageViewController
- (void)loadView {
    [super loadView];
    self.scrollView.frame = self.view.bounds;
    self.scrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view insertSubview:self.scrollView
                     atIndex:0];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.scrollView.contentInset = UIEdgeInsetsZero;
}

- (void)viewContentInsetDidChanged {
    [super viewContentInsetDidChanged];
    self.scrollView.contentInset = UIEdgeInsetsZero;
    UIEdgeInsets inset = self.safeAreaInsets;
    inset.top = self.navigationBar.gy_height;
    [self updateHorizontalViewControllersContentInsetFromRoot:inset];
}

#pragma mark - implementation
- (void)addHorizontalViewControllers:(NSArray *)viewControllers {
    _horizontalViewControllers = viewControllers;
    UIViewController *prevViewController = nil;
    for (GYViewController *viewcontroller in viewControllers) {
        [self addChildViewController:viewcontroller];
        [self.scrollView addSubview:viewcontroller.view];
        const BOOL isFirst = viewcontroller == viewControllers.firstObject;
        const BOOL isLast = viewcontroller == viewControllers.lastObject;
        if (isFirst && isLast) {
            [viewcontroller.view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(0);
                make.top.right.bottom.equalTo(self.scrollView);
                make.width.equalTo(self.scrollView.mas_width);
                make.height.equalTo(self.scrollView.mas_height);
            }];
        } else if (isFirst) {
            [viewcontroller.view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.mas_equalTo(0);
                make.top.bottom.equalTo(self.scrollView);
                make.width.equalTo(self.scrollView.mas_width);
                make.height.equalTo(self.scrollView.mas_height);
            }];
        } else if (isLast) {
            [viewcontroller.view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(prevViewController.view.mas_right).offset(0);
                make.right.top.bottom.equalTo(self.scrollView);
                make.height.equalTo(self.scrollView.mas_height);
                make.width.equalTo(self.scrollView.mas_width);
            }];
        } else {
            [viewcontroller.view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(prevViewController.view.mas_right).offset(0);
                make.top.bottom.equalTo(self.scrollView);
                make.width.equalTo(self.scrollView.mas_width);
                make.height.equalTo(self.scrollView.mas_height);
            }];
        }
        prevViewController = viewcontroller;
    }
    UIEdgeInsets inset = self.safeAreaInsets;
    inset.top = self.navigationBar.gy_height;
    [self updateHorizontalViewControllersContentInsetFromRoot:inset];
}

- (void)updateHorizontalViewControllersContentInsetFromRoot:(UIEdgeInsets)contentInsetFromRoot {
    for (GYViewController *controller in _horizontalViewControllers) {
        controller.contentInsetsFromParent = contentInsetFromRoot;
    }
}

#pragma mark - getter and setter
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _scrollView.backgroundColor = [UIColor clearColor];
        _scrollView.delegate = self;
        _scrollView.bounces = NO;
        _scrollView.pagingEnabled = YES;
        if (@available(iOS 11.0, *)) {
            _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _scrollView;
}

@end
