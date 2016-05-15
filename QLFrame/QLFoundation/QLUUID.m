//
//  QLUUID.m
//  QLTools
//
//  Created by 王青海 on 15/11/26.
//  Copyright © 2015年 王青海. All rights reserved.
//


#import "QLUUID.h"
#import "QLKeyChain.h"
#import "SSKeychain.h"

static NSString * const __UUIDServiceName = @"com.yuanqing";
static NSString * const __UUIDAccount = @"UUID";

NSString * QL_UUID_AESKey() {
    return @"lHohVxLvVWOXlGmOlYMnFgdXEcpkzUXiwDFIPhUjuFKJIuzEioJWmSFVUORYyfyXQusHedNegAVspoKXfxMlWkULOQzjQqpSwToWVCiZHNeCuxVTnxKcmBQYqDMEsLpnFxKXZLGzVMMWiWQXFSIOKCsHOcCAeNHKExKLixuMMvkrkkkHjkGhfnJwszilyCeQThAdaApJFNjthjixCtRESRacVakWorvnlYSTCmWmcGyqzNMKlutFYVEDQrcgsHAz";
}

@implementation QLUUID


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

+ (NSString *)UUID
{
//    NSString *identifier = [[NSBundle mainBundle] bundleIdentifier];
    NSString *UUID = [SSKeychain passwordForService:__UUIDServiceName account:__UUIDAccount];
    if(UUID) {
        return UUID;
    }
    return [self createSerialForService:__UUIDServiceName account:__UUIDAccount];
}


@end
