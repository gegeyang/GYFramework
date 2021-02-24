//
//  GYGlobalDefines.h
//  GYFramework
//
//  Created by GeYang on 2018/6/4.
//  Copyright © 2018年 GeYang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GYGlobalConst.h"

/* 判断版本号 */
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define GYKIT_IS_IOS9_OR_LATER      SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"9.0")
#define GYKIT_IS_IOS10_OR_LATER     SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"10.0")
#define GYKIT_IS_IOS11_OR_LATER     SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"11.0")

/* 分辨率 屏幕宽高 判断设备 */
#define SCREEN_MODE_SIZE                [UIScreen mainScreen].currentMode.size
#define SCREEN_NATIVEBOUNDS_SIZE        [UIScreen mainScreen].nativeBounds.size

/* build版本号 发布版本号 名称 */
#define GYKIT_SHORT_VERSION_STRING      ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"])
#define GYKIT_BUNDLER_VERSION_STRING    ([[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleVersionKey])
#define GYKIT_DISPLAY_NAME_STRING      ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"])

/* 状态栏高度 导航栏高度 tabbar底部距离 tabbar高度 tabbar字体大小 */
#define GYKIT_NAVIGATIONBAR_HEIGHT          44.0f
#define GYKIT_TABBAR_HEIGHT                 49.0f
#define GYKIT_TABBAR_TITLE_FONT_SIZE        10.0f

/* 定义基础间距 */
#define GYKIT_GENERAL_H_MARGIN              15.0f
#define GYKIT_GENERAL_SPACING1              5.0f
#define GYKIT_GENERAL_SPACING2              10.0f
#define GYKIT_GENERAL_SPACING3              15.0f
#define GYKIT_GENERAL_SPACING4              20.0f

/* 定义基础字体大小 */
#define GYKIT_GENERAL_BASE_FONTSIZE         18.0f
#define GYKIT_GENERAL_FONTSIZE_S1           (GYKIT_GENERAL_BASE_FONTSIZE - 3)  // 15
#define GYKIT_GENERAL_FONTSIZE_S2           (GYKIT_GENERAL_BASE_FONTSIZE - 4)  // 12
#define GYKIT_GENERAL_FONTSIZE_S3           (GYKIT_GENERAL_BASE_FONTSIZE - 6)  // 10
#define GYKIT_GENERAL_FONTSIZE_S4           (GYKIT_GENERAL_BASE_FONTSIZE - 7)  // 9

/* 定义APP主色值 */
#define GYKIT_APP_MAIN_COLOR                0x0488EC
#define GYKIT_PAGEBG_COLOR_HEX              0xFFFFFF

/*tabbar相关*/
#define GYKIT_APP_TABBAR_TITLE_COLOR_NORMAL     0x333333
#define GYKIT_APP_TABBAR_TITLE_COLOR_SELECTED   0x0488EC
#define GYKIT_APP_TABBAR_BG_COLOR_HEX           0xFFFFFF   //tabbar背景色
#define GYKIT_APP_TABBAR_TOPLINE_COLOR_HEX      0xEBEBEB   //tabbar顶部线条颜色
#define GYKIT_APP_TABBAR_FONT_SIZE              11 

/* 状态栏默认样式 */
#define GYKIT_STATUSBAR_STYLE               UIStatusBarStyleLightContent

/* 底部线的厚度 */
#define GYKIT_LINE_THICKNESS            (1.0 / [UIScreen mainScreen].scale)

/* 网络错误 */
#define GYNETWORK_SERVER_CODE_FAILDDOMAIN   @"GY_SERVER_CODE_ERROR"
#define GYNETWORK_CACHED_TIME_KEY           @"GY-Cache-Expiration-Time"
#define GYNETWORK_CACHED_DATE_KEY           @"GY-Cache-Expiration-Date"

/*基础图片*/
#define GYKIT_IMAGE_BACK_GRAY               [UIImage imageNamed:@"common_gary_back"]
#define GYKIT_IMAGE_BACK_WHITE              [UIImage imageNamed:@"common_back_white"]


typedef void(^GYVoidBlock)(void);

typedef NS_ENUM(NSInteger, GYCoordinatingControllerTag) {
    GYCoordinatingControllerTagFirstPage,
    GYCoordinatingControllerTagSecondPage,
    GYCoordinatingControllerTagThirdPage,
    GYCoordinatingControllerTagCollectionPage,
};

static inline UIEdgeInsets GYJoinEdgeInsets(UIEdgeInsets edgeInsets1, UIEdgeInsets edgeInsets2) {
    UIEdgeInsets joinResult = edgeInsets1;
    joinResult.top += edgeInsets2.top;
    joinResult.bottom += edgeInsets2.bottom;
    joinResult.left += edgeInsets2.left;
    joinResult.right += edgeInsets2.right;
    return joinResult;
}
