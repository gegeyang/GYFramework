//
//  GYTextField.m
//  GYKit
//
//  Created by 琚冠辉 on 16/3/9.
//  Copyright © 2016年 网家科技有限责任公司. All rights reserved.
//

#import "GYTextField.h"
#import "UIFont+GYExtend.h"
#import "UIColor+GYExtend.h"

@implementation GYTextField

- (void)initDefaultParams {
    _limitMaxLenth = 0;
    self.font = [UIFont gy_CNFontSizeS1];
    self.textColor = [UIColor gy_color6];
    self.gyPlaceholderColor = [UIColor gy_color9];
    self.gyContentInsets = UIEdgeInsetsMake(8, 8, 8, 8);
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self initDefaultParams];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initDefaultParams];
    }
    return self;
}

- (void)gySetPlaceholder:(NSString *)placeholder color:(UIColor *)color {
    self.gyPlaceholderColor = color;
    [self setPlaceholder:placeholder];
}

- (void)setPlaceholder:(NSString *)placeholder {
    [super setPlaceholder:placeholder];
    
    if (placeholder.length > 0) {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSForegroundColorAttributeName] = self.gyPlaceholderColor;
        dict[NSFontAttributeName] = self.font;
        NSAttributedString *attribute = [[NSAttributedString alloc] initWithString:self.placeholder attributes:dict];
        [self setAttributedPlaceholder:attribute];
    }
}

// placeholder position
- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectMake(self.gyContentInsets.left,
                      self.gyContentInsets.top,
                      bounds.size.width - self.gyContentInsets.left - self.gyContentInsets.right,
                      bounds.size.height - self.gyContentInsets.top - self.gyContentInsets.bottom);
}

// text position
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectMake(self.gyContentInsets.left,
                      self.gyContentInsets.top,
                      bounds.size.width - self.gyContentInsets.left - self.gyContentInsets.right,
                      bounds.size.height - self.gyContentInsets.top - self.gyContentInsets.bottom);
}

- (void)textValueChange:(UITextField *)textField {
    if (_limitMaxLenth == 0) {
        return;
    }
    NSString *toBeString = textField.text;
    UITextRange *selectedRange = [textField markedTextRange];
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
    if (!position || !selectedRange) {
        if (toBeString.length > self.limitMaxLenth) {
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:self.limitMaxLenth];
            if (rangeIndex.length == 1) {
                textField.text = [toBeString substringToIndex:self.limitMaxLenth];
            } else {
                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, self.limitMaxLenth)];
                textField.text = [toBeString substringWithRange:rangeRange];
            }
        }
    }
}

#pragma mark - getters and setters
- (void)setLimitMaxLenth:(NSInteger)limitMaxLenth {
    _limitMaxLenth = limitMaxLenth;
    if (limitMaxLenth > 0) {
        [self addTarget:self
                 action:@selector(textValueChange:)
       forControlEvents:UIControlEventEditingChanged];
    } else {
        [self removeTarget:self
                    action:@selector(textValueChange:)
          forControlEvents:UIControlEventEditingChanged];
    }
}

@end
