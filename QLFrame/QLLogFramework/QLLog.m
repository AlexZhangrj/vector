//
//  QLLogAPI.m
//  QLLogFrameWork
//
//  Created by 王青海 on 15/11/1.
//  Copyright © 2015年 王青海. All rights reserved.
//


#import "QLLog.h"
#import "QLLogModel.h"
#import "QLLogHeaders.h"
#import "QLConsoleLoger.h"
#import "QLCustomLoger.h"
#import "QLTCPLoger.h"
#import "QLFileLoger.h"

#include <sys/types.h>
#include <sys/sysctl.h>
#import <UIKit/UIKit.h>




static NSString * const QLLogKeyFileInited = @"QLLogKeyFileInited";
static NSString * const QLLogInfoName = @"QLLog_info.plist";
static NSString * const QLLogHomeDictionryName = @"QLLogs";
static NSString * const QLLogTextFileDictionryName = @"textLogs";
static NSString * const QLLogSqliteDictionryName = @"fmdb";
static NSString * const QLLogCrashsDictionryName = @"crashFiles";


NSDate * QLLogAPI_NowBeijingTime()
{
    static NSTimeZone * ___timeZone = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!___timeZone) {
            ___timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT+0800"];
        }
    });
    NSDate * date = [NSDate date];
    
    NSInteger seconds = [___timeZone secondsFromGMTForDate: date];
    return [NSDate dateWithTimeInterval: seconds sinceDate: date];
}



static NSDateFormatter * QLLogAPI_TimeFormatter()
{
    static NSDateFormatter * ___qllogerTimeFormatter = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        if (!___qllogerTimeFormatter) {
            ___qllogerTimeFormatter = [[NSDateFormatter alloc] init];
            [___qllogerTimeFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss.sTZD"];
        }
    });
    return ___qllogerTimeFormatter;
}

NSString * QLLogAPI_NowBeijingTimeString()
{
    NSString *timeStr = [NSString stringWithFormat:@"%@", [QLLogAPI_TimeFormatter() stringFromDate:QLLogAPI_NowBeijingTime()]];
    return timeStr;
}

//static NSString *____QLLogHomeDirectory = nil;
//
//
//static void QLConfigLogHomeDirectory(NSString * rootPath)
//{
//    ____QLLogHomeDirectory = rootPath;
//}


/*
 home:QLLog / logs/
 crashs/
 db/
 qllog_info.plist
 
 */
NSString * QLLogHomeDirectory()
{
    NSString * directoryPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES) firstObject];
    NSString * logHomeDic = [directoryPath stringByAppendingPathComponent:QLLogHomeDictionryName];
    
    return logHomeDic;
}

NSString * QLLogTextFileDirectory()
{
    NSString * directoryPath = QLLogHomeDirectory();
    NSString * logFDic = [directoryPath stringByAppendingPathComponent:QLLogTextFileDictionryName];
    return logFDic;
}

NSString * QLLogSqliteDirectory()
{
    NSString * directoryPath = QLLogHomeDirectory();
    NSString * logFDic = [directoryPath stringByAppendingPathComponent:QLLogSqliteDictionryName];
    return logFDic;
}

NSString * QLLogCrashDirectory()
{
    NSString * directoryPath = QLLogHomeDirectory();
    NSString * logFDic = [directoryPath stringByAppendingPathComponent:QLLogCrashsDictionryName];
    return logFDic;
}










void QLLogStoreAllLogs()
{
    [[QLLog defaultLog] storeAllLogs];
}




dispatch_queue_t QLGetDistributionQueue()
{
    static dispatch_queue_t ____QLGetDistributionQueue = NULL;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        if (!____QLGetDistributionQueue) {
            ____QLGetDistributionQueue = dispatch_queue_create("com.ql.app.log_operationqueue", DISPATCH_QUEUE_SERIAL);
        }
    });
    return ____QLGetDistributionQueue;
}

void QLInitLogFileDirectorys()
{


}





static inline void QLMainLogFunc(NSObject * obj, QLFuncType funcType, NSDate * date, QLLogType logType, const char * func, NSUInteger line, NSString * tag, NSString * msg)
{
    @autoreleasepool {
        
        QLLogModel * logModel = [[QLLog defaultLog] logModel];
        
        logModel.funcType = funcType;
        switch (funcType) {
            case QLFuncTypeCfunc:
            {
                logModel.objAddress = 0;
                logModel.objDes = @"C";
            }
                break;
            case QLFuncTypeOCfunc:
            {
                logModel.objAddress = [NSString stringWithFormat:@"%p", obj];
                logModel.objDes = [obj description];
            }
                break;
            default:
                break;
        }
        logModel.logType = logType;
        logModel.date = date;
        logModel.func = [NSString stringWithCString:func encoding:NSUTF8StringEncoding];
        logModel.line = line;
        logModel.tag = tag;
        logModel.msg = msg;
        
        dispatch_async(QLGetDistributionQueue(), ^{
            @autoreleasepool {
                [[QLLog defaultLog] log:logModel];
            }
        });
        
    }
}

void QLObjLogMsgFunc(NSObject * obj, NSDate * date, QLLogType type, const char * func, NSUInteger line, NSString * tag, NSString * format, ...)
{
    va_list args;
    va_start(args, format);
    
    NSString *contentStr = [[NSString alloc] initWithFormat:format arguments:args];
    QLMainLogFunc(obj, QLFuncTypeOCfunc, date, type, func, line, tag, contentStr);
    va_end(args);
}

void QLCLogMsgFunc(NSDate * date, QLLogType type, const char * func, NSUInteger line, NSString * tag, NSString * format, ...)
{
    va_list args;
    va_start(args, format);
    @autoreleasepool {
        NSString *contentStr = [[NSString alloc] initWithFormat:format arguments:args];
        QLMainLogFunc(nil, QLFuncTypeCfunc, date, type, func, line, tag, contentStr);
    }
    va_end(args);
}






















@interface QLLog ()

//@property (nonatomic, strong) NSMutableArray * allLogModels;
@property (nonatomic, strong) NSMutableArray * cacheLogModels;


@property (nonatomic, strong) NSMutableArray * logers;


@end
@implementation QLLog

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.logers = [NSMutableArray array];
        self.cacheLogModels = [NSMutableArray array];
//        self.allLogModels = [NSMutableArray array];

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
        QLLogModel *model = self.cacheLogModels.firstObject;
        [self.cacheLogModels removeObjectAtIndex:0];
        return model;
    }else {
        QLLogModel *model = [[QLLogModel alloc]init];
        model.countBecomeTo0 = ^(QLLogModel *tmodle) {
            [QLLog cacheLogModel:tmodle];
        };
        
        return model;
    }
}

+ (void)cacheLogModel:(QLLogModel *)logModel
{
    

}


- (void)cacheLogModel:(QLLogModel *)logModel
{
    [self.cacheLogModels addObject:logModel];
}



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

+ (void)setOutputOptions:(QLLogTypeOptions)options
{
    {
        id<QLLoger> loger;
        if ((options & QLLogTypeOptionConsole) == QLLogTypeOptionConsole) {
            loger = [QLConsoleLoger defaultLoger];
            [[QLLog defaultLog].logers addObject:loger];
        }else {
            [[QLLog defaultLog].logers removeObject:loger];
        }
    }
    
    {
        id<QLLoger> loger;
        if ((options & QLLogTypeOptionFile) == QLLogTypeOptionFile) {
            loger = [QLFileLoger defaultLoger];
            [[QLLog defaultLog].logers addObject:loger];
        }else {
            [[QLLog defaultLog].logers removeObject:loger];
        }
    }
    
    {
        id<QLLoger> loger;
        if ((options & QLLogTypeOptionTCPOutput) == QLLogTypeOptionTCPOutput) {
            loger = [QLTCPLoger defaultLoger];
            [[QLLog defaultLog].logers addObject:loger];
        }else {
            [[QLLog defaultLog].logers removeObject:loger];
        }
    }
}

+ (void)addLoger:(id<QLLoger>)loger
{
    if (!loger) {
        [[QLLog defaultLog].logers addObject:loger];
    }
}

+ (void)removeLoger:(id<QLLoger>)loger
{
    if (!loger) {
        [[QLLog defaultLog].logers removeObject:loger];
    }
}


+ (QLLog *)defaultLog
{
    return QLLogAPI_DefaultLog();
}

- (void)logCrash:(NSException *)exception
{
    for (id<QLLoger> loger in self.logers) {
        [loger logCrash:exception];
    }
}

@end







NSString * QLLogAPI_PlatformString()
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithUTF8String:machine];
    free(machine);
    
    if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4 (GSM)";
    if ([platform isEqualToString:@"iPhone3,2"])    return @"iPhone 4 (GSM Rev A)";
    if ([platform isEqualToString:@"iPhone3,3"])    return @"iPhone 4 (CDMA)";
    if ([platform isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    if ([platform isEqualToString:@"iPhone5,1"])    return @"iPhone 5 (GSM)";
    if ([platform isEqualToString:@"iPhone5,2"])    return @"iPhone 5 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPhone5,3"])    return @"iPhone 5c (GSM)";
    if ([platform isEqualToString:@"iPhone5,4"])    return @"iPhone 5c (GSM+CDMA)";
    if ([platform isEqualToString:@"iPhone6,1"])    return @"iPhone 5s (GSM)";
    if ([platform isEqualToString:@"iPhone6,2"])    return @"iPhone 5s (GSM+CDMA)";
    if ([platform isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    if ([platform isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    if ([platform isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    if ([platform isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    if ([platform isEqualToString:@"iPod5,1"])      return @"iPod Touch 5G";
    if ([platform isEqualToString:@"iPad1,1"])      return @"iPad";
    if ([platform isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    if ([platform isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    if ([platform isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    if ([platform isEqualToString:@"iPad2,5"])      return @"iPad Mini (WiFi)";
    if ([platform isEqualToString:@"iPad2,6"])      return @"iPad Mini (GSM)";
    if ([platform isEqualToString:@"iPad2,7"])      return @"iPad Mini (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    if ([platform isEqualToString:@"iPad3,2"])      return @"iPad 3 (GSM+CDMA)";
    if ([platform isEqualToString:@"iPad3,3"])      return @"iPad 3 (GSM)";
    if ([platform isEqualToString:@"iPad3,4"])      return @"iPad 4 (WiFi)";
    if ([platform isEqualToString:@"iPad3,5"])      return @"iPad 4 (GSM)";
    if ([platform isEqualToString:@"iPad3,6"])      return @"iPad 4 (GSM+CDMA)";
    if ([platform isEqualToString:@"i386"])         return @"Simulator";
    if ([platform isEqualToString:@"x86_64"])       return @"Simulator";
    
    return platform;
}

NSString * QLLogAPI_SystemVersion()
{
    return [[UIDevice currentDevice] systemVersion];
}



