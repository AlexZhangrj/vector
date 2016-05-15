//
//  QLKeyChain.h
//  QLFoundation
//
//  Created by 王青海 on 16/1/28.
//  Copyright © 2016年 ql. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QLKeyChain : NSObject

+ (BOOL)saveMessage:(NSString *)msg forService:(NSString *)serviceName account:(NSString *)account;

+ (NSString *)getMessageForService:(NSString *)serviceName account:(NSString *)account;

+ (NSString *)createSingleSerialForService:(NSString *)serviceName account:(NSString *)account;

+ (NSString *)getSerialForService:(NSString *)serviceName account:(NSString *)account;

+ (NSString *)getSerialForService:(NSString *)serviceName account:(NSString *)account noExitToCreate:(BOOL)create;

@end
