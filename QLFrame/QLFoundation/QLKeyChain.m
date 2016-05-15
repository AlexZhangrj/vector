//
//  QLKeyChain.m
//  QLFoundation
//
//  Created by 王青海 on 16/1/28.
//  Copyright © 2016年 ql. All rights reserved.
//

#import "QLKeyChain.h"
#import "SSKeychain.h"



@implementation QLKeyChain

+ (BOOL)saveMessage:(NSString *)msg forService:(NSString *)serviceName account:(NSString *)account
{
    return [SSKeychain setPassword:msg forService:serviceName account:account];
}

+ (NSString *)getMessageForService:(NSString *)serviceName account:(NSString *)account
{
    return [SSKeychain passwordForService:serviceName account:account];
}

+ (NSString *)createSingleSerialForService:(NSString *)serviceName account:(NSString *)account
{
    if([SSKeychain passwordForService:serviceName account:account]) {
        return [SSKeychain passwordForService:serviceName account:account];
    }
    return [self createSerialForService:serviceName account:account];
}

+ (NSString *)createSerialForService:(NSString *)serviceName account:(NSString *)account
{
    // 产生一个序列号
    NSString *uuid = [[NSUUID UUID] UUIDString];
    // Keychain
    [SSKeychain setPassword:uuid forService:serviceName account:account];
    return uuid;
}

+ (NSString *)getSerialForService:(NSString *)serviceName account:(NSString *)account
{
    return [SSKeychain passwordForService:serviceName account:account];
}

+ (NSString *)getSerialForService:(NSString *)serviceName account:(NSString *)account noExitToCreate:(BOOL)create
{
    NSString * serial = [SSKeychain passwordForService:serviceName account:account];
    if (serial) {
        return serial;
    }else {
        if (create) {
            return [self createSingleSerialForService:serviceName account:account];
        }else {
            return nil;
        }
    }
}



@end
