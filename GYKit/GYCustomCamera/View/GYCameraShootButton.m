//
//  GYCameraShootButton.m
//  GYFramework
//
//  Created by Yang Ge on 2021/3/23.
//  Copyright © 2021 GeYang. All rights reserved.
//

#import "GYCameraShootButton.h"
#import "GYTimerTool.h"

#define CAMERA_BUTTON_WIDTH     75  //view的宽度
#define CAMERA_TOUCHVIEW_WIDTH  55  //touch view的宽度
#define CAMERA_SHOOTBEGIN_ANIMATION_DURATION   0.3  //视频录制开始的过渡动画时长
#define CAMERA_SHOOT_PROGRESS_LINE_WIDTH     3       // 录制按钮动画轨道宽度
#define CAMERA_SHOOT_MAX_DURATION  (30 * 1000) //录制时长
#define CAMERA_SHOOTBGEGIN_VIEW_SCALE  1.5f    //录制时view的缩放比
#define CAMERA_SHOOTBGEGIN_TOUCH_VIEW_SCALE 0.4 //录制时touch view的缩放比

@interface GYCameraShootButton () {
    CGFloat _timeDuration;
}

@property (nonatomic, strong) CAShapeLayer *progressLayer;
@property (nonatomic, strong) UIView *touchView;
@property (nonatomic, strong) GYTimerTool *timerTool;
@property (nonatomic, strong) UILongPressGestureRecognizer *longPress;

@end

@implementation GYCameraShootButton

- (instancetype)init {
    if (self = [super initWithFrame:CGRectMake(0, 0, CAMERA_BUTTON_WIDTH, CAMERA_BUTTON_WIDTH)]) {
        self.layer.cornerRadius = CAMERA_BUTTON_WIDTH / 2.0;
        self.backgroundColor = [UIColor gy_color9];
        [self addSubview:self.touchView];
    }
    return self;
}

- (void)dealloc {
    [_timerTool stopTimer];
}

#pragma mark - implementation
- (void)startShootAnimationWithDuration:(NSTimeInterval)duration {
    [UIView animateWithDuration:duration
                     animations:^{
        self.transform = CGAffineTransformMakeScale(CAMERA_SHOOTBGEGIN_VIEW_SCALE, CAMERA_SHOOTBGEGIN_VIEW_SCALE);
        self.touchView.transform = CGAffineTransformMakeScale(CAMERA_SHOOTBGEGIN_TOUCH_VIEW_SCALE, CAMERA_SHOOTBGEGIN_TOUCH_VIEW_SCALE);
        [self.layer addSublayer:self.progressLayer];
    }];
}


- (void)takePhoto:(UITapGestureRecognizer *)sender {
    if (self.finishTakePhoto) {
        self.finishTakePhoto();
    }
}

- (void)shootVideo:(UILongPressGestureRecognizer *)sender {
    switch (sender.state) {
        case UIGestureRecognizerStateBegan: {
            _timeDuration = 0;
            [self startShootAnimationWithDuration:CAMERA_SHOOTBEGIN_ANIMATION_DURATION];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(CAMERA_SHOOTBEGIN_ANIMATION_DURATION * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (self.beginShootVideo) {
                    self.beginShootVideo();
                }
                //开始录制
                [self.timerTool startTimer:NO];
            });
            
        }
            break;
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateFailed: {
            [self.timerTool stopTimer];
            if (self.finishShootVideo) {
                self.finishShootVideo();
            }
            [self finishShootVideoAnimation];
        }
            break;
        default:
            break;
    }
}

- (void)finishShootVideoAnimation {
    [UIView animateWithDuration:0.3 animations:^{
        self.transform = CGAffineTransformIdentity;
        self.touchView.transform = CGAffineTransformIdentity;
    }];
    [self.progressLayer removeFromSuperlayer];
    self.progressLayer = nil;
}

#pragma mark - getter and setter
- (CGSize)buttonSize {
    return CGSizeMake(CAMERA_BUTTON_WIDTH, CAMERA_BUTTON_WIDTH);
}

- (void)setSupportVideo:(BOOL)supportVideo {
    _supportVideo = supportVideo;
    if (supportVideo) {
        [self.touchView addGestureRecognizer:self.longPress];
    } else {
        [self.touchView removeGestureRecognizer:self.longPress];
    }
}

- (GYTimerTool *)timerTool {
    if (!_timerTool) {
        CGFloat timerInterval = 10;
        _timerTool = [[GYTimerTool alloc] init];
        _timerTool.timeInterval = timerInterval;
        __weak typeof(self) weakself = self;
        _timerTool.distanceBlock = ^{
            __strong typeof(weakself) strongself = weakself;
            if (strongself->_timeDuration > CAMERA_SHOOT_MAX_DURATION) {
                [strongself.timerTool stopTimer];
                if (strongself.finishShootVideo) {
                    strongself.finishShootVideo();
                }
                [strongself finishShootVideoAnimation];
            } else {
                strongself.progressLayer.strokeEnd = strongself->_timeDuration / CAMERA_SHOOT_MAX_DURATION;
                [strongself.progressLayer removeAllAnimations];
                strongself->_timeDuration += 10;
            }
        };
    }
    return _timerTool;
}

- (UIView *)touchView {
    if (!_touchView) {
        CGFloat touchViewX = (CAMERA_BUTTON_WIDTH - CAMERA_TOUCHVIEW_WIDTH) / 2;
        CGFloat touchViewY = (CAMERA_BUTTON_WIDTH - CAMERA_TOUCHVIEW_WIDTH) / 2;
        _touchView = [[UIView alloc] initWithFrame:CGRectMake(touchViewX, touchViewY, CAMERA_TOUCHVIEW_WIDTH, CAMERA_TOUCHVIEW_WIDTH)];
        _touchView.layer.cornerRadius = _touchView.bounds.size.width / 2.0;
        _touchView.backgroundColor = [UIColor whiteColor];
        //添加相关手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                              action:@selector(takePhoto:)];
        [_touchView addGestureRecognizer:tap];
    }
    return _touchView;
}

- (UILongPressGestureRecognizer *)longPress {
    if (!_longPress) {
        _longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                   action:@selector(shootVideo:)];
    }
    return _longPress;
}

- (CAShapeLayer *)progressLayer {
    if (!_progressLayer) {
        float centerX = self.bounds.size.width / 2.0;
        float centerY = self.bounds.size.height / 2.0;
        float radius = (self.bounds.size.width - CAMERA_SHOOT_PROGRESS_LINE_WIDTH) / 2.0;
        
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(centerX, centerY)
                                                            radius:radius startAngle:(-0.5f * M_PI)
                                                          endAngle:(1.5f * M_PI)
                                                         clockwise:YES];
        _progressLayer = [CAShapeLayer layer];
        _progressLayer.frame = self.bounds;
        _progressLayer.fillColor = [UIColor clearColor].CGColor;
        _progressLayer.strokeColor = [UIColor greenColor].CGColor;
        _progressLayer.lineWidth = CAMERA_SHOOT_PROGRESS_LINE_WIDTH;
        _progressLayer.path = path.CGPath;
        _progressLayer.strokeStart = 0;
        _progressLayer.strokeEnd = 0;
    }
    return _progressLayer;
}
@end
