//
//  FirstViewController.m
//  GYFramework
//
//  Created by GeYang on 2018/7/7.
//  Copyright © 2018年 GeYang. All rights reserved.
//

#import "FirstViewController.h"
#import "GYMineCollectionViewController.h"
#import "GYCoordinatingMediator.h"
#import "FirstCollectionViewCell.h"
#import "GYMineScrollPageRootController.h"
#import <Flutter/Flutter.h>
#import "GYCustomCameraController.h"

static NSString *kUICollectionViewCellReuseIdentifier = @"kUICollectionViewCellReuseIdentifier";

@interface FirstViewController () {
    NSArray *_actionArray;
}

@property (nonatomic, strong) FlutterViewController *flutterVC;

@end

@implementation FirstViewController
- (instancetype)init {
    if (self = [super init]) {
        _actionArray = @[
            @"Collection List",
            @"Controller嵌套联动",
            @"Flutter页面",
            @"自定义相机"
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
    return CGSizeMake(collectionView.gy_width, 50);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return GYKIT_GENERAL_SPACING1;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *title = [_actionArray objectAtIndex:indexPath.row];
    switch (indexPath.row) {
        case 0:{
            GYMineCollectionViewController *collectionVC = [[GYMineCollectionViewController alloc] initWithTitle:title];
            [self.navigationController pushViewController:collectionVC animated:YES];
        }
            break;
        case 1: {
            GYMineScrollPageRootController *rootVC = [[GYMineScrollPageRootController alloc] initWithTitle:title];
            [self.navigationController pushViewController:rootVC animated:YES];
        }
            break;
        case 2: {
            /**
             initialRoute：标志需要展示flutter哪个页面
             */
            self.flutterVC = [[FlutterViewController alloc] initWithProject:nil
                                                               initialRoute:@"Flutter Page1"
                                                                    nibName:nil bundle:nil];
            [self.navigationController pushViewController:self.flutterVC
                                                 animated:YES];
            //创建通信频道
            FlutterMethodChannel *nativeChannel = [FlutterMethodChannel methodChannelWithName:@"EachOtherChannel" binaryMessenger:(id)self.flutterVC.binaryMessenger];
            __weak typeof(self) weakself = self;
            //接收flutter回调的消息
            [nativeChannel setMethodCallHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult  _Nonnull result) {
                __strong typeof(weakself) strongself = weakself;
                if ([call.method isEqualToString:@"exit"]) {
                    [strongself.navigationController popViewControllerAnimated:YES];
                }
            }];
            //给flutter发送消息
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [nativeChannel invokeMethod:@"invokeFlutterMethod"
                                  arguments:@{@"title" : @"1213456"}];
            });
        }
            break;
        case 3: {
            GYCustomCameraController *cameraVC  = [[GYCustomCameraController alloc] init];
            [self.navigationController pushViewController:cameraVC
                                                 animated:YES];
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
