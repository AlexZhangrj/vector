//
//  DataHelper.m
//  IMTestDemo
//
//  Created by wangqinghai on 16/5/13.
//  Copyright © 2016年 yimay. All rights reserved.
//

#import "DataHelper.h"

@implementation DataHelper

+ (NSInteger)outputStream:(NSOutputStream *)stream data:(NSData *)data beginIndex:(NSInteger)beginIndex
{
    NSInteger len;
    const void *bytes = [data bytes];
    const void *target = bytes + beginIndex;
    
    NSInteger sendLen = data.length - beginIndex;
    len = [stream write:target maxLength:sendLen];
    return len;
}

@end
