//
//  QLSQLServiceManager.m
//  QLTools
//
//  Created by 王青海 on 15/11/18.
//  Copyright © 2015年 王青海. All rights reserved.
//

#import "QLSQLServiceAPI.h"
#import "QLDatabaseHeader.h"
#import "QLFoundation.h"
#import "QLDataPersistenceAPI.h"


static NSString * const QLSQLServiceTableName = @"ql_service";

NSString * QLSQLService_CoreService = @"QLSQLService_CoreService";
NSString * QLSQLService_CachesService = @"QLSQLService_CachesService";


@interface QLSQLService ()

- (instancetype)initWithDB:(FMDatabase *)DB;

@end


@interface QLSQLServiceAPI ()

@property (nonatomic, strong) NSMutableDictionary *SQLServiceDict;

@end

@implementation QLSQLServiceAPI

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.SQLServiceDict = [NSMutableDictionary dictionary];
    }
    return self;
}

+ (QLSQLServiceAPI *)share
{
    static QLSQLServiceAPI *____share = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!____share) {
            ____share = [[QLSQLServiceAPI alloc] init];
        }
    });
    return ____share;
}



+ (void)SQLServiceWithIdentifier:(NSString *)identifier sqlTask:(QLSQLServiceCallBack)sqlTask
{
    QLSQLService * service = nil;
    if (identifier == QLSQLService_CoreService) {
        service = [QLSQLServiceAPI share].SQLServiceDict[identifier];
        if (!service) {
            service = [[QLSQLService alloc] initWithDB:[QLDatabase share].DB];
            [QLSQLServiceAPI share].SQLServiceDict[identifier] = service;
        }
    }else if (identifier == QLSQLService_CachesService) {
        service = [QLSQLServiceAPI share].SQLServiceDict[identifier];
        if (!service) {
            service = [[QLSQLService alloc] initWithDB:[QLDatabase share].cacheDB];
            [QLSQLServiceAPI share].SQLServiceDict[identifier] = service;
        }
    }
    if (sqlTask) {
        sqlTask(service);
    }
}


+ (void)SQLServiceWithIdentifier:(NSString *)identifier asyncSqlTask:(QLSQLServiceCallBack)sqlTask
{
    [QLDatabaseAPI asyncInDBWorkQueue:^{
        QLSQLService * service = nil;
        if (identifier == QLSQLService_CoreService) {
            service = [QLSQLServiceAPI share].SQLServiceDict[identifier];
            if (!service) {
                service = [[QLSQLService alloc] initWithDB:[QLDatabase share].DB];
                [QLSQLServiceAPI share].SQLServiceDict[identifier] = service;
            }
        }else if (identifier == QLSQLService_CachesService) {
            service = [QLSQLServiceAPI share].SQLServiceDict[identifier];
            if (!service) {
                service = [[QLSQLService alloc] initWithDB:[QLDatabase share].cacheDB];
                [QLSQLServiceAPI share].SQLServiceDict[identifier] = service;
            }
        }
        if (sqlTask) {
            sqlTask(service);
        }
    }];
}

+ (void)SQLServiceWithIdentifier:(NSString *)identifier syncSqlTask:(QLSQLServiceCallBack)sqlTask
{
    [QLDatabaseAPI syncInDBWorkQueue:^{
        QLSQLService * service = nil;
        if (identifier == QLSQLService_CoreService) {
            service = [QLSQLServiceAPI share].SQLServiceDict[identifier];
            if (!service) {
                service = [[QLSQLService alloc] initWithDB:[QLDatabase share].DB];
                [QLSQLServiceAPI share].SQLServiceDict[identifier] = service;
            }
        }else if (identifier == QLSQLService_CachesService) {
            service = [QLSQLServiceAPI share].SQLServiceDict[identifier];
            if (!service) {
                service = [[QLSQLService alloc] initWithDB:[QLDatabase share].cacheDB];
                [QLSQLServiceAPI share].SQLServiceDict[identifier] = service;
            }
        }
        if (sqlTask) {
            sqlTask(service);
        }
    }];
}

+ (void)prepareDirectiory
{
    [QLDataPersistenceAPI prepareDirectiory:[[QLDataPersistenceAPI homeDirectory] stringByAppendingPathComponent:QLDBDirectoryRelpath]];
    [QLDataPersistenceAPI prepareDirectiory:[[QLDataPersistenceAPI cacheHomeDirectory] stringByAppendingPathComponent:QLDBDirectoryRelpath]];
}
@end



@implementation QLSQLService

//create table ql_service1(service varchar(128), item varchar(128), message text, sid integer UNIQUE, primary key(service, item));

- (instancetype)initWithDB:(FMDatabase *)DB
{
    self = [super init];
    if (self) {
        self.DB = DB;
        
        [self.DB open];
        NSString * srcSql = @"create table ql_service(service varchar(128), item varchar(128), message text, sid integer UNIQUE, primary key(service, item));";
        BOOL success =[self.DB executeUpdate:srcSql];
        
        if (!success) {
            NSLog(@"%s 创建service表失败 失败原因:%@", __func__, [self.DB lastErrorMessage]);
        }
        [self.DB close];
    }
    return self;
}

- (NSInteger)suitableSid
{
    NSString * selectSql = [NSString stringWithFormat:@"select max(sid) AS sid from ql_service;"];
    
    FMDatabase *db = self.DB;
    FMResultSet *rs = [db executeQuery:selectSql];
    
    NSDictionary * resultDict = nil;
    
    if ([rs next]) {
        resultDict = [rs resultDictionary];
    }
    if ([resultDict[@"sid"] isKindOfClass:[NSNull class]]) {
        return 0;
    }else if([resultDict[@"sid"] integerValue] >= INT32_MAX) {//
        FMResultSet *rs1 = [db executeQuery:@"select sid from ql_service order by sid asc;"];
        
        NSInteger last = -1;
        
        while ([rs1 next]) {
            NSInteger now = [[rs1 resultDictionary][@"sid"] integerValue];
            if (last >= 0) {
                if (last + 1 < now) {
                    return last + 1;
                }
            }
        }
    }
    
    return [resultDict[@"sid"] integerValue] + 1;
}

- (BOOL)saveMessage:(NSString *)msg forService:(NSString *)serviceName item:(NSString *)item
{
    if (!serviceName || !item || [serviceName isEqualToString:@""] || [item isEqualToString:@""]) {
        return NO;
    }

    FMDatabase *db = self.DB;
    [db open];
    
    NSString * selectSql = [NSString stringWithFormat:@"select sid from ql_service where service='%@' and item='%@';", serviceName, item];
    
    FMResultSet *rs = [db executeQuery:selectSql];
    
    NSDictionary * resultDict = nil;
    
    if ([rs next]) {
        resultDict = [rs resultDictionary];
    }

    if (resultDict[@"sid"]) {
        NSString *updateSql = @"";
        updateSql = [[NSString alloc] initWithFormat:@"UPDATE 'ql_service' SET 'message' = '%@' where sid = %@", msg, resultDict[@"sid"]];
        
        BOOL res = [db executeUpdate:updateSql];
        [db close];

        if (res) {
            return YES;
        } else {
            return NO;
        }
    }else {

        NSString * sql = [NSString stringWithFormat:@"insert into ql_service(service, item, message, sid) values('%@','%@','%@', %ld);", serviceName, item, msg, [self suitableSid]];
        
        BOOL res = [db executeUpdate:sql];
        [db close];

        if (res) {
            return YES;
        } else {
            return NO;
        }
    }
}

- (NSString *)getMessageForService:(NSString *)serviceName item:(NSString *)item
{
    if (!serviceName || !item || [serviceName isEqualToString:@""] || [item isEqualToString:@""]) {
        return nil;
    }
    __block NSString *msg = nil;
    FMDatabase *db = self.DB;
    [db open];

    NSString *selectSql = [NSString stringWithFormat:@"select * from ql_service where service = '%@' and item = '%@';", serviceName, item];
    FMResultSet *rs = [db executeQuery:selectSql];
    NSDictionary *resultDict = nil;
    if ([rs next]) {
        resultDict = [rs resultDictionary];
    }
    [db close];

    msg = resultDict[@"message"];

    if ([msg isKindOfClass:[NSNull class]]) {
        msg = nil;
    }
    
    return msg;
}

- (void)asyncGetMessageForService:(NSString *)serviceName item:(NSString *)item didGetMsg:(QLSQLServiceAPIMsgCallBack)didGetMsg callQueue:(dispatch_queue_t)callQueue
{
    NSString *msg = nil;
    FMDatabase *db = self.DB;
    [db open];
    
    NSString *selectSql = [NSString stringWithFormat:@"select * from ql_service where service = '%@' and item = '%@';", serviceName, item];
    FMResultSet *rs = [db executeQuery:selectSql];
    NSDictionary *resultDict = nil;
    while ([rs next]) {
        resultDict = [rs resultDictionary];
        break;
    }
    msg = resultDict[@"message"];
    [db close];

    if ([msg isKindOfClass:[NSNull class]]) {
        msg = nil;
    }
    
    dispatch_queue_t callQ = callQueue;
    if (NULL == callQ) {
        callQ = dispatch_get_main_queue();
    }
    dispatch_async(callQ, ^{
        if (didGetMsg) {
            didGetMsg(msg);
        }
    });
}

- (void)deleteMessageForService:(NSString *)serviceName item:(NSString *)item
{
    if (!serviceName || !item || [serviceName isEqualToString:@""] || [item isEqualToString:@""]) {
        return;
    }
    
    NSString * deleteSql = [NSString stringWithFormat:@"delete from ql_service where service = '%@' and item = '%@';", serviceName, item];
    FMDatabase *db = self.DB;
    [db open];

    BOOL success=[db executeUpdate:deleteSql];
    if (!success) {
        NSLog(@"ql_service数据删除失败:%@",[db lastErrorMessage]);
    }else {
        NSLog(@"ql_service数据删除成功, %@ %@", serviceName, item);
    }
    [db close];
}




- (BOOL)saveStrMessage:(NSString *)msg forService:(NSString *)serviceName item:(NSString *)item
{
    if (!msg) {
        return NO;
    }
    
    NSString *corveredMsg = [QLStringAPI base64EncodedString:msg];
    NSString *timeStr = [NSString stringWithFormat:@"%lf", [NSDate date].timeIntervalSince1970];

    NSDictionary *dict = @{
                           @"countent_type" : @"NSString",
                           @"countent_message" : corveredMsg,
                           @"countent_time" : timeStr,
                           @"verify_key" : [QLStringAPI md5_32:[NSString stringWithFormat:@"NSString%@^&%@^&%@^&%@^&%@^&", serviceName, item, corveredMsg, @"QLService2016", timeStr]]
                           };

    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&parseError];
    
    if (!jsonData) {
        NSLog(@"%s 序列化输出出错", __func__);
        return NO;
    }
    
    NSString *saveMsg = [QLDataAPI base64EncodedData:jsonData];

    if (saveMsg) {
        return [self saveMessage:saveMsg forService:serviceName item:item];
    }else {
        NSLog(@"%s 序列化输出出错2", __func__);
        return NO;
    }
}

- (NSString *)getStrMessageForService:(NSString *)serviceName item:(NSString *)item
{
    NSString *savedMsg = [self getMessageForService:serviceName item:item];
    
    if (savedMsg) {
        NSDictionary *msgDict = QLJSONToDict([QLDataAPI base64DecodedDataStr:savedMsg]);
        if (msgDict) {
            NSString *verify_key = [QLStringAPI md5_32:[NSString stringWithFormat:@"NSString%@^&%@^&%@^&%@^&%@^&", serviceName, item, msgDict[@"countent_message"], @"QLService2016", msgDict[@"countent_time"]]];
            if ([verify_key isEqualToString:msgDict[@"verify_key"]]) {
                if ([msgDict[@"countent_type"] isEqualToString:@"NSString"]) {
                    return [QLStringAPI base64DecodedString:msgDict[@"countent_message"]];
                }
            }
        }
    }
    return nil;
}


- (BOOL)saveDataMessage:(NSData *)msgData forService:(NSString *)serviceName item:(NSString *)item
{
    if (!msgData) {
        return NO;
    }
    
    NSString *corveredMsg = [QLDataAPI base64EncodedData:msgData];
    NSString *timeStr = [NSString stringWithFormat:@"%lf", [NSDate date].timeIntervalSince1970];
    
    NSDictionary *dict = @{
                           @"countent_type" : @"NSData",
                           @"countent_message" : corveredMsg,
                           @"countent_time" : timeStr,
                           @"verify_key" : [QLStringAPI md5_32:[NSString stringWithFormat:@"NSData%@^&%@^&%@^&%@^&%@^&", serviceName, item, corveredMsg, @"QLService2016", timeStr]]
                           };
    
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&parseError];
    
    if (!jsonData) {
        NSLog(@"%s 序列化输出出错", __func__);
        return NO;
    }
    
    NSString *saveMsg = [QLDataAPI base64EncodedData:jsonData];
    
    if (saveMsg) {
        return [self saveMessage:saveMsg forService:serviceName item:item];
    }else {
        NSLog(@"%s 序列化输出出错2", __func__);
        return NO;
    }
}

- (NSData *)getDataMessageForService:(NSString *)serviceName item:(NSString *)item
{
    NSString *savedMsg = [self getMessageForService:serviceName item:item];
    
    if (savedMsg) {
        NSDictionary *msgDict = QLJSONToDict([QLDataAPI base64DecodedDataStr:savedMsg]);
        if (msgDict) {
            NSString *verify_key = [QLStringAPI md5_32:[NSString stringWithFormat:@"NSData%@^&%@^&%@^&%@^&%@^&", serviceName, item, msgDict[@"countent_message"], @"QLService2016", msgDict[@"countent_time"]]];
            if ([verify_key isEqualToString:msgDict[@"verify_key"]]) {
                if ([msgDict[@"countent_type"] isEqualToString:@"NSData"]) {
                    return [QLDataAPI base64DecodedDataStr:msgDict[@"countent_message"]];
                }
            }
        }
    }
    return nil;
}

@end
