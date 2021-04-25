//
//  GYCommentInputView.m
//  GYZF
//
//  Created by GeYang on 2019/4/24.
//  Copyright © 2019 网家科技有限责任公司. All rights reserved.
//

#import "GYCommentInputView.h"
#import "GYTextView.h"
#import "GYCoordinatingMediator.h"

#define kSendButtonWidth   55
#define KBottomViewHeight  155

@interface GYCommentInputView () <UITextViewDelegate>

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, strong) UIButton *sendButton;
@property (nonatomic, strong) GYTextView *textView;

@end

@implementation GYCommentInputView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onClickOther:)];
        [self addGestureRecognizer:tap];
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        [self addSubview:self.bottomView];
        [self.bottomView addSubview:self.textView];
        [self.bottomView addSubview:self.sendButton];
    }
    return self;
}

- (void)onClickOther:(UITapGestureRecognizer *)tap {
    [self removeFromSuperview];
    if (self.onClickRemove) {
        self.onClickRemove();
    }
}

- (void)onClickSend:(UIButton *)sender {
    [self removeFromSuperview];
    if (self.onClickSend) {
        self.onClickSend(self.textView.text);
    }
}

- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length > 0) {
        self.sendButton.enabled = YES;
    } else {
        self.sendButton.enabled = NO;
    }
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.gy_height - KBottomViewHeight, self.gy_width, KBottomViewHeight)];
        _bottomView.backgroundColor = [UIColor whiteColor];
    }
    return _bottomView;
}

- (GYTextView *)textView {
    if (!_textView) {
        _textView = [[GYTextView alloc] initWithFrame:CGRectMake(GYKIT_GENERAL_H_MARGIN, GYKIT_GENERAL_H_MARGIN, self.bottomView.gy_width - GYKIT_GENERAL_H_MARGIN - kSendButtonWidth, _bottomView.gy_height - GYKIT_GENERAL_H_MARGIN * 2)];
        _textView.textColor = [UIColor gy_color6];
        _textView.gyPlaceholderColor = [UIColor gy_color9];
        _textView.font = [UIFont gy_CNFontSizeS1];
        _textView.delegate = self;
        _textView.layoutManager.allowsNonContiguousLayout = NO;
        _textView.layer.borderWidth = 0.5;
        _textView.layer.borderColor = [UIColor gy_colorWithRGB:0xE9E9E9].CGColor;
    }
    return _textView;
}

- (UIButton *)sendButton {
    if (!_sendButton) {
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _sendButton.frame = CGRectMake(_textView.gy_x1, _bottomView.gy_height - kSendButtonWidth, kSendButtonWidth, kSendButtonWidth);
        [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
        [_sendButton setTitleColor:[UIColor gy_color9] forState:UIControlStateDisabled];
        [_sendButton setTitleColor:[UIColor gy_colorWithRGB:GYKIT_APP_MAIN_COLOR] forState:UIControlStateNormal];
        _sendButton.enabled = NO;
        _sendButton.titleLabel.font = [UIFont gy_CNFontSizeS1];
        [_sendButton addTarget:self action:@selector(onClickSend:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendButton;
}

@end

@implementation GYViewController(CommentInputExtend)

#pragma mark - 显示回复弹窗
- (void)gy_comment_openCommentView:(NSString *)placeholder
                         sendBlock:(void(^)(NSString *comment))sendBlock
                       removeBlock:(void(^)(void))removeBlock {
    GYViewController *controller = [GYCoordinatingMediator shareInstance].activeViewController;
    GYCommentInputView *commentView = [[GYCommentInputView alloc] initWithFrame:controller.view.bounds];
    commentView.textView.gyPlaceholder = placeholder;
    commentView.onClickSend = sendBlock;
    [controller.view addSubview:commentView];
    [commentView.textView becomeFirstResponder];
}

#pragma mark -
- (void)gy_comment_openCommentView:(nullable NSString *)placeholder
                         sendTitle:(NSString *)sendTitle
                         sendBlock:(void(^)(NSString *comment))sendBlock {
    GYViewController *controller = [GYCoordinatingMediator shareInstance].activeViewController;
    GYCommentInputView *commentView = [[GYCommentInputView alloc] initWithFrame:controller.view.bounds];
    commentView.textView.gyPlaceholder = placeholder;
    commentView.onClickSend = sendBlock;
    [commentView.sendButton setTitle:sendTitle forState:UIControlStateNormal];
    [controller.view addSubview:commentView];
    [commentView.textView becomeFirstResponder];
}

@end
