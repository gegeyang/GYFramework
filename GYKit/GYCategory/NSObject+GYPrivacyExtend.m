//
//  NSObject+GYPrivacyExtend.m
//  GYFramework
//
//  Created by Yang Ge on 2021/3/23.
//  Copyright © 2021 GeYang. All rights reserved.
//

#import "NSObject+GYPrivacyExtend.h"
#import <Photos/PHPhotoLibrary.h>
#import "NSObject+GYAlertExtend.h"
#import <AVFoundation/AVFoundation.h>

@implementation NSObject (GYPrivacyExtend)

- (void)gy_privacy_changeApplicationSetting:(NSString *)title
                                    appPref:(GYAppPref)appPref {
    GYAlertAction *okItem = [GYAlertAction actionWithTitle:NSLocalizedString(@"确定", nil)
                                                     style:GYAlertActionStyleDefault
                                                   handler:^(GYAlertAction *action) {
        NSString *urlString = UIApplicationOpenSettingsURLString;
        NSURL *url = [NSURL URLWithString:urlString];
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:url
                                               options:@{}
                                     completionHandler:nil];
        }
    }];
    [self gy_alertWithTitle:title
                    message:nil
                 alertStyle:GYAlertControllerStyleAlert
               cancelAction:[GYAlertAction cancelAction]
                otherAction:okItem, nil];
}

#pragma mark - 相册
- (void)gy_privacy_checkAndOpenPhotoLibWithCompletion:(void(^)(void))completion {
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
        dispatch_async(dispatch_get_main_queue(), ^{
            switch (status) {
                case PHAuthorizationStatusNotDetermined:
                case PHAuthorizationStatusAuthorized:
                case PHAuthorizationStatusLimited:
                    if (completion) {
                        completion();
                    }
                    break;
                case PHAuthorizationStatusRestricted:
                    [self gy_alertWithTitle:NSLocalizedString(@"家长控制，不允许访问照片", nil)
                                    message:nil
                                 alertStyle:GYAlertControllerStyleAlert
                               cancelAction:[GYAlertAction cancelAction]
                                otherAction:nil];
                    
                    break;
                case PHAuthorizationStatusDenied:
                    [self gy_privacy_changeApplicationSetting:@"请在设备的\"设置-隐私-照片\"中允许访问照片"
                                                      appPref:GYAppPrefPrivacyPhoto];
                    break;
            }
        });
    }];
}

#pragma mark - 相机
- (void)gy_privacy_checkAndOpenCameraWithCompletion:(void(^)(void))completion {
    [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo
                             completionHandler:^(BOOL granted) {
        dispatch_async(dispatch_get_main_queue(), ^{
            switch ([AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo]) {
                case AVAuthorizationStatusNotDetermined:
                case AVAuthorizationStatusAuthorized:
                    if (completion) {
                        completion();
                    }
                    break;
                case AVAuthorizationStatusRestricted:
                    [self gy_alertWithTitle:NSLocalizedString(@"家长控制，不允许访问相机", nil)
                                    message:nil
                                 alertStyle:GYAlertControllerStyleAlert
                               cancelAction:[GYAlertAction cancelAction]
                                otherAction:nil];
                    break;
                case AVAuthorizationStatusDenied:
                    [self gy_privacy_changeApplicationSetting:@"请在设备的\"设置-隐私-相机\"中允许访问相机"
                                                      appPref:GYAppPrefPrivacyCamera];
                    break;
            }
        });
    }];
}

@end
