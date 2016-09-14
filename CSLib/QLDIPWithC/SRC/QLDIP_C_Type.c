//
//  QLDIP_C_Type.c
//  QLDIPForC
//
//  Created by prsoft_mac01 on 15/12/16.
//  Copyright © 2015年 ql. All rights reserved.
//

#include "QLDIP_C_Type.h"


QLDIP_C_Range QLDIP_C_RangeMake(uint32_t location, uint32_t len)
{
    QLDIP_C_Range range;
    range.location = location;
    range.len = len;
    return range;
}

QLDIP_C_Range QLDIP_C_RangeMakeZero()
{
    QLDIP_C_Range range;
    range.location = 0;
    range.len = 0;
    return range;
}