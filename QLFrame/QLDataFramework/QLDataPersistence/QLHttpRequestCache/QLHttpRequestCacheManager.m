//
//  QLHttpRequestCacheManager.m
//  QLFrame
//
//  Created by 王青海 on 16/2/22.
//  Copyright © 2016年 王青海. All rights reserved.
//

#import "QLHttpRequestCacheManager.h"

#import "QLHttpRequestCacheModel.h"
#import "QLFoundation.h"



@implementation QLHttpRequestCacheManager

+ (QLHttpRequestCacheModel *)simpleUnsalfCacheModel
{

    return nil;
}

+ (NSArray *)orderedDictKeys:(NSDictionary *)dict
{
    if (!dict) {
        return nil;
    }
    NSArray *outKeys = [[dict allKeys] sortedArrayUsingComparator:^(NSString * obj1, NSString * obj2){
        return (NSComparisonResult)[obj1 compare:obj2 options:NSForcedOrderingSearch];
    }];
    return outKeys;
}

+ (NSString *)allPathWithURLString:(NSString *)URLString parameters:(NSDictionary *)parameters requestType:(QLHttpRequestType)requestType
{
    NSMutableString *retStr = [NSMutableString string];
    
    [retStr appendFormat:@"%@@%@", requestType, URLString];
    
    NSArray * keys = [QLHttpRequestCacheManager orderedDictKeys:parameters];
    if (keys && keys.count>0) {
        for (NSInteger i=0; i<keys.count; i++) {
            if (0 == i) {
                [retStr appendString:@"?"];
            }else {
                [retStr appendFormat:@"&"];
            }
            [retStr appendFormat:@"%@=%@", keys[i], [parameters objectForKey:keys[i]]];
        }
    }
//    [retStr appendString:requestType];
    
    
    return retStr;
}


+ (NSData *)tmpCacheDataWith:(NSString *)URLString
               parameters:(NSDictionary *)parameters
              requestType:(QLHttpRequestType)requestType
{
    NSString *allPathString = [QLHttpRequestCacheManager allPathWithURLString:URLString parameters:parameters requestType:requestType];
    NSString *dirName = [QLStringAPI md5_32:allPathString];
    
    
    
    
    return nil;
}

+ (void)tmpCacheResultData:(NSData *)resultData
                   With:(NSString *)URLString
             parameters:(NSDictionary *)parameters
         expirationDate:(NSTimeInterval)expirationDate
            requestType:(QLHttpRequestType)requestType
{

}




@end
