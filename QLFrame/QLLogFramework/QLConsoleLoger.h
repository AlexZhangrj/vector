//
//  QLConsoleLoger.h
//  QLLogFrameWork
//
//  Created by 王青海 on 15/11/1.
//  Copyright © 2015年 王青海. All rights reserved.
//

#import "QLLoger.h"

@interface QLConsoleLoger : QLLoger




@end



static inline dispatch_queue_t ql_getConsoleLogerDoQueue()
{
    static dispatch_queue_t ___consoleLogerDoQueue = NULL;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        if (!___consoleLogerDoQueue) {
            ___consoleLogerDoQueue = dispatch_queue_create("com.ql.app.consoleLogerDoQueue", DISPATCH_QUEUE_SERIAL);
        }
    });
    return ___consoleLogerDoQueue;
}