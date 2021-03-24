//
//  GYVideoPreviewController.m
//  GYFramework
//
//  Created by Yang Ge on 2021/3/24.
//  Copyright © 2021 GeYang. All rights reserved.
//

#import "GYVideoPreviewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import "GYAppRootController.h"

#define kGYKIT_TABBAR_ORIGIN_HEIGHT  49.0f

@interface GYVideoPreviewController ()

@property (nonatomic, strong) AVPlayerViewController *moviePlayer;
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerItem *item;
@property (nonatomic, assign) BOOL allowRepeat;
@property (nonatomic, strong) UIView *viewBtns;
@property (nonatomic, strong) UIButton *switchButton;
@property (nonatomic, strong) UIButton *cancelButton;

@end

@implementation GYVideoPreviewController

- (instancetype)initWithVideoUrl:(NSURL *)url
                     allowRepeat:(BOOL)allowRepeat {
    self = [super init];
    if (self) {
        if ([url.scheme isEqualToString:@"file"]) {
            AVURLAsset *asset = [AVURLAsset assetWithURL:url];
            _item = [AVPlayerItem playerItemWithAsset:asset];
        } else {
            //设置流媒体视频路径
            _item = [AVPlayerItem playerItemWithURL:url];
        }
        //设置AVPlayer中的AVPlayerItem
        _player = [AVPlayer playerWithPlayerItem:_item];
        _allowRepeat = allowRepeat;
    }
    return self;
}

- (instancetype)initWithAllowRepeat:(BOOL)allowRepeat {
    if (self = [super init]) {
        _allowRepeat = allowRepeat;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _moviePlayer = [[AVPlayerViewController alloc] init];
    _moviePlayer.player = _player;
    _moviePlayer.videoGravity = AVLayerVideoGravityResizeAspect;
    [self addChildViewController:_moviePlayer];
    [self.view addSubview:_moviePlayer.view];
    _moviePlayer.view.frame = self.view.bounds;
    [_moviePlayer.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    if (_allowRepeat) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(playVideoFinished:)
                                                     name:AVPlayerItemDidPlayToEndTimeNotification
                                                   object:_item];
    }
    
    [self.view addSubview:self.viewBtns];
    const CGFloat hMargin = 40;
    const CGFloat bottomMargin = self.safeAreaInsets.bottom + kGYKIT_TABBAR_ORIGIN_HEIGHT;
    UIImage *image = [UIImage imageNamed:@"camera_transform"];
    [_viewBtns mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(image.size);
        make.left.mas_equalTo(hMargin);
        make.right.mas_equalTo(-hMargin);
        make.bottom.mas_equalTo(-bottomMargin);
    }];
    _cancelButton.hidden = (self.onClickCancel == nil);
    _switchButton.hidden = (self.onClickFinish == nil);
    _viewBtns.hidden = (_cancelButton.hidden && _switchButton.hidden);
    _moviePlayer.showsPlaybackControls = (_viewBtns.hidden);
    [self addPlayerControlStatusObserver];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.player play];
    });
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (@available(iOS 10.0, *)) {
        [_player removeObserver:self
                        forKeyPath:@"timeControlStatus"];
    }
}

- (void)viewContentInsetDidChanged {
    [super viewContentInsetDidChanged];
    const CGFloat bottomMargin = self.safeAreaInsets.bottom + kGYKIT_TABBAR_ORIGIN_HEIGHT;
    [_viewBtns mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-bottomMargin);
    }];
}

#pragma mark - implementation
- (void)addPlayerControlStatusObserver {
    if (@available(iOS 10.0, *)) {
        [_player addObserver:self
                  forKeyPath:@"timeControlStatus"
                     options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld
                     context:nil];
    } else {
        if (self.onReadyToPlay) {
            self.onReadyToPlay();
        }
    }
}

- (void)updateVideoInfoWithUrl:(NSURL *)url {
    if ([url.scheme isEqualToString:@"file"]) {
        AVURLAsset *asset = [AVURLAsset assetWithURL:url];
        _item = [AVPlayerItem playerItemWithAsset:asset];
    } else {
        _item = [AVPlayerItem playerItemWithURL:url];
    }
    _player = [AVPlayer playerWithPlayerItem:_item];
    _moviePlayer.player = _player;
    [self addPlayerControlStatusObserver];
    [_player play];
}

- (void)onClickCancel:(UIButton *)sender {
    if (self.onClickCancel) {
        self.onClickCancel();
    }
}

- (void)onClickConfirm:(UIButton *)sender {
    if (self.onClickFinish) {
        self.onClickFinish();
    }
}

- (void)playVideoFinished:(NSNotification *)nofify {
    [_player seekToTime:CMTimeMake(0, 1)];
    [_player play];
}

- (void)videoPause {
    [_player pause];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if (@available(iOS 10.0, *)) {
        if ([keyPath isEqualToString:@"timeControlStatus"]) {
            AVPlayerTimeControlStatus oldStatus = [[change objectForKey:@"old"] intValue];;
            AVPlayerTimeControlStatus timeControlStatus = [[change objectForKey:@"new"] intValue];
            if (timeControlStatus == AVPlayerTimeControlStatusPlaying
                && oldStatus != timeControlStatus) {
                if (self.onReadyToPlay) {
                    self.onReadyToPlay();
                }
            }
        }
    }
}

#pragma mark - getter and setter
- (UIView *)viewBtns {
    if (!_viewBtns) {
        _viewBtns = [[UIView alloc] init];
        
        UIImage *imageCancel = [UIImage imageNamed:@"camera_back_black"];
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton setImage:imageCancel
                       forState:UIControlStateNormal];
        [_cancelButton addTarget:self
                          action:@selector(onClickCancel:)
                forControlEvents:UIControlEventTouchUpInside];
        [_viewBtns addSubview:_cancelButton];
        
        UIImage *imageSwitch = [UIImage imageNamed:@"camera_confirm"];
        _switchButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_switchButton setImage:imageSwitch
                       forState:UIControlStateNormal];
        [_switchButton addTarget:self
                          action:@selector(onClickConfirm:)
                forControlEvents:UIControlEventTouchUpInside];
        [_viewBtns addSubview:_switchButton];
        
        [_cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.mas_equalTo(0);
            make.width.mas_equalTo(imageCancel.size.width);
        }];
        [_switchButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.bottom.mas_equalTo(0);
            make.width.mas_equalTo(imageSwitch.size.width);
        }];
    }
    return _viewBtns;
}

@end

@implementation GYViewController(VideoPlayerExtend)
- (void)gy_videoplayer_openUrl:(NSURL *)url
                   allowRepeat:(BOOL)allowRepeat {
    GYVideoPreviewController *controller = [[GYVideoPreviewController alloc] initWithVideoUrl:url
                                                                                  allowRepeat:allowRepeat];
    GYAppRootController *appRootController = [[GYAppRootController alloc] initWithRootViewController:controller];
    [self presentViewController:appRootController
                       animated:YES
                     completion:nil];
}

- (void)gy_videoplayer_openUrl:(NSURL *)url
                   allowRepeat:(BOOL)allowRepeat
                   cancelBlock:(void(^ _Nullable )(void))cancelBlock
                   finishBlock:(void(^ _Nullable )(void))finishBlock {
    GYVideoPreviewController *controller = [[GYVideoPreviewController alloc] initWithVideoUrl:url
                                                                                  allowRepeat:allowRepeat];
    controller.onClickCancel = cancelBlock;
    controller.onClickFinish = finishBlock;
    GYAppRootController *appRootController = [[GYAppRootController alloc] initWithRootViewController:controller];
    [self presentViewController:appRootController
                       animated:YES
                     completion:nil];
}

@end
