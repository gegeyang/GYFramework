//
//  GYMineScrollPageRootController.m
//  GYFramework
//
//  Created by Yang Ge on 2021/2/24.
//  Copyright © 2021 GeYang. All rights reserved.
//

#import "GYMineScrollPageRootController.h"
#import "GYMineCollectionViewController.h"

@interface GYMineScrollPageRootController () {
    NSArray *_subViewController;
}

@property (nonatomic, copy) NSString *naviTitle;
@property (nonatomic, strong) GYMineCollectionViewController *pageVC1;
@property (nonatomic, strong) GYMineCollectionViewController *pageVC2;

@end

@implementation GYMineScrollPageRootController
- (instancetype)initWithTitle:(NSString *)title {
    if (self = [super init]) {
        _naviTitle = title;
    }
    return self;
}

- (void)loadView {
    [super loadView];
    [self gy_navigation_initTitle:_naviTitle];
    [self gy_navigation_initLeftBackBtn:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _subViewController = @[self.pageVC1, self.pageVC2];
    [self addHorizontalViewControllers:_subViewController];
}

#pragma mark - getter and setter
- (GYMineCollectionViewController *)pageVC1 {
    if (!_pageVC1) {
        _pageVC1 = [[GYMineCollectionViewController alloc] initWithTitle:nil];
    }
    return _pageVC1;
}

- (GYMineCollectionViewController *)pageVC2 {
    if (!_pageVC2) {
        _pageVC2 = [[GYMineCollectionViewController alloc] initWithTitle:nil];
    }
    return _pageVC2;
}

@end
