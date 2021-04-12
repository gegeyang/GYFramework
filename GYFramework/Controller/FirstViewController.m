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
            @"Gallery"
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
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - getter and setter
- (NSArray *)imageList {
    GYGalleryImageInfo *info1 = [GYGalleryImageInfo infoWithDictionary:@{@"cover" : @"https://i1.carimg.com/0/photo/0/057/866/603/000/1603866057/1603866057Psc6GH.jpg"}];
    GYGalleryImageInfo *info2 = [GYGalleryImageInfo infoWithDictionary:@{@"cover" : @"https://i.carimg.com/zf/0/110/056/588/000/1588056110/1588056110Ikh1kD.jpg"}];
    GYGalleryImageInfo *info3 = [GYGalleryImageInfo infoWithDictionary:@{@"cover" : @"https://i1.carimg.com/0/photo/0/122/993/587/000/1587993122/1587993122SJNHIu.png"}];
    GYGalleryImageInfo *info4 = [GYGalleryImageInfo infoWithDictionary:@{@"cover" : @"https://i.carimg.com/zf/0/133/994/587/000/1587994133/1587994133HwD2Ay.jpg"}];
    GYGalleryImageInfo *info5 = [GYGalleryImageInfo infoWithDictionary:@{@"cover" : @"https://i.carimg.com/zf/0/194/994/587/000/1587994194/15879941947IHZ9G.jpg"}];
    GYGalleryImageInfo *info6 = [GYGalleryImageInfo infoWithDictionary:@{@"cover" : @"https://i1.carimg.com/0/photo/0/068/995/587/000/1587995068/1587995068nquGLq.jpg"}];
    GYGalleryImageInfo *info7 = [GYGalleryImageInfo infoWithDictionary:@{@"cover" : @"https://i1.carimg.com/0/photo/0/068/995/587/000/1587995068/15879950686NQ7IQ.jpg"}];
    GYGalleryImageInfo *info8 = [GYGalleryImageInfo infoWithDictionary:@{@"cover" : @"https://i1.carimg.com/0/photo/0/068/995/587/000/1587995068/1587995068fgv2aE.jpg"}];
    GYGalleryImageInfo *info9 = [GYGalleryImageInfo infoWithDictionary:@{@"cover" : @"https://i1.carimg.com/0/photo/0/128/995/587/000/1587995128/1587995128TNqJC2.jpg"}];
    GYGalleryImageInfo *info10 = [GYGalleryImageInfo infoWithDictionary:@{@"cover" : @"https://i1.carimg.com/0/photo/0/128/995/587/000/1587995128/1587995128cNGUPL.jpg"}];
    return @[info1, info2, info3, info4, info5, info6, info7, info8, info9, info10];
}

@end
