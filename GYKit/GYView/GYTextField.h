//
//  GYTextField.h
//  GYKit
//
//  Created by 琚冠辉 on 16/3/9.
//  Copyright © 2016年 网家科技有限责任公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GYTextField : UITextField

@property (nonatomic, assign) UIEdgeInsets gyContentInsets;
@property (nonatomic, strong) UIColor *gyPlaceholderColor;
@property (nonatomic, assign) NSInteger limitMaxLenth;

- (void)gySetPlaceholder:(NSString *)placeholder color:(UIColor *)color;

@end
