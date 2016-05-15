//
//  QLFoundation.h
//  QLFoundation
//
//  Created by 王青海 on 16/1/28.
//  Copyright © 2016年 王青海. All rights reserved.
//

#ifndef QLFoundation_h
#define QLFoundation_h

#import "QLBaseModel.h"
#import "QLStringAPI.h"
#import "QLHttpRequestAPI.h"
#import "QLRSAAPI.h"
#import "QLNetwork.h"
#import "QLKeyChain.h"
#import "QLDataAPI.h"

#import <Foundation/Foundation.h>


static inline void QLAsyncTaskToMainQueue(dispatch_block_t task){
    @autoreleasepool {
        dispatch_async(dispatch_get_main_queue(), task);
    }
}
static inline void QLSyncTaskToMainQueue(dispatch_block_t task){
    @autoreleasepool {
        dispatch_sync(dispatch_get_main_queue(), task);
    }
}

static inline void QLTimerAfter(NSTimeInterval time, dispatch_block_t block)
{
    dispatch_time_t afterTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)((time) * NSEC_PER_SEC));
    dispatch_after(afterTime, dispatch_get_main_queue(), block);
}

#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;



#endif /* QLFoundation_h */


#define QLLogFunction NSLog(@"%s", __FUNCTION__);

