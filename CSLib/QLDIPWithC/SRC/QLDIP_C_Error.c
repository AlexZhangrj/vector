//
//  QLDIP_C_Error.c
//  QLDIPWithC
//
//  Created by WangQinghai on 15/12/28.
//  Copyright © 2015年 ql. All rights reserved.
//

#include "QLDIP_C_Error.h"

#include "QLDIP_C_Base.h"
#include "QLDIP_C_String.h"


QLDIP_C_ErrorRef __QLDIP_C_ErrorCreateWithStringAndErrorCode(QLDIP_C_String * str, uint32_t errorCode);



QLDIP_C_ErrorRef QLDIP_C_ErrorCreate()
{
    QLDIP_C_ErrorRef error = NULL;
    int size = sizeof(QLDIP_C_Error);
    error = (QLDIP_C_ErrorRef)QLDIP_C_allocWithInit(size);
    if (NULL == error) {
        return NULL;
    }
    error->base.hasValue = QLDIP_C_BoolValue_false;
    error->base.objType = QLDIP_C_Object_type_Error;
    error->base.refcount = 1;
    
    return error;
}

QLDIP_C_ErrorRef QLDIP_C_ErrorCreateWithCharArray(const char * cstr)
{
    QLDIP_C_StringRef str = QLDIP_C_StringCreateWithCharArray(cstr);
    return __QLDIP_C_ErrorCreateWithStringAndErrorCode(str, 0);
}

QLDIP_C_ErrorRef QLDIP_C_ErrorCreateWithCharArrayAndErrorCode(const char * cstr, uint32_t errorCode)
{
    QLDIP_C_StringRef str = QLDIP_C_StringCreateWithCharArray(cstr);
    return __QLDIP_C_ErrorCreateWithStringAndErrorCode(str, errorCode);
}

QLDIP_C_ErrorRef QLDIP_C_ErrorCreateWithString(QLDIP_C_String * str)
{
    return __QLDIP_C_ErrorCreateWithStringAndErrorCode(str, 0);
}

QLDIP_C_ErrorRef QLDIP_C_ErrorCreateWithStringAndErrorCode(QLDIP_C_String * str, uint32_t errorCode)
{
    return __QLDIP_C_ErrorCreateWithStringAndErrorCode(str, errorCode);
}

QLDIP_C_ErrorRef __QLDIP_C_ErrorCreateWithStringAndErrorCode(QLDIP_C_String * str, uint32_t errorCode)
{
    QLDIP_C_ErrorRef error = QLDIP_C_ErrorCreate();
    if (NULL == error) {
        return NULL;
    }
    error->base.hasValue = QLDIP_C_BoolValue_true;
    error->errorCode = errorCode;
    error->errorMsg = str;
    return error;
}

void QLDIP_C_ErrorDealloc(QLDIP_C_ErrorRef theError)
{
    if (NULL == theError) {
        return;
    }
    
    QLDIP_C_Release(theError->errorMsg);
    QLDIP_C_Dealloc(theError);
}


