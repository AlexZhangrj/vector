//
//  QLLogCmdServerHandler.h
//  QLLogFrameWork
//
//  Created by 王青海 on 15/11/1.
//  Copyright © 2015年 王青海. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QLLogCmdServerHandler : NSObject


- (NSMutableDictionary *)didGetCmdRequest:(NSDictionary *)info;


+ (QLLogCmdServerHandler *)defaultCmdServerHandler;

@end
