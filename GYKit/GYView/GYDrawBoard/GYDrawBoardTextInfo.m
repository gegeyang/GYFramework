//
//  GYDrawBoardTextInfo.m
//  GYZF
//
//  Created by Yang Ge on 2020/11/20.
//  Copyright © 2020 网家科技有限责任公司. All rights reserved.
//

#import "GYDrawBoardTextInfo.h"
#import "NSString+GYExtend.h"

#define GYDrawBoardTextActionKey        @"key"
#define GYDrawBoardTextActionValue      @"value"
#define GYDrawBoardTextActionOriginal   @"original"

typedef NS_ENUM(NSInteger, GYDrawBoardTextActionType) {
    GYDrawBoardTextActionTypeForMove,
    GYDrawBoardTextActionTypeForEdit,
};

#define kTextInfoMargin  20

@interface GYDrawBoardTextInfo ()

@property (nonatomic, assign) CGPoint endPoint;
@property (nonatomic, copy) NSString *endString;
@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) NSMutableArray *actionMuarr;

@end

@implementation GYDrawBoardTextInfo

- (instancetype)initWithOriginalPoint:(CGPoint)originalPoint
                       originalString:(NSString *)originalString {
    if (self = [super init]) {
        _endString = originalString;
        _endPoint = originalPoint;
        _textLabel = [[UILabel alloc] init];
        _textLabel.font = [UIFont gy_CNFontSizeS1];
        _textLabel.numberOfLines = 0;
        _textLabel.text = originalString;
        _textLabel.textAlignment = NSTextAlignmentCenter;
        _textLabel.backgroundColor = [UIColor whiteColor];
        _textLabel.userInteractionEnabled = YES;
        self.textString = originalString;
        self.textPoint = originalPoint;
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                       action:@selector(onPan:)];
        [_textLabel addGestureRecognizer:pan];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(onTap:)];
        [_textLabel addGestureRecognizer:tap];
    }
    return self;
}

#pragma mark - implementation
- (void)onPan:(UIPanGestureRecognizer *)pan {
    if ([self.delegate respondsToSelector:@selector(gy_drawBoradTextDidPan:textInfo:)]) {
        [self.delegate gy_drawBoradTextDidPan:pan
                                     textInfo:self];
    }
}

- (void)onTap:(UITapGestureRecognizer *)tap {
    if ([self.delegate respondsToSelector:@selector(gy_drawBoradTextDidTap:textInfo:)]) {
        [self.delegate gy_drawBoradTextDidTap:tap
                                     textInfo:self];
    }
}

//添加移动位置
- (void)addMovePoint:(CGPoint)point {
    [self.actionMuarr addObject:@{
        GYDrawBoardTextActionKey : @(GYDrawBoardTextActionTypeForMove),
        GYDrawBoardTextActionValue : NSStringFromCGPoint(point),
        GYDrawBoardTextActionOriginal : NSStringFromCGPoint(_endPoint),
    }];
    _endPoint = point;
}

//添加文字编辑
- (void)addTextEdit:(NSString *)string {
    [self.actionMuarr addObject:@{
        GYDrawBoardTextActionKey : @(GYDrawBoardTextActionTypeForEdit),
        GYDrawBoardTextActionValue : string,
        GYDrawBoardTextActionOriginal : _endString,
    }];
    _endString = string;
}

#pragma mark - getter and setter
- (BOOL)checkAndRepealLastAction {
    if (self.actionMuarr.count == 0) {
        return NO;
    }
    NSDictionary *actionDict = self.actionMuarr.lastObject;
    GYDrawBoardTextActionType actionType = ([[actionDict objectForKey:GYDrawBoardTextActionKey] integerValue]);
    switch (actionType) {
        case GYDrawBoardTextActionTypeForMove: {
            CGPoint point = CGPointFromString([actionDict objectForKey:GYDrawBoardTextActionOriginal]);
            self.textPoint = point;
        }
            break;
        case GYDrawBoardTextActionTypeForEdit: {
            NSString *string = [actionDict objectForKey:GYDrawBoardTextActionOriginal];
            self.textString = string;
        }
            break;
        default:
            break;
    }
    [self.actionMuarr removeLastObject];
    return YES;
}

- (void)setTextColor:(UIColor *)textColor {
    _textColor = textColor;
    _textLabel.textColor = textColor;
}

- (void)setTextString:(NSString *)textString {
    _textString = textString;
    _textLabel.text = textString;
    _textLabel.frame = CGRectMake(0, 0, [self textSize].width + kTextInfoMargin, [self textSize].height + kTextInfoMargin);
    _textLabel.center = self.textPoint;
}

- (CGSize)textSize {
    CGSize maxSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - GYKIT_GENERAL_H_MARGIN * 2, [UIScreen mainScreen].bounds.size.height);
    CGSize size = [_textString gy_calcSizeWithFont:[UIFont gy_CNFontSizeS1]
                                constrainedToSize:maxSize];
    return size;
}

- (void)setTextPoint:(CGPoint)textPoint {
    _textPoint = textPoint;
    _textLabel.center = self.textPoint;
}

- (NSMutableArray *)actionMuarr {
    if (!_actionMuarr) {
        _actionMuarr = [NSMutableArray array];
    }
    return _actionMuarr;
}

@end
