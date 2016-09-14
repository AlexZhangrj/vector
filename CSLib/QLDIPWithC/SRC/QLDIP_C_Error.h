//
//  QLDIP_C_Error.h
//  QLDIPWithC
//
//  Created by WangQinghai on 15/12/28.
//  Copyright © 2015年 ql. All rights reserved.
//

#ifndef QLDIP_C_Error_h
#define QLDIP_C_Error_h

#include <stdio.h>
#include <stdlib.h>
#include "QLDIP_C_Type.h"




QLDIP_C_ErrorRef QLDIP_C_ErrorCreate();

QLDIP_C_ErrorRef QLDIP_C_ErrorCreateWithCharArray(const char * cstr);

QLDIP_C_ErrorRef QLDIP_C_ErrorCreateWithCharArrayAndErrorCode(const char * cstr, uint32_t errorCode);

QLDIP_C_ErrorRef QLDIP_C_ErrorCreateWithString(QLDIP_C_String * str);

QLDIP_C_ErrorRef QLDIP_C_ErrorCreateWithStringAndErrorCode(QLDIP_C_String * str, uint32_t errorCode);

void QLDIP_C_ErrorDealloc(QLDIP_C_ErrorRef theError);



#endif /* QLDIP_C_Error_h */
