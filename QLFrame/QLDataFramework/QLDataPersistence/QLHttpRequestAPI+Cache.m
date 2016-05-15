//
//  QLHttpRequestAPI+Cache.m
//  QLKit
//
//  Created by 王青海 on 16/2/17.
//  Copyright © 2016年 王青海. All rights reserved.
//

#import "QLHttpRequestAPI+Cache.h"

#import "QLHttpRequestCacheManager.h"



@implementation QLHttpRequestAPI (Cache)



/**
 缓存时间，单位秒
 */
+ (void)GETWithCache:(NSString *)URLString
          parameters:(NSDictionary *)parameters
           cacheTime:(NSTimeInterval)cacheTime
             success:(QLHttpResultDataCallBlock)success
             failure:(QLHttpResultErrorCallBlock)failure
{
    QLAsyncToHttpRequestCallBackQueue(^{
        NSData *data = [QLHttpRequestCacheManager cacheDataWith:URLString parameters:parameters requestType:QLHttpRequestType_GET];
        if (data) {
            if (success) {
                success(data);
            }
            return;
        }
 
        [QLHttpRequestAPI GETData:URLString parameters:parameters success:^(NSData *responseData) {
            if (success) {
                success(responseData);
            }
            //缓存数据
            
            
        } failure:^(NSError *error) {
            if (failure) {
                failure(error);
            }
        }];
    });
}

/**
 失效时间
 */
+ (void)GETWithCache:(NSString *)URLString
          parameters:(NSDictionary *)parameters
      expirationDate:(NSTimeInterval)expirationDate
             success:(QLHttpResultDataCallBlock)success
             failure:(QLHttpResultErrorCallBlock)failure
{
    QLAsyncToHttpRequestCallBackQueue(^{
        NSData *data = [QLHttpRequestCacheManager cacheDataWith:URLString parameters:parameters requestType:QLHttpRequestType_GET];
        if (data) {
            if (success) {
                success(data);
            }
            return;
        }
        
        [QLHttpRequestAPI GETData:URLString parameters:parameters success:^(NSData *responseData) {
            if (success) {
                success(responseData);
            }
            //缓存数据
        
        } failure:^(NSError *error) {
            if (failure) {
                failure(error);
            }
        }];
    });
}

/**
 临时缓存
 */
+ (void)GETWithTmpCache:(NSString *)URLString
             parameters:(NSDictionary *)parameters
                success:(QLHttpResultDataCallBlock)success
                failure:(QLHttpResultErrorCallBlock)failure
{
    QLAsyncToHttpRequestCallBackQueue(^{
        NSData *data = [QLHttpRequestCacheManager cacheDataWith:URLString parameters:parameters requestType:QLHttpRequestType_GET];
        if (data) {
            if (success) {
                success(data);
            }
            return;
        }
        
        [QLHttpRequestAPI GETData:URLString parameters:parameters success:^(NSData *responseData) {
        if (success) {
            success(responseData);
        }
        //缓存数据
        
        
        } failure:^(NSError *error) {
            if (failure) {
                failure(error);
            }
        }];
    });

}

/**
 缓存时间，单位秒
 */
+ (void)POSTWithCache:(NSString *)URLString
           parameters:(NSDictionary *)parameters
            cacheTime:(NSTimeInterval)cacheTime
              success:(QLHttpResultDataCallBlock)success
              failure:(QLHttpResultErrorCallBlock)failure
{
    QLAsyncToHttpRequestCallBackQueue(^{
        NSData *data = [QLHttpRequestCacheManager cacheDataWith:URLString parameters:parameters requestType:QLHttpRequestType_GET];
        if (data) {
            if (success) {
                success(data);
            }
            return;
        }
        
        [QLHttpRequestAPI POSTWithDataResult:URLString parameters:parameters success:^(NSData *responseData) {
        if (success) {
            success(responseData);
        }
        //缓存数据
        
        
        } failure:^(NSError *error) {
            if (failure) {
                failure(error);
            }
        }];
    });
}

/**
 失效时间
 */
+ (void)POSTWithCache:(NSString *)URLString
           parameters:(NSDictionary *)parameters
       expirationDate:(NSTimeInterval)expirationDate
              success:(QLHttpResultDataCallBlock)success
              failure:(QLHttpResultErrorCallBlock)failure
{
    QLAsyncToHttpRequestCallBackQueue(^{
        NSData *data = [QLHttpRequestCacheManager cacheDataWith:URLString parameters:parameters requestType:QLHttpRequestType_GET];
        if (data) {
            if (success) {
                success(data);
            }
            return;
        }
        
        [QLHttpRequestAPI POSTWithDataResult:URLString parameters:parameters success:^(NSData *responseData) {
        if (success) {
            success(responseData);
        }
        //缓存数据
        
        
        } failure:^(NSError *error) {
            if (failure) {
                failure(error);
            }
        }];
    });
}

/**
 临时缓存
 */
+ (void)POSTWithTmpCache:(NSString *)URLString
              parameters:(NSDictionary *)parameters
                 success:(QLHttpResultDataCallBlock)success
                 failure:(QLHttpResultErrorCallBlock)failure
{
    QLAsyncToHttpRequestCallBackQueue(^{
        NSData *data = [QLHttpRequestCacheManager cacheDataWith:URLString parameters:parameters requestType:QLHttpRequestType_GET];
        if (data) {
            if (success) {
                success(data);
            }
            return;
        }
        
        [QLHttpRequestAPI POSTWithDataResult:URLString parameters:parameters success:^(NSData *responseData) {
        if (success) {
            success(responseData);
        }
        //缓存数据
        
        
        } failure:^(NSError *error) {
            if (failure) {
                failure(error);
            }
        }];
    });
}







//+ (NSArray *)sortKeys:(NSArray *)keys
//{
//    NSArray *outKeys = [keys sortedArrayUsingComparator:^(NSString * obj1, NSString * obj2){
//    }];
//    return outKeys;
//}






@end
