//
//  GYSandboxHelper.m
//  GYFramework
//
//  Created by Yang Ge on 2021/4/6.
//  Copyright © 2021 GeYang. All rights reserved.
//

#import "GYSandboxHelper.h"

@implementation GYSandboxHelper

+ (BOOL)checkAndCreatePath:(NSString *)path {
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    if ([fileMgr fileExistsAtPath:path]) {
        return YES;
    }
    return [fileMgr createDirectoryAtPath:path
              withIntermediateDirectories:YES
                               attributes:nil
                                    error:NULL];
}

+ (NSString *)documentPath {
    static NSString *s_documentPath = nil;
    if (!s_documentPath) {
        s_documentPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        if (![self checkAndCreatePath:s_documentPath]) {
            s_documentPath = nil;
        }
    }
    return s_documentPath;
}

+ (NSString *)libAppSupportPath {
    static NSString *s_appSupportPath = nil;
    if (!s_appSupportPath) {
        s_appSupportPath = [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        if (![self checkAndCreatePath:s_appSupportPath]) {
            s_appSupportPath = nil;
        }
    }
    return s_appSupportPath;
}

+ (NSString *)libCachedPath {
    static NSString *s_cachedPath = nil;
    if (!s_cachedPath) {
        s_cachedPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        s_cachedPath = [s_cachedPath stringByAppendingPathComponent:[[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString *)kCFBundleIdentifierKey]];
        s_cachedPath = [s_cachedPath stringByAppendingPathComponent:@"globalCachedData"];
    }
    if (![self checkAndCreatePath:s_cachedPath]) {
        s_cachedPath = nil;
    }
    return s_cachedPath;
}
@end


@implementation GYSandboxHelper (GYVideoCache)
+ (NSString *)gy_videoCache_basePath {
    NSString *basePath = [self libAppSupportPath];
    basePath = [basePath stringByAppendingString:@"/video_cache"];
    if (![self checkAndCreatePath:basePath]) {
        return nil;
    }
    return basePath;
}

+ (NSString *)gy_videoCache_inputPath:(NSString *)videoName {
    NSString *floderPath = [[self gy_videoCache_basePath] stringByAppendingFormat:@"/%@", videoName];
    return [floderPath stringByAppendingString:@"/input.mp4"];
}

+ (NSString *)gy_videoCache_savePath:(NSString *)videoName {
    NSString *floderPath = [[self gy_videoCache_basePath] stringByAppendingFormat:@"/%@", videoName];
    return [floderPath stringByAppendingString:@"/save.mp4"];
}

+ (NSString *)gy_videoCache_coverImagePath:(NSString *)videoName {
    NSString *floderPath = [[self gy_videoCache_basePath] stringByAppendingFormat:@"/%@", videoName];
    return [floderPath stringByAppendingString:@"/cover_image.jpg"];
}

@end

