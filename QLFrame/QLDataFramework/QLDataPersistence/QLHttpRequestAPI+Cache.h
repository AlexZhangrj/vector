//
//  QLHttpRequestAPI+Cache.h
//  QLKit
//
//  Created by 王青海 on 16/2/17.
//  Copyright © 2016年 王青海. All rights reserved.
//

#import "QLHttpRequestAPI.h"

typedef NS_ENUM(NSUInteger, QLHttpRequestCacheType) {
    QLHttpRequestCacheTmp,
    QLHttpRequestCacheDoc
};

///Library/Caches

@interface QLHttpRequestAPI (Cache)

/**
 缓存时间，单位秒
 */
+ (void)GETWithCache:(NSString *)URLString
                            parameters:(NSDictionary *)parameters
                             cacheTime:(NSTimeInterval)cacheTime
                               success:(QLHttpResultDataCallBlock)success
                               failure:(QLHttpResultErrorCallBlock)failure;
/**
 失效时间
 */
+ (void)GETWithCache:(NSString *)URLString
                            parameters:(NSDictionary *)parameters
                        expirationDate:(NSTimeInterval)expirationDate
                               success:(QLHttpResultDataCallBlock)success
                               failure:(QLHttpResultErrorCallBlock)failure;

/**
 临时缓存
 */
+ (void)GETWithTmpCache:(NSString *)URLString
                               parameters:(NSDictionary *)parameters
                                  success:(QLHttpResultDataCallBlock)success
                                  failure:(QLHttpResultErrorCallBlock)failure;

/**
 缓存时间，单位秒
 */
+ (void)POSTWithCache:(NSString *)URLString
                            parameters:(NSDictionary *)parameters
                             cacheTime:(NSTimeInterval)cacheTime
                               success:(QLHttpResultDataCallBlock)success
                               failure:(QLHttpResultErrorCallBlock)failure;
/**
 失效时间
 */
+ (void)POSTWithCache:(NSString *)URLString
                            parameters:(NSDictionary *)parameters
                        expirationDate:(NSTimeInterval)expirationDate
                               success:(QLHttpResultDataCallBlock)success
                               failure:(QLHttpResultErrorCallBlock)failure;

/**
 临时缓存
 */
+ (void)POSTWithTmpCache:(NSString *)URLString
                               parameters:(NSDictionary *)parameters
                                  success:(QLHttpResultDataCallBlock)success
                                  failure:(QLHttpResultErrorCallBlock)failure;

@end
