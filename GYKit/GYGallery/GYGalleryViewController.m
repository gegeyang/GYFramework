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

@interface GYGalleryViewController ()

@property (nonatomic, strong) NSArray *imageList;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIView *viewNavigationBar;
@property (nonatomic, strong) UILabel *pageNumberLabel;
@property (nonatomic, strong) UIButton *backButton;

@end

@implementation GYGalleryViewController
- (instancetype)initWithImageList:(NSArray <id<GYGalleryItemObject>>*)imageList {
    if (self = [super init]) {
        self.imageList = imageList;
        self.dataSource = imageList;
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
