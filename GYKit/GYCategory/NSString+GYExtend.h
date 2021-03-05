//
//  NSString+GYExtend.h
//  GYFramework
//
//  Created by Yang Ge on 2021/2/23.
//  Copyright © 2021 GeYang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (GYExtend)

- (CGSize)gy_calcSizeWithFont:(UIFont *)font
            constrainedToSize:(CGSize)size;

@end

NS_ASSUME_NONNULL_END
