//
//  QLMemoryCacheAPI.m
//  QLKit
//
//  Created by 王青海 on 16/2/17.
//  Copyright © 2016年 王青海. All rights reserved.
//

#import "QLMemoryCacheAPI.h"
#import "QLFoundation.h"


static inline dispatch_queue_t QLGetMemoryCacheWorkQueue()
{
    static dispatch_queue_t ____QLGetMemoryCacheWorkQueue = NULL;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        if (!____QLGetMemoryCacheWorkQueue) {
            ____QLGetMemoryCacheWorkQueue = dispatch_queue_create("com.ql.app.dataMemoryCache_workqueue", DISPATCH_QUEUE_SERIAL);
        }
    });
    return ____QLGetMemoryCacheWorkQueue;
}


@interface QLMemoryCache : NSObject

@property (nonatomic, strong) NSMutableDictionary *cacheServiceDict;
@property (nonatomic, strong) NSMutableDictionary *cacheServiceItemDict;



+ (QLMemoryCache *)share;




@end
@implementation QLMemoryCache

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.cacheServiceDict = [NSMutableDictionary dictionary];
        self.cacheServiceItemDict = [NSMutableDictionary dictionary];

    }
    return self;
}

+ (QLMemoryCache *)share
{
    static QLMemoryCache *____share = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ____share = [[QLMemoryCache alloc] init];
    });
    return ____share;
}





@end


@implementation QLMemoryCacheAPI

+ (id)objectForService:(NSString *)service
{
    __block id obj = nil;
    
    dispatch_sync(QLGetMemoryCacheWorkQueue(), ^{
        obj = [QLMemoryCache share].cacheServiceDict[service];
    });
    
    return obj;
}

+ (void)setObject:(id)obj forService:(NSString *)service
{
    dispatch_sync(QLGetMemoryCacheWorkQueue(), ^{
        if (obj) {
            
            [[QLMemoryCache share].cacheServiceDict setObject:obj forKey:service];
        }else {
            [[QLMemoryCache share].cacheServiceDict removeObjectForKey:service];
        }
    });
}


+ (id)objectForService:(NSString *)service itemName:(NSString *)itemName
{
    __block id obj = nil;
    
    dispatch_sync(QLGetMemoryCacheWorkQueue(), ^{
        obj = [QLMemoryCache share].cacheServiceItemDict[service][itemName];
    });
    
    return obj;
}


+ (void)setObject:(id)obj forService:(NSString *)service itemName:(NSString *)itemName
{
    if (!service || !itemName) {
        return;
    }
    
    dispatch_sync(QLGetMemoryCacheWorkQueue(), ^{
        if (obj) {
            NSMutableDictionary *serviceDict = [QLMemoryCache share].cacheServiceItemDict[service];
            
            if (!serviceDict) {
                serviceDict = [NSMutableDictionary dictionary];
                [QLMemoryCache share].cacheServiceItemDict[service] = serviceDict;
            }
            
            [serviceDict setObject:obj forKey:itemName];
        }else {
            [[QLMemoryCache share].cacheServiceItemDict[service] removeObjectForKey:itemName];
        }
    });
}



@end
