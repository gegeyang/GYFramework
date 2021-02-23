//
//  MineCollectionViewController.m
//  GYFramework
//
//  Created by GeYang on 2018/9/12.
//  Copyright © 2018年 GeYang. All rights reserved.
//

#import "MineCollectionViewController.h"
#import "GYViewController+GYNavBarExtend.h"

@interface MineCollectionViewController ()

@end

@implementation MineCollectionViewController

- (void)loadView {
    [super loadView];
    [self gy_navigation_initTitle:@"Collection List"];
    [self gy_navigation_initLeftBackBtn:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

@end
