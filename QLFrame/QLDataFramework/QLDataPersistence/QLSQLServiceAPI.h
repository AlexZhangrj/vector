//
//  QLSQLServiceManager.h
//  QLTools
//
//  Created by 王青海 on 15/11/18.
//  Copyright © 2015年 王青海. All rights reserved.
//

#import <Foundation/Foundation.h>


extern NSString * QLSQLService_CoreService;
extern NSString * QLSQLService_CachesService;


@class QLSQLService;

typedef void(^QLSQLServiceAPIMsgCallBack)(NSString *msg);
typedef void(^QLSQLServiceCallBack)(QLSQLService *service);



@interface QLSQLServiceAPI : NSObject

//block callback in ql_getDatabaseWorkQueue();, Only call this method in ql_getDatabaseWorkQueue()
+ (void)SQLServiceWithIdentifier:(NSString *)identifier sqlTask:(QLSQLServiceCallBack)sqlTask;

//block callback in ql_getDatabaseWorkQueue(); Only call this method not in ql_getDatabaseWorkQueue()
+ (void)SQLServiceWithIdentifier:(NSString *)identifier asyncSqlTask:(QLSQLServiceCallBack)sqlTask;

//block callback in ql_getDatabaseWorkQueue(); Only call this method not in ql_getDatabaseWorkQueue()
+ (void)SQLServiceWithIdentifier:(NSString *)identifier syncSqlTask:(QLSQLServiceCallBack)sqlTask;

+ (void)prepareDirectiory;



@end


@class FMDatabase;

@interface QLSQLService : NSObject

@property (nonatomic, strong) FMDatabase *DB;

//- (instancetype)initWithDB:(FMDatabase *)DB;

//原型保存
- (BOOL)saveMessage:(NSString *)msg forService:(NSString *)serviceName item:(NSString *)item;
//- (void)saveMessage:(NSString *)msg forService:(NSString *)serviceName item:(NSString *)item saveSuccess:(dispatch_block_t)success saveFaild:(dispatch_block_t)faild;
//原型获取
- (NSString *)getMessageForService:(NSString *)serviceName item:(NSString *)item;
//原型删除
- (void)deleteMessageForService:(NSString *)serviceName item:(NSString *)item;


//- (void)asyncGetMessageForService:(NSString *)serviceName item:(NSString *)item didGetMsg:(QLSQLServiceAPIMsgCallBack)didGetMsg callQueue:(dispatch_queue_t)callQueue;


- (BOOL)saveStrMessage:(NSString *)msg forService:(NSString *)serviceName item:(NSString *)item;

- (NSString *)getStrMessageForService:(NSString *)serviceName item:(NSString *)item;


- (BOOL)saveDataMessage:(NSData *)msgData forService:(NSString *)serviceName item:(NSString *)item;

- (NSData *)getDataMessageForService:(NSString *)serviceName item:(NSString *)item;


@end

