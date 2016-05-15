//
//  QLLogAPI.h
//  QLLogFrameWork
//
//  Created by 王青海 on 15/11/1.
//  Copyright © 2015年 王青海. All rights reserved.
//


#import <Foundation/Foundation.h>

#import "QLLogEnum.h"


#ifndef QLLogAPI_C_h
#define QLLogAPI_C_h


@protocol QLLoger;

void QLLogStoreAllLogs();

NSDate * QLLogAPI_NowBeijingTime();
NSString * QLLogAPI_NowBeijingTimeString();

NSString * QLLogHomeDirectory();
NSString * QLLogCrashDirectory();

dispatch_queue_t QLGetDistributionQueue();

void QLInitLogFileDirectorys();

void QLObjLogMsgFunc(NSObject * obj, NSDate * date, QLLogType type, const char * func, NSUInteger line, NSString * tag, NSString * format, ...);

void QLCLogMsgFunc(NSDate * date, QLLogType type, const char * func, NSUInteger line, NSString * tag, NSString * format, ...);



#endif


@class QLLogModel;

@interface QLLog : NSObject

@property (nonatomic, assign, readonly) BOOL initSuccessed;


- (void)log:(QLLogModel *)logModel;
- (QLLogModel *)logModel;

+ (void)cacheLogModel:(QLLogModel *)logModel;
- (void)cacheLogModel:(QLLogModel *)logModel;

- (void)logCrash:(NSException *)exception;


- (void)storeAllLogs;

+ (void)setOutputOptions:(QLLogTypeOptions)options;

+ (void)addLoger:(id<QLLoger>)loger;
+ (void)removeLoger:(id<QLLoger>)loger;


+ (QLLog *)defaultLog;

@end




#define QLOLog(tag, format, ...) QLObjLogMsgFunc(self, QLLogAPI_NowBeijingTime(), QLLogTypeNormol, __FUNCTION__, __LINE__, tag, format, ##__VA_ARGS__);
#define QLOLogDebug(tag, format, ...) QLObjLogMsgFunc(self, QLLogAPI_NowBeijingTime(), QLLogTypeDebug, __FUNCTION__, __LINE__, tag, format, ##__VA_ARGS__);
#define QLOLogInfo(tag, format, ...) QLObjLogMsgFunc(self, QLLogAPI_NowBeijingTime(), QLLogTypeInfo, __FUNCTION__, __LINE__, tag, format, ##__VA_ARGS__);
#define QLOLogWarning(tag, format, ...) QLObjLogMsgFunc(self, QLLogAPI_NowBeijingTime(), QLLogTypeWarning, __FUNCTION__, __LINE__, tag, format, ##__VA_ARGS__);
#define QLOLogCrashs(tag, format, ...) QLObjLogMsgFunc(self, QLLogAPI_NowBeijingTime(), QLLogTypeCrash, __FUNCTION__, __LINE__, tag, format, ##__VA_ARGS__);
#define QLOLogError(tag, format, ...) QLObjLogMsgFunc(self, QLLogAPI_NowBeijingTime(), QLLogTypeError, __FUNCTION__, __LINE__, tag, format, ##__VA_ARGS__);


#define QLCLog(tag, format, ...) QLCLogMsgFunc(QLLogAPI_NowBeijingTime(), QLLogTypeNormol, __FUNCTION__, __LINE__, tag, format, ##__VA_ARGS__);
#define QLCLogDebug(tag, format, ...) QLCLogMsgFunc(QLLogAPI_NowBeijingTime(), QLLogTypeDebug, __FUNCTION__, __LINE__, tag, format, ##__VA_ARGS__);
#define QLCLogInfo(tag, format, ...) QLCLogMsgFunc(QLLogAPI_NowBeijingTime(), QLLogTypeInfo, __FUNCTION__, __LINE__, tag, format, ##__VA_ARGS__);
#define QLCLogWarning(tag, format, ...) QLCLogMsgFunc(QLLogAPI_NowBeijingTime(), QLLogTypeWarning, __FUNCTION__, __LINE__, tag, format, ##__VA_ARGS__);
#define QLCLogCrashs(tag, format, ...) QLCLogMsgFunc(QLLogAPI_NowBeijingTime(), QLLogTypeCrash, __FUNCTION__, __LINE__, tag, format, ##__VA_ARGS__);
#define QLCLogError(tag, format, ...) QLCLogMsgFunc(QLLogAPI_NowBeijingTime(), QLLogTypeError, __FUNCTION__, __LINE__, tag, format, ##__VA_ARGS__);

//#define QLLogFrashAllLogs
//QLLogStoreAllLogs();




static inline QLLog * QLLogAPI_DefaultLog()
{
    static QLLog * ___defaultLog = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        if (!___defaultLog) {
            ___defaultLog = [[QLLog alloc]init];
        }
    });
    return ___defaultLog;
}

NSString * QLLogAPI_PlatformString();
NSString * QLLogAPI_SystemVersion();





