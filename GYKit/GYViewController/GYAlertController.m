//
//  GYAlertController.m
//  GYFramework
//
//  Created by Yang Ge on 2021/3/23.
//  Copyright © 2021 GeYang. All rights reserved.
//

#import "GYAlertController.h"
#import "NSObject+GYAlertExtend.h"

#define GYALERTCONTROLLER_CELL_HEIGHT           roundf(GYKIT_GENERAL_FONTSIZE_S1 * 3.5)
#define GYALERTCONTROLLER_CELL_H_MARGIN         GYKIT_GENERAL_H_MARGIN
#define GYALERTCONTROLLER_CELL_FONTSIZE         GYKIT_GENERAL_FONTSIZE_S1
#define GYALERTCONTROLLER_CELL_V_MARGIN         10
#define GYALERTCONTROLLER_CELL_TITLE_V_MARGIN   25

@interface GYAlertAction ()

@property (nullable, nonatomic, copy) NSString *actionTitle;
@property (nullable, nonatomic, strong) NSAttributedString *actionAttributedTitle;
@property (nullable, nonatomic, copy) void(^handler)(GYAlertAction *action);
@property (nonatomic, assign) GYAlertActionStyle actionStyle;

- (CGFloat)calcHeight:(CGFloat)givenWidth;

@end


@implementation GYAlertAction

+ (instancetype)actionWithTitle:(nullable NSString *)title
                          style:(GYAlertActionStyle)style
                        handler:(void (^ __nullable)(GYAlertAction *action))handler {
    GYAlertAction *action = [[GYAlertAction alloc] init];
    action.actionTitle = title;
    action.actionStyle = style;
    action.handler = handler;
    action.enabled = YES;
    return action;
}

+ (instancetype)actionWithAttributedTitle:(nullable NSAttributedString *)attributedTitle
                                    style:(GYAlertActionStyle)style
                                  handler:(void (^ __nullable)(GYAlertAction *action))handler {
    GYAlertAction *action = [[GYAlertAction alloc] init];
    action.actionAttributedTitle = attributedTitle;
    action.actionStyle = style;
    action.handler = handler;
    action.enabled = YES;
    return action;
}

- (NSAttributedString *)convertActionTitle {
    if (self.actionTitle.length == 0) {
        return nil;
    }
    NSMutableAttributedString *attributedTitle = [[NSMutableAttributedString alloc] initWithString:self.actionTitle];
    const NSRange rangeTotal = NSMakeRange(0, self.actionTitle.length);
    switch (self.actionStyle) {
        case GYAlertActionStyleDefault: {
            [attributedTitle addAttribute:NSFontAttributeName
                                    value:[UIFont gy_CNFontWithFontSize:GYALERTCONTROLLER_CELL_FONTSIZE]
                                    range:rangeTotal];
            [attributedTitle addAttribute:NSForegroundColorAttributeName
                                    value:[UIColor gy_color3]
                                    range:rangeTotal];
        }
            break;
        case GYAlertActionStyleBold: {
            [attributedTitle addAttribute:NSFontAttributeName
                                    value:[UIFont gy_CNBoldFontWithFontSize:GYALERTCONTROLLER_CELL_FONTSIZE]
                                    range:rangeTotal];
            [attributedTitle addAttribute:NSForegroundColorAttributeName
                                    value:[UIColor gy_color3]
                                    range:rangeTotal];
        }
            break;
    }
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.alignment = NSTextAlignmentCenter;
    [attributedTitle addAttribute:NSParagraphStyleAttributeName
                            value:paraStyle
                            range:rangeTotal];
    return attributedTitle;
}

- (CGFloat)calcHeight:(CGFloat)givenWidth {
    if (!self.actionAttributedTitle && !self.actionTitle) {
        return 0;
    }
    return GYALERTCONTROLLER_CELL_HEIGHT;
}

@end


@implementation GYAlertAction(NormalExtend)

+ (instancetype)cancelAction {
    return [GYAlertAction actionWithTitle:@"取消"
                                    style:GYAlertActionStyleDefault
                                  handler:nil];
}

@end


@interface GYAlertHeader : UICollectionReusableView

@property (nonatomic, strong) UILabel *labelTitle;

+ (CGFloat)headerHeight:(CGFloat)givenWidth
         attributedText:(NSAttributedString *)attributedText;

@end

@implementation GYAlertHeader

+ (CGFloat)headerHeight:(CGFloat)givenWidth
         attributedText:(NSAttributedString *)attributedText {
    if (!attributedText) {
        return 0;
    }
    static dispatch_once_t onceToken;
    static UILabel *s_label = nil;
    dispatch_once(&onceToken, ^{
        s_label = [[UILabel alloc] init];
        s_label.numberOfLines = 0;
        s_label.textAlignment = NSTextAlignmentCenter;
        s_label.font = [UIFont gy_CNFontWithFontSize:GYALERTCONTROLLER_CELL_FONTSIZE];
    });
    s_label.attributedText = attributedText;
    return ceilf([s_label textRectForBounds:CGRectMake(0, 0, givenWidth - GYALERTCONTROLLER_CELL_H_MARGIN * 2, CGFLOAT_MAX)
                     limitedToNumberOfLines:0].size.height) + GYALERTCONTROLLER_CELL_TITLE_V_MARGIN * 2;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        const CGFloat hMargin = GYALERTCONTROLLER_CELL_H_MARGIN;
        const CGFloat vMargin = GYALERTCONTROLLER_CELL_TITLE_V_MARGIN;
        _labelTitle = [[UILabel alloc] init];
        _labelTitle.numberOfLines = 0;
        _labelTitle.textColor = [UIColor gy_color3];
        _labelTitle.textAlignment = NSTextAlignmentCenter;
        _labelTitle.font = [UIFont gy_CNFontWithFontSize:GYALERTCONTROLLER_CELL_FONTSIZE];
        [self addSubview:_labelTitle];
        [_labelTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(hMargin);
            make.right.mas_equalTo(-hMargin);
            make.top.mas_equalTo(vMargin);
            make.bottom.mas_equalTo(-vMargin);
        }];
        [self gy_drawBorderWithLineType:GYDrawLineBottom];
    }
    return self;
}

@end


@interface GYAlertCell : UICollectionViewCell

@property (nonatomic, strong) UILabel *labelTitle;

@end

@implementation GYAlertCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        const CGFloat hMargin = GYALERTCONTROLLER_CELL_H_MARGIN;
        _labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(hMargin, 0, self.gy_width - hMargin * 2, self.gy_height)];
        _labelTitle.font = [UIFont gy_CNFontWithFontSize:GYALERTCONTROLLER_CELL_FONTSIZE];
        _labelTitle.textColor = [UIColor gy_color3];
        _labelTitle.textAlignment = NSTextAlignmentCenter;
        _labelTitle.numberOfLines = 0;
        _labelTitle.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [self addSubview:_labelTitle];
    }
    return self;
}

@end


@interface GYAlertController () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nullable, nonatomic, strong) NSAttributedString *attributedTitle;
@property (nonatomic, strong) UILabel *labelTitle;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray<GYAlertAction *> *arrOtherActions;
@property (nonatomic, strong) NSMutableArray<GYAlertAction *> *arrCancelActions;
@property (nonatomic, strong) NSMutableArray<NSMutableArray *> *arrActions;
@property (nonatomic, assign) GYAlertControllerStyle preferredStyle;
@property (nonatomic, assign) CGFloat sectionBottomInset;
@property (nonatomic, assign) CGFloat contentBottomInset;

@end

@implementation GYAlertController

static NSString * const kWJAlertHeaderReusedIdentifier = @"kWJAlertHeaderReusedIdentifier";
static NSString * const kWJAlertCellReusedIdentifier = @"kWJAlertCellReusedIdentifier";

+ (instancetype)alertControllerWithAttributedTitle:(nullable NSAttributedString *)attributedTitle
                                    preferredStyle:(GYAlertControllerStyle)preferredStyle {
    GYAlertController *controller = [[GYAlertController alloc] init];
    controller.attributedTitle = attributedTitle;
    controller.preferredStyle = preferredStyle;
    switch (preferredStyle) {
        case GYAlertControllerStyleActionSheet:
            controller.sectionBottomInset = GYKIT_GENERAL_SPACING1;
            if (@available(iOS 11.0, *)) {
                controller.contentBottomInset = [UIApplication sharedApplication].windows[0].safeAreaInsets.bottom;
            }
            break;
        default:
            break;
    }
    return controller;
}

- (NSMutableArray<GYAlertAction *> *)arrOtherActions {
    if (!_arrOtherActions) {
        _arrOtherActions = [NSMutableArray array];
    }
    return _arrOtherActions;
}

- (NSMutableArray<GYAlertAction *> *)arrCancelActions {
    if (!_arrCancelActions) {
        _arrCancelActions = [NSMutableArray array];
    }
    return _arrCancelActions;
}

- (NSMutableArray<NSMutableArray *> *)arrActions {
    if (!_arrActions) {
        _arrActions = [NSMutableArray array];
    }
    return _arrActions;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumLineSpacing = layout.minimumInteritemSpacing = 0;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,
                                                                         0,
                                                                         self.view.gy_width,
                                                                         self.view.gy_height - self.contentBottomInset)
                                         collectionViewLayout:layout];
    switch (self.preferredStyle) {
        case GYAlertControllerStyleActionSheet:
            _collectionView.backgroundColor = [UIColor gy_colorWithRGB:0xF3F3F3];
            break;
        case GYAlertControllerStyleAlert:
            _collectionView.backgroundColor = [UIColor whiteColor];
            break;
    }
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.scrollEnabled = YES;
    _collectionView.bounces = NO;
    _collectionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [_collectionView registerClass:[GYAlertCell class]
        forCellWithReuseIdentifier:kWJAlertCellReusedIdentifier];
    [_collectionView registerClass:[GYAlertHeader class]
        forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
               withReuseIdentifier:kWJAlertHeaderReusedIdentifier];
    if (@available(iOS 11.0, *)) {
        _collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    [self.view addSubview:_collectionView];
    [_collectionView gy_drawBorderWithLineType:GYDrawLineTop];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - implementation
- (void)addCancelAction:(GYAlertAction *)action {
    if (!action) {
        return;
    }
    switch (self.preferredStyle) {
        case GYAlertControllerStyleActionSheet: {
            [self.arrCancelActions addObject:action];
            if ([self.arrActions indexOfObject:self.arrCancelActions] != 1) {
                [self.arrActions removeObject:self.arrCancelActions];
                [self.arrActions addObject:self.arrCancelActions];
            }
        }
            break;
        case GYAlertControllerStyleAlert: {
            [self.arrOtherActions insertObject:action atIndex:0];
            if ([self.arrActions indexOfObject:self.arrOtherActions] != 0) {
                [self.arrActions removeObject:self.arrOtherActions];
                [self.arrActions insertObject:self.arrOtherActions atIndex:0];
            }
        }
            break;
    }
}

- (void)addOtherActions:(NSArray<GYAlertAction *> *)arrAction {
    [self.arrOtherActions addObjectsFromArray:arrAction];
    if ([self.arrActions indexOfObject:self.arrOtherActions] != 0) {
        [self.arrActions removeObject:self.arrOtherActions];
        [self.arrActions insertObject:self.arrOtherActions atIndex:0];
    }
}

- (CGFloat)calcAllHeight:(CGFloat)givenWidth {
    CGFloat allHeight = [GYAlertHeader headerHeight:givenWidth
                                     attributedText:self.attributedTitle];
    const NSInteger sectionCount = self.arrActions.count;
    const NSInteger itemCount = self.arrCancelActions.count + self.arrOtherActions.count;
    if ((itemCount <= 2) && (self.preferredStyle == GYAlertControllerStyleAlert)) {
        allHeight += GYALERTCONTROLLER_CELL_HEIGHT;
    } else {
        for (NSInteger section = 0; section < sectionCount; section++) {
            NSArray *arrAction = [self.arrActions objectAtIndex:section];
            for (GYAlertAction *action in arrAction) {
                allHeight += [action calcHeight:givenWidth];
            }
            allHeight += self.sectionBottomInset;
        }
        if (sectionCount > 0) {
            allHeight += self.contentBottomInset - self.sectionBottomInset;
        }
    }
    return allHeight;
}

#pragma mark - UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.arrActions.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSArray *arrAction = [self.arrActions objectAtIndex:section];
    return arrAction.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    GYAlertCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kWJAlertCellReusedIdentifier
                                                                  forIndexPath:indexPath];
    const NSInteger section = indexPath.section;
    if (section >= 0 && section < self.arrActions.count) {
        NSArray *arrAction = [self.arrActions objectAtIndex:indexPath.section];
        const NSInteger row = indexPath.row;
        const NSInteger totalCount = arrAction.count;
        switch (self.preferredStyle) {
            case GYAlertControllerStyleActionSheet: {
                if (section > 0) {
                    [cell gy_drawBorderWithLineType:GYDrawLineTop];
                } else {
                    [cell gy_drawBorderWithLineType:GYDrawLineBottom];
                }
            }
                break;
            case GYAlertControllerStyleAlert: {
                if (row + 1 >= totalCount) {
                    [cell gy_drawBorderWithLineType:GYDrawLineNone];
                } else {
                    [cell gy_drawBorderWithLineType:GYDrawLineRight];
                }
            }
                break;
        }
        if (row >= 0 && row < totalCount) {
            GYAlertAction *action = [arrAction objectAtIndex:row];
            if (action.actionAttributedTitle) {
                cell.labelTitle.attributedText = action.actionAttributedTitle;
            } else if (action.actionTitle) {
                cell.labelTitle.attributedText = [action convertActionTitle];
            }
        } else {
            cell.labelTitle.text = nil;
            cell.labelTitle.attributedText = nil;
        }
    } else {
        cell.labelTitle.text = nil;
        cell.labelTitle.attributedText = nil;
        [cell gy_drawBorderWithLineType:GYDrawLineNone];
    }
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    GYAlertHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind
                                                               withReuseIdentifier:kWJAlertHeaderReusedIdentifier
                                                                      forIndexPath:indexPath];
    header.labelTitle.attributedText = self.attributedTitle;
    return header;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    const NSInteger section = indexPath.section;
    if (section >= 0 && section < self.arrActions.count) {
        NSArray *arrAction = [self.arrActions objectAtIndex:indexPath.section];
        const NSInteger row = indexPath.row;
        if (row >= 0 && row < arrAction.count) {
            GYAlertAction *action = [arrAction objectAtIndex:row];
            if (action.enabled) {
                if (action.handler) {
                    action.handler(action);
                }
                [self gy_hideAlertController];
            }
        }
    }
}

#pragma mark - UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    const NSInteger section = indexPath.section;
    if (section >= 0 && section < self.arrActions.count) {
        NSArray *arrAction = [self.arrActions objectAtIndex:indexPath.section];
        const NSInteger row = indexPath.row;
        if (row >= 0 && row < arrAction.count) {
            GYAlertAction *action = [arrAction objectAtIndex:row];
            const NSInteger itemCount = self.arrCancelActions.count + self.arrOtherActions.count;
            if ((itemCount <= 2) && (self.preferredStyle == GYAlertControllerStyleAlert)) {
                return CGSizeMake((itemCount == 0) ? collectionView.gy_width : floorf(collectionView.gy_width / itemCount),                                  GYALERTCONTROLLER_CELL_HEIGHT);
            } else {
                return CGSizeMake(collectionView.gy_width,
                                  [action calcHeight:collectionView.gy_width]);
            }
        }
    }
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    if (section == 0 && self.attributedTitle) {
        const CGFloat width = collectionView.gy_width;
        return CGSizeMake(width, [GYAlertHeader headerHeight:width
                                              attributedText:self.attributedTitle]);
    }
    return CGSizeZero;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (self.arrActions.count - 1 == section) {
        return UIEdgeInsetsMake(0, 0, 0, 0);
    } else {
        return UIEdgeInsetsMake(0, 0, self.sectionBottomInset, 0);
    }
}

@end


@implementation NSAttributedString(WJAlertControllerExtend)

+ (instancetype)gy_alert_attributedString:(NSString *)title
                                  message:(NSString *)message {
    NSMutableArray *arrInfo = [NSMutableArray array];
    if (title) {
        [arrInfo addObject:title];
    }
    if (message) {
        [arrInfo addObject:message];
    }
    if (arrInfo.count == 0) {
        return nil;
    }
    
    NSString *strTotal = [arrInfo componentsJoinedByString:@"\n"];
    const NSRange rangeTitle = title ? [strTotal rangeOfString:title] : NSMakeRange(0, NSNotFound);
    const NSRange rangeMessage = NSMakeRange(title ? title.length + 1 : 0, message.length);
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:strTotal];
    if (rangeTitle.length != NSNotFound) {
        [attributedString addAttribute:NSFontAttributeName
                                 value:[UIFont gy_CNFontWithFontSize:GYALERTCONTROLLER_CELL_FONTSIZE]
                                 range:rangeTitle];
        [attributedString addAttribute:NSForegroundColorAttributeName
                                 value:[UIColor gy_color3]
                                 range:rangeTitle];
        NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
        paraStyle.alignment = NSTextAlignmentCenter;
        paraStyle.paragraphSpacing = 6.0f;
        const NSRange rangeWithEnter = (arrInfo.count == 2) ? NSMakeRange(rangeTitle.location, rangeTitle.length + 1) : rangeTitle;
        [attributedString addAttribute:NSParagraphStyleAttributeName
                                 value:paraStyle
                                 range:rangeWithEnter];
    }
    if (rangeMessage.length != NSNotFound) {
        [attributedString addAttribute:NSFontAttributeName
                                 value:[UIFont gy_CNFontWithFontSize:GYALERTCONTROLLER_CELL_FONTSIZE - 4]
                                 range:rangeMessage];
        [attributedString addAttribute:NSForegroundColorAttributeName
                                 value:[UIColor gy_color9]
                                 range:rangeMessage];
        NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
        paraStyle.alignment = NSTextAlignmentCenter;
        [attributedString addAttribute:NSParagraphStyleAttributeName
                                 value:paraStyle
                                 range:rangeMessage];
    }
    return attributedString;
}


@end
