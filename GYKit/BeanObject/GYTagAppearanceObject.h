//
//  GYTagAppearanceObject.h
//  GYFramework
//
//  Created by Yang Ge on 2021/2/23.
//  Copyright © 2021 GeYang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol GYTagAppearanceObject <NSObject>

- (UIColor *)tagBorderColor;
- (UIColor *)tagFillColor;
- (UIColor *)tagNameColor;
- (UIFont *)tagNameFont;

@optional
- (UIEdgeInsets)tagContentInset;
- (CGSize)tagFixedSize;

@end

NS_ASSUME_NONNULL_END
