//
//  GYCollectionViewController.h
//  GYFramework
//
//  Created by GeYang on 2018/7/11.
//  Copyright © 2018年 GeYang. All rights reserved.
//

#import "GYViewController.h"
#import "GYListViewDataSource.h"

@interface GYCollectionViewController : GYViewController <UICollectionViewDelegate,
                                                          UICollectionViewDataSource,
                                                          UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *collectionLayout;
@property (nonatomic, strong) id <GYListViewDataSource> dataSource;

@end
