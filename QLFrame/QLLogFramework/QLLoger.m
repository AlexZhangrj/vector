//
//  QLLoger.m
//  QLLogFrameWork
//
//  Created by 王青海 on 15/11/1.
//  Copyright © 2015年 王青海. All rights reserved.
//

#import "QLLoger.h"
#import "QLLogHeaders.h"
#import "QLLogModel.h"



@interface QLLoger ()


@end

@implementation QLLoger

- (dispatch_queue_t)getDoQueue
{
    return dispatch_get_global_queue(0, 0);
}


+ (QLLoger *)defaultLoger
{
    return ql_defaultLoger();
}

- (void)storeAllLogs
{
    
}

- (void)log:(QLLogModel *)logModel
{
    
}

- (void)configWithInfo:(NSDictionary *)info
{

}


- (void)logCrash:(NSException *)exception
{
//    if (nil == exception)
//    {
//        return;
//    }
//    //#ifdef DEBUG
//    NSLog(@"CRASH: %@", exception);
//    NSLog(@"Stack Trace: %@", [exception callStackSymbols]);
//    //#endif
//    // Internal error reporting
//    if ([[QLLog defaultLog] initSuccessed]) {
//        NSString * crashDic = QLLogCrashDirectory();
//        NSString * fileName = [NSString stringWithFormat:@"CRASH_%@.log", [QLLogAPI_NowBeijingTimeString() stringByReplacingOccurrencesOfString:@" " withString:@"_"]];
//        NSString * filePath = [crashDic stringByAppendingPathComponent:fileName];
//        NSString *content = [[NSString stringWithFormat:@"CRASH: %@\n", exception] stringByAppendingString:[NSString stringWithFormat:@"Stack Trace: %@\n", [exception callStackSymbols]]];
//        
//        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//        NSArray *languages = [defaults objectForKey:@"AppleLanguages"];
//        NSString *phoneLanguage = [languages objectAtIndex:0];
//        
//        content = [content stringByAppendingString:[NSString stringWithFormat:@"iPhone:%@  iOS Version:%@ Language:%@",QLLogAPI_PlatformString(), QLLogAPI_SystemVersion(),phoneLanguage]];
//        NSError *error = nil;
//        [content writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
//        
//        if (error) {
//            //            QLOLogCrashs(@"%@", error);
//        }
//    }
//    
//    //    QLLogFrashAllLogs
    
}

@end




void QLLogIntial()
{
    //    if (!logFilePath())
    //    {
    //        NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    //        NSString *logDirectory       = [documentsDirectory stringByAppendingString:@"/log/"];
    //        NSString *crashDirectory     = [documentsDirectory stringByAppendingString:@"/log/"];
    //
    //        if (![[NSFileManager defaultManager] fileExistsAtPath:logDirectory]) {
    //            [[NSFileManager defaultManager] createDirectoryAtPath:logDirectory
    //                                      withIntermediateDirectories:YES
    //                                                       attributes:nil
    //                                                            error:nil];
    //        }
    //
    //        if (![[NSFileManager defaultManager] fileExistsAtPath:crashDirectory]) {
    //            [[NSFileManager defaultManager] createDirectoryAtPath:crashDirectory
    //                                      withIntermediateDirectories:YES
    //                                                       attributes:nil
    //                                                            error:nil];
    //        }
    //
    //        logDic   = logDirectory;
    //        crashDic = crashDirectory;
    //
    //        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //        dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT+0800"];;
    //        NSString *fileNamePrefix = [dateFormatter stringFromDate:[NSDate date]];
    //        NSString *fileName = [NSString stringWithFormat:@"KK_log_%@.logtraces.txt", fileNamePrefix];
    //        NSString *filePath = [logDirectory stringByAppendingPathComponent:fileName];
    //
    //        logFilePath = filePath;
    //#if DEBUG
    //        NSLog(@"LogPath: %@", logFilePath);
    //#endif
    //        //create file if it doesn't exist
    //        if(![[NSFileManager defaultManager] fileExistsAtPath:filePath])
    //            [[NSFileManager defaultManager] createFileAtPath:filePath contents:nil attributes:nil];
    //
    //        //删除过期的日志
    //        NSDate *prevDate = [[NSDate date] dateByAddingTimeInterval:-60*60*24*k_preDaysToDelLog];
    //        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:prevDate];
    //        [components setHour:0];
    //        [components setMinute:0];
    //        [components setSecond:0];
    //
    //        //要删除三天以前的日志（0点开始）
    //        NSDate *delDate = [[NSCalendar currentCalendar] dateFromComponents:components];
    //        NSArray *logFiles = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:logDic error:nil];
    //        for (NSString *file in logFiles)
    //        {
    //            NSString *fileName = [file stringByReplacingOccurrencesOfString:@".logtraces.txt" withString:@""];
    //            fileName = [fileName stringByReplacingOccurrencesOfString:@"KK_log_" withString:@""];
    //            NSDate *fileDate = [dateFormatter dateFromString:fileName];
    //            if (nil == fileDate)
    //            {
    //                continue;
    //            }
    //            if (NSOrderedAscending == [fileDate compare:delDate])
    //            {
    //                [[NSFileManager defaultManager] removeItemAtPath:[logDic stringByAppendingString:file] error:nil];
    //            }
    //        }
    //    }
    //
    //    dispatch_once(&logQueueCreatOnce, ^{
    //        k_operationQueue =  dispatch_queue_create("com.coneboy.app.operationqueue", DISPATCH_QUEUE_SERIAL);
    //    });
    
    
}


//static inline void QLLogMsg(QLLogType type, NSString * func, NSUInteger line, NSString * format, va_list vaList)
//{
//    
//
//}


//static inline void QLLogWithFormat(NSString * format, va_list vaList)
//{

    
    
    
    
    //    __block NSString *formatTmp = format;
    //
    //    dispatch_async(k_operationQueue, ^{
    //
    //        if (level >= LogLevel)
    //        {
    //            formatTmp = [[KKLog KKLogFormatPrefix:level] stringByAppendingString:formatTmp];
    //            NSString *contentStr = [[NSString alloc] initWithFormat:formatTmp arguments:args];
    //            NSString *contentN = [contentStr stringByAppendingString:@"\n"];
    //            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //            NSString *content = [NSString stringWithFormat:@"%@ %@", [dateFormatter stringFromDate:[KKLog nowBeijingTime]], contentN];
    //            //append text to file (you'll probably want to add a newline every write)
    //            NSFileHandle *file = [NSFileHandle fileHandleForUpdatingAtPath:logFilePath];
    //            [file seekToEndOfFile];
    //            [file writeData:[content dataUsingEncoding:NSUTF8StringEncoding]];
    //            [file closeFile];
    //#ifdef DEBUG
    //            NSLog(@"%@", content);
    //#endif
    //            
    //            formatTmp = nil;
    //        }
    //        
    //    });
    
    
    
//}




