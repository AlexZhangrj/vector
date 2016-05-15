//
//  QLMemoryCacheAPI.h
//  QLKit
//
//  Created by 王青海 on 16/2/17.
//  Copyright © 2016年 王青海. All rights reserved.
//

#import <Foundation/Foundation.h>


/*轻量级*/
@interface QLMemoryCacheAPI : NSObject

+ (id)objectForService:(NSString *)service;

+ (void)setObject:(id)obj forService:(NSString *)service;


+ (id)objectForService:(NSString *)service itemName:(NSString *)itemName;

+ (void)setObject:(id)obj forService:(NSString *)service itemName:(NSString *)itemName;






@end
