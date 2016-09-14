//
//  QLDIP_C_String.h
//  QLDIPWithC
//
//  Created by prsoft_mac01 on 15/12/22.
//  Copyright © 2015年 ql. All rights reserved.
//

#ifndef QLDIP_C_String_h
#define QLDIP_C_String_h

#include <stdio.h>
#include <stdlib.h>
#include "QLDIP_C_Type.h"

QLDIP_C_StringRef QLDIP_C_StringCreateWithCharArray(const char * cstr);

void QLDIP_C_StringDealloc(QLDIP_C_StringRef theString);

QLDIP_C_StringRef QLDIP_C_StringCreate();

QLDIP_C_StringRef QLDIP_C_StringCopy(QLDIP_C_StringRef theString);

QLDIP_C_StringRef QLDIP_C_StringCreateWithByteArray(QLDIP_C_Byte * stringByte, QLDIP_C_Range byteRange, QLDIP_C_StringCoding stringCoding);





void QLDIP_C_StringSetContentCharArray(QLDIP_C_StringRef theString, const char * cstr);

// return char[] is read only, if you need use, requit  memory copy; sea also const char * QLDIP_C_StringUnsafeCharArrayFromStringByCopy(QLDIP_C_StringRef string)
const char * QLDIP_C_StringCharArrayFromString(QLDIP_C_StringRef string);

//return a new malloc pointer without memory Management
const char * QLDIP_C_StringUnsafeCharArrayFromStringByCopy(QLDIP_C_StringRef string);




#endif /* QLDIP_C_String_h */
