//
//  GYTextView.m
//  GYKit
//
//  Created by 琚冠辉 on 16/3/9.
//  Copyright © 2016年 网家科技有限责任公司. All rights reserved.
//

#import "GYTextView.h"
#import "UIImage+GYExtend.h"
#import "UIColor+GYExtend.h"
#import "UIFont+GYExtend.h"
#import "UIView+GYExtend.h"

#define kRequiredWidth 15

@interface GYTextView()

@property (nonatomic, strong) UILabel *gyPlaceholderLabel;

@end

@implementation GYTextView

#pragma mark - life cycle
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        _contentColor = nil;
        self.scrollsToTop = NO;
        self.showBorder = YES;
        self.gyContentInsets = UIEdgeInsetsMake(8, 8, 8, 8);
        self.backgroundColor = [UIColor clearColor];
        
        _gyPlaceholderLabel = [[UILabel alloc] init];
        _gyPlaceholderLabel.backgroundColor = [UIColor  clearColor];
        _gyPlaceholderLabel.numberOfLines = 0;
        [self insertSubview:_gyPlaceholderLabel atIndex:0];
                
        self.allowSupportResponderStandardEditActions = YES;
        self.gyPlaceholderColor = [UIColor gy_colorC];
        self.font = [UIFont gy_CNFontSizeS1];
        self.textColor = [UIColor gy_color6];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(textDidChange)
                                                     name:UITextViewTextDidChangeNotification
                                                   object:self];
    }
    return self;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setWjContentInsets:(UIEdgeInsets)gyContentInsets {
    _gyContentInsets = gyContentInsets;
    gyContentInsets.left -= 3;
    gyContentInsets.right -= 3;
    self.textContainerInset = gyContentInsets;
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    const UIEdgeInsets insets = self.gyContentInsets;
    const CGFloat width = self.gy_width - insets.left - insets.right;
    const CGFloat height = ceilf([self.gyPlaceholderLabel.text boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                                                            options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                                                         attributes:@{NSFontAttributeName: self.gyPlaceholderLabel.font}
                                                                            context:nil].size.height);
    self.gyPlaceholderLabel.frame = CGRectMake(insets.left, insets.top, width, height);
}

- (NSString *)gyPlaceholder {
    return self.gyPlaceholderLabel.text;
}

- (void)setWjPlaceholder:(NSString*)gyPlaceholder{
    self.gyPlaceholderLabel.text = gyPlaceholder;
    [self setNeedsLayout];
}

- (void)setWjPlaceholderColor:(UIColor*)placeholderColor{
    _gyPlaceholderColor = placeholderColor;
    self.gyPlaceholderLabel.textColor = placeholderColor;
}

- (void)setShowBorder:(BOOL)showBorder {
    _showBorder = showBorder;
    [self setNeedsLayout];
}

- (void)setFont:(UIFont*)font {
    [super setFont:font];
    self.gyPlaceholderLabel.font = font;
    [self setNeedsLayout];
}

- (void)setText:(NSString*)text{
    [super setText:text];
    [self textDidChange];
}

- (void)setAttributedText:(NSAttributedString*)attributedText {
    [super setAttributedText:attributedText];
    [self textDidChange];
}

#pragma mark - 监听文字改变
- (void)textDidChange {
    self.gyPlaceholderLabel.hidden = self.hasText;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if (!_allowSupportResponderStandardEditActions) {
        return NO;
    }
    return (action == @selector(paste:) ||
            action == @selector(selectAll:) ||
            action == @selector(copy:));
}

@end
