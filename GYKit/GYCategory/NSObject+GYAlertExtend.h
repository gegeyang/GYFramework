//
//  NSObject+GYAlertExtend.h
//  GYFramework
//
//  Created by Yang Ge on 2021/3/23.
//  Copyright © 2021 GeYang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GYAlertController.h"

NS_ASSUME_NONNULL_BEGIN

@interface NSObject (GYAlertExtend)

- (void)gy_alertWithTitle:(NSString * _Nullable)title
                  message:(NSString * _Nullable)message
               alertStyle:(GYAlertControllerStyle)alertStyle
             cancelAction:(GYAlertAction * _Nullable)cancelAction
              otherAction:(GYAlertAction * _Nullable)otherAction, ... NS_REQUIRES_NIL_TERMINATION;

- (void)gy_alertWithAttributedTitle:(NSAttributedString * _Nullable)attributedTitle
                         alertStyle:(GYAlertControllerStyle)alertStyle
                       cancelAction:(GYAlertAction * _Nullable)cancelAction
                       otherActions:(NSArray<GYAlertAction *> * _Nullable)otherActions
                             inView:(UIView * _Nullable)inView;

- (void)gy_hideAlertController;

- (void)gy_alertWithTitle:(NSString * _Nullable)title
                  message:(NSString * _Nullable)message
             cancelEnable:(BOOL)cancelEnable
            confirmAction:(GYAlertAction * _Nonnull)confirmAction;


@end

NS_ASSUME_NONNULL_END
