//
//  GYSegmentSliderBar.m
//  GYFramework
//
//  Created by Yang Ge on 2021/2/24.
//  Copyright © 2021 GeYang. All rights reserved.
//

#import "GYSegmentSliderBar.h"
#import "NSString+GYExtend.h"

#define kTag(num) (num + 1000)
#define kEnTag(num) (num - 1000)

@interface GYSegmentSliderBar ()

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIButton *selectedButton;
@property (nonatomic, strong) NSArray *itemArray;
@property (nonatomic, strong) UIView *bottomSliderLine;
@property (nonatomic, assign) GYSegmentBarContentMode contentMode;

@end

@implementation GYSegmentSliderBar

- (instancetype)initWithFrame:(CGRect)frame
                  contentMode:(GYSegmentBarContentMode)contentMode
                selectedIndex:(NSInteger)selectedIndex
                    itemArray:(NSArray<NSString *> *)itemArray {
    if (self = [super initWithFrame:frame]) {
        _contentMode = contentMode;
        _selectedSegmentIndex = selectedIndex;
        _itemArray = itemArray;
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.scrollView];
        [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.top.bottom.mas_equalTo(0);
        }];
        [self updateUIInfo];
    }
    return self;
}

#pragma mark - implemantaction
- (void)onClickItem:(UIButton *)sender {
    [self onClickItemForStyle:sender];
    if (self.onClickSegment) {
        self.onClickSegment(kEnTag(sender.tag));
    }
}

- (void)onClickItemForStyle:(UIButton *)sender {
    self.selectedButton.selected = NO;
    sender.selected = YES;
    self.selectedButton = sender;
    if (_contentMode == GYSegmentBarContentModeFill) {
        [UIView animateWithDuration:0.1 animations:^{
            self.bottomSliderLine.gy_centerX = sender.gy_centerX;
        }];
    }
}

- (void)updateUIInfo {
    for (UIView *view in self.scrollView.subviews) {
        if (view.tag != NSIntegerMax) {
            [view removeFromSuperview];
        }
    }
    CGFloat previousX = 0;
    for (NSInteger index = 0; index < _itemArray.count; index++) {
        NSString *titleString = [_itemArray objectAtIndex:index];
        CGSize size = [titleString gy_calcSizeWithFont:[UIFont gy_CNFontSizeS2] constrainedToSize:CGSizeMake(CGFLOAT_MAX, GYKIT_GENERAL_FONTSIZE_S2)];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self updateButtonStyle:button
                    titleString:titleString
                          index:index];
        if (_contentMode == GYSegmentBarContentModeDefault) {
            button.frame = CGRectMake(previousX, 0, size.width + GYKIT_GENERAL_SPACING2, self.gy_height);
            previousX += (button.frame.size.width + GYKIT_GENERAL_SPACING1);
        } else {
            button.frame = CGRectMake(previousX, 0, self.scrollView.gy_width / _itemArray.count, self.gy_height);
            previousX += button.frame.size.width;
        }
        [self.scrollView addSubview:button];
        if (index == _itemArray.count - 1) {
            self.scrollView.contentSize = CGSizeMake(previousX, self.gy_height);
        }
        if (_contentMode == GYSegmentBarContentModeFill) {
            [self.scrollView addSubview:self.bottomSliderLine];
            self.bottomSliderLine.gy_width = self.scrollView.gy_width / _itemArray.count;
            self.bottomSliderLine.gy_y1 = self.scrollView.gy_y1;
            if (button.isSelected) {
                self.bottomSliderLine.gy_centerX = button.gy_centerX;
            }
        }
    }
}

- (void)updateButtonStyle:(UIButton *)button
              titleString:(NSString *)titleString
                    index:(NSInteger)index {
    button.titleLabel.font = [UIFont gy_CNFontSizeS2];
    button.titleLabel.adjustsFontSizeToFitWidth = NO;
    [button setTitle:titleString
            forState:UIControlStateNormal];
    [button setTitle:titleString
            forState:UIControlStateSelected];
    [button setTitleColor:[UIColor gy_color9]
                 forState:UIControlStateNormal];
    [button setTitleColor:[UIColor gy_colorWithRGB:GYKIT_APP_MAIN_COLOR]
                 forState:UIControlStateSelected];
    button.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [button addTarget:self
               action:@selector(onClickItem:)
     forControlEvents:UIControlEventTouchUpInside];
    button.tag = kTag(index);
    button.selected = (index == _selectedSegmentIndex);
    if (button.isSelected) {
        self.selectedButton = button;
    }
}

#pragma mark - getter and setter
- (void)setSelectedSegmentIndex:(NSInteger)selectedSegmentIndex {
    _selectedSegmentIndex = selectedSegmentIndex;
    UIButton *button = [self viewWithTag:kTag(selectedSegmentIndex)];
    [self onClickItemForStyle:button];
}

- (UIView *)bottomSliderLine {
    if (!_bottomSliderLine) {
        _bottomSliderLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 3)];
        _bottomSliderLine.tag = NSIntegerMax;
        _bottomSliderLine.backgroundColor = [UIColor gy_colorWithRGB:GYKIT_APP_MAIN_COLOR];
    }
    return _bottomSliderLine;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.gy_size.height)];
        _scrollView.bounces = NO;
        _scrollView.scrollsToTop = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}
@end
