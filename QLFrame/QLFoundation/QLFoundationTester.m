//
//  QLFoundationTester.m
//  QLFoundation
//
//  Created by 王青海 on 16/1/28.
//  Copyright © 2016年 王青海. All rights reserved.
//

#import "QLFoundationTester.h"
#import "QLFoundation.h"


@implementation QLFoundationTester


+ (void)test
{
    QLAsyncTaskToMainQueue(^{
     NSLog(@"123");
    });
    
    QLSyncTaskToMainQueue(^{
        NSLog(@"123");
    });
}

@end
