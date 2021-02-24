//
//  FirstViewController.m
//  GYFramework
//
//  Created by GeYang on 2018/7/7.
//  Copyright © 2018年 GeYang. All rights reserved.
//

#import "FirstViewController.h"
#import "GYViewController+GYNavBarExtend.h"
#import "GYMineCollectionViewController.h"
#import "GYCoordinatingMediator.h"
#import "FirstCollectionViewCell.h"

static NSString *kUICollectionViewCellReuseIdentifier = @"kUICollectionViewCellReuseIdentifier";

@interface FirstViewController () {
    NSArray *_actionArray;
}

@end

@implementation FirstViewController
- (instancetype)init {
    if (self = [super init]) {
        _actionArray = @[
            @"Collection List",
            @"Controller嵌套联动"
        ];
    }
    return self;
}

- (void)loadView {
    [super loadView];
    [self gy_navigation_initTitle:@"第一页"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.collectionView registerClass:[FirstCollectionViewCell class]
            forCellWithReuseIdentifier:kUICollectionViewCellReuseIdentifier];
    [self.collectionView reloadData];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _actionArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FirstCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kUICollectionViewCellReuseIdentifier forIndexPath:indexPath];
    [cell updateCellInfo:[_actionArray objectAtIndex:indexPath.row]];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(collectionView.gy_width, 40);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return GYKIT_GENERAL_SPACING1;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:{
            GYMineCollectionViewController *collectionVC = [[GYMineCollectionViewController alloc] init];
            [self.navigationController pushViewController:collectionVC animated:YES];
        }
            break;
        case 1: {
            
        }
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
