//
//  QLConsoleLogOptions.m
//  QLLogFrameWork
//
//  Created by 王青海 on 15/11/1.
//  Copyright © 2015年 王青海. All rights reserved.
//

#import "QLConsoleLogOptions.h"

@implementation QLConsoleLogOptions






+ (QLConsoleLogOptions *)defaultConsoleLogOptions
{
    static QLConsoleLogOptions *____defaultConsoleLogOptions;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ____defaultConsoleLogOptions = [[[self class] alloc] init];
    });
    return ____defaultConsoleLogOptions;
}


@end
