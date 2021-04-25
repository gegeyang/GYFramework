//
//  GYGraffitiViewController.m
//  GYZF
//
//  Created by Yang Ge on 2020/11/19.
//  Copyright © 2020 网家科技有限责任公司. All rights reserved.
//

#import "GYGraffitiViewController.h"
#import "GYDrawBoardView.h"
#import "GYCountEditView.h"
#import "GYCommentInputView.h"
#import "GYViewController+MediaPickerExtend.h"

@interface GYGraffitiViewController ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) GYDrawBoardView *drawBoard;
@property (nonatomic, assign) NSInteger selectedTag;
@property (nonatomic, strong) NSArray *colorArr;
@property (nonatomic, strong) UIButton *addText;
@property (nonatomic, strong) GYCountEditView *countView;
@property (nonatomic, strong) UIButton *selectedPhoto;

@end

@implementation GYGraffitiViewController

- (void)loadView {
    [super loadView];
    [self gy_navigation_initTitle:@"涂鸦"];
    [self gy_navigation_initLeftBackBtn:nil];
    [self gy_navigation_insertLeftBtn:self.selectedPhoto
                              atIndex:1];
    
    UIButton *save = [UIButton buttonWithType:UIButtonTypeCustom];
    [save setTitle:@"保存"
            forState:UIControlStateNormal];
    [save addTarget:self
               action:@selector(onClickSave:)
     forControlEvents:UIControlEventTouchUpInside];
    [self gy_navigation_insertRightBtn:save
                               atIndex:0];
    [self gy_navigation_layoutSubView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:@"撤销"
            forState:UIControlStateNormal];
    [button addTarget:self
               action:@selector(onClickRepeal:)
     forControlEvents:UIControlEventTouchUpInside];
    [self gy_navigation_insertRightBtn:button atIndex:1];
    [self gy_navigation_layoutSubView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.imageView = [[UIImageView alloc] init];
    self.imageView.userInteractionEnabled = YES;
    [self.view addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.equalTo(self.navigationBar.mas_bottom).offset(60);
        make.height.mas_equalTo(400);
    }];
    UIImage *image = [UIImage gy_imageWithColor:[UIColor grayColor] size:CGSizeMake(self.view.gy_width, 400) radius:0];
    self.imageView.image = image;
    
    [self.imageView addSubview:self.drawBoard];
    [self.drawBoard mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    
    NSArray *colorTitle = @[@"红色", @"蓝色", @"黄色", @"绿色"];
    NSArray *colorArr = @[[UIColor redColor], [UIColor blueColor], [UIColor yellowColor], [UIColor greenColor]];
    _colorArr = colorArr;
    NSMutableArray *arr = [NSMutableArray array];
    for (NSInteger index = 0; index < colorTitle.count; index++) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle:[colorTitle objectAtIndex:index] forState:UIControlStateNormal];
        [button setTitleColor:[colorArr objectAtIndex:index]
                     forState:UIControlStateSelected];
        [button setTitleColor:[UIColor gy_color6]
                     forState:UIControlStateNormal];
        [button addTarget:self
                   action:@selector(onClick:)
         forControlEvents:UIControlEventTouchUpInside];
        button.tag = (index + 1) * 10;
        if (index == 0) {
            button.selected = YES;
            _selectedTag = button.tag;
        }
        [self.view addSubview:button];
        [arr addObject:button];
    }
    [arr mas_distributeViewsAlongAxis:MASAxisTypeHorizontal
                     withFixedSpacing:10
                          leadSpacing:10
                          tailSpacing:10];
    [arr mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.navigationBar.mas_bottom).offset(20);
        make.height.mas_equalTo(30);
    }];
    
    [self.view addSubview:self.countView];
    [self.countView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(GYKIT_GENERAL_H_MARGIN);
        make.top.equalTo(self.imageView.mas_bottom).offset(GYKIT_GENERAL_H_MARGIN);
        make.size.mas_equalTo(kCountEditSize);
    }];
    
    [self.view addSubview:self.addText];
    [self.addText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.countView.mas_right).offset(GYKIT_GENERAL_SPACING4);
        make.centerY.mas_equalTo(self.countView.mas_centerY);
    }];
}

#pragma mark - implementation
- (void)onClickAddText:(UIButton *)sender {
    __weak typeof(self) weakself = self;
    [self gy_comment_openCommentView:@""
                           sendTitle:@"完成"
                           sendBlock:^(NSString * _Nonnull comment) {
        __strong typeof(weakself) strongself = weakself;
        [strongself.drawBoard gy_drawBoardAddText:comment];
    }];
}

- (void)onClickSave:(UIButton *)sender {
    [self.view gy_showProgressHUD:nil];
    UIImage *resultImage = [UIImage gy_image_compoundImageAndView:self.drawBoard
                                                            image:self.imageView.image];
    __weak typeof(self) weakself = self;
    [self gy_saveWithImage:resultImage
             resultHandler:^(PHAsset * _Nonnull asset) {
        __strong typeof(weakself) strongself = weakself;
        [strongself.view gy_showStaticHUD:@"保存成功"];
    }];
}

- (void)onClick:(UIButton *)sender {
    UIButton *button = [self.view viewWithTag:self.selectedTag];
    button.selected = NO;
    sender.selected = YES;
    self.selectedTag = sender.tag;
    NSInteger index = (sender.tag / 10 - 1);
    [_drawBoard updateLineColor:[_colorArr objectAtIndex:index]];
}

- (BOOL)handleNavigationTransitionEnabled {
    return NO;
}

- (void)onClickRepeal:(UIButton *)sender {
    [self.drawBoard gy_drawBoardRepealAction];
}

- (void)onClickSelectedPhoto:(UIButton *)sender {
//    [self gy_imagepicker_checkAndOpenImageLib:1
//                                resultHandler:^(NSArray<PHAsset *> * _Nonnull assetList) {
//        PHAsset *asset = assetList.firstObject;
//        self.imageView.image = [[GYCachingImageManager defaultManager] syncRequestThumeImageWithLocalIdentifier:asset.localIdentifier];
//        CGFloat scale = self.imageView.image.size.height / self.imageView.image.size.width;
//        [self.imageView mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.height.mas_equalTo(self.view.gy_width * scale);
//        }];
//    }];
}

#pragma mark - getter and setter
- (GYDrawBoardView *)drawBoard {
    if (!_drawBoard) {
        _drawBoard = [[GYDrawBoardView alloc] initWithFrame:CGRectMake(0, 0, self.view.gy_width, 400)];
        [_drawBoard updateLineColor:[UIColor redColor]];
    }
    return _drawBoard;
}

- (GYCountEditView *)countView {
    if (!_countView) {
        _countView = [[GYCountEditView alloc] initWithMinValue:[NSDecimalNumber decimalNumberWithString:@"1"]
                                                      maxValue:[NSDecimalNumber decimalNumberWithString:@"20"]
                                               maximumDecimals:0
                                                  defaultValue:[NSDecimalNumber decimalNumberWithString:@"4"]];
        _countView.countValue = [NSDecimalNumber decimalNumberWithString:@"2"];
        [self.drawBoard updateLineWidth:_countView.countValue.doubleValue];
        _countView.inputEnable = NO;
        __weak typeof(self) weakself = self;
        __weak typeof(_countView) weakCount = _countView;
        _countView.addBlock = ^{
            __strong typeof(weakself) strongself = weakself;
            weakCount.countValue = [weakCount.countValue decimalNumberByAdding:[NSDecimalNumber decimalNumberWithString:@"1"]];
            [strongself.drawBoard updateLineWidth:weakCount.countValue.doubleValue];
        };
        _countView.subBlock = ^{
            __strong typeof(weakself) strongself = weakself;
            weakCount.countValue = [weakCount.countValue decimalNumberBySubtracting:[NSDecimalNumber decimalNumberWithString:@"1"]];
            [strongself.drawBoard updateLineWidth:weakCount.countValue.doubleValue];
        };
    }
    return _countView;
}

- (UIButton *)addText {
    if (!_addText) {
        _addText = [UIButton buttonWithType:UIButtonTypeCustom];
        [_addText setTitle:@"添加文字" forState:UIControlStateNormal];
        _addText.titleLabel.font = [UIFont gy_CNFontSizeS1];
        [_addText setTitleColor:[UIColor gy_color3]
                       forState:UIControlStateNormal];
        [_addText addTarget:self
                     action:@selector(onClickAddText:)
           forControlEvents:UIControlEventTouchUpInside];
    }
    return _addText;
}

- (UIButton *)selectedPhoto {
    if (!_selectedPhoto) {
        _selectedPhoto = [UIButton buttonWithType:UIButtonTypeCustom];
        [_selectedPhoto setTitle:@"选择图片"
                        forState:UIControlStateNormal];
        [_selectedPhoto addTarget:self
                           action:@selector(onClickSelectedPhoto:)
                 forControlEvents:UIControlEventTouchUpInside];
    }
    return _selectedPhoto;
}

@end
