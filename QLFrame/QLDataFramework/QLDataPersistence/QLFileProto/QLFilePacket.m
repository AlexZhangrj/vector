//
//  QLFilePacket.m
//  QLKit
//
//  Created by 王青海 on 16/1/10.
//  Copyright (c) 2016年 王青海. All rights reserved.
//

#import "QLFilePacket.h"
#import "QLFoundation.h"

@interface QLFilePacket()


@end
@implementation QLFilePacket

+ (NSMutableData *)convertData2FileData:(NSData *)data
{
    if (!data) {
        return nil;
    }
    
    NSString *contentDataMD5Str = [QLDataAPI md5_32:data];
    NSString *verifyStr = [NSString stringWithFormat:@"%@#^&%@akerilk;lpop[rwqds%lu", contentDataMD5Str, contentDataMD5Str, data.length];
    
    NSString *verify_key = [QLStringAPI md5_32:verifyStr];
    
    NSData *verify_key_data = [verify_key dataUsingEncoding:NSUTF8StringEncoding];
    
    uint8_t verify_key_len = (uint8_t)(verify_key_data.length);
    uint32_t contentData_len = (uint32_t)(data.length);
    uint32_t packet_len = sizeof(uint8_t) + verify_key_len + sizeof(uint32_t) + contentData_len;//len uri msg_id
    
    NSMutableData * mdata = [NSMutableData data];
    [mdata appendData:[NSData dataWithBytes:&packet_len length: sizeof(uint32_t)]];
    [mdata appendData:[NSData dataWithBytes:&verify_key_len length: sizeof(uint8_t)]];
    [mdata appendData:verify_key_data];
    [mdata appendData:[NSData dataWithBytes:&contentData_len length: sizeof(uint32_t)]];
    [mdata appendData:data];
    
    return mdata;
}

+ (NSData *)convertFileData2Data:(NSData *)data
{
    uint8_t verify_key_len = 0;
    uint32_t contentData_len = 0;
    uint32_t packet_len = 0;
    
    [data getBytes:&packet_len length:sizeof(uint32_t)];
    [data getBytes:&verify_key_len range:NSMakeRange(sizeof(uint32_t), sizeof(uint8_t))];
    [data getBytes:&contentData_len range:NSMakeRange(sizeof(uint32_t)+sizeof(uint8_t)+verify_key_len, sizeof(uint32_t))];
    
    NSString *verify_key = [[NSString alloc] initWithData:[data subdataWithRange:NSMakeRange(sizeof(uint32_t) + sizeof(uint8_t), verify_key_len)] encoding:NSUTF8StringEncoding];
    NSData *contentData = [data subdataWithRange:NSMakeRange(sizeof(uint32_t)+sizeof(uint8_t)+verify_key_len+sizeof(uint32_t), contentData_len)];
    
    NSString *contentDataMD5Str = [QLDataAPI md5_32:contentData];
    NSString *verifyStr = [NSString stringWithFormat:@"%@#^&%@akerilk;lpop[rwqds%lu", contentDataMD5Str, contentDataMD5Str, contentData.length];
    if ([[QLStringAPI md5_32:verifyStr] isEqualToString:verify_key]) {
        return contentData;
    }else {
        return nil;
    }
}



@end