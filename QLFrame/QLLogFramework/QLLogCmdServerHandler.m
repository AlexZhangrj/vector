//
//  QLLogCmdServerHandler.m
//  QLLogFrameWork
//
//  Created by 王青海 on 15/11/1.
//  Copyright © 2015年 王青海. All rights reserved.
//

#import "QLLogCmdServerHandler.h"
#import "QLLogHeaders.h"


@implementation QLLogCmdServerHandler

- (NSMutableDictionary *)didGetCmdRequest:(NSDictionary *)info
{
    NSString * logkey = info[@"cmd"];
    if (logkey) {
//        NSString * logCmdStr = info[logkey];
//        if ([logCmdStr isEqualToString:@"get_log_list"]) {
//            return [self get_log_list];
//        }else if ([logCmdStr isEqualToString:@"get_log"]) {
//            return [self get_log:info[@"log_name"]];
//            //        }else if ([logCmdStr isEqualToString:@"get_crash_list"]) {
//            //            return [self get_crash_list];
//            //        }else if ([logCmdStr isEqualToString:@"get_crash"]) {
//            //            return [self get_crash:info[@"crash_name"]];
//        }
        
        return nil;
    }else {
        return nil;
    }
}
//- (NSString *)didGetCmdRequest:(NSDictionary *)info
//{
//    NSString * logkey = info[@"cmd"];
//    if (logkey) {
//        NSString * logCmdStr = info[logkey];
//        if ([logCmdStr isEqualToString:@"get_log_list"]) {
//            return [self get_log_list];
//        }else if ([logCmdStr isEqualToString:@"get_crash_list"]) {
//            return [self get_crash_list];
//        }else if ([logCmdStr isEqualToString:@"get_log"]) {
//            return [self get_log:info[@"log_name"]];
//        }else if ([logCmdStr isEqualToString:@"get_crash"]) {
//            return [self get_crash:info[@"crash_name"]];
//        }
//        
//        return @"";
//    }else {
//        return nil;
//    }
//}
//
//- (NSString *)get_log_list
//{
//    NSArray *files = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:ql_logTextFileDirectory() error:nil];
//    
//    NSMutableString * ret = [NSMutableString stringWithFormat:@"[%@]", [files componentsJoinedByString:@",\n"]];
//    
//    return ret;
//}
//
//- (NSString *)get_crash_list
//{
//    NSArray *files = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath:ql_logCrashDirectory() error:nil];
//    
//    NSMutableString * ret = [NSMutableString stringWithFormat:@"[%@]", [files componentsJoinedByString:@",\n"]];
//    
//    return ret;
//}
//
//- (NSString *)get_log:(NSString *)name
//{
//    if (!name) {
//        return @"";
//    }
//    
//    NSData * data = [NSData dataWithContentsOfFile:[ql_logTextFileDirectory() stringByAppendingPathComponent:name]];
//    if (!data) {
//        return @"";
//    }else {
//        return [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//    }
//}
//
//- (NSString *)get_crash:(NSString *)name
//{
//    if (!name) {
//        return @"";
//    }
//    
//    NSData * data = [NSData dataWithContentsOfFile:[ql_logCrashDirectory() stringByAppendingPathComponent:name]];
//    if (!data) {
//        return @"";
//    }else {
//        return [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
//    }
//}


+ (QLLogCmdServerHandler *)defaultCmdServerHandler
{
    static QLLogCmdServerHandler * ___defaultCmdServerHandler = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!___defaultCmdServerHandler) {
            ___defaultCmdServerHandler = [[QLLogCmdServerHandler alloc]init];
        }
    });
    return ___defaultCmdServerHandler;
}


@end
