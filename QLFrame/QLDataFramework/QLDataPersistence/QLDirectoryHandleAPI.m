//
//  QLDirectoryManager.m
//  QLTools
//
//  Created by 王青海 on 15/11/18.
//  Copyright © 2015年 王青海. All rights reserved.
//

#import "QLDirectoryHandleAPI.h"

@implementation QLDirectoryHandleAPI

+ (void)asyncInDirWorkQueue:(dispatch_block_t)block
{
    @autoreleasepool {
        dispatch_async(QLGetDirWorkQueue(), block);
    }
}

+ (void)syncInDirWorkQueue:(dispatch_block_t)block
{
    @autoreleasepool {
        dispatch_sync(QLGetDirWorkQueue(), block);
    }
}

@end
