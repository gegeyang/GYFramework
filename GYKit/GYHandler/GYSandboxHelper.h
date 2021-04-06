//
//  GYSandboxHelper.h
//  GYFramework
//
//  Created by Yang Ge on 2021/4/6.
//  Copyright © 2021 GeYang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GYSandboxHelper : NSObject

/**
 判断是否存目录，若不存在，创建该目录
 */
+ (BOOL)checkAndCreatePath:(NSString *)path;

/**
 Document/xxx
 */
+ (NSString * _Nullable)documentPath;

/**
 Library/Application Support/xxx
 */
+ (NSString * _Nullable)libAppSupportPath;

/**
 Library/Caches/xxx
 */
+ (NSString * _Nullable)libCachedPath;

@end

@interface GYSandboxHelper (GYVideoCache)
/**
 video基础目录
 */
+ (NSString *)gy_videoCache_basePath;
/**
 video录制中写入路径
 */
+ (NSString *)gy_videoCache_inputPath:(NSString *)videoName;
/**
 video录制完成保存路径
 */
+ (NSString *)gy_videoCache_savePath:(NSString *)videoName;
/**
 video封面图路径
 */
+ (NSString *)gy_videoCache_coverImagePath:(NSString *)videoName;
@end

NS_ASSUME_NONNULL_END
