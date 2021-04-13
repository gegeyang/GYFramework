//
//  GYGalleryViewController.m
//  GYFramework
//
//  Created by Yang Ge on 2021/4/12.
//  Copyright © 2021 GeYang. All rights reserved.
//

#import "GYGalleryViewController.h"
#import "NSArray+GYListViewDataSource.h"
#import "GYGalleryCollectionCell.h"

static NSString *const kGYGalleryCollectionCellReuseIdentifier = @"kGYGalleryCollectionCellReuseIdentifier";

@interface GYGalleryViewController () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) NSArray *imageList;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *viewNavigationBar;
@property (nonatomic, strong) UILabel *pageNumberLabel;
@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UITapGestureRecognizer *doubleTap;

@end

@implementation GYGalleryViewController
- (instancetype)initWithImageList:(NSArray <id<GYGalleryItemObject>>*)imageList {
    if (self = [super init]) {
        self.imageList = imageList;
        self.dataSource = imageList;
        self.selectedIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:self.contentView];
    [self.contentView addSubview:self.viewNavigationBar];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.mas_equalTo(0);
    }];
    [self.viewNavigationBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.mas_equalTo(0);
        make.height.mas_equalTo(GYKIT_NAVIGATIONBAR_HEIGHT + self.safeAreaInsets.top);
    }];
    
    self.collectionLayout.sectionInset = UIEdgeInsetsZero;
    self.collectionLayout.minimumLineSpacing = 0;
    self.collectionLayout.minimumInteritemSpacing = 0;
    self.collectionLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView.alwaysBounceVertical = NO;
    self.collectionView.pagingEnabled = YES;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.allowsSelection = NO;
    [self.collectionView registerClass:[GYGalleryCollectionCell class]
            forCellWithReuseIdentifier:kGYGalleryCollectionCellReuseIdentifier];
    [self.collectionView reloadData];
    [self.collectionView scrollToItemAtIndexPath:self.selectedIndexPath
                                atScrollPosition:UICollectionViewScrollPositionNone
                                        animated:NO];
    //
    self.doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onDoubleTap:)];
    self.doubleTap.numberOfTapsRequired = 2;
    self.doubleTap.delegate = self;
    [self.view addGestureRecognizer:self.doubleTap];
    [self updateTitleInfo];
}

- (void)viewContentInsetDidChanged {
    [super viewContentInsetDidChanged];
    [_viewNavigationBar mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(GYKIT_NAVIGATIONBAR_HEIGHT + self.safeAreaInsets.top);
    }];
}

#pragma mark - implementaction
- (void)onClickBack:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onDoubleTap:(UITapGestureRecognizer *)gesture {
    GYGalleryCollectionCell *cell = (GYGalleryCollectionCell *)[self.collectionView cellForItemAtIndexPath:self.selectedIndexPath];
    [cell doubleTapOnPoint:[gesture locationInView:cell]];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    const NSInteger oldSection = self.selectedIndexPath.section;
    const NSInteger sectionCount = self.collectionView.numberOfSections;
    const NSInteger rowCount = [self.collectionView numberOfItemsInSection:oldSection];
    NSInteger newRow = roundf(scrollView.contentOffset.x / scrollView.gy_width);
    NSInteger newSection = 0;
    for (NSInteger sectionIndex = 0; sectionIndex < sectionCount; sectionIndex++) {
        const NSInteger sectionItemCount = [self.collectionView numberOfItemsInSection:sectionIndex];
        if (newRow >= sectionItemCount) {
            newSection++;
            newRow-=sectionItemCount;
        } else {
            break;
        }
    }
    newSection = MAX(0, MIN(sectionCount - 1, newSection));
    newRow = MAX(0, MIN(rowCount - 1, newRow));
    self.selectedIndexPath = [NSIndexPath indexPathForRow:newRow
                                                inSection:newSection];
    [self updateTitleInfo];
}

- (void)updateTitleInfo {
    NSString *strPageNumber = [NSString stringWithFormat:@"%@ / %@",
                               @(self.selectedIndexPath.row + 1),
                               @([self.dataSource numberOfDatasInSection:0])];
    self.pageNumberLabel.text = strPageNumber;
    self.viewNavigationBar.hidden = NO;
}

#pragma mark - UICollectionViewDataSource and UICollectionViewDelegateFlowLayout
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    id<GYGalleryItemObject> itemObject = [self.dataSource itemInfoAtIndexPath:indexPath];
    NSAssert([itemObject conformsToProtocol:@protocol(GYGalleryItemObject)], @" not realize GYGalleryItemObject... ");
    switch (itemObject.galleryItemType) {
        case GYGalleryItemTypeVideo: {
            
        }
            break;
        default: {
            GYGalleryCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kGYGalleryCollectionCellReuseIdentifier
                                                                                      forIndexPath:indexPath];
            [cell updateCellInfo:itemObject];
            return cell;
        }
            break;
    }
    return nil;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return collectionView.bounds.size;
}

#pragma mark - getter and setter
- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] initWithFrame:self.view.bounds];
        _contentView.backgroundColor = [UIColor clearColor];
        [_contentView addSubview:self.collectionView];
        self.collectionView.translatesAutoresizingMaskIntoConstraints = YES;
        self.collectionView.frame = _contentView.bounds;
    }
    return _contentView;
}

- (UIView *)viewNavigationBar {
    if (!_viewNavigationBar) {
        _viewNavigationBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.gy_width, GYKIT_NAVIGATIONBAR_HEIGHT + self.safeAreaInsets.top)];
        _viewNavigationBar.backgroundColor = [UIColor clearColor];
        
        _pageNumberLabel = [[UILabel alloc] init];
        _pageNumberLabel.font = [UIFont gy_CNFontSizeS1];
        _pageNumberLabel.textColor = [UIColor whiteColor];
        _pageNumberLabel.numberOfLines = 1;
        _pageNumberLabel.textAlignment = NSTextAlignmentCenter;
        [_viewNavigationBar addSubview:_pageNumberLabel];
        
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton setImage:[UIImage imageNamed:@"common_back_white"] forState:UIControlStateNormal];
        [_backButton addTarget:self
                        action:@selector(onClickBack:)
              forControlEvents:UIControlEventTouchUpInside];
        [_viewNavigationBar addSubview:_backButton];
        
        [_pageNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.viewNavigationBar.mas_bottom);
            make.centerX.mas_equalTo(self.viewNavigationBar.mas_centerX);
        }];
        [_backButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.bottom.mas_equalTo(0);
            make.size.mas_equalTo(CGSizeMake(self.backButton.imageView.image.size.width + GYKIT_GENERAL_H_MARGIN * 2, GYKIT_NAVIGATIONBAR_HEIGHT));
        }];
    }
    return _viewNavigationBar;
}

@end
