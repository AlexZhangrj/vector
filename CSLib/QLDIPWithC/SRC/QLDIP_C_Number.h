//
//  QLDIP_C_Number.h
//  QLDIPWithC
//
//  Created by prsoft_mac01 on 15/12/22.
//  Copyright © 2015年 ql. All rights reserved.
//

#ifndef QLDIP_C_Number_h
#define QLDIP_C_Number_h

#include <stdio.h>
#include <stdlib.h>
#include "QLDIP_C_Type.h"

QLDIP_C_NumberRef QLDIP_C_NumberCreate();
void QLDIP_C_NumberDealloc(QLDIP_C_NumberRef theNumber);

QLDIP_C_NumberRef QLDIP_C_NumberCreateWithUInt64(uint64_t theIntNum);
QLDIP_C_NumberRef QLDIP_C_NumberCreateWithUInt32(uint32_t theIntNum);
QLDIP_C_NumberRef QLDIP_C_NumberCreateWithUInt16(uint16_t theIntNum);
QLDIP_C_NumberRef QLDIP_C_NumberCreateWithUInt8(uint8_t theIntNum);

QLDIP_C_NumberRef QLDIP_C_NumberCreateWithInt64(int64_t theIntNum);
QLDIP_C_NumberRef QLDIP_C_NumberCreateWithInt32(int32_t theIntNum);
QLDIP_C_NumberRef QLDIP_C_NumberCreateWithInt16(int16_t theIntNum);
QLDIP_C_NumberRef QLDIP_C_NumberCreateWithInt8(int8_t theIntNum);

QLDIP_C_NumberRef QLDIP_C_NumberCreateWithBool(QLDIP_C_BoolValue theBool);

QLDIP_C_NumberRef QLDIP_C_NumberCreateWithFloat(float theFloatNum);

QLDIP_C_NumberRef QLDIP_C_NumberCreateWithDouble(double theDoubleNum);




uint64_t QLDIP_C_NumberUInt64Value(QLDIP_C_NumberRef theNumber);
uint32_t QLDIP_C_NumberUInt32Value(QLDIP_C_NumberRef theNumber);
uint16_t QLDIP_C_NumberUInt16Value(QLDIP_C_NumberRef theNumber);
uint8_t QLDIP_C_NumberUInt8Value(QLDIP_C_NumberRef theNumber);

int64_t QLDIP_C_NumberInt64Value(QLDIP_C_NumberRef theNumber);
int32_t QLDIP_C_NumberInt32Value(QLDIP_C_NumberRef theNumber);
int16_t QLDIP_C_NumberInt16Value(QLDIP_C_NumberRef theNumber);
int8_t QLDIP_C_NumberInt8Value(QLDIP_C_NumberRef theNumber);

QLDIP_C_BoolValue QLDIP_C_NumberBoolValue(QLDIP_C_NumberRef theNumber);

float QLDIP_C_NumberFloatValue(QLDIP_C_NumberRef theNumber);

double QLDIP_C_NumberDoubleValue(QLDIP_C_NumberRef theNumber);


#endif /* QLDIP_C_Number_h */
