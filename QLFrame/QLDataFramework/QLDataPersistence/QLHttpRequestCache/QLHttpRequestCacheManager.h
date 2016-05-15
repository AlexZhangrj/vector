//
//  QLHttpRequestCacheManager.h
//  QLFrame
//
//  Created by 王青海 on 16/2/22.
//  Copyright © 2016年 王青海. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "QLHttpRequestOptions.h"

@class QLHttpRequestCacheModel;

@interface QLHttpRequestCacheManager : NSObject

+ (QLHttpRequestCacheModel *)simpleUnsalfCacheModel;

//+ (QLHttpRequestCacheModel *)cacheModelWith:(NSString *)URLString
//                                 parameters:(NSDictionary *)parameters
//                             expirationDate:(NSTimeInterval)expirationDate;

+ (NSArray *)orderedDictKeys:(NSDictionary *)dict;

+ (NSData *)cacheDataWith:(NSString *)URLString
                  parameters:(NSDictionary *)parameters
                 requestType:(QLHttpRequestType)requestType;

+ (void)cacheResultData:(NSData *)resultData
                      With:(NSString *)URLString
                parameters:(NSDictionary *)parameters
            expirationDate:(NSTimeInterval)expirationDate
               requestType:(QLHttpRequestType)requestType;


+ (NSData *)tmpCacheDataWith:(NSString *)URLString
               parameters:(NSDictionary *)parameters
              requestType:(QLHttpRequestType)requestType;

+ (void)tmpCacheResultData:(NSData *)resultData
                   With:(NSString *)URLString
             parameters:(NSDictionary *)parameters
         expirationDate:(NSTimeInterval)expirationDate
            requestType:(QLHttpRequestType)requestType;

@end
