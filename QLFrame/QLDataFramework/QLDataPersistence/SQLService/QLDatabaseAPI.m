//
//  QLAsyncDatabaseManager.m
//  QLTools
//
//  Created by 王青海 on 15/11/18.
//  Copyright © 2015年 王青海. All rights reserved.
//

#import "QLDatabaseHeader.h"


#import "QLDatabaseAPI.h"



@implementation QLDatabaseAPI



+ (void)asyncInDBWorkQueue:(dispatch_block_t)block
{
    @autoreleasepool {
        dispatch_async(ql_getDatabaseWorkQueue(), block);
    }
}

+ (void)syncInDBWorkQueue:(dispatch_block_t)block
{
    @autoreleasepool {
        dispatch_sync(ql_getDatabaseWorkQueue(), block);
    }
}


@end
