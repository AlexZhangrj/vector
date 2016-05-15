//
//  QLFileLoger.h
//  QLLogFrameWork
//
//  Created by 王青海 on 15/11/1.
//  Copyright © 2015年 王青海. All rights reserved.
//

#import "QLLoger.h"






@interface QLFileLoger : QLLoger

- (void)storeAllLogs;






+ (NSArray *)logDictsWithWithContentsOfFile:(NSString *)filePath;
+ (NSArray *)logDictsWithData:(NSData *)data;

@end



static inline dispatch_queue_t ql_getFileLogerDoQueue()
{
    static dispatch_queue_t ___fileLogerDoQueue = NULL;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        if (!___fileLogerDoQueue) {
            ___fileLogerDoQueue = dispatch_queue_create("com.ql.app.fileLogerDoQueue", DISPATCH_QUEUE_SERIAL);
        }
    });
    return ___fileLogerDoQueue;
}