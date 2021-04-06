//
//  GYCustomCameraController.m
//  GYFramework
//
//  Created by Yang Ge on 2021/3/23.
//  Copyright © 2021 GeYang. All rights reserved.
//

#import "GYCustomCameraController.h"
#import <AVFoundation/AVFoundation.h>
#import "GYCameraShootButton.h"
#import "UIImage+CustomCameraExtend.h"
#import "GYCMMotionManager.h"
#import "GYViewController+MediaPickerExtend.h"

@interface GYCustomCameraController () <UIGestureRecognizerDelegate> {
    /**取景框比例 */
    CGFloat _captureScale;
    /**焦距 */
    CGFloat _currentZoomFactor;
}

/**负责输入和输出设备之间的数据传输 */
@property (nonatomic, strong) AVCaptureSession *captureSession;
/**输入设备输入*/
@property (nonatomic, strong) AVCaptureDeviceInput *cameraInput;
/**输入设备 - 摄像头*/
@property (nonatomic, strong) AVCaptureDevice *captureDevice;
/**相机拍摄时的预览图层*/
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;
/**输出*/
@property (nonatomic, strong) AVCaptureStillImageOutput *imageOutPut;

/**设备的拍摄方向*/
@property (nonatomic, assign) UIDeviceOrientation deviceOrientation;
/**设置焦距的捏合手势*/
@property (nonatomic, strong) UIPinchGestureRecognizer *pinchGesture;
@property (nonatomic, strong) GYCameraShootButton *photoButton;
@property (nonatomic, strong) UIButton *switchButton;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIView *focusView; //对焦动画框
@property (nonatomic, strong) UIButton *flashButton;
@property (nonatomic, strong) UILabel *tipsLabel;

@end

@implementation GYCustomCameraController
- (instancetype)init {
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationDidEnterBackground:)
                                                     name:UIApplicationDidEnterBackgroundNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(applicationDidBecomeActive:)
                                                     name:UIApplicationDidBecomeActiveNotification
                                                   object:nil];
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self initializeMotionManger];
    [self.captureSession startRunning];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self initializeCamera];
    [self initializeUI];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.captureSession stopRunning];
    [[GYCMMotionManager sharedManager].motionManager stopAccelerometerUpdates];
}

- (void)viewContentInsetDidChanged  {
    [super viewContentInsetDidChanged];
    const CGFloat bottomMargin = self.safeAreaInsets.bottom + GYKIT_TABBAR_HEIGHT;
    [_photoButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-bottomMargin);
    }];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 初始化传感器
- (void)initializeMotionManger {
    self.deviceOrientation = UIDeviceOrientationPortrait;
    __weak typeof(self) weakself = self;
    [[GYCMMotionManager sharedManager] startAccelerometerUpdatesWithHandler:^(UIDeviceOrientation orientation) {
        __strong typeof(weakself) strongself = weakself;
        [strongself deviceRotate:orientation];
    }];
}

#pragma mark - 初始化相机
- (void)initializeCamera {
    //加入输入设备
    if ([self.captureSession canAddInput:self.cameraInput]) {
        [self.captureSession addInput:self.cameraInput];
    }
    //加入输出设备
    if ([self.captureSession canAddOutput:self.imageOutPut]) {
        [self.captureSession addOutput:self.imageOutPut];
    }
    [self.view.layer addSublayer:self.captureVideoPreviewLayer];
    [self.captureSession startRunning];
}

#pragma mark - 初始化UI
- (void)initializeUI {
    const CGFloat bottomMargin = self.safeAreaInsets.bottom + GYKIT_TABBAR_HEIGHT;
    const CGFloat bottomBtnWidth = 60;
    const CGFloat bottomBtnHeight = 60;
    const CGFloat bottomHMargin = 40;
    const CGFloat btnWidth = 45;
    const CGFloat btnHeight = 40;
    [self.view addSubview:self.photoButton];
    [self.view addSubview:self.cancelButton];
    [self.view addSubview:self.flashButton];
    [self.view addSubview:self.switchButton];
    [self.view addSubview:self.focusView];
    [self.view addSubview:self.tipsLabel];
    
    [self.photoButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(self.photoButton.buttonSize);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.bottom.mas_equalTo(-bottomMargin);
    }];
    
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.photoButton.mas_top).offset(-GYKIT_GENERAL_SPACING4);
        make.centerX.mas_equalTo(self.view.mas_centerX);
    }];
    
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(bottomHMargin);
        make.width.mas_equalTo(bottomBtnWidth);
        make.height.mas_equalTo(bottomBtnHeight);
        make.centerY.mas_equalTo(self.photoButton.mas_centerY);
    }];
    [self.flashButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.width.mas_equalTo(btnWidth);
        make.height.mas_equalTo(btnHeight);
        make.centerY.equalTo(self.view.mas_centerY).offset(-GYKIT_GENERAL_SPACING4 * 3);
    }];
    [self.switchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(0);
        make.width.mas_equalTo(btnWidth);
        make.height.mas_equalTo(btnHeight);
        make.top.equalTo(self.flashButton.mas_bottom).offset(GYKIT_GENERAL_SPACING4);
    }];
    [self.view addGestureRecognizer:self.pinchGesture];
}

#pragma mark - Overwrite
- (void)applicationDidEnterBackground:(UIApplication *)application {
    [self.captureSession stopRunning];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [self reset];
}

#pragma mark - implementaction
- (void)reset {
    [self.captureSession startRunning];
    self.photoButton.userInteractionEnabled = YES;
}

- (void)deviceRotate:(UIDeviceOrientation)orientation {
    if (_deviceOrientation == orientation) {
        return;
    }
    _deviceOrientation = orientation;
    CGFloat oldAngle = [self getAngelByOrientation:UIDeviceOrientationPortrait];
    CGFloat angle = -oldAngle + [self getAngelByOrientation:_deviceOrientation];
    while (angle < 0) {
        angle += M_PI * 2;
    }
    while (angle > 2 * M_PI) {
        angle -= M_PI * 2;
    }
    if (UIDeviceOrientationIsPortrait(orientation)) {
        [UIView animateWithDuration:0.3 animations:^{
            self.switchButton.transform = CGAffineTransformIdentity;
            self.cancelButton.transform = CGAffineTransformIdentity;
            self.flashButton.transform = CGAffineTransformIdentity;
            self.photoButton.transform = CGAffineTransformIdentity;
        }];
    } else {
        [UIView animateWithDuration:0.3 animations:^{
            self.switchButton.transform = CGAffineTransformMakeRotation(angle);
            self.cancelButton.transform = CGAffineTransformMakeRotation(angle);
            self.flashButton.transform = CGAffineTransformMakeRotation(angle);
            self.photoButton.transform = CGAffineTransformMakeRotation(angle);
        }];
    }
    [self deviceOrientationDidChanged:(CGFloat)angle];
}

- (CGFloat)getAngelByOrientation:(UIDeviceOrientation)aOrientation {
    switch (aOrientation) {
        case UIDeviceOrientationLandscapeLeft:
            return M_PI_2;
        case UIDeviceOrientationLandscapeRight:
            return 3 * M_PI_2;
        case UIDeviceOrientationPortraitUpsideDown:
            return M_PI;
        default:
            return 0;
    }
}

- (void)deviceOrientationDidChanged:(CGFloat)angle {
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = nil;
    for (UITouch *t in touches) {
        touch = t;
        break;
    }
    CGPoint point = [touch locationInView:self.view];
    //判断点击的是否是拍照按钮
    CGPoint photoPoint = [self.photoButton.layer convertPoint:point
                                                    fromLayer:self.view.layer];
    if ([self.photoButton.layer containsPoint:photoPoint]) {
        return;
    }
    CGPoint cameraPoint = [self.captureVideoPreviewLayer captureDevicePointOfInterestForPoint:point];
    [self focusAtPoint:cameraPoint
            touchPoint:point];
}

- (void)setupCaptureSessionPreset:(AVCaptureDevice *)captureDevice {
    _captureScale = 1.0;
    if ([_captureSession canSetSessionPreset:AVCaptureSessionPreset3840x2160]
        && [captureDevice supportsAVCaptureSessionPreset:AVCaptureSessionPreset3840x2160]) {
        _captureScale = 3840 / 2160.0;
        _captureSession.sessionPreset = AVCaptureSessionPreset3840x2160;
    } else if ([_captureSession canSetSessionPreset:AVCaptureSessionPreset1920x1080]
               && [captureDevice supportsAVCaptureSessionPreset:AVCaptureSessionPreset1920x1080]) {
        _captureScale = 1920 / 1080.0;
        _captureSession.sessionPreset = AVCaptureSessionPreset1920x1080;
    } else if ([_captureSession canSetSessionPreset:AVCaptureSessionPreset1280x720]
               && [captureDevice supportsAVCaptureSessionPreset:AVCaptureSessionPreset1280x720]) {
        _captureScale = 1280 / 720.0;
        _captureSession.sessionPreset = AVCaptureSessionPreset1280x720;
    } else if ([_captureSession canSetSessionPreset:AVCaptureSessionPreset640x480]
               && [captureDevice supportsAVCaptureSessionPreset:AVCaptureSessionPreset640x480]) {
        _captureScale = 640 / 480.0;
        _captureSession.sessionPreset = AVCaptureSessionPreset640x480;
    }
}

#pragma mark - 获取指定摄像头
- (AVCaptureDevice *)getCameraCaptureDeviceWithPosition:(AVCaptureDevicePosition)positon {
    NSArray *cameraDevices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *camera in cameraDevices) {
        if (camera.position == positon) {
            return camera;
        }
    }
    return nil;
}

#pragma mark - 对焦
- (void)focusAtPoint:(CGPoint)cameraPoint
          touchPoint:(CGPoint)touchPoint {
    NSError *error = nil;
    [self.captureDevice lockForConfiguration:&error];
    if (!error) {
        if ([self.captureDevice isFocusPointOfInterestSupported]) {
            [self.captureDevice setFocusPointOfInterest:cameraPoint];
        }
        if ([self.captureDevice isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
            [self.captureDevice setFocusMode:AVCaptureFocusModeAutoFocus];
        }
    }
    //对焦动画
    _focusView.center = touchPoint;
    _focusView.hidden = NO;
    [UIView animateWithDuration:0.3 animations:^{
        self.focusView.transform = CGAffineTransformMakeScale(1.25, 1.25);
    }completion:^(BOOL finished) {
        [UIView animateWithDuration:0.5 animations:^{
            self.focusView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
            self.focusView.hidden = YES;
        }];
    }];
    [self.captureDevice unlockForConfiguration];
}

#pragma mark - 焦距
- (CGFloat)minZoomFactor{
    CGFloat minZoomFactor = 1.0;
    if (@available(iOS 11.0, *)) {
        minZoomFactor = self.captureDevice.minAvailableVideoZoomFactor;
    }
    return minZoomFactor;
}
 
- (CGFloat)maxZoomFactor{
    CGFloat maxZoomFactor = self.captureDevice.activeFormat.videoMaxZoomFactor;
    if (@available(iOS 11.0, *)) {
        maxZoomFactor = self.captureDevice.maxAvailableVideoZoomFactor;
    }
    if (maxZoomFactor > 10.0) {
        maxZoomFactor = 10.0;
    }
    return maxZoomFactor;
}


- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    if ([gestureRecognizer isKindOfClass:[UIPinchGestureRecognizer class]]){
        _currentZoomFactor = self.captureDevice.videoZoomFactor;
    }
    return YES;
}

- (void)zoomChangePinchGestureRecognizerClick:(UIPinchGestureRecognizer *)pinchGestureRecognizer {
    if (pinchGestureRecognizer.state == UIGestureRecognizerStateBegan
        || pinchGestureRecognizer.state == UIGestureRecognizerStateChanged){
        CGFloat currentZoomFactor = _currentZoomFactor * pinchGestureRecognizer.scale;
        [self changeFactor:currentZoomFactor];
    }
}

- (void)changeFactor:(CGFloat)currentZoomFactor {
    if (currentZoomFactor < self.maxZoomFactor
        && currentZoomFactor > self.minZoomFactor){
        NSError *error = nil;
        if ([self.captureDevice lockForConfiguration:&error] ) {
            [self.captureDevice rampToVideoZoomFactor:currentZoomFactor withRate:3];//rate越大，动画越慢
            [self.captureDevice unlockForConfiguration];
        }
    }
}

#pragma mark - 拍照
- (void)shutterPhoto:(UIView *)sender {
    sender.userInteractionEnabled = NO;
    AVCaptureConnection * videoConnection = [self.imageOutPut connectionWithMediaType:AVMediaTypeVideo];
    if (videoConnection ==  nil) {
        sender.userInteractionEnabled = YES;
        return;
    }
    __weak typeof(self) weakself = self;
    [self.view gy_showProgressHUD:nil];
    [self.imageOutPut captureStillImageAsynchronouslyFromConnection:videoConnection
                                                  completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        __strong typeof(weakself) strongself = weakself;
        if (imageDataSampleBuffer == nil || error) {
            sender.userInteractionEnabled = YES;
            [strongself.view gy_showStaticHUD:@"拍摄失败"];
            return;
        }
        [strongself.captureSession stopRunning];
        NSData *imageData =  [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        UIImage *originalImage = [UIImage imageWithData:imageData];
        UIImage *fixOriginalImage = [UIImage gy_image_commonFixOrientation:originalImage
                                                               orientation:strongself.deviceOrientation];
        if (originalImage == nil || fixOriginalImage == nil) {
            [strongself.view gy_showStaticHUD:@"拍摄失败"];
            sender.userInteractionEnabled = YES;
            [strongself.captureSession startRunning];
            return;
        }
        [strongself gy_imagesave_saveImage:fixOriginalImage
                             resultHandler:^(PHAsset * _Nonnull asset) {
            [strongself.view gy_hideHUD];
            [strongself.captureSession startRunning];
        }];
    }];
}

#pragma mark - 闪光灯
- (void)onClickFlash:(UIButton *)sender {
    NSError *error = nil;
    [self.captureDevice lockForConfiguration:&error];
    if (!error && [self.captureDevice hasFlash]) {
        if (sender.isSelected) {
            if([self.captureDevice isFlashModeSupported:AVCaptureFlashModeOff]) {
                [self.captureDevice setFlashMode:AVCaptureFlashModeOff];
                sender.selected = NO;
            }
        } else {
            if([self.captureDevice isFlashModeSupported:AVCaptureFlashModeOn]) {
                [self.captureDevice setFlashMode:AVCaptureFlashModeOn];
                sender.selected = YES;
            }
        }
    } else {
        GYLog(@"闪光灯操作失败");
    }
    [self.captureDevice unlockForConfiguration];
}

#pragma mark - 前后置切换
- (void)onClickSwitch:(UIButton *)sender {
    NSUInteger cameraCount = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo].count;
    if (cameraCount <= 1) {
        return;
    }
    NSError *error = nil;
    [self.captureDevice lockForConfiguration:&error];
    if (error) {
        return;
    }
    AVCaptureDevicePosition currentPosition = [self.cameraInput device].position;
    //添加转场动画
    CATransition *animation = [CATransition animation];
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.duration = 0.5;
    animation.type = @"oglFlip";
    AVCaptureDevice *newCamera = nil;
    if (currentPosition == AVCaptureDevicePositionBack) {
        newCamera = [self getCameraCaptureDeviceWithPosition:AVCaptureDevicePositionFront];
        animation.subtype = kCATransitionFromRight;
    } else {
        newCamera = [self getCameraCaptureDeviceWithPosition:AVCaptureDevicePositionBack];
        animation.subtype = kCATransitionFromLeft;
    }
    [self.captureVideoPreviewLayer addAnimation:animation forKey:nil];
    [self setupCaptureSessionPreset:newCamera];
    [self.captureDevice lockForConfiguration:&error];
    AVCaptureDeviceInput *newCameraInput = [AVCaptureDeviceInput deviceInputWithDevice:newCamera error:nil];
    if (newCameraInput) {
        [self.captureSession beginConfiguration];
        [self.captureSession removeInput:self.cameraInput];
        if ([self.captureSession canAddInput:newCameraInput]) {
            [self.captureSession addInput:newCameraInput];
            self.cameraInput = newCameraInput;
        } else {
            [self.captureSession addInput:self.cameraInput];
        }
        [self.captureSession commitConfiguration];
    }
    [self.captureDevice unlockForConfiguration];
}

#pragma mark - 返回
- (void)onClickCancel:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 视频开始录制
- (void)startVideoRecord {
    
}

#pragma mark - 视频停止录制
- (void)stopVideoRecord {
    
}

#pragma mark - getter and setter
- (AVCaptureSession *)captureSession {
    if (!_captureSession) {
        _captureSession = [[AVCaptureSession alloc] init];
        _captureScale = 1.0;
    }
    return _captureSession;
}

- (AVCaptureDevice *)captureDevice {
    if (!_captureDevice) {
        _captureDevice = [self getCameraCaptureDeviceWithPosition:AVCaptureDevicePositionBack];
        [self setupCaptureSessionPreset:_captureDevice];
    }
    return _captureDevice;
}

- (AVCaptureDeviceInput *)cameraInput {
    if (!_cameraInput) {
        if (self.captureDevice == nil) {
            GYLog(@"获取摄像头失败");
            return nil;
        }
        NSError *error = nil;
        _cameraInput = [[AVCaptureDeviceInput alloc] initWithDevice:self.captureDevice
                                                              error:&error];
        if (error) {
            GYLog(@"摄像头获取异常：%@", error.description);
        }
    }
    return _cameraInput;
}

- (AVCaptureStillImageOutput *)imageOutPut {
    if (!_imageOutPut) {
        _imageOutPut = [[AVCaptureStillImageOutput alloc] init];
    }
    return _imageOutPut;
}

- (AVCaptureVideoPreviewLayer *)captureVideoPreviewLayer {
    if (!_captureVideoPreviewLayer) {
        _captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.captureSession];
        _captureVideoPreviewLayer.frame = self.view.bounds;
        _captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    }
    return _captureVideoPreviewLayer;
}

- (GYCameraShootButton *)photoButton {
    if (!_photoButton) {
        _photoButton = [[GYCameraShootButton alloc] init];
        __weak typeof(self) weakself = self;
        _photoButton.finishTakePhoto = ^{
            __strong typeof(weakself) strongself = weakself;
            [strongself shutterPhoto:strongself.photoButton];
        };
        _photoButton.beginShootVideo = ^{
            __strong typeof(weakself) strongself = weakself;
            [strongself startVideoRecord];
        };
        _photoButton.finishShootVideo = ^{
            __strong typeof(weakself) strongself = weakself;
            [strongself stopVideoRecord];
        };
    }
    return _photoButton;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setImage:[UIImage imageNamed:@"camera_back_white"]
                       forState:UIControlStateNormal];
        [_cancelButton addTarget:self
                          action:@selector(onClickCancel:)
                forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (UIButton *)flashButton {
    if (!_flashButton) {
        _flashButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _flashButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _flashButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, GYKIT_GENERAL_H_MARGIN);
        [_flashButton setImage:[UIImage imageNamed:@"photo_picker_flash_close"]
                      forState:UIControlStateNormal];
        [_flashButton setImage:[UIImage imageNamed:@"photo_picker_flash_open"]
                      forState:UIControlStateSelected];
        [_flashButton addTarget:self
                         action:@selector(onClickFlash:)
               forControlEvents:UIControlEventTouchUpInside];
    }
    return _flashButton;
}

- (UIButton *)switchButton {
    if (!_switchButton) {
        _switchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _switchButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _switchButton.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, GYKIT_GENERAL_H_MARGIN);
        [_switchButton setImage:[UIImage imageNamed:@"photo_picker_switch"]
                       forState:UIControlStateNormal];
        [_switchButton addTarget:self
                          action:@selector(onClickSwitch:)
                forControlEvents:UIControlEventTouchUpInside];
    }
    return _switchButton;
}

- (UIView *)focusView {
    if (!_focusView) {
        _focusView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        _focusView.backgroundColor = [UIColor clearColor];
        _focusView.layer.borderWidth = 1;
        _focusView.layer.borderColor = [UIColor gy_colorWithRGB:GYKIT_APP_MAIN_COLOR].CGColor;
        _focusView.hidden = YES;
    }
    return _focusView;
}

- (UILabel *)tipsLabel {
    if (!_tipsLabel) {
        _tipsLabel = [[UILabel alloc] init];
        _tipsLabel.font = [UIFont gy_CNFontSizeS3];
        _tipsLabel.textColor = [UIColor whiteColor];
        _tipsLabel.text = @"轻触拍照，长按拍摄";
        _tipsLabel.hidden = YES;
    }
    return _tipsLabel;
}

- (UIPinchGestureRecognizer *)pinchGesture {
    if (!_pinchGesture) {
        _pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(zoomChangePinchGestureRecognizerClick:)];
        _pinchGesture.delegate = self;
    }
    return _pinchGesture;
}

@end
