//
//  GYCountEditView.m
//  GYZF
//
//  Created by 琚冠辉 on 2020/3/24.
//  Copyright © 2020 网家科技有限责任公司. All rights reserved.
//

#import "GYCountEditView.h"
#import "GYTextField.h"

@interface GYCountEditView() <UITextFieldDelegate>

@property (nonatomic, assign) BOOL allowMaxInPut;
@property (nonatomic, copy) NSString *maxErrorTip;
@property (nonatomic, strong) UIButton *subBtn;
@property (nonatomic, strong) UIButton *addBtn;
@property (nonatomic, strong) GYTextField *countTextField;
@property (nonatomic, strong) NSDecimalNumber *minValue;
@property (nonatomic, strong) NSDecimalNumber *maxValue;
@property (nonatomic, assign) NSUInteger maximumDecimals;
@property (nonatomic, strong) NSDecimalNumber *defaultValue;

@end

@implementation GYCountEditView

- (instancetype)initWithMinValue:(NSDecimalNumber *)minValue
                        maxValue:(NSDecimalNumber *)maxValue
                 maximumDecimals:(NSUInteger)maximumDecimals {
    return [self initWithMinValue:minValue
                         maxValue:maxValue
                  maximumDecimals:maximumDecimals
                     defaultValue:minValue];
}

- (instancetype)initWithMinValue:(NSDecimalNumber *)minValue
                        maxValue:(NSDecimalNumber *)maxValue
                 maximumDecimals:(NSUInteger)maximumDecimals
                    defaultValue:(NSDecimalNumber *)defaultValue {
    if (self = [super init]) {
        NSAssert(minValue.doubleValue <= maxValue.doubleValue, @"error!!!");
        _minValue = minValue;
        _maxValue = maxValue;
        _countValue = minValue;
        _countColor = [UIColor gy_color6];
        _inputEnable = YES;
        _maximumDecimals = maximumDecimals;
        _defaultValue = defaultValue;
        
        _subBtn = [[UIButton alloc] init];
        [_subBtn gy_drawBorderWithLineType:GYDrawLineBorder];
        [_subBtn setImage:[UIImage imageNamed:@"common_count_sub"]
                 forState:UIControlStateNormal];
        [_subBtn setImage:[UIImage imageNamed:@"common_count_sub_disable"]
                 forState:UIControlStateDisabled];
        [_subBtn addTarget:self
                    action:@selector(onSubClicked:)
          forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_subBtn];
        
        _countTextField = [[GYTextField alloc] init];
        _countTextField.delegate = self;
        _countTextField.keyboardType = UIKeyboardTypeDecimalPad;
        _countTextField.gyContentInsets = UIEdgeInsetsZero;
        _countTextField.text = _countValue.stringValue;
        _countTextField.font = [UIFont gy_CNFontSizeS1];
        _countTextField.textColor = _countColor;
        _countTextField.adjustsFontSizeToFitWidth = YES;
        _countTextField.textAlignment = NSTextAlignmentCenter;
        [_countTextField gy_drawBorderWithLineType:GYDrawLineVertical];
        [self addSubview:_countTextField];
        
        _addBtn = [[UIButton alloc] init];
        [_addBtn gy_drawBorderWithLineType:GYDrawLineBorder];
        [_addBtn setImage:[UIImage imageNamed:@"common_count_add"]
                 forState:UIControlStateNormal];
        [_addBtn setImage:[UIImage imageNamed:@"common_count_add_disable"]
                 forState:UIControlStateDisabled];
        [_addBtn addTarget:self
                    action:@selector(onAddClicked:)
          forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_addBtn];
        
        [_subBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.mas_equalTo(0);
            make.width.equalTo(self.mas_height);
        }];
        [_addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.bottom.mas_equalTo(0);
            make.width.equalTo(self.mas_height);
        }];
        [_countTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(0);
            make.left.equalTo(self.subBtn.mas_right);
            make.right.equalTo(self.addBtn.mas_left);
        }];
    }
    return self;
}

#pragma mark - implementation
- (void)updateMinValue:(NSDecimalNumber *)minValue
              maxValue:(NSDecimalNumber *)maxValue
         allowMaxInPut:(BOOL)allowMaxInPut
           maxErrorTip:(NSString *)maxErrorTip {
    NSAssert(minValue.doubleValue <= maxValue.doubleValue, @"error!!!");
    _minValue = minValue;
    _maxValue = maxValue;
    _allowMaxInPut = allowMaxInPut;
    _maxErrorTip = maxErrorTip;
    if (_countTextField.text.doubleValue < _minValue.doubleValue) {
        _countValue = _minValue;
    } else if (_countTextField.text.doubleValue > _maxValue.doubleValue) {
        _countValue = _maxValue;
    }
    _countTextField.text = _countValue.stringValue;
    [self checkButtonStatus];
}

- (void)onSubClicked:(UIButton *)sender {
    if (self.subBlock) {
        self.subBlock();
    }
    [self checkButtonStatus];
}

- (void)onAddClicked:(UIButton *)sender {
    if (self.addBlock) {
        self.addBlock();
    }
    [self checkButtonStatus];
}

- (void)checkButtonStatus {
    self.addBtn.enabled = !([self.countValue decimalNumberByAdding:[NSDecimalNumber decimalNumberWithString:@"1"]].doubleValue > _maxValue.doubleValue);
    self.subBtn.enabled = !([self.countValue decimalNumberBySubtracting:[NSDecimalNumber decimalNumberWithString:@"1"]].doubleValue < _minValue.doubleValue);
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    self.addBtn.enabled = NO;
    self.subBtn.enabled = NO;
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    BOOL isHasPoint = [textField.text containsString:@"."] ? YES : NO;
    if (string.length > 0) {
        unichar single = [string characterAtIndex:0];
        //仅允许输入小数时 能输入.
        BOOL pointEnable = (_maximumDecimals > 0 && single == '.');
        // 不能输入.0-9以外的字符
        if (!((single >= '0' && single <= '9') || pointEnable)){
            return NO;
        }
        
        //已经输入过. 不能再输入  || 如果location后面位数过多 无法输入
        NSUInteger lastCount = textField.text.length - range.location;
        if ((isHasPoint && single == '.') || (single == '.' && lastCount > self.maximumDecimals)) {
            return NO;
        }
        
        //如果后面有值，第一位不允许输入0
        if (textField.text.length != 0 && (single == '0') && range.location == 0) {
            return NO;;
        }
        
        // 如果第一位是.则前面加上0.
        if (range.location == 0 && (single == '.')) {
            textField.text = [NSString stringWithFormat:@"0.%@", textField.text];
            return NO;
        }
        
        // 如果第一位是0则后面必须输入点，否则不能输入。
        if ([textField.text hasPrefix:@"0"]) {
            if (textField.text.length > 1) {
                NSString *secondStr = [textField.text substringWithRange:NSMakeRange(1, 1)];
                if (![secondStr isEqualToString:@"."]) {
                    return NO;
                }
            } else {
                if (![string isEqualToString:@"."] && range.location != 0) {
                    return NO;
                }
            }
        }
          
        //限制小数位数
        if (isHasPoint) {
            NSRange pointRange = [textField.text rangeOfString:@"."];
            //小数个数
            NSUInteger decimalsCount = NSMakeRange(pointRange.location + 1, textField.text.length - pointRange.location - 1).length;
            //当前输入的位置，在小数点后 && 小数位置已经大于或等于最大位数
            if (range.location > pointRange.location && decimalsCount >= _maximumDecimals) {
                return NO;
            }
        }
        
        //不判断最小 否则无法输入0
        NSString *toString = range.location >= textField.text.length ? [textField.text stringByAppendingString:string] : [textField.text stringByReplacingCharactersInRange:range withString:string];
        if (self.allowMaxInPut) {
            if ([NSDecimalNumber decimalNumberWithString:toString].doubleValue > _maxValue.doubleValue) {
                textField.text = _maxValue.stringValue;
                [[UIApplication sharedApplication].keyWindow gy_showStaticHUD:[NSString stringWithFormat:@"%@", _maxErrorTip]];
                return NO;
            }
        } else {
            if ([NSDecimalNumber decimalNumberWithString:toString].doubleValue > _maxValue.doubleValue) {
                [[UIApplication sharedApplication].keyWindow gy_showStaticHUD:[NSString stringWithFormat:@"不能大于%@", _maxValue.stringValue]];
                return NO;
            }
        }
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    NSDecimalNumber *countValue = [NSDecimalNumber decimalNumberWithString:textField.text];
    const BOOL isSmallerThanMax = (countValue.doubleValue <= _maxValue.doubleValue);
    const BOOL isBigerThanMin = (countValue.doubleValue >= _minValue.doubleValue);
    if (!isBigerThanMin) { //如果输入@"", countValue = NaN  默认进入当前判断
        textField.text = _defaultValue.stringValue;
        [[UIApplication sharedApplication].keyWindow gy_showStaticHUD:[NSString stringWithFormat:@"不能小于%@", _minValue.stringValue]];
    } else if (!isSmallerThanMax) {
        textField.text = _maxValue.stringValue;
        [[UIApplication sharedApplication].keyWindow gy_showStaticHUD:[NSString stringWithFormat:@"不能大于%@", _maxValue.stringValue]];
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    self.countValue = [NSDecimalNumber decimalNumberWithString:textField.text];
    if (self.endEditBlock) {
        self.endEditBlock(_countValue);
    }
    [self checkButtonStatus];
}

#pragma mark - getters and setters
- (void)setCountValue:(NSDecimalNumber *)countValue {
    if (countValue.doubleValue >= _minValue.doubleValue && countValue.doubleValue <= _maxValue.doubleValue) {
        _countValue = countValue;
        _countTextField.text = countValue.stringValue;
        [self checkButtonStatus];
    }
}

- (void)setCountColor:(UIColor *)countColor {
    _countColor = countColor;
    _countTextField.textColor = _countColor;
}

- (void)setInputEnable:(BOOL)inputEnable {
    _inputEnable = inputEnable;
    _countTextField.enabled = inputEnable;
}

@end
