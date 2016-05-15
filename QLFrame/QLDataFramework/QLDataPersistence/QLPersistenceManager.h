//
//  QLPersistenceManager.h
//  QLTools
//
//  Created by 王青海 on 15/11/18.
//  Copyright © 2015年 王青海. All rights reserved.
//

#import <Foundation/Foundation.h>

/**线程非安全的
 在主线程工作
 */
@interface QLPersistenceManager : NSObject



- (nullable id)objectForKey:(nonnull NSString *)key;

- (void)setObject:(nullable id)value forKey:(nonnull NSString *)key;

- (void)removeObjectForKey:(nonnull NSString *)key;

- (void)synchronize:(_Nullable dispatch_block_t)success faild:(_Nullable dispatch_block_t)faild;


+ (nullable NSString *)persistenceDirectory;

+ (nonnull QLPersistenceManager *)defaultManager;



+ (void)cleanSDImageChache;


@end
