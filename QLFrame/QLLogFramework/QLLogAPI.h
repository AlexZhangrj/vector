//
//  QLLog.h
//  QLLogFrameWork
//
//  Created by 王青海 on 15/10/31.
//  Copyright © 2015年 王青海. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QLLogEnum.h"


//extern NSString * const QLLogOptionsKeyTCP;
//extern NSString * const QLLogOptionsKeyConsole;
//extern NSString * const QLLogOptionsKeyFile;
//extern NSString * const QLLogOptionsKeyCustom;
//extern NSString * const QLLogKeyPort;
//extern NSString * const QLLogKeyTags;
//extern NSString * const QLLogKeyTag_filename;
//extern NSString * const QLLogKeyTags_Color;
//extern NSString * const QLLogKeyClassStr;

@class QLLog;

@class QLLogModel;


typedef void(^QLLogBlock)(QLLogType type, id obj, NSString * timeStr, NSString * func, NSUInteger line, NSString * msg, NSUInteger tag);
typedef void(^QLLogDetailMsgBlock)(QLLogType type, NSString * func, NSUInteger line, uint32_t tag, NSString * msg);

@interface QLLogAPI : NSObject

@property (nonatomic, readonly) QLLogBlock log;
//@property (nonatomic, readonly) QLLogDetailMsgBlock logDetailMsg;
@property (nonatomic, assign, readonly) BOOL initSuccessed;


/*
 info 配置字典
 {
    @”QLLogOptionsTCP“ : {}
    @”QLLogOptionsConsole“ : {}
    @”QLLogOptionsFile“ : {}
    @”QLLogOptionsCustom“ : {}
 }
 
 二级字典：
 {
    @“Port” ：port  //tcp 端口 缺省-17543 17544 ... //tcp 输出端口
    @“Tags” ：  @[tag1<NSNumber>, tag2<NSNumber>]  //tcp输出的指定tag的日志 tag1<NSNumber>， tag2  <NSNumber> 缺省-全部tag
 
    @"tag_filename" : {tag : filename, tag1 : filename1}; //如果找不到该键值对 则会默认tags 全部到file
 
    @“Tags_Color” ： {tag1<NSString>：tag1Color<UIColor> , tag2<NSString>：tag2Color<UIColor>}
    @"ClassStr" : @"QLCustomLoger 或者 其子类"
 }

 */
//+ (void)setOutputOptions:(QLLogOptions)options info:(NSDictionary *)info;



- (void)log:(QLLogModel *)logModel;
- (QLLogModel *)logModel;
- (void)cacheLogModel:(QLLogModel *)logModel;

- (void)logCrash:(NSException *)exception;


- (void)storeAllLogs;


+ (QLLog *)defaultLog;

@end


//static inline QLLog * ql_defaultLog()
//{
//    static QLLog * ___defaultLog = nil;
//    static dispatch_once_t once;
//    dispatch_once(&once, ^{
//        if (!___defaultLog) {
//            ___defaultLog = [[QLLog alloc]init];
//        }
//    });
//    return ___defaultLog;
//}
//
//NSString * ql_platformString();
//NSString * ql_systemVersion();
