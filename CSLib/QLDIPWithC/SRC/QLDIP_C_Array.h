//
//  QLDIP_C_Array.h
//  QLDIPWithC
//
//  Created by prsoft_mac01 on 15/12/22.
//  Copyright © 2015年 ql. All rights reserved.
//

#ifndef QLDIP_C_Array_h
#define QLDIP_C_Array_h

#include <stdio.h>
#include <stdlib.h>
#include "QLDIP_C_Type.h"

QLDIP_C_ArrayRef QLDIP_C_ArrayCreate();
void QLDIP_C_ArrayDealloc(QLDIP_C_ArrayRef theArray);


QLDIP_C_BoolValue QLDIP_C_ArrayReplaceValues(QLDIP_C_ArrayRef theArray, QLDIP_C_Range range, const void **newValues, uint32_t newCount);

const void *QLDIP_C_ArrayGetValueAtIndex(QLDIP_C_ArrayRef theArray, uint32_t idx);

QLDIP_C_Array_ItemRef QLDIP_C_ArrayGetItemAtIndex(QLDIP_C_ArrayRef theArray, uint32_t idx);


void QLDIP_C_ArrayAppendObject(QLDIP_C_ArrayRef theArray, const void *newValue);
void QLDIP_C_ArrayRemoveObjectAtIndex(QLDIP_C_ArrayRef theArray, uint32_t idx);



#endif /* QLDIP_C_Array_h */
