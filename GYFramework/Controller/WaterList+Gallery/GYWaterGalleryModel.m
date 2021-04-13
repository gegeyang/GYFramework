//
//  GYWaterGalleryModel.m
//  GYFramework
//
//  Created by Yang Ge on 2021/4/13.
//  Copyright © 2021 GeYang. All rights reserved.
//

#import "GYWaterGalleryModel.h"
#import "GYGalleryImageInfo.h"

@implementation GYWaterGalleryModel

- (void)fetchDataWithSuccess:(void (^)(void))success failure:(void (^)(NSError *))failure {
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
    [self.arrFetchResult addObjectsFromArray:@[info1, info2, info3, info4, info5, info6, info7, info8, info9, info10, info11, info12]];
    [self.arrFetchResult addObjectsFromArray:@[info1, info2, info3, info4, info5, info6, info7, info8, info9, info10, info11, info12]];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (success) {
            success();
        }
    });
}

@end
