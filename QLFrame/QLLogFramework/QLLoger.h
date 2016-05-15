//
//  QLLoger.h
//  QLLogFrameWork
//
//  Created by 王青海 on 15/11/1.
//  Copyright © 2015年 王青海. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QLLogEnum.h"

@class QLLogModel;

@protocol QLLoger <NSObject>

//子类必须重写的方法且不许调用super
- (void)log:(nonnull QLLogModel *)logModel;

//子类必须重写的方法且不许调用super
- (nonnull dispatch_queue_t)getDoQueue;

- (void)configWithInfo:(nullable NSDictionary *)info;

- (void)storeAllLogs;

- (void)logCrash:(nullable NSException *)exception;

//子类必须重写的方法且不许调用super
+ (nonnull id<QLLoger>)defaultLoger;

@end


@interface QLLoger : NSObject<QLLoger>


@end


static inline QLLoger * _Nonnull ql_defaultLoger()
{
    static QLLoger * ___defaultLoger = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        if (!___defaultLoger) {
            ___defaultLoger = [[QLLoger alloc]init];
        }
    });
    return ___defaultLoger;
}










