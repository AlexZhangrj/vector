//
//  QLDIP_C_DIPSerialization.h
//  QLDIPWithC
//
//  Created by 蔡连凤 on 16/1/1.
//  Copyright © 2016年 ql. All rights reserved.
//

#ifndef QLDIP_C_DIPSerialization_h
#define QLDIP_C_DIPSerialization_h

#include <stdio.h>
#include "QLDIP_C_Base.h"
#include "QLDIP_C_Type.h"



#pragma mark - <interface>


#pragma pack (1)

// obj 0-3 len4
// obj 4 type1
//number subtype(5 1len)  value(6 len = 余下的数据长度)余下的数据
//string string类型(5-6 2len) stringValues(7 len = 余下的数据长度)
//data   dataValues
//array  count idx value(obj)
//map    count idx key-value

typedef struct {
    QLDIP_C_Range selfRange;
    
    uint32_t objLen;
    QLDIP_C_Object_type objType;
    QLDIP_C_BoolValue hasValue;

    QLDIP_C_Range objBodyRange;
}__QLDIP_C_ObjHeader;
//typedef __QLDIP_C_ObjHeader * __QLDIP_C_ObjHeaderRef;


typedef struct {
    QLDIP_C_Range selfRange;
    
    uint32_t objLen;
    QLDIP_C_Range objLenByteRange;
    uint32_t objType;
    QLDIP_C_Range objTypeByteRange;
    QLDIP_C_BoolValue hasValue;
    QLDIP_C_Range hasValueByteRange;
}__QLDIP_C_ObjSerializationBase;



typedef struct {
    __QLDIP_C_ObjSerializationBase base;
}__QLDIP_C_NullSerialization;
//typedef __QLDIP_C_NullSerialization * __QLDIP_C_NullSerializationRef;



typedef struct {
    __QLDIP_C_ObjSerializationBase base;
    QLDIP_C_Number_type numberType;
    QLDIP_C_Range numberTypeByteRange;
    QLDIP_C_Range numberByteRange;
    //    uint32_t strLen;
    //    char * string;
}__QLDIP_C_NumberSerialization;
//typedef __QLDIP_C_NumberSerialization * __QLDIP_C_NumberSerializationRef;

typedef struct {
    __QLDIP_C_ObjSerializationBase base;
    QLDIP_C_String_Type stringType;
    QLDIP_C_Range stringTypeByteRange;
    QLDIP_C_Range stringByteRange;
//    uint32_t strLen;
//    char * string;
}__QLDIP_C_StringSerialization;
//typedef __QLDIP_C_StringSerialization * __QLDIP_C_StringSerializationRef;


typedef struct {
    __QLDIP_C_ObjSerializationBase base;
    QLDIP_C_Range dataByteRange;
}__QLDIP_C_DataSerialization;
//typedef __QLDIP_C_StringSerialization * __QLDIP_C_StringSerializationRef;


typedef struct {
    __QLDIP_C_ObjSerializationBase base;
    uint32_t count;
    QLDIP_C_Range countByteRange;
    QLDIP_C_Range arrayByteRange;
}__QLDIP_C_ArraySerialization;
//typedef __QLDIP_C_ArraySerialization * __QLDIP_C_ArraySerializationRef;
typedef struct {
    QLDIP_C_Range selfRange;
    uint32_t idx;
    uint32_t itemLen;
    QLDIP_C_Range itemLenByteRange;
    QLDIP_C_Range idxByteRange;
//    uint32_t len;
    QLDIP_C_Range itemByteRange;
}__QLDIP_C_ArrayItemSerialization;




typedef struct {
    __QLDIP_C_ObjSerializationBase base;
    uint32_t count;
    QLDIP_C_Range countByteRange;
    QLDIP_C_Range mapByteRange;
}__QLDIP_C_MapSerialization;
//typedef __QLDIP_C_MapSerialization * __QLDIP_C_MapSerializationRef;

typedef struct {
    QLDIP_C_Range selfRange;
    uint32_t idx;
    QLDIP_C_Range idxByteRange;
    uint32_t itemLen;
    QLDIP_C_Range itemLenByteRange;
    QLDIP_C_Range itemByteRange;
    
    uint32_t keyLen;
    QLDIP_C_Range keyLenByteRange;
    uint32_t valueLen;
    QLDIP_C_Range valueLenByteRange;
}__QLDIP_C_MapItemSerialization;


#pragma pack (0)

__QLDIP_C_NumberSerialization __QLDIP_C_NumberSerializationMakeInit();

//__QLDIP_C_NumberSerialization __QLDIP_C_DIPPresetSerializationNumberToByte(QLDIP_C_NumberRef theNumber);


__QLDIP_C_NumberSerialization __QLDIP_C_DIPPresetSerializationNumberToByte(QLDIP_C_NumberRef theNumber);





__QLDIP_C_NullSerialization __QLDIP_C_DIPSerializationNullToByte(QLDIP_C_NullRef theNull, QLDIP_C_Byte *putInByte, uint32_t putInBeginIdx);

QLDIP_C_ObjRef __QLDIP_C_DIPSerializationByteToObj(QLDIP_C_Byte *readByte, QLDIP_C_Range objByteRange);


#pragma mark - <interface/>
//--------------------------------------------------------------------------------------
#pragma mark - <interface>
#pragma mark - <interface/>
#pragma mark - <------------------------------------------------------------------------>
#pragma mark - <implementation>
#pragma mark - </public>

#pragma mark - </public/>

#pragma mark - </private>

#pragma mark - </private/>
#pragma mark - <implementation/>




















#endif /* QLDIP_C_DIPSerialization_h */
