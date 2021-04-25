//
//  GYDrawBoardView.m
//  GYZF
//
//  Created by Yang Ge on 2020/11/19.
//  Copyright © 2020 网家科技有限责任公司. All rights reserved.
//

#import "GYDrawBoardView.h"
#import "GYDrawBoardLineInfo.h"
#import "GYDrawBoardTextInfo.h"
#import "GYCoordinatingMediator.h"
#import "GYCommentInputView.h"

@interface GYDrawBoardView () <UIGestureRecognizerDelegate, GYDrawBoardTextDelegete>

@property (nonatomic, assign) CGContextRef context;
@property (nonatomic, strong) UIPanGestureRecognizer *pan;
@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, assign) CGFloat lineWidth;

//存放绘制的线
@property (nonatomic, strong) NSMutableArray *lineArray;
//存放绘制的文字
@property (nonatomic, strong) NSMutableArray *textArray;
//存在当前绘制的线经过的点
@property (nonatomic, strong) NSMutableArray *actionPointArray;
@property (nonatomic, strong) NSMutableArray *allActionArr;
@property (nonatomic, assign) CGPoint differencePoint;

@end

@implementation GYDrawBoardView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.lineArray = [NSMutableArray array];
        self.textArray = [NSMutableArray array];
        self.actionPointArray = [NSMutableArray array];
        self.allActionArr = [NSMutableArray array];
        self.pan = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(pan:)];
        self.pan.delegate = self;
        [self addGestureRecognizer:self.pan];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    // 获取图形上下文
    _context = UIGraphicsGetCurrentContext();
    // 设置线条的样式
    CGContextSetLineCap(_context, kCGLineCapRound);
    // 设置线条转角样式
    CGContextSetLineJoin(_context, kCGLineJoinRound);
    // 判断之前是否有线条需要重绘
    for (GYDrawBoardLineInfo *lineInfo in _lineArray) {
        [self drawLineWithLineInfo:lineInfo];
    }
    // 绘制当前线条
    GYDrawBoardLineInfo *currentLineInfo = [GYDrawBoardLineInfo initWithPointArr:[_actionPointArray copy]
                                                                       lineColor:self.lineColor
                                                                       lineWidth:self.lineWidth];
    [self drawLineWithLineInfo:currentLineInfo];
}

#pragma mark - UIGestureRecognizerDelegate
- (void)pan:(UIGestureRecognizer *)ges {
    UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)ges;
    if (pan.state == UIGestureRecognizerStateChanged
        || pan.state == UIGestureRecognizerStateBegan) {
        // 获取手指移动的位置
        CGPoint currentPoint = [pan locationInView:self];
        // 将位置保存到数组中
        [_actionPointArray addObject:NSStringFromCGPoint(currentPoint)];
        [self setNeedsDisplay];
    } else if (pan.state == UIGestureRecognizerStateEnded) {
        // 把刚画的图形保存到线条数组中
        GYDrawBoardLineInfo *lineInfo = [GYDrawBoardLineInfo initWithPointArr:[_actionPointArray copy]
                                                                    lineColor:self.lineColor
                                                                    lineWidth:self.lineWidth];
        [_lineArray addObject:lineInfo];
        [_allActionArr addObject:lineInfo];
        // 清空当前点的位置数组,以便重新绘制图形
        [_actionPointArray removeAllObjects];
    }
}
 
#pragma mark - GYDrawBoardTextDelegete

- (void)gy_drawBoradTextDidPan:(UIPanGestureRecognizer *)pan
                      textInfo:(GYDrawBoardTextInfo *)textInfo {
    CGPoint point = [pan locationInView:self];
    if (pan.state == UIGestureRecognizerStateBegan) {
        //判断当前点位与label中心点的偏差
        self.differencePoint = CGPointMake(textInfo.textPoint.x - point.x, textInfo.textPoint.y - point.y);
    } else if (pan.state == UIGestureRecognizerStateChanged) {
        textInfo.textPoint = CGPointMake(point.x + self.differencePoint.x, point.y + self.differencePoint.y);
    } else if (pan.state == UIGestureRecognizerStateEnded) {
        [textInfo addMovePoint:textInfo.textPoint];
    }
}

- (void)gy_drawBoradTextDidTap:(UITapGestureRecognizer *)tap
                      textInfo:(GYDrawBoardTextInfo *)textInfo {
    GYViewController *viewController = [GYCoordinatingMediator shareInstance].activeViewController;
    [viewController gy_comment_openCommentView:textInfo.textString
                                     sendTitle:@"完成"
                                     sendBlock:^(NSString * _Nonnull comment) {
        textInfo.textString = comment;
        [textInfo addTextEdit:comment];
    }];
}

#pragma mark - implementation
//根据指定的点位，绘制path
- (void)drawLineWithLineInfo:(GYDrawBoardLineInfo *)lineInfo {
    // 设置线条的宽度
    CGContextSetLineWidth(_context, lineInfo.lineWidth);
    // 设置线条的颜色
    CGContextSetStrokeColorWithColor(_context, lineInfo.lineColor.CGColor);
    if (lineInfo.pointArr.count == 0) {
        return;
    }
    // 开始绘制
    CGContextBeginPath(_context);
    // 获取线条的开始点
    CGPoint startPoint = CGPointFromString(lineInfo.pointArr.firstObject);
    // 绘制起点
    CGContextMoveToPoint(_context, startPoint.x, startPoint.y);
    for (NSString *pointString in lineInfo.pointArr) {
        CGPoint endPoint = CGPointFromString(pointString);
        // 绘制终点
        CGContextAddLineToPoint(_context, endPoint.x, endPoint.y);
    }
    // 保存绘制的线条
    CGContextStrokePath(_context);
}

#pragma mark - 设置线条颜色
- (void)updateLineColor:(UIColor *)lineColor {
    self.lineColor = lineColor;
}

#pragma mark - 撤销
- (void)gy_drawBoardRepealAction {
    if (self.allActionArr == 0) {
        return;
    }
    id lastObject = self.allActionArr.lastObject;
    if ([lastObject isKindOfClass:[GYDrawBoardLineInfo class]]) {
        [_lineArray removeLastObject];
        [self setNeedsDisplay];
        [self.allActionArr removeLastObject];
    } else if ([lastObject isKindOfClass:[GYDrawBoardTextInfo class]]) {
        GYDrawBoardTextInfo *textInfo = lastObject;
        //判断是否移动过位置
        if (![textInfo checkAndRepealLastAction]) {
            [textInfo.textLabel removeFromSuperview];
            [self.allActionArr removeLastObject];
        }
    }
}

#pragma mark - 设置线条宽度
- (void)updateLineWidth:(CGFloat)lineWidth {
    self.lineWidth = lineWidth;
}

#pragma mark - 添加文字
- (void)gy_drawBoardAddText:(NSString *)textString {
    GYDrawBoardTextInfo *textInfo = [[GYDrawBoardTextInfo alloc] initWithOriginalPoint:CGPointMake((self.gy_width / 2.0), (self.gy_height / 2.0))
                                                                        originalString:textString];
    if (textInfo) {
        textInfo.textColor = self.lineColor;
        textInfo.delegate = self;
        [self.textArray addObject:textInfo];
        [self.allActionArr addObject:textInfo];
        [self drawTextView:textInfo];
    }
}

- (void)drawTextView:(GYDrawBoardTextInfo *)textInfo {
    if (!textInfo) {
        return;
    }
    [self addSubview:textInfo.textLabel];
}

@end
