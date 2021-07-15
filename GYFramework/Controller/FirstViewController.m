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
#import "GYWaterListController.h"
#import "NSObject+GYPrivacyExtend.h"
#import "GYGalleryViewController.h"
#import "GYGalleryImageInfo.h"
#import "GYWaterGalleryController.h"
#import "GYGraffitiViewController.h"
#import "GYAlbumListController.h"
#import "GYAlgorithmInfo.h"
#import "GYFramework-Swift.h"

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
            @"自定义相机",
            @"瀑布流",
            @"Gallery",
            @"瀑布流 + Gallery",
            @"涂鸦画板",
            @"相册",
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
            [self gy_privacy_checkAndOpenCameraWithCompletion:^{
                GYCustomCameraController *cameraVC  = [[GYCustomCameraController alloc] initWithSupportVideo:YES];
                [self.navigationController pushViewController:cameraVC
                                                     animated:YES];
            }];
        }
            break;
        case 4: {
            GYWaterListController *listVC = [[GYWaterListController alloc] init];
            [self.navigationController pushViewController:listVC animated:YES];
        }
            break;
        case 5: {
            GYGalleryViewController *galleryVC = [[GYGalleryViewController alloc] initWithImageList:[self imageList]];
            [self.navigationController pushViewController:galleryVC animated:YES];
        }
            break;
        case 6: {
            GYWaterGalleryController *controller = [[GYWaterGalleryController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case 7: {
            GYGraffitiViewController *graffVC = [[GYGraffitiViewController alloc] init];
            [self.navigationController pushViewController:graffVC animated:YES];
        }
            break;
        case 8: {
            GYAlbumListController *albumVC = [[GYAlbumListController alloc] init];
            [self.navigationController pushViewController:albumVC animated:YES];
        }
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - getter and setter
- (NSArray *)imageList {
    GYGalleryImageInfo *info1 = [GYGalleryImageInfo infoWithDictionary:@{@"cover" : @"https://i1.carimg.com/0/photo/300/108/000/6755a015c07ea466.jpg!l", @"width" : @"1100", @"height" : @"1064"}];
    GYGalleryImageInfo *info2 = [GYGalleryImageInfo infoWithDictionary:@{@"cover" : @"https://i1.carimg.com/0/photo/625/095/000/679586f7dae79e94.jpg!l", @"width" : @"1600", @"height" : @"1200"}];
    GYGalleryImageInfo *info3 = [GYGalleryImageInfo infoWithDictionary:@{@"cover" : @"https://i1.carimg.com/0/photo/797/061/000/61457fdf8931724c.jpg!l", @"width" : @"1200", @"height" : @"799"}];
    GYGalleryImageInfo *info4 = [GYGalleryImageInfo infoWithDictionary:@{@"cover" : @"https://i1.carimg.com/0/photo/157/063/000/60857fdf9077c29f.jpg!l", @"width" : @"1200", @"height" : @"966"}];
    GYGalleryImageInfo *info5 = [GYGalleryImageInfo infoWithDictionary:@{@"cover" : @"https://i1.carimg.com/0/photo/229/107/000/1859cb3bddb0869.jpg!l", @"width" : @"2000", @"height" : @"1500"}];
    GYGalleryImageInfo *info6 = [GYGalleryImageInfo infoWithDictionary:@{@"cover" : @"https://i1.carimg.com/0/photo/983/107/000/61459f2e9a8ced9b.jpg!l", @"width" : @"1800", @"height" : @"1201"}];
    GYGalleryImageInfo *info7 = [GYGalleryImageInfo infoWithDictionary:@{@"cover" : @"https://i1.carimg.com/0/photo/397/094/000/625586f7d7429888.jpg!l", @"width" : @"1200", @"height" : @"900"}];
    GYGalleryImageInfo *info8 = [GYGalleryImageInfo infoWithDictionary:@{@"cover" : @"https://i1.carimg.com/0/photo/449/051/000/21657fcc79b86a7a.jpg!l", @"width" : @"1500", @"height" : @"1035"}];
    GYGalleryImageInfo *info9 = [GYGalleryImageInfo infoWithDictionary:@{@"cover" : @"https://i1.carimg.com/0/photo/762/107/000/32259eae31fb0df3.jpg!l", @"width" : @"1557", @"height" : @"1148"}];
    GYGalleryImageInfo *info10 = [GYGalleryImageInfo infoWithDictionary:@{@"cover" : @"https://i1.carimg.com/0/photo/447/108/000/pNFb91A1xaQGnAbTsZUv.jpg!l", @"width" : @"960", @"height" : @"916"}];
    GYGalleryImageInfo *info11 = [GYGalleryImageInfo infoWithDictionary:@{@"cover" : @"https://i1.carimg.com/0/photo/652/108/000/egtwBPnN2sQOGiuiRbsU.jpg!l", @"width" : @"1200", @"height" : @"844"}];
    GYGalleryImageInfo *info12 = [GYGalleryImageInfo infoWithDictionary:@{@"cover" : @"https://i1.carimg.com/0/photo/113/107/000/93359c8c61338bc7.jpg!l", @"width" : @"1167", @"height" : @"779"}];
    return @[info1, info2, info3, info4, info5, info6, info7, info8, info9, info10, info11, info12];
}

@end
