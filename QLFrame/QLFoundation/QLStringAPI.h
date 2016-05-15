//
//  QLStringAPI.h
//  QLTools
//
//  Created by 王青海 on 15/11/26.
//  Copyright © 2015年 王青海. All rights reserved.
//

#include <Foundation/Foundation.h>


@interface QLStringAPI : NSObject

//+ (NSString *)stringWithBase64EncodedString:(NSString *)string;
//+ (NSData *)base64DecodedData:(NSString *)str;

+ (NSString *)base64EncodedString:(NSString *)str;
+ (NSString *)base64DecodedString:(NSString *)str;


+ (BOOL)stringContainsEmoji:(NSString *)string;
+ (BOOL)stringIsEmoji:(NSString *)string;



/**
 md5 32位 加密 （小写）
 */
+ (NSString *)md5_32:(NSString *)str;


+ (NSString *)ql_private_base64:(NSString *)str;






@end

