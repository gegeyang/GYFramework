//
//  GYKeyboardManager.h
//  GYKit
//
//  Created by juguanhui on 2019/2/15.
//  Copyright © 2019 网家科技有限责任公司. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GYKeyboardManager : NSObject

@property(nonatomic, assign, getter = isEnabled) BOOL enable;
@property(nonatomic, readonly) BOOL keyboardIsShowing;
@property(nonatomic, assign) CGFloat keyboardToNavigationDistance;

+ (GYKeyboardManager *)defaultManager;

- (void)registerApp;

@end

NS_ASSUME_NONNULL_END
