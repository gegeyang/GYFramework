//
//  GYAlertController.h
//  GYFramework
//
//  Created by Yang Ge on 2021/3/23.
//  Copyright © 2021 GeYang. All rights reserved.
//

#import "GYViewController.h"

typedef NS_ENUM(NSInteger, GYAlertActionStyle) {
    GYAlertActionStyleDefault = 0, // 字体颜色为灰色，文字居中
    GYAlertActionStyleBold, // 字体颜色为灰色加粗，文字居中
};

typedef NS_ENUM(NSInteger, GYAlertControllerStyle) {
    GYAlertControllerStyleActionSheet,
    GYAlertControllerStyleAlert,
};

NS_ASSUME_NONNULL_BEGIN

@interface GYAlertAction : NSObject

+ (instancetype _Nonnull )actionWithTitle:(nullable NSString *)title
                                    style:(GYAlertActionStyle)style
                                  handler:(void (^ __nullable)(GYAlertAction * _Nullable action))handler;
+ (instancetype _Nonnull )actionWithAttributedTitle:(nullable NSAttributedString *)attributedTitle
                                              style:(GYAlertActionStyle)style
                                            handler:(void (^ __nullable)(GYAlertAction * _Nullable action))handler;

@property (nonatomic, readonly) GYAlertActionStyle actionStyle;
@property (nonatomic, assign) BOOL enabled;
@property (nullable, nonatomic, readonly) void(^handler)(GYAlertAction * _Nullable action);

@end

@interface GYAlertAction(NormalExtend)

+ (instancetype _Nonnull )cancelAction;

@end

@interface GYAlertController : GYViewController

+ (instancetype _Nonnull )alertControllerWithAttributedTitle:(nullable NSAttributedString *)attributedTitle
                                              preferredStyle:(GYAlertControllerStyle)preferredStyle;

- (void)addCancelAction:(GYAlertAction *_Nonnull)action;
- (void)addOtherActions:(NSArray<GYAlertAction *> *_Nonnull)arrAction;

- (CGFloat)calcAllHeight:(CGFloat)givenWidth;

@property (nonatomic, readonly) GYAlertControllerStyle preferredStyle;

@end

@interface NSAttributedString(GYAlertControllerExtend)

+ (instancetype _Nullable)gy_alert_attributedString:(NSString * _Nullable)title
                                            message:(NSString * _Nullable)message;

@end

NS_ASSUME_NONNULL_END
