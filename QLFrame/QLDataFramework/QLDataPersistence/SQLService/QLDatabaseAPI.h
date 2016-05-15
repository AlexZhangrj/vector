//
//  QLAsyncDatabaseManager.h
//  QLTools
//
//  Created by 王青海 on 15/11/18.
//  Copyright © 2015年 王青海. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QLDatabaseAPI : NSObject



+ (void)asyncInDBWorkQueue:(dispatch_block_t)block;

+ (void)syncInDBWorkQueue:(dispatch_block_t)block;







@end
