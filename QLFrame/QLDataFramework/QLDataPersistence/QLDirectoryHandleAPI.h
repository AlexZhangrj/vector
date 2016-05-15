//
//  QLDirectoryManager.h
//  QLTools
//
//  Created by 王青海 on 15/11/18.
//  Copyright © 2015年 王青海. All rights reserved.
//

#import <Foundation/Foundation.h>

static inline dispatch_queue_t QLGetDirWorkQueue()
{
    static dispatch_queue_t ____QLGetDirWorkQueue = NULL;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        if (!____QLGetDirWorkQueue) {
            ____QLGetDirWorkQueue = dispatch_queue_create("com.ql.app.dir_workqueue", DISPATCH_QUEUE_SERIAL);
        }
    });
    return ____QLGetDirWorkQueue;
}


@interface QLDirectoryHandleAPI : NSObject


+ (void)asyncInDirWorkQueue:(dispatch_block_t)block;

+ (void)syncInDirWorkQueue:(dispatch_block_t)block;

@end
