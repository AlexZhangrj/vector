//
//  SwiftBridgeC.c
//  EventDemo
//
//  Created by wangqinghai on 16/5/24.
//  Copyright © 2016年 王青海. All rights reserved.
//

#include "SwiftBridgeC.h"

#include <event2/event.h>

#include <assert.h>
#include <unistd.h>
#include <string.h>
#include <stdlib.h>


void *create_event_base()
{
    struct event_base *base;
    base = event_base_new();//初始化libevent
    return base;
}





