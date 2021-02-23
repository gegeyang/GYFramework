//
//  GYTabbarViewController.m
//  GYFramework
//
//  Created by GeYang on 2018/6/1.
//  Copyright © 2018年 GeYang. All rights reserved.
//

#import "GYTabbarViewController.h"
#import "GYTabbarView.h"
#import "FirstViewController.h"
#import "SecondViewController.h"
#import "ThirdViewController.h"
#import "GYTabbarItemInfo.h"
#import "GYTabbarButton.h"

@interface GYTabbarViewController ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) GYViewController *activeViewController;
@property (nonatomic, strong) NSMutableArray <GYTabbarItemInfo *> *arrItemInfo;
@property (nonatomic, strong) GYTabbarView *tabbarView;
@property (nonatomic, assign) NSInteger homePageTag;
@property (nonatomic, strong) GYTabbarItemInfo *itemInfo1;
@property (nonatomic, strong) GYTabbarItemInfo *itemInfo2;
@property (nonatomic, strong) GYTabbarItemInfo *itemInfo3;

@end

@implementation GYTabbarViewController
- (instancetype)init {
    if (self = [super init]) {
        FirstViewController *firstVC = [[FirstViewController alloc] init];
        self.itemInfo1 = [GYTabbarItemInfo mainBarItemInfoWithTitle:NSLocalizedString(@"第一页", nil)
                                                         normalImage:[UIImage imageNamed:@"first_tabbar_normal"]
                                                       selectedImage:[UIImage imageNamed:@"first_tabbar_selected"]
                                                             itemTag:GYCoordinatingControllerTagFirstPage
                                                      viewController:firstVC];
        
        SecondViewController *secondVC = [[SecondViewController alloc] init];
        self.itemInfo2 = [GYTabbarItemInfo mainBarItemInfoWithTitle:NSLocalizedString(@"第二页", nil)
                                                         normalImage:[UIImage imageNamed:@"second_tabbar_normal"]
                                                       selectedImage:[UIImage imageNamed:@"second_tabbar_selected"]
                                                             itemTag:GYCoordinatingControllerTagSecondPage
                                                      viewController:secondVC];
        
        ThirdViewController *thirdVC = [[ThirdViewController alloc] init];
        self.itemInfo3 = [GYTabbarItemInfo mainBarItemInfoWithTitle:NSLocalizedString(@"第三页", nil)
                                                         normalImage:[UIImage imageNamed:@"third_tabbar_normal"]
                                                       selectedImage:[UIImage imageNamed:@"third_tabbar_selected"]
                                                             itemTag:GYCoordinatingControllerTagThirdPage
                                                      viewController:thirdVC];
        
        _arrItemInfo = [NSMutableArray array];
        [_arrItemInfo addObject:self.itemInfo1];
        [_arrItemInfo addObject:self.itemInfo2];
        [_arrItemInfo addObject:self.itemInfo3];
        _homePageTag = GYCoordinatingControllerTagFirstPage;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    [self.view addSubview:self.toolBar];
    const CGFloat toolBarHeight = _arrItemInfo.count <= 1 ? 0 : GYKIT_TABBAR_HEIGHT + self.safeAreaInsets.bottom;
    [_tabbarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.height.mas_equalTo(toolBarHeight);
    }];
    [self updateItemInfos:self.arrItemInfo];
    
    //设置tabbar上圆点
    [self.itemInfo2.barItem setBadgeValue:46];
}

- (void)viewContentInsetDidChanged {
    [super viewContentInsetDidChanged];
    const CGFloat toolBarHeight = _arrItemInfo.count <= 1 ? 0 : GYKIT_TABBAR_HEIGHT + self.safeAreaInsets.bottom;
    [_tabbarView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(toolBarHeight);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - implementation
- (void)updateItemInfos:(NSMutableArray<GYTabbarItemInfo *> *)arrItemInfo {
    NSMutableArray *arrItem = [NSMutableArray array];
    for (GYTabbarItemInfo *info in arrItemInfo) {
        [arrItem addObject:info.barItem];
    }
    [_tabbarView updateItems:arrItem];
}

- (void)switchToViewController:(NSInteger)tag params:(NSDictionary *)params {
    if (_activeViewController && (_activeViewController.view.tag == tag)) {
        if (params) {
            [_activeViewController switchToParams:params];
        } else {
            [_activeViewController forceRefresh:NO];
        }
        return;
    }
    const CGFloat vcHeight = self.view.gy_height - GYKIT_TABBAR_HEIGHT + 1;
    for (GYTabbarItemInfo *itemInfo in _arrItemInfo) {
        GYViewController *vc = itemInfo.viewController;
        const BOOL isSelected = (vc.view.tag == tag);
        if (isSelected) {
            [vc switchToParams:params];
            [_activeViewController removeFromParentViewController];
            [_activeViewController.view removeFromSuperview];
            _activeViewController = vc;
            [self addChildViewController:vc];
            vc.view.frame = CGRectMake(0, 0, self.view.gy_width, vcHeight);
            [self.view addSubview:vc.view];
            [self.view insertSubview:vc.view belowSubview:self.toolBar];
            break;
        }
    }
    for (UIView *subView in self.toolBar.subviews) {
        if ([subView isKindOfClass:[GYTabbarButton class]]) {
            GYTabbarButton *tabItem = (GYTabbarButton *)subView;
            const BOOL isSelected = (tabItem.tag == tag);
            [tabItem setSelected:isSelected];
        }
    }
}

- (void)switchToHomePage:(NSDictionary *)params {
    const BOOL animation = [params[@"animtaion"] boolValue];
    [self switchToViewController:_homePageTag
                          params:params];
    [self.navigationController popToRootViewControllerAnimated:animation];
}

#pragma mark - getter and setter
- (GYTabbarView *)toolBar {
    if (!_tabbarView) {
        _tabbarView = [[GYTabbarView alloc] init];
        __weak typeof(self) weakself = self;
        _tabbarView.selectItemBlock = ^(NSInteger tag) {
            __strong typeof(weakself) strongself = weakself;
            [strongself switchToViewController:tag
                                        params:nil];
        };
    }
    return _tabbarView;
}

@end
