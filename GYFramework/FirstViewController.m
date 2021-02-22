//
//  FirstViewController.m
//  GYFramework
//
//  Created by GeYang on 2018/7/7.
//  Copyright © 2018年 GeYang. All rights reserved.
//

#import "FirstViewController.h"
#import "GYViewController+GYNavBarExtend.h"
#import "NewViewController.h"
#import "GYCoordinatingMediator.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)loadView {
    [super loadView];
    [self gy_navigation_initTitle:@"第一页"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *btn =  [UIButton buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.3];
    [btn setTitle:@"普通跳转" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.size.mas_equalTo(CGSizeMake(100, 40));
        make.top.equalTo(self.navigationBar.mas_bottom).offset(15);
    }];
    
    UIButton *btn1 =  [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.3];
    [btn1 setTitle:@"tabbar跳转" forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(onClick1:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.size.mas_equalTo(CGSizeMake(100, 40));
        make.top.equalTo(btn.mas_bottom).offset(15);
    }];
    
    UIButton *btn2 =  [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.3];
    [btn2 setTitle:@"协议跳转" forState:UIControlStateNormal];
    [btn2 addTarget:self action:@selector(onClick2:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn2];
    [btn2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.size.mas_equalTo(CGSizeMake(100, 40));
        make.top.equalTo(btn1.mas_bottom).offset(15);
    }];
}


- (void)onClick:(UIButton *)sender {
    NewViewController *new = [[NewViewController alloc] init];
    [self.navigationController pushViewController:new animated:YES];
}

- (void)onClick1:(UIButton *)sender {
    [[GYCoordinatingMediator shareInstance] requestWithTag:GYCoordinatingControllerTagSecondPage params:nil];
}
- (void)onClick2:(UIButton *)sender {
    [[GYCoordinatingMediator shareInstance] requestWithTag:GYCoordinatingControllerTagNew params:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
