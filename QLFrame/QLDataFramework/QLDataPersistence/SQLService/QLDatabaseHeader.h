//
//  QLDatabaseHeader.h
//  QLTools
//
//  Created by 王青海 on 15/11/18.
//  Copyright © 2015年 王青海. All rights reserved.
//

#ifndef QLDatabaseHeader_h
#define QLDatabaseHeader_h




#import "QLDatabase.h"
#import "QLDatabaseAPI.h"
#import "FMDatabase.h"

static dispatch_queue_t ql_getDatabaseWorkQueue()
{
    static dispatch_queue_t ___ql_DB_Queue = NULL;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        if (!___ql_DB_Queue) {
            ___ql_DB_Queue = dispatch_queue_create("com.ql.app.db_workqueue", DISPATCH_QUEUE_SERIAL);
        }
    });
    return ___ql_DB_Queue;
}


#endif /* QLDatabaseHeader_h */
