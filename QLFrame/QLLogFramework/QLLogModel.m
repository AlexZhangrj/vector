//
//  QLLogModel.m
//  QLLogFrameWork
//
//  Created by 王青海 on 15/11/1.
//  Copyright © 2015年 王青海. All rights reserved.
//

#import "QLLogModel.h"
#import "QLLogHeaders.h"
#import "QLLog.h"





@interface QLLogModel ()

@property (nonatomic, assign) NSUInteger recycleRetainCount;

@end

@implementation QLLogModel

- (void)logCacheRetain
{
    self.recycleRetainCount ++;
}
- (void)logCacheRelease
{
    self.recycleRetainCount --;
    if (self.recycleRetainCount == 0) {
        if (self.countBecomeTo0) {
            self.countBecomeTo0(self);
        }
    }
}



//- (void)testQLLog
//{
//    
//    
////#define
//    ql_log(self, QLFuncTypeOCfunc, ql_nowBeijingTimeString(), QLLogTypeDebug, __FUNCTION__, __LINE__, 0, @"");
//
//}

- (NSString *)dateStr
{
    return @"";
}


- (char *)consoleStr
{
    NSString * retStr;
    switch (self.funcType) {
        case QLFuncTypeCfunc:
        {
            retStr = [NSString stringWithFormat:@"<QLLog>%@ func:%@ line:%lu tag:%@ msg:%@", self.dateStr, self.func, self.line, self.tag, self.msg];
        }
            break;
        case QLFuncTypeOCfunc:
        {
            retStr = [NSString stringWithFormat:@"<QLLog>%@ obj:%@ objDes:%@ func:%@ line:%lu tag:%@  msg:%@", self.dateStr, self.objAddress, self.objDes, self.func, self.line, self.tag, self.msg];
        }
            break;
        default:
            break;
    }
    return [retStr cStringUsingEncoding:NSUTF8StringEncoding];
}


- (NSString *)fileStr
{
    NSString * retStr;
    switch (self.funcType) {
        case QLFuncTypeCfunc:
        {
            retStr = [NSString stringWithFormat:@"<QLLog>%@ func:%@ line:%lu tag:%@ type:%ld msg:%@", self.dateStr, self.func, self.line, self.tag, self.logType, self.msg];
        }
            break;
        case QLFuncTypeOCfunc:
        {
            retStr = [NSString stringWithFormat:@"<QLLog>%@ obj:%@ objDes:%@ func:%@ line:%lu tag:%@ type:%ld msg:%@", self.dateStr, self.objAddress, self.objDes, self.func, self.line, self.tag, self.logType, self.msg];
        }
            break;
        default:
            break;
    }
    return retStr;
}


- (id)dateValue
{
    if (self.date) {
        return [NSNumber numberWithDouble:self.date.timeIntervalSince1970];
    }else {
        return [NSNull null];
    }
}

- (void)setDateValue:(id)dateValue
{
    if ([dateValue isKindOfClass:[NSNumber class]]) {
        self.date = [NSDate dateWithTimeIntervalSince1970:[dateValue doubleValue]];
    }else {
        self.date = nil;
    }
}

- (void)setObjectKeyToDict:(NSMutableDictionary *)dict value:(id)value key:(NSString *)key
{
    if (value) {
        [dict setObject:value forKey:key];
    }
}

- (NSDictionary *)dictFromModel
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[@"d"] = [self dateValue];
    dict[@"fT"] = [NSNumber numberWithUnsignedInteger:self.funcType];
    dict[@"lT"] = [NSNumber numberWithUnsignedInteger:self.logType];
    dict[@"li"] = [NSNumber numberWithUnsignedInteger:self.line];
    
    [self setObjectKeyToDict:dict value:self.objAddress key:@"oA"];
    [self setObjectKeyToDict:dict value:self.objDes key:@"oD"];
    [self setObjectKeyToDict:dict value:self.func key:@"fc"];
    [self setObjectKeyToDict:dict value:self.msg key:@"msg"];
    [self setObjectKeyToDict:dict value:self.tag key:@"tag"];
    
    return dict;
}

+ (QLLogModel *)logModelWithDict:(NSDictionary *)dict
{
    QLLogModel *model = [[QLLogModel alloc] init];
    [model setDateValue:dict[@"d"]];
    model.funcType = [dict[@"fT"] unsignedIntegerValue];
    model.logType = [dict[@"lT"] unsignedIntegerValue];
    model.line = [dict[@"li"] unsignedIntegerValue];

    model.objAddress = dict[@"oA"];
    model.objDes = dict[@"oD"];
    model.func = dict[@"fc"];
    model.msg = dict[@"msg"];
    model.tag = dict[@"tag"];

    
    return model;
}



@end
