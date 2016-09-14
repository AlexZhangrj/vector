//
//  QLDIP_C_Number.c
//  QLDIPWithC
//
//  Created by prsoft_mac01 on 15/12/22.
//  Copyright © 2015年 ql. All rights reserved.
//

#include "QLDIP_C_Number.h"
#include "QLDIP_C_Base.h"




#pragma mark - <interface>

void __QLDIP_C_NumberSetInt64Value(QLDIP_C_NumberRef theNumber, int64_t theIntNum);
QLDIP_C_NumberRef __QLDIP_C_NumberCreateWithValue();
void __QLDIP_C_NumberSetDoubleValue(QLDIP_C_NumberRef theNumber, double theDoubleNum);
void __QLDIP_C_NumberSetFloatValue(QLDIP_C_NumberRef theNumber, float theFloatNum);

int64_t __QLDIP_C_NumberGetInt64Value(QLDIP_C_NumberRef theNumber);
double __QLDIP_C_NumberGetDoubleValue(QLDIP_C_NumberRef theNumber);
float __QLDIP_C_NumberGetFloatValue(QLDIP_C_NumberRef theNumber);
QLDIP_C_BoolValue __QLDIP_C_NumberGetBoolValue(QLDIP_C_NumberRef theNumber);
#pragma mark - <interface/>
#pragma mark - <------------------------------------------------------------------------>
#pragma mark - <implementation>
#pragma mark - </public>
QLDIP_C_NumberRef QLDIP_C_NumberCreate()
{
    QLDIP_C_NumberRef retRef = (QLDIP_C_NumberRef)QLDIP_C_malloc(sizeof(QLDIP_C_Number));
    retRef->base.objType = QLDIP_C_Object_type_Number;
    retRef->base.hasValue = QLDIP_C_BoolValue_false;
    retRef->base.refcount = 1;
    return retRef;
}

void QLDIP_C_NumberDealloc(QLDIP_C_NumberRef theNumber)
{
    if (NULL == theNumber) {
        return;
    }
}

QLDIP_C_NumberRef QLDIP_C_NumberCreateWithUInt64(uint64_t theIntNum)
{
    QLDIP_C_NumberRef retNumer = __QLDIP_C_NumberCreateWithValue();
    int64_t num = (int64_t)theIntNum;
    __QLDIP_C_NumberSetInt64Value(retNumer, num);
    retNumer->numberType = QLDIP_C_Number_type_UInt64;
    return retNumer;
}
QLDIP_C_NumberRef QLDIP_C_NumberCreateWithUInt32(uint32_t theIntNum)
{
    QLDIP_C_NumberRef retNumer = __QLDIP_C_NumberCreateWithValue();
    int64_t num = (int64_t)theIntNum;
    __QLDIP_C_NumberSetInt64Value(retNumer, num);
    retNumer->numberType = QLDIP_C_Number_type_UInt32;
    return retNumer;
}
QLDIP_C_NumberRef QLDIP_C_NumberCreateWithUInt16(uint16_t theIntNum)
{
    QLDIP_C_NumberRef retNumer = __QLDIP_C_NumberCreateWithValue();
    int64_t num = (int64_t)theIntNum;
    __QLDIP_C_NumberSetInt64Value(retNumer, num);
    retNumer->numberType = QLDIP_C_Number_type_UInt16;
    return retNumer;
}
QLDIP_C_NumberRef QLDIP_C_NumberCreateWithUInt8(uint8_t theIntNum)
{
    QLDIP_C_NumberRef retNumer = __QLDIP_C_NumberCreateWithValue();
    int64_t num = (int64_t)theIntNum;
    __QLDIP_C_NumberSetInt64Value(retNumer, num);
    retNumer->numberType = QLDIP_C_Number_type_UInt8;
    return retNumer;
}

QLDIP_C_NumberRef QLDIP_C_NumberCreateWithInt64(int64_t theIntNum)
{
    QLDIP_C_NumberRef retNumer = __QLDIP_C_NumberCreateWithValue();
    int64_t num = (int64_t)theIntNum;
    __QLDIP_C_NumberSetInt64Value(retNumer, num);
    retNumer->numberType = QLDIP_C_Number_type_Int64;
    return retNumer;
}
QLDIP_C_NumberRef QLDIP_C_NumberCreateWithInt32(int32_t theIntNum)
{
    QLDIP_C_NumberRef retNumer = __QLDIP_C_NumberCreateWithValue();
    int64_t num = (int64_t)theIntNum;
    __QLDIP_C_NumberSetInt64Value(retNumer, num);
    retNumer->numberType = QLDIP_C_Number_type_Int32;
    return retNumer;
}
QLDIP_C_NumberRef QLDIP_C_NumberCreateWithInt16(int16_t theIntNum)
{
    QLDIP_C_NumberRef retNumer = __QLDIP_C_NumberCreateWithValue();
    int64_t num = (int64_t)theIntNum;
    __QLDIP_C_NumberSetInt64Value(retNumer, num);
    retNumer->numberType = QLDIP_C_Number_type_Int16;
    return retNumer;
}
QLDIP_C_NumberRef QLDIP_C_NumberCreateWithInt8(int8_t theIntNum)
{
    QLDIP_C_NumberRef retNumer = __QLDIP_C_NumberCreateWithValue();
    int64_t num = (int64_t)theIntNum;
    __QLDIP_C_NumberSetInt64Value(retNumer, num);
    retNumer->numberType = QLDIP_C_Number_type_Int8;
    return retNumer;
}
QLDIP_C_NumberRef QLDIP_C_NumberCreateWithBool(QLDIP_C_BoolValue theBool)
{
    QLDIP_C_NumberRef retNumer = __QLDIP_C_NumberCreateWithValue();
    int64_t num = (int64_t)theBool;
    __QLDIP_C_NumberSetInt64Value(retNumer, num);
    retNumer->numberType = QLDIP_C_Number_type_Bool;
    return retNumer;
}
QLDIP_C_NumberRef QLDIP_C_NumberCreateWithFloat(float theFloatNum)
{
    QLDIP_C_NumberRef retNumer = __QLDIP_C_NumberCreateWithValue();
    __QLDIP_C_NumberSetFloatValue(retNumer, theFloatNum);
    retNumer->numberType = QLDIP_C_Number_type_Float;
    return retNumer;
}
QLDIP_C_NumberRef QLDIP_C_NumberCreateWithDouble(double theDoubleNum)
{
    QLDIP_C_NumberRef retNumer = __QLDIP_C_NumberCreateWithValue();
    double num = (double)theDoubleNum;
    __QLDIP_C_NumberSetDoubleValue(retNumer, num);
    retNumer->numberType = QLDIP_C_Number_type_Double;
    return retNumer;
}




uint64_t QLDIP_C_NumberUInt64Value(QLDIP_C_NumberRef theNumber)
{
    int64_t retNum = __QLDIP_C_NumberGetInt64Value(theNumber);
    return (uint64_t)retNum;
}
uint32_t QLDIP_C_NumberUInt32Value(QLDIP_C_NumberRef theNumber)
{
    int64_t retNum = __QLDIP_C_NumberGetInt64Value(theNumber);
    return (uint32_t)retNum;
}
uint16_t QLDIP_C_NumberUInt16Value(QLDIP_C_NumberRef theNumber)
{
    int64_t retNum = __QLDIP_C_NumberGetInt64Value(theNumber);
    return (uint16_t)retNum;
}
uint8_t QLDIP_C_NumberUInt8Value(QLDIP_C_NumberRef theNumber)
{
    int64_t retNum = __QLDIP_C_NumberGetInt64Value(theNumber);
    return (uint8_t)retNum;
}

int64_t QLDIP_C_NumberInt64Value(QLDIP_C_NumberRef theNumber)
{
    int64_t retNum = __QLDIP_C_NumberGetInt64Value(theNumber);
    return (int64_t)retNum;
}
int32_t QLDIP_C_NumberInt32Value(QLDIP_C_NumberRef theNumber)
{
    int64_t retNum = __QLDIP_C_NumberGetInt64Value(theNumber);
    return (int32_t)retNum;
}
int16_t QLDIP_C_NumberInt16Value(QLDIP_C_NumberRef theNumber)
{
    int64_t retNum = __QLDIP_C_NumberGetInt64Value(theNumber);
    return (int16_t)retNum;
}
int8_t QLDIP_C_NumberInt8Value(QLDIP_C_NumberRef theNumber)
{
    int64_t retNum = __QLDIP_C_NumberGetInt64Value(theNumber);
    return (int8_t)retNum;
}

QLDIP_C_BoolValue QLDIP_C_NumberBoolValue(QLDIP_C_NumberRef theNumber)
{
    return __QLDIP_C_NumberGetBoolValue(theNumber);
}

float QLDIP_C_NumberFloatValue(QLDIP_C_NumberRef theNumber)
{
    float retNum = __QLDIP_C_NumberGetFloatValue(theNumber);
    return retNum;
}

double QLDIP_C_NumberDoubleValue(QLDIP_C_NumberRef theNumber)
{
    double retNum = __QLDIP_C_NumberGetDoubleValue(theNumber);
    return retNum;
}




#pragma mark - </public/>

#pragma mark - </private>
void __QLDIP_C_NumberSetInt64Value(QLDIP_C_NumberRef theNumber, int64_t theIntNum)
{
    if (NULL == theNumber) {
        return;
    }
    theNumber->value.i64 = theIntNum;
}

void __QLDIP_C_NumberSetDoubleValue(QLDIP_C_NumberRef theNumber, double theDoubleNum)
{
    if (NULL == theNumber) {
        return;
    }
    theNumber->value.d = theDoubleNum;
}

void __QLDIP_C_NumberSetFloatValue(QLDIP_C_NumberRef theNumber, float theFloatNum)
{
    if (NULL == theNumber) {
        return;
    }
    theNumber->value.f = theFloatNum;
}

QLDIP_C_NumberRef __QLDIP_C_NumberCreateWithValue()
{
    QLDIP_C_NumberRef retRef = (QLDIP_C_NumberRef)QLDIP_C_allocWithInit(sizeof(QLDIP_C_Number));
    retRef->base.objType = QLDIP_C_Object_type_Number;
    retRef->base.refcount = 1;
    retRef->base.hasValue = QLDIP_C_BoolValue_true;
    return retRef;
}

int64_t __QLDIP_C_NumberGetInt64Value(QLDIP_C_NumberRef theNumber)
{
    if (NULL == theNumber) {
        return 0;
    }
    return theNumber->value.i64;
}

double __QLDIP_C_NumberGetDoubleValue(QLDIP_C_NumberRef theNumber)
{
    if (NULL == theNumber) {
        return 0;
    }
    return theNumber->value.d;
}

float __QLDIP_C_NumberGetFloatValue(QLDIP_C_NumberRef theNumber)
{
    if (NULL == theNumber) {
        return 0;
    }
    return theNumber->value.f;
}

QLDIP_C_BoolValue __QLDIP_C_NumberGetBoolValue(QLDIP_C_NumberRef theNumber)
{
    if (NULL == theNumber) {
        return QLDIP_C_BoolValue_false;
    }
    if(QLDIP_C_BoolValue_false == theNumber->value.i64) {
        return QLDIP_C_BoolValue_false;
    }else {
        return QLDIP_C_BoolValue_true;
    }
}


#pragma mark - </private/>
#pragma mark - <implementation/>



































