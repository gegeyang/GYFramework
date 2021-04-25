//
//  GYTextView.h
//  WJKit
//
//  Created by 琚冠辉 on 16/3/9.
//  Copyright © 2016年 网家科技有限责任公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GYTextView : UITextView

@property (nonatomic, assign) UIEdgeInsets gyContentInsets;
@property (nonatomic, copy) NSString *gyPlaceholder;  //文字
@property (nonatomic, strong) UIColor *gyPlaceholderColor; //文字颜色
@property (nonatomic, strong) UIColor *contentColor;
@property (nonatomic, assign) BOOL showBorder;
@property (nonatomic, assign) BOOL allowSupportResponderStandardEditActions;//是否支持系统编辑action

@end
