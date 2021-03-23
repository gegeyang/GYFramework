//
//  NSObject+GYPrivacyExtend.h
//  GYFramework
//
//  Created by Yang Ge on 2021/3/23.
//  Copyright © 2021 GeYang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, GYAppPref) {
    GYAppPrefPrivacyLocation, //隐私定位
    GYAppPrefPrivacyPhoto, //隐私相册
    GYAppPrefPrivacyCamera, //隐私相机
    GYAppPrefPrivacyContact, //隐私通讯录
    GYAppPrefLocation, // 定位
    GYAppPrefPhoto, // 相册
    GYAppPrefCamera, // 相机
    GYAppPrefContact, // 通讯录
    GYAppPrefNetwork,//网络
};

@interface NSObject (GYPrivacyExtend)

@end

NS_ASSUME_NONNULL_END
