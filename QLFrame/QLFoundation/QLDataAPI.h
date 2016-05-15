//
//  QLDataTool.h
//  QLFoundation
//
//  Created by 王青海 on 16/1/28.
//  Copyright © 2016年 王青海. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QLDataAPI : NSObject

+ (NSData*)AES256EncryptData:(NSData *)data key:(NSString*)key;
+ (NSData*)AES256DecryptData:(NSData *)data key:(NSString*)key;

+ (NSString *)AES256Create;

+ (NSString *)base64EncodedData:(NSData *)data;

+ (NSData *)base64DecodedDataStr:(NSString *)str;


//md5 32位 加密 （小写）
+ (NSString *)md5_32:(NSData *)data;


+ (NSData *)dataWithUint32:(uint32_t)num;
+ (NSMutableData *)mutableDataWithUint32:(uint32_t)num;


@end
