//
//  QLFilePacket.h
//  QLKit
//
//  Created by 王青海 on 16/1/10.
//  Copyright (c) 2016年 王青海. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface QLFilePacket : NSObject

/*
 len 
 verify_key_len
 verify_key
 contentData_len
 contentData
 
 */

//@property (nonatomic, assign) uint32_t len;
//@property (nonatomic, copy) NSString *verify_key;
@property (nonatomic, copy) NSData *contentData;



+ (NSMutableData *)convertData2FileData:(NSData *)data;

+ (NSData *)convertFileData2Data:(NSData *)data;




@end







