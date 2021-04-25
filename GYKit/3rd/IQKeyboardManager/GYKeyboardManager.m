//
//  GYKeyboardManager.m
//  GYKit
//
//  Created by juguanhui on 2019/2/15.
//  Copyright © 2019 网家科技有限责任公司. All rights reserved.
//

#import "GYKeyboardManager.h"
#import "IQKeyboardManager.h"

@interface GYKeyboardManager()

@property (nonatomic, strong) IQKeyboardManager *keyboardMgr;

@end

@implementation GYKeyboardManager

+ (GYKeyboardManager *)defaultManager {
    static GYKeyboardManager *s_instance = nil;
    static dispatch_once_t once_token;
    dispatch_once(&once_token, ^{
        s_instance =  [[super allocWithZone:NULL] init];
    });
    return s_instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [GYKeyboardManager defaultManager];
}

- (instancetype)copyWithZone:(struct _NSZone *)zone {
    return [GYKeyboardManager defaultManager];
}

- (instancetype)mutableCopyWithZone:(nullable NSZone *)zone {
    return [GYKeyboardManager defaultManager];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _keyboardMgr = [IQKeyboardManager sharedManager];
    }
    return self;
}

- (void)registerApp {
    _keyboardMgr.shouldResignOnTouchOutside = YES;
    _keyboardMgr.shouldToolbarUsesTextFieldTintColor = YES;
    _keyboardMgr.keyboardDistanceFromTextField = 40;
//    _keyboardMgr.canAdjustAdditionalSafeAreaInsets = YES;
    _keyboardMgr.placeholderFont = [UIFont gy_CNFontSizeS1];
}

- (void)setEnable:(BOOL)enable {
    [_keyboardMgr setEnable:enable];
}

- (BOOL)isEnabled {
    return _keyboardMgr.isEnabled;
}

- (BOOL)keyboardIsShowing {
    return _keyboardMgr.keyboardShowing;
}

- (void)setKeyboardToNavigationDistance:(CGFloat)keyboardToNavigationDistance {
    [[IQKeyboardManager sharedManager] setKeyboardToNavigationDistance:keyboardToNavigationDistance];
}

@end
