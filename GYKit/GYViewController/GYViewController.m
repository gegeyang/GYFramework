//
//  GYViewController.m
//  GYFramework
//
//  Created by GeYang on 2018/6/1.
//  Copyright © 2018年 GeYang. All rights reserved.
//

#import "GYViewController.h"

@interface GYViewController () {
     BOOL _viewIsAppear;
}

@property (nonatomic, strong) UIView *navigationBar;
@property (nonatomic, assign) BOOL navigationBarHidden;
@property (nonatomic, strong) NSMutableArray *navigationLeftBtns;
@property (nonatomic, strong) NSMutableArray *navigationRightBtns;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, copy) void(^wj_base_backBlock)(void);
@property (nonatomic, copy) void(^wj_base_closeBlock)(void);

- (void)onApplicationWillResignActive:(NSNotification *)notify;
- (void)onApplicationDidBecomeActive:(NSNotification *)notify;

@end

@implementation GYViewController
- (instancetype)init {
    if (self = [super init]) {
        GYLog(@"%@ init", self.class);
        _viewIsAppear = NO;
        _navigationBarHidden = YES;
        NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
        [defaultCenter addObserver:self
                          selector:@selector(onApplicationWillResignActive:)
                              name:UIApplicationWillResignActiveNotification
                            object:nil];
        [defaultCenter addObserver:self
                          selector:@selector(onApplicationDidBecomeActive:)
                              name:UIApplicationDidBecomeActiveNotification
                            object:nil];
    }
    return self;
}

- (void)loadView {
    [super loadView];
    self.navigationBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.navigationBar];
    if (_navigationBarHidden) {
        _navigationBar.frame = CGRectMake(0, 0, self.view.gy_width, 0);
    } else {
        const CGFloat topInset = self.safeAreaInsets.top;
        _navigationBar.frame = CGRectMake(0, 0, self.view.gy_width, topInset + GYKIT_NAVIGATIONBAR_HEIGHT);
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.frame = CGRectMake(0, 0, self.view.gy_width, _navigationBarHidden ? 0 : self.safeAreaInsets.top + GYKIT_NAVIGATIONBAR_HEIGHT);
    self.view.backgroundColor = [UIColor gy_colorWithRGB:GYKIT_PAGEBG_COLOR_HEX];
    [self gy_navigation_layoutSubView];
    [self viewContentInsetDidChanged];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    _viewIsAppear = YES;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    _viewIsAppear = NO;
}

- (void)viewSafeAreaInsetsDidChange {
    [super viewSafeAreaInsetsDidChange];
    [self viewContentInsetDidChanged];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    GYLog(@"%@ dealloc", self.class);
}

#pragma mark - implementation
- (void)viewContentInsetDidChanged {
    self.navigationBar.frame = CGRectMake(0, 0, self.view.gy_width, _navigationBarHidden ? 0 : self.safeAreaInsets.top + GYKIT_NAVIGATIONBAR_HEIGHT);
    [self gy_navigation_layoutSubView];
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return GYKIT_STATUSBAR_STYLE;
}

- (void)forceRefresh:(BOOL)ignoreIsRefresh {
    
}

- (void)switchToParams:(NSDictionary *)params {
    
}

#pragma mark - Notification
- (void)onApplicationWillResignActive:(NSNotificationCenter *)notify {
    
}

- (void)onApplicationDidBecomeActive:(NSNotificationCenter *)notify {
    
}

#pragma mark - getter and setter
- (UIEdgeInsets)safeAreaInsets {
    if (@available(iOS 11.0, *)) {
        return self.view.safeAreaInsets;
    } else {
        return UIEdgeInsetsMake(20, 0, 0, 0);
    }
}

- (UIView *)navigationBar {
    if (!_navigationBar) {
        _navigationBar = [[UIView alloc] init];
        _navigationBar.backgroundColor = [UIColor gy_colorWithRGB:GYKIT_APP_MAIN_COLOR];
        [_navigationBar gy_drawBorderWithColor:[UIColor gy_colorWithRGB:GYKIT_PAGEBG_COLOR_HEX]
                                      lineType:GYDrawLineBottom];
    }
    return _navigationBar;
}

@end

@implementation GYViewController(GYAnimatedTransitioningExtend)

- (GYVCPushAnimationMode)preferredPushAnimationMode {
    return GYVCPushNormalMode;
}

@end

@implementation GYViewController(NavigationExtend)

- (UIButton *)gy_navigation_leftBtnAtIndex:(NSInteger)index {
    if (index < 0 || index >= _navigationLeftBtns.count) {
        return nil;
    }
    return [_navigationLeftBtns objectAtIndex:index];
}

- (UIButton *)gy_navigation_rightBtnAtIndex:(NSInteger)index {
    if (index < 0 || index >= _navigationRightBtns.count) {
        return nil;
    }
    return [_navigationRightBtns objectAtIndex:index];
}

- (void)gy_navigation_initLeftBackBtn:(void(^)(void))backBlock {
    self.wj_base_backBlock = backBlock;
    UIButton *btn = [[UIButton alloc] init];
    [btn setImage:GYKIT_IMAGE_BACK_WHITE
         forState:UIControlStateNormal];
    [btn setTitle:@"返回"
         forState:UIControlStateNormal];
    [btn addTarget:self
            action:@selector(gy_navigation_onBackClicked:)
  forControlEvents:UIControlEventTouchUpInside];
    [self gy_navigation_insertLeftBtn:btn
                              atIndex:0];
}

- (void)gy_navigation_onBackClicked:(id)sender {
    if (self.wj_base_backBlock) {
        self.wj_base_backBlock();
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)gy_navigation_insertLeftBtn:(UIButton *)btn
                            atIndex:(NSInteger)index {
    [self.navigationBar addSubview:btn];
    self.navigationBarHidden = NO;
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    btn.contentEdgeInsets = UIEdgeInsetsMake(0, GYKIT_GENERAL_H_MARGIN, 0, 0);
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, GYKIT_GENERAL_SPACING1, 0, 0);
    btn.titleLabel.font = [UIFont gy_CNFontSizeS1];
    [btn setTitleColor:[UIColor whiteColor]
              forState:UIControlStateNormal];
    if (!_navigationLeftBtns) {
        _navigationLeftBtns = [NSMutableArray array];
    }
    [_navigationLeftBtns insertObject:btn
                              atIndex:index];
}

- (void)gy_navigation_removeLeftBtnAtIndex:(NSInteger)index {
    if (index < 0 || index >= _navigationLeftBtns.count) {
        return;
    }
    UIButton *btn = [_navigationLeftBtns objectAtIndex:index];
    if (!btn) {
        return;
    }
    [btn removeFromSuperview];
    [_navigationLeftBtns removeObject:btn];
}

- (void)gy_navigation_insertRightBtn:(UIButton *)btn
                             atIndex:(NSInteger)index {
    [self.navigationBar addSubview:btn];
    self.navigationBarHidden = NO;
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    btn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, GYKIT_GENERAL_H_MARGIN);
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, GYKIT_GENERAL_SPACING1, 0, 0);
    btn.titleLabel.font = [UIFont gy_CNFontSizeS1];
    [btn setTitleColor:[UIColor whiteColor]
              forState:UIControlStateNormal];
    if (!_navigationRightBtns) {
        _navigationRightBtns = [NSMutableArray array];
    }
    [_navigationRightBtns insertObject:btn
                               atIndex:index];
}

- (void)gy_navigation_removeRightBtnAtIndex:(NSInteger)index {
    if (index < 0 || index >= _navigationRightBtns.count) {
        return;
    }
    UIButton *btn = [_navigationRightBtns objectAtIndex:index];
    if (!btn) {
        return;
    }
    [btn removeFromSuperview];
    [_navigationRightBtns removeObject:btn];
}

- (void)gy_navigation_initTitle:(NSString *)title {
    [self gy_navigation_checkAndCreateTitleLabel];
    _titleLabel.text = title;
}

- (void)gy_navigation_checkAndCreateTitleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self.navigationBar addSubview:_titleLabel];
        self.navigationBarHidden = NO;
    }
}

- (void)gy_navigation_setLeftHidden:(BOOL)hidden {
    for (UIButton *btn in _navigationLeftBtns) {
        btn.hidden = hidden;
    }
}

- (void)gy_navigation_setRightHidden:(BOOL)hidden {
    for (UIButton *btn in _navigationRightBtns) {
        btn.hidden = hidden;
    }
}

- (void)gy_navigation_layoutSubView {
    if (_navigationLeftBtns.count > 0
        || _navigationRightBtns.count > 0
        || _titleLabel) {
        _titleLabel.hidden = NO;
        const CGFloat topInset = self.safeAreaInsets.top;
        const BOOL hasTitle = self.titleLabel.text.length > 0;
        const CGFloat titleWidth = hasTitle ? ceilf([self.titleLabel textRectForBounds:CGRectMake(0, 0, roundf(self.view.gy_width / 2), CGFLOAT_MAX) limitedToNumberOfLines:1].size.width) : 0;
        const CGFloat btnMaxWidth = hasTitle ? roundf((self.view.gy_width - titleWidth) * 0.5 - GYKIT_GENERAL_SPACING1) : self.view.gy_width;
        __block CGFloat leftBtnAllWidth = 0;
        [_navigationLeftBtns enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            leftBtnAllWidth += [obj gy_navigationWidth:btnMaxWidth];
        }];
        __block CGFloat rightBtnAllWidth = 0;
        [_navigationRightBtns enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            const CGFloat contentWidth = [obj gy_contentWidth:CGFLOAT_MAX
                                                      spacing:GYKIT_GENERAL_SPACING1];
            rightBtnAllWidth += obj.hidden ? 0 : MIN(btnMaxWidth, contentWidth + GYKIT_GENERAL_SPACING1 + GYKIT_GENERAL_H_MARGIN);
        }];
        const CGFloat leftMaxRight = self.view.gy_width - titleWidth - rightBtnAllWidth - 20;
        __block CGFloat leftWidth = MIN(leftBtnAllWidth, btnMaxWidth);
        __block CGFloat leftMargin = 0;
        [_navigationLeftBtns enumerateObjectsUsingBlock:^(UIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            const CGFloat btnWidth = MAX(0, MIN([obj gy_navigationWidth:leftWidth], leftMaxRight - leftMargin));
            [obj mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(topInset);
                make.left.mas_equalTo(leftMargin);
                make.width.mas_equalTo(btnWidth);
                make.bottom.mas_equalTo(0);
            }];
            leftMargin += btnWidth;
            leftWidth -= btnWidth;
        }];
        __block CGFloat rightMargin = 0;
        [_navigationRightBtns enumerateObjectsWithOptions:NSEnumerationReverse
                                               usingBlock:^(UIButton *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            const CGFloat contentWidth = [obj gy_contentWidth:CGFLOAT_MAX
                                                      spacing:GYKIT_GENERAL_SPACING1];
            const CGFloat btnWidth = obj.hidden ? 0 : MIN(btnMaxWidth, contentWidth + GYKIT_GENERAL_SPACING1 + GYKIT_GENERAL_H_MARGIN);
            [obj mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(topInset);
                make.right.mas_equalTo(-rightMargin);
                make.width.mas_equalTo(btnWidth);
                make.bottom.mas_equalTo(0);
            }];
            rightMargin += btnWidth;
                                               }];
        const CGFloat maxMargin = MAX(leftMargin, rightMargin);
        [_titleLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(topInset);
            make.left.mas_equalTo(maxMargin);
            make.right.mas_equalTo(-maxMargin);
            make.bottom.mas_equalTo(0);
        }];
    } else {
        self.navigationBarHidden = YES;
    }
}

@end


