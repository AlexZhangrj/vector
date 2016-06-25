//
//  NSData+MD5.m
//  FileManager
//
//  Created by 王青海 on 16/6/23.
//  Copyright © 2016年 yimay. All rights reserved.
//

#import "NSData+MD5.h"
#import <CommonCrypto/CommonDigest.h>




@implementation NSData (MD5)





//md5 32位 加密 （小写）
- (NSString *)md5 {
    
    const char *data = self.bytes;
    unsigned char result[32];
    uint32_t len = (uint32_t)self.length;
    CC_MD5(data, len, result);
    NSMutableString *resultStr = [NSMutableString string];
    for (int i=0;i<32; i++) {
        [resultStr appendFormat:@"%02x", result[i]];
    }
    
    return resultStr;
}


@end



@implementation NSString (MD5)

//md5 32位 加密 （小写）
- (NSString *)md5 {
    NSData *tmpData = [self dataUsingEncoding:NSUTF8StringEncoding];
    const char *data =tmpData .bytes;
    unsigned char result[32];
    uint32_t len = (uint32_t)tmpData.length;
    CC_MD5(data, len, result);
    NSMutableString *resultStr = [NSMutableString string];
    for (int i=0;i<32; i++) {
        [resultStr appendFormat:@"%02x", result[i]];
    }
    
    return resultStr;
}


@end