//
//  GYCommentInputView.h
//  GYZF
//
//  Created by GeYang on 2019/4/24.
//  Copyright © 2019 网家科技有限责任公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYTextView.h"

NS_ASSUME_NONNULL_BEGIN

@interface GYCommentInputView : UIView

@property (nonatomic, copy) void(^onClickSend)(NSString *comment);
@property (nonatomic, copy) void(^onClickRemove)(void);
@property (nonatomic, readonly) GYTextView *textView;

@end

@interface GYViewController(CommentInputExtend)

#pragma mark - 显示回复弹窗
- (void)gy_comment_openCommentView:(nullable NSString *)placeholder
                         sendBlock:(void(^)(NSString *comment))sendBlock
                       removeBlock:(nullable void(^)(void))removeBlock;
#pragma mark - 
- (void)gy_comment_openCommentView:(nullable NSString *)placeholder
                         sendTitle:(NSString *)sendTitle
                         sendBlock:(void(^)(NSString *comment))sendBlock;

@end

NS_ASSUME_NONNULL_END
