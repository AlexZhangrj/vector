//
//  QLDIP_C_Type.h
//  QLDIPForC
//
//  Created by prsoft_mac01 on 15/12/16.
//  Copyright © 2015年 ql. All rights reserved.
//

#ifndef QLDIP_C_Type_h
#define QLDIP_C_Type_h

#include <stdio.h>

#pragma pack (1)

typedef unsigned char QLDIP_C_Byte;
typedef uint32_t QLDIP_C_Number_type;
typedef uint32_t QLDIP_C_BoolValue;
typedef uint32_t QLDIP_C_Number_BoolValue;
typedef uint32_t QLDIP_C_Object_type;

typedef uint32_t QLDIP_C_ErrorCode;
typedef uint32_t QLDIP_C_StringCoding;



typedef uint32_t                        QLDIP_C_UnicodeScalarValue;
typedef uint32_t                        QLDIP_C_UTF32Char;
typedef uint16_t                        QLDIP_C_UniChar;
typedef uint16_t                        QLDIP_C_UTF16Char;
typedef uint8_t                         QLDIP_C_UTF8Char;
typedef QLDIP_C_UniChar *               QLDIP_C_UniCharPtr;
typedef unsigned long                   QLDIP_C_UniCharCount;
typedef QLDIP_C_UniCharCount *          QLDIP_C_UniCharCountPtr;


//typedef uint64_t QLDIP_C_Int64;


static const QLDIP_C_Object_type QLDIP_C_Object_type_Number   = 1;
static const QLDIP_C_Object_type QLDIP_C_Object_type_String   = 2;
static const QLDIP_C_Object_type QLDIP_C_Object_type_Data     = 3;
static const QLDIP_C_Object_type QLDIP_C_Object_type_Array    = 4;
static const QLDIP_C_Object_type QLDIP_C_Object_type_Map      = 5;
static const QLDIP_C_Object_type QLDIP_C_Object_type_Error    = 6;
static const QLDIP_C_Object_type QLDIP_C_Object_type_Null     = 7;

static const int QLDIP_C_Object_type_Number_IntValue   = QLDIP_C_Object_type_Number;
static const int QLDIP_C_Object_type_String_IntValue   = QLDIP_C_Object_type_String;
static const int QLDIP_C_Object_type_Data_IntValue     = QLDIP_C_Object_type_Data;
static const int QLDIP_C_Object_type_Array_IntValue    = QLDIP_C_Object_type_Array;
static const int QLDIP_C_Object_type_Map_IntValue      = QLDIP_C_Object_type_Map;
static const int QLDIP_C_Object_type_Error_IntValue    = QLDIP_C_Object_type_Error;

//基本错误区间  0 - 0x7ee(uint16 max)
static const QLDIP_C_ErrorCode QLDIP_C_ErrorCode_MallocFaild   = 1;



//----<基础数据类型>
static const QLDIP_C_Number_type QLDIP_C_Number_type_Null     = 0;
static const QLDIP_C_Number_type QLDIP_C_Number_type_Int8     = 1;
static const QLDIP_C_Number_type QLDIP_C_Number_type_Int16    = 2;
static const QLDIP_C_Number_type QLDIP_C_Number_type_Int32    = 3;
static const QLDIP_C_Number_type QLDIP_C_Number_type_Int64    = 4;
static const QLDIP_C_Number_type QLDIP_C_Number_type_UInt8    = 5;
static const QLDIP_C_Number_type QLDIP_C_Number_type_UInt16   = 6;
static const QLDIP_C_Number_type QLDIP_C_Number_type_UInt32   = 7;
static const QLDIP_C_Number_type QLDIP_C_Number_type_UInt64   = 8;
static const QLDIP_C_Number_type QLDIP_C_Number_type_Bool     = 9;
static const QLDIP_C_Number_type QLDIP_C_Number_type_Float    = 10;
static const QLDIP_C_Number_type QLDIP_C_Number_type_Double   = 11;



static QLDIP_C_BoolValue QLDIP_C_BoolValue_true         = 1;
static QLDIP_C_BoolValue QLDIP_C_BoolValue_false        = 0;


//QLDIP_C_StringCoding
static const QLDIP_C_StringCoding QLDIP_C_StringCoding_CString   = 1;




typedef struct {
    uint32_t location;
    uint32_t len;
}QLDIP_C_Range;
typedef QLDIP_C_Range * QLDIP_C_RangeRef;

QLDIP_C_Range QLDIP_C_RangeMake(uint32_t location, uint32_t len);
QLDIP_C_Range QLDIP_C_RangeMakeZero();



typedef struct {
    uint32_t refcount;
    QLDIP_C_Object_type objType;
    QLDIP_C_BoolValue hasValue;
}QLDIP_C_BaseStruct;

typedef struct {
    QLDIP_C_BaseStruct base;
    void *nullRef;
}QLDIP_C_Null;

typedef QLDIP_C_Null * QLDIP_C_NullRef;






union __QLDIP_C_NumberUnion{
    QLDIP_C_Byte valueByte[64];
    float f;
    double d;
//    int8_t i8;
//    int16_t i16;
//    int32_t i32;
    int64_t i64;
//    uint8_t ui8;
//    uint16_t ui16;
//    uint32_t ui32;
//    uint64_t ui64;
//    QLDIP_C_BoolValue b;
};
typedef union __QLDIP_C_NumberUnion QLDIP_C_NumberUnion;



typedef struct {
    QLDIP_C_BaseStruct base;
    QLDIP_C_Number_type numberType;
    QLDIP_C_NumberUnion value;
}QLDIP_C_Number;

typedef QLDIP_C_Number * QLDIP_C_NumberRef;


typedef uint32_t QLDIP_C_String_Type;//包含编码方式 string 类型
static QLDIP_C_String_Type QLDIP_C_String_Null = 0;
static QLDIP_C_String_Type QLDIP_C_String_Coding_UTF8 = 1;
static QLDIP_C_String_Type QLDIP_C_String_CString = 2;


typedef struct {
    QLDIP_C_BaseStruct base;
    QLDIP_C_String_Type stringType;
    uint32_t strLen;
    char * string;
    char * Uni;
}QLDIP_C_String;

typedef QLDIP_C_String * QLDIP_C_StringRef;

typedef struct {
    QLDIP_C_BaseStruct base;
    uint32_t dataLen;
    uint32_t bufferLen;
    QLDIP_C_Byte * data;
}QLDIP_C_Data;

typedef QLDIP_C_Data * QLDIP_C_DataRef;






//typedef struct __QLDIP_C_Array_Deque512{
//    struct __QLDIP_C_Array_Deque512 * last;
//    uint32_t currentCapacity;//容量
//    void * element[512];
//    struct __QLDIP_C_Array_Deque512 * next;
//}QLDIP_C_Array_Deque512;
//typedef QLDIP_C_Array_Deque512 * QLDIP_C_Array_Deque512Ref;

typedef struct {
    void * value;
}QLDIP_C_Array_Item;
typedef QLDIP_C_Array_Item * QLDIP_C_Array_ItemRef;


typedef struct __QLDIP_C_Array_Deque1024{
    struct __QLDIP_C_Array_Deque1024 * last;
    uint32_t currentCapacity;//容量
    QLDIP_C_Array_Item items[1024];
    struct __QLDIP_C_Array_Deque1024 * next;
}QLDIP_C_Array_Deque;
typedef QLDIP_C_Array_Deque * QLDIP_C_Array_DequeRef;


typedef struct {
    QLDIP_C_BaseStruct base;
    uint32_t count;
    uint32_t deqCount;
    QLDIP_C_Array_DequeRef store;
}QLDIP_C_Array;
typedef QLDIP_C_Array * QLDIP_C_ArrayRef;



typedef struct{
    QLDIP_C_BoolValue empty;//是否为空
    QLDIP_C_StringRef keyRef;
    void * valueRef;
    uint64_t hashCode;
}QLDIP_C_Map_Item;
typedef QLDIP_C_Map_Item * QLDIP_C_Map_ItemRef;


typedef struct __QLDIP_C_Map_Deque1024{
    struct __QLDIP_C_Map_Deque1024 * last;
    uint32_t currentCapacity;//容量
    QLDIP_C_Map_Item mapItems[1024];
    struct __QLDIP_C_Map_Deque1024 * next;
}QLDIP_C_Map_Deque;
typedef QLDIP_C_Map_Deque * QLDIP_C_Map_DequeRef;

typedef struct {
    QLDIP_C_BaseStruct base;
    uint32_t count;
    uint32_t deqCount;
    QLDIP_C_Map_DequeRef store;
}QLDIP_C_Map;
typedef QLDIP_C_Map * QLDIP_C_MapRef;

typedef struct {
    QLDIP_C_BaseStruct base;
    uint32_t errorCode;
    QLDIP_C_String * errorMsg;
}QLDIP_C_Error;
typedef QLDIP_C_Error * QLDIP_C_ErrorRef;


//----<基础数据类型/>



typedef struct {
    QLDIP_C_BaseStruct base;
    void * other;
}QLDIP_C_Obj;
typedef QLDIP_C_Obj * QLDIP_C_ObjRef;



#pragma pack ()




















































#endif /* QL_C_DIPType_h */
