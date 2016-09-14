//
//  QLDIP_C_Null.c
//  QLDIPWithC
//
//  Created by 蔡连凤 on 16/1/3.
//  Copyright © 2016年 ql. All rights reserved.
//

#include "QLDIP_C_Null.h"

#include "QLDIP_C_Base.h"


QLDIP_C_NullRef QLDIP_C_NullCreate()
{
    QLDIP_C_NullRef theNull = NULL;
    int size = sizeof(QLDIP_C_Null);
    theNull = (QLDIP_C_NullRef)QLDIP_C_allocWithInit(size);
    if (NULL == theNull) {
        return NULL;
    }
    theNull->base.hasValue = QLDIP_C_BoolValue_true;
    theNull->base.objType = QLDIP_C_Object_type_Null;
    theNull->base.refcount = 1;
    return theNull;
}


void QLDIP_C_NullDealloc(QLDIP_C_NullRef theNull)
{
    if (NULL == theNull) {
        return;
    }
    
    QLDIP_C_Dealloc(theNull);
}