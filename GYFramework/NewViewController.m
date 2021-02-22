//
//  NewViewController.m
//  GYFramework
//
//  Created by GeYang on 2018/9/12.
//  Copyright © 2018年 GeYang. All rights reserved.
//

#import "NewViewController.h"
#import "GYViewController+GYNavBarExtend.h"

@interface NewViewController ()

@end

@implementation NewViewController

- (void)loadView {
    [super loadView];
    [self gy_navigation_initTitle:@"NEW"];
    [self gy_navigation_initLeftBackBtn:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
