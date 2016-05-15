//
//  QLNetwork.h
//  QLTools
//
//  Created by 王青海 on 15/11/26.
//  Copyright © 2015年 王青海. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QLNetwork : NSObject


/**
 *  获取IP信息，如果是公网，则是公网IP， 局域网则是局域网IP
 *
 *  @return ip的字符串
 */
+ (NSString *)localIPAddress;

@end
