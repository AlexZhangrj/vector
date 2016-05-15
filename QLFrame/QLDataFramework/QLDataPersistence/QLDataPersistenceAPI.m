//
//  QLDataPersistence.m
//  QLKit
//
//  Created by 王青海 on 16/2/17.
//  Copyright © 2016年 王青海. All rights reserved.
//

#import "QLDataPersistenceAPI.h"
#import "QLDirectoryHandleAPI.h"
#import "QLPersistenceManager.h"
#import "QLDirectoryHandleAPI.h"
#import "QLDatabase.h"
#import "QLSQLServiceAPI.h"


#import "QLFoundation.h"

static NSString *QLHomeDirectory_BaseName = @"DataPersistence_Doc";
static NSString *QLCacheHomeDirectory_BaseName = @"DataPersistence_Caches";
static NSString *QLTmpHomeDirectory_BaseName = @"DataPersistence_tmp";



//static NSString *QLHomeDirectoryName()
//{
//    static NSString *____QLHomeDirectoryName = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        if (!____QLHomeDirectoryName) {
//            ____QLHomeDirectoryName = [QLStringAPI md5_32:QLHomeDirectory_BaseName];
//        }
//    });
//    return ____QLHomeDirectoryName;
//}

@implementation QLDataPersistenceAPI


+ (NSString *)homeDirectoryName
{
    static NSString *____homeDirectoryName = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!____homeDirectoryName) {
            ____homeDirectoryName = [QLStringAPI md5_32:QLHomeDirectory_BaseName];
        }
    });
    return ____homeDirectoryName;
}

+ (NSString *)homeDirectory
{
    static NSString *____homeDirectory = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!____homeDirectory) {
            ____homeDirectory = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%@", [QLDataPersistenceAPI homeDirectoryName]]];
        }
    });
    return ____homeDirectory;
}

+ (NSString *)cacheHomeDirectory
{
    static NSString *____cacheHomeDirectory = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!____cacheHomeDirectory) {
            ____cacheHomeDirectory = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Library/Caches/%@", [QLStringAPI md5_32:QLCacheHomeDirectory_BaseName]]];
        }
    });
    return ____cacheHomeDirectory;
}

+ (NSString *)tmpHomeDirectory
{
    static NSString *____tmpHomeDirectory = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!____tmpHomeDirectory) {
            ____tmpHomeDirectory = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"tmp/%@", [QLStringAPI md5_32:QLTmpHomeDirectory_BaseName]]];
        }
    });
    return ____tmpHomeDirectory;
}



+ (void)initBase
{
    [QLDataPersistenceAPI prepareDirectiory];
    [QLSQLServiceAPI prepareDirectiory];
}

+ (void)prepareDirectiory
{
    [QLDataPersistenceAPI prepareDirectiory:[QLDataPersistenceAPI homeDirectory]];
    [QLDataPersistenceAPI prepareDirectiory:[QLDataPersistenceAPI cacheHomeDirectory]];
    [QLDataPersistenceAPI prepareDirectiory:[QLDataPersistenceAPI tmpHomeDirectory]];
}

+ (void)prepareDirectiory:(NSString *)path
{
    [QLDirectoryHandleAPI asyncInDirWorkQueue:^{
        BOOL isDirectory = NO;
        NSError *error = nil;
        BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDirectory];
        
        if (!fileExists) {
            BOOL result = [[NSFileManager defaultManager] createDirectoryAtPath:path
                                                    withIntermediateDirectories:YES
                                                                     attributes:nil
                                                                          error:&error];
            if (result) {
                NSLog(@"1 %s create DataPersistence homeDir success %@", __func__, path);
            }else {
                NSLog(@"1 %s create DataPersistence homeDir faild, error message:%@ path:%@", __func__, [error localizedDescription], path);
            }
        }else {
            if (!isDirectory) {
                NSError *removeError = nil;
                BOOL removeResult = [[NSFileManager defaultManager] removeItemAtPath:path error:&removeError];
                if (removeResult) {
                    NSLog(@"%s remove DataPersistence woring file success  %@", __func__, path);
                }else {
                    NSLog(@"%s remove DataPersistence woring file faild, error message:%@", __func__, [removeError localizedDescription]);
                }
                
                BOOL result = [[NSFileManager defaultManager] createDirectoryAtPath:path
                                                        withIntermediateDirectories:YES
                                                                         attributes:nil
                                                                              error:&error];
                if (result) {
                    NSLog(@"2 %s create DataPersistence homeDir success path:%@", __func__, path);
                }else {
                    NSLog(@"2 %s create DataPersistence homeDir faild, error message:%@ path:%@", __func__, [error localizedDescription], path);
                }
            }
        }
    }];
}


@end
