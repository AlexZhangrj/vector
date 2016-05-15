//
//  QLLog.m
//  QLLogFrameWork
//
//  Created by 王青海 on 15/10/31.
//  Copyright © 2015年 王青海. All rights reserved.
//

#import "QLLogAPI.h"
#import "QLLogHeaders.h"
#import "QLConsoleLoger.h"
#import "QLCustomLoger.h"
#import "QLTCPLoger.h"
#import "QLFileLoger.h"

#include <sys/types.h>
#include <sys/sysctl.h>
#import <UIKit/UIKit.h>
#import "QLLog.h"



//
//NSString * const QLLogOptionsKeyTCP = @"QLLogOptionsTCP";
//NSString * const QLLogOptionsKeyConsole = @"QLLogOptionsConsole";
//NSString * const QLLogOptionsKeyCustom = @"QLLogOptionsCustom";
//NSString * const QLLogOptionsKeyFile = @"QLLogOptionsFile";
//
//NSString * const QLLogKeyPort = @"QLLogPort";
//NSString * const QLLogKeyTags = @"QLLogTags";
//NSString * const QLLogKeyTag_filename = @"QLLogKeyTag_filename";
//NSString * const QLLogKeyTags_Color = @"QLLogTags_Color";
//NSString * const QLLogKeyClassStr = @"QLLogClassStr";


@interface QLLogAPI ()

@property (nonatomic, strong) NSMutableArray * cacheLogModels;


@property (nonatomic, strong) NSMutableArray * logers;


@end

@implementation QLLogAPI

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.logers = [NSMutableArray array];
        self.cacheLogModels = [NSMutableArray array];
        
        [self.logers addObject:[QLConsoleLoger defaultLoger]];
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            QLInitLogFileDirectorys();
            dispatch_async(QLGetDistributionQueue(), ^{
                [self setInitSuccessed:YES];
            });
        });
        
    }
    return self;
}

- (void)setInitSuccessed:(BOOL)initSuccessed
{
    if (initSuccessed != _initSuccessed) {
        _initSuccessed = initSuccessed;
    }
}

- (void)setLog:(QLLogBlock)log
{
    _log = nil;
    _log = [log copy];
}


- (void)log:(QLLogModel *)logModel
{
    for (id<QLLoger> loger in self.logers) {
        dispatch_async([loger getDoQueue], ^{
            
            @autoreleasepool {
                [loger log:logModel];
            }
        });
    }
}

- (QLLogModel *)logModel
{
    if (self.cacheLogModels.count > 0) {
        return self.cacheLogModels.firstObject;
    }else {
        return [[QLLogModel alloc]init];
    }
}

- (void)cacheLogModel:(QLLogModel *)logModel
{
    [self.cacheLogModels addObject:logModel];
}




/*
 typedef NS_OPTIONS(NSUInteger, QLLogOptions) {
 QLLogOptionConsole              = 1 <<  0,//控制台
 QLLogOptionTCPOutput            = 1 <<  1,//TCP
 QLLogOptionPersistent           = 1 <<  2,//持久化 写入文件
 QLLogOptionCustom               = 1 <<  3 //自定义
 };
 */
//+ (void)setOutputOptions:(QLLogOptions)options info:(NSDictionary *)info
//{
//    [[QLLog defaultLog].logers removeAllObjects];
//    id<QLLoger> loger;
//    
//    if ((options & QLLogOptionConsole) == QLLogOptionConsole) {
//        loger = [QLConsoleLoger defaultLoger];
//        [loger configWithInfo:info[QLLogOptionsKeyConsole]];
//        [[QLLog defaultLog].logers addObject:loger];
//    }
//    if ((options & QLLogOptionFile) == QLLogOptionFile) {
//        loger = [QLFileLoger defaultLoger];
//        [loger configWithInfo:info[QLLogOptionsKeyFile]];
//        [[QLLog defaultLog].logers addObject:loger];
//    }
//    if ((options & QLLogOptionTCPOutput) == QLLogOptionTCPOutput) {
//        loger = [QLTCPLoger defaultLoger];
//        [loger configWithInfo:info[QLLogOptionsKeyTCP]];
//        [[QLLog defaultLog].logers addObject:loger];
//    }
//    if ((options & QLLogOptionCustom) == QLLogOptionCustom) {
//        NSDictionary * custonLogerInfo = info[QLLogOptionsKeyCustom];
//        NSString * classStr = custonLogerInfo[QLLogKeyClassStr];
//        Class customLogerClass;
//        
//        if (classStr) {
//            customLogerClass = NSClassFromString(classStr);
//        }
//        if (classStr) {
//            customLogerClass = [QLCustomLoger class];
//        }
//        loger = [customLogerClass defaultLoger];
//        [loger configWithInfo:custonLogerInfo];
//        [[QLLog defaultLog].logers addObject:loger];
//    }
//}

- (void)storeAllLogs
{
    dispatch_group_t group = dispatch_group_create();

    for (id<QLLoger> loger in self.logers) {
        dispatch_group_async(group, [loger getDoQueue], ^{
            @autoreleasepool {
                [loger storeAllLogs];
            }
        });
    }
    
    
//    for (id<QLLoger> loger in self.logers) {
//        dispatch_group_enter(group);
//        dispatch_async([loger getDoQueue], ^{
//            [loger frashAllLogs];
//            dispatch_group_leave(group);
//        });
//    }
    
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
}


+ (QLLog *)defaultLog
{
//    return ql_defaultLog();
    return nil;
}

- (void)logCrash:(NSException *)exception
{
    if (nil == exception)
    {
        return;
    }
    //#ifdef DEBUG
    NSLog(@"CRASH: %@", exception);
    NSLog(@"Stack Trace: %@", [exception callStackSymbols]);
    //#endif
    // Internal error reporting
    if ([[QLLog defaultLog] initSuccessed]) {
        NSString * crashDic = QLLogCrashDirectory();
        NSString * fileName = [NSString stringWithFormat:@"CRASH_%@.log", [QLLogAPI_NowBeijingTimeString() stringByReplacingOccurrencesOfString:@" " withString:@"_"]];
        NSString * filePath = [crashDic stringByAppendingPathComponent:fileName];
        NSString *content = [[NSString stringWithFormat:@"CRASH: %@\n", exception] stringByAppendingString:[NSString stringWithFormat:@"Stack Trace: %@\n", [exception callStackSymbols]]];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSArray *languages = [defaults objectForKey:@"AppleLanguages"];
        NSString *phoneLanguage = [languages objectAtIndex:0];
        
        content = [content stringByAppendingString:[NSString stringWithFormat:@"iPhone:%@  iOS Version:%@ Language:%@",QLLogAPI_PlatformString(), QLLogAPI_SystemVersion(),phoneLanguage]];
        NSError *error = nil;
        [content writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
        
        if (error) {
//            QLOLogCrashs(@"%@", error);
        }
    }
    
//    QLLogFrashAllLogs
    
}

@end







//NSString * ql_platformString()
//{
//    size_t size;
//    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
//    char *machine = malloc(size);
//    sysctlbyname("hw.machine", machine, &size, NULL, 0);
//    NSString *platform = [NSString stringWithUTF8String:machine];
//    free(machine);
//    
//    if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
//    if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
//    if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
//    if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4 (GSM)";
//    if ([platform isEqualToString:@"iPhone3,2"])    return @"iPhone 4 (GSM Rev A)";
//    if ([platform isEqualToString:@"iPhone3,3"])    return @"iPhone 4 (CDMA)";
//    if ([platform isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
//    if ([platform isEqualToString:@"iPhone5,1"])    return @"iPhone 5 (GSM)";
//    if ([platform isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (GSM+CDMA)";
//    if ([platform isEqualToString:@"iPhone5,3"])    return @"iPhone 5c (GSM)";
//    if ([platform isEqualToString:@"iPhone5,4"])    return @"iPhone 5c (GSM+CDMA)";
//    if ([platform isEqualToString:@"iPhone6,1"])    return @"iPhone 5s (GSM)";
//    if ([platform isEqualToString:@"iPhone6,2"])    return @"iPhone 5s (GSM+CDMA)";
//    if ([platform isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
//    if ([platform isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
//    if ([platform isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
//    if ([platform isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
//    if ([platform isEqualToString:@"iPod5,1"])      return @"iPod Touch 5G";
//    if ([platform isEqualToString:@"iPad1,1"])      return @"iPad";
//    if ([platform isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
//    if ([platform isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
//    if ([platform isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
//    if ([platform isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
//    if ([platform isEqualToString:@"iPad2,6"])      return @"iPad Mini (GSM)";
//    if ([platform isEqualToString:@"iPad2,7"])      return @"iPad Mini (GSM+CDMA)";
//    if ([platform isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
//    if ([platform isEqualToString:@"iPad3,2"])      return @"iPad 3 (GSM+CDMA)";
//    if ([platform isEqualToString:@"iPad3,3"])      return @"iPad 3 (GSM)";
//    if ([platform isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
//    if ([platform isEqualToString:@"iPad3,5"])      return @"iPad 4 (GSM)";
//    if ([platform isEqualToString:@"iPad3,6"])      return @"iPad 4 (GSM+CDMA)";
//    if ([platform isEqualToString:@"i386"])         return @"Simulator";
//    if ([platform isEqualToString:@"x86_64"])       return @"Simulator";
//    
//    return platform;
//}
//
//NSString * ql_systemVersion()
//{
//    return [[UIDevice currentDevice] systemVersion];
//}
//
