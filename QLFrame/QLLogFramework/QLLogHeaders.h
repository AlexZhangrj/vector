//
//  QLLogHeaders.h
//  QLLogFrameWork
//
//  Created by 王青海 on 15/10/31.
//  Copyright © 2015年 王青海. All rights reserved.
//



#ifndef QLLogHeaders_h
#define QLLogHeaders_h

#import "QLLogEnum.h"
#import "QLLogAPI.h"
//#define QLLogerUseSQLite
#import "QLFileLogOptions.h"



#import "QLLog.h"
#import "QLLoger.h"



#import "QLLogModel.h"

#import "QLLogParamsFile.h"












////文件校验
//static BOOL isNeedCreateAllLogDirectory()
//{
//    NSString * logHomeDic = ql_LogFileHomeDirectory();
//    
//    BOOL isDir;
//    BOOL fileExists;
//    fileExists = [[NSFileManager defaultManager] fileExistsAtPath:logHomeDic isDirectory:&isDir];
//    if (fileExists) {
//        if (isDir) {
//            NSString * textLogsDir = [logHomeDic stringByAppendingPathComponent:@"/textlogs"];
//            BOOL isDir1;
//            BOOL fileExists1;
//            fileExists1 = [[NSFileManager defaultManager] fileExistsAtPath:textLogsDir isDirectory:&isDir1];
//            if (fileExists1) {
//                
//            }else {
//                return YES;
//            }
//        }else {
//            return YES;
//        }
//    }else {
//        return YES;
//    }
//    return NO;
//}

//文件校验
//static BOOL isNeedCreateAllLogDirectory()
//{
//    NSString * logHomeDic = QLLogHomeDirectory();
//    
//    BOOL isDir;
//    BOOL fileExists;
//    fileExists = [[NSFileManager defaultManager] fileExistsAtPath:logHomeDic isDirectory:&isDir];
//    if (fileExists) {
//        NSString * qllogPlistPath = ql_logInfoPlistPath();
//        NSMutableDictionary * qllogInfo = [[NSMutableDictionary alloc] initWithContentsOfFile:qllogPlistPath];
//        NSLog(@"qllog文件创建成功 key：qllogKeyFileInited   dict：%@", qllogInfo);//直接打印数据。
//        if (!qllogInfo[QLLogKeyFileInited] ) {
//            return YES;
//        }
//    }else {
//        return YES;
//    }
//    return NO;
//}


//static void createAllLogDirectory()
//{
//    NSString * logHomeDic = ql_LogFileHomeDirectory();
//
//    NSFileManager * fdm = [NSFileManager defaultManager];
//    BOOL isDir;
//    BOOL fileExists;
//    fileExists = [fdm fileExistsAtPath:logHomeDic isDirectory:&isDir];
//    if (fileExists) {
//        if (isDir) {
//            NSString * textLogsDir = [logHomeDic stringByAppendingPathComponent:@"/textlogs"];
//            BOOL isDir1;
//            BOOL fileExists1;
//            fileExists1 = [[NSFileManager defaultManager] fileExistsAtPath:textLogsDir isDirectory:&isDir1];
//            if (fileExists1) {
//
//            }else {
//                
//            }
//        }else {
//            NSError * logHomeDicError;
//            if ([fdm removeItemAtPath:logHomeDic error:&logHomeDicError] != YES) {
//                NSLog(@"Unable to delete file: %@", [logHomeDicError localizedDescription]);
//            }
//            [fdm createDirectoryAtPath:logHomeDic withIntermediateDirectories:NO attributes:nil error:nil];
//        }
//    }else {
//        [fdm createDirectoryAtPath:logHomeDic withIntermediateDirectories:NO attributes:nil error:nil];
//    }
//}

//static void createAllLogDirectory()
//{
//    NSString * logHomeDic = ql_logHomeDirectory();
//    
//    NSFileManager * fdm = [NSFileManager defaultManager];
//    BOOL isDir;
//    BOOL fileExists;
//    fileExists = [fdm fileExistsAtPath:logHomeDic isDirectory:&isDir];
//    if (fileExists) {
//        if (isDir) {
//            if([fdm contentsOfDirectoryAtPath:logHomeDic error:nil]){
//                [fdm removeItemAtPath:logHomeDic error:nil];
//            }
//        }else {
//            NSError * logHomeDicError;
//            if ([fdm removeItemAtPath:logHomeDic error:&logHomeDicError] != YES) {
//                NSLog(@"Unable to delete file: %@", [logHomeDicError localizedDescription]);
//            }
//        }
//    }
//    
//    NSError * createError;
//    //主目录
//    BOOL result = [fdm createDirectoryAtPath:logHomeDic withIntermediateDirectories:NO attributes:nil error:&createError];
//    if (result) {
//        NSError * createError1;
//        //创建logFile 目录
//        BOOL result1 = [fdm createDirectoryAtPath:ql_logSqliteDirectory() withIntermediateDirectories:NO attributes:nil error:&createError1];
//        
//        
//        NSError * createError2;
//        BOOL result2 = [fdm createDirectoryAtPath:ql_logCrashDirectory() withIntermediateDirectories:NO attributes:nil error:&createError2];
//        
//        NSError * createError3;
//        BOOL result3 = [fdm createDirectoryAtPath:ql_logTextFileDirectory() withIntermediateDirectories:NO attributes:nil error:&createError3];
//        
//        
//        if (result1) {
//            
//        }else {
//            NSLog(@"%@", [createError1 localizedDescription]);
//        }
//        if (result2) {
//            
//        }else {
//            NSLog(@"%@", [createError2 localizedDescription]);
//        }
//        if (result3) {
//            
//        }else {
//            NSLog(@"%@", [createError3 localizedDescription]);
//        }
//        
//        if (result1 && result2 && result3) {
//            NSLog(@"%s 创建子文件夹成功", __func__);
//        }
//        
//        NSString * qllogPlistPath = ql_logInfoPlistPath();
//        NSMutableDictionary * qllogInfo = [[NSMutableDictionary alloc] init];
//        qllogInfo[QLLogKeyFileInited] = @"OK";
//        BOOL result4 = [qllogInfo writeToFile:qllogPlistPath atomically:YES];
//        if (result4) {
//            NSLog(@"logHomeDic : %@", logHomeDic);
//            NSLog(@"创建plist文件成功");
//        }
//    }else {
//        NSLog(@"%@", [createError localizedDescription]);
//    }
//}
//
//
//static inline void ql_initLogFileDirectorys()
//{
//    if (isNeedCreateAllLogDirectory()) {
//        createAllLogDirectory();
//    }
//    NSLog(@"logHomeDic : %@", ql_logHomeDirectory());
//}







#endif /* QLLogHeaders_h */
