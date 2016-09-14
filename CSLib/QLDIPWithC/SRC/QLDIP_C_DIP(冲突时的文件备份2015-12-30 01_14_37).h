//
//  QLDIP_C_DIP.h
//  QLDIPWithC
//
//  Created by WangQinghai on 15/12/28.
//  Copyright © 2015年 ql. All rights reserved.
//

#ifndef QLDIP_C_DIP_h
#define QLDIP_C_DIP_h

#include <stdio.h>

#include "QLDIP_C_Base.h"
#include "QLDIP_C_Type.h"


static union { char c[4]; unsigned long l; } endian_test = { { 'l', '?', '?', 'b' } };
#define QLDIP_C_ENDIAN ((char)endian_test.l)

#define QLDIP_C_ENDIAN_Big ('b' == QLDIP_C_ENDIAN)
#define QLDIP_C_ENDIAN_Little ('l' == QLDIP_C_ENDIAN)



//#define BigLittle QLDIP_C_BaseIsBigEndian()

#pragma mark - <interface>

#pragma pack (1)

typedef uint32_t QLDIP_C_Node_type;

static const uint32_t QLDIP_C_Node_ProtoHeaderVerifyCode     = 0;
static const uint32_t QLDIP_C_Node_ProtoFooterVerifyCode     = UINT32_MAX;


static QLDIP_C_Node_type QLDIP_C_Node_type_Root     = 0;
static QLDIP_C_Node_type QLDIP_C_Node_type_Number   = 1;
static QLDIP_C_Node_type QLDIP_C_Node_type_String   = 2;
static QLDIP_C_Node_type QLDIP_C_Node_type_Data     = 3;
static QLDIP_C_Node_type QLDIP_C_Node_type_Map      = 4;
static QLDIP_C_Node_type QLDIP_C_Node_type_Array    = 5;


static const uint32_t QLDIP_C_Node_ProtoHeaderVerifyCodeLen     = 4;
static const uint32_t QLDIP_C_Node_ProtoHeaderLen               = 4;
static const uint32_t QLDIP_C_Node_ProtoVersionLen              = 4;
static const uint32_t QLDIP_C_Node_ProtoHeaderExpandLen         = 2;

static const uint32_t QLDIP_C_Node_ProtoBodyCountLen            = 1;
static const uint32_t QLDIP_C_Node_ProtoBodysTotalLen           = 4;
static const uint32_t QLDIP_C_Node_ProtoBodyLen                 = 4;

static const uint32_t QLDIP_C_Node_ProtoFooterVerifyCodeLen     = 4;





//error code
static const QLDIP_C_ErrorCode QLDIP_C_ErrorCode_DIP_LenthNotEnough = (0xff << 8) + 1;
static const QLDIP_C_ErrorCode QLDIP_C_ErrorCode_DIP_TargetNull = (0xff << 8) + 2;




typedef struct {
    QLDIP_C_Node_type type;//节点类型
    uint32_t headerLen;//节点数据 头
}QLDIP_C_NodeBase;

typedef QLDIP_C_NodeBase * QLDIP_C_NodeBaseRef;


typedef struct {
    QLDIP_C_NodeBase nodeBase;
    void * detail;
}QLDIP_C_Node;

typedef QLDIP_C_Node * QLDIP_C_NodeRef;


typedef struct {
    uint32_t expandIntervalLen;
    void * footerVerifyCode;
}QLDIP_C_NodeProtoExpand;

typedef QLDIP_C_NodeProtoExpand * QLDIP_C_NodeProtoExpandRef;

typedef struct {
    uint32_t bodyCount;
    uint32_t bodyLen;
    QLDIP_C_Byte * body;
}QLDIP_C_NodeProtoBody;

typedef QLDIP_C_NodeProtoBody * QLDIP_C_NodeProtoBodyRef;

typedef struct {
    QLDIP_C_NodeBase nodeBase;
    uint32_t headerVerifyCode;
    uint32_t version;
    QLDIP_C_NodeProtoExpand * headerExpand;
    
    
    
    uint32_t footerVerifyCode;
}QLDIP_C_NodeProto;

typedef QLDIP_C_NodeProto * QLDIP_C_NodeProtoRef;




#pragma mark - <func>

QLDIP_C_ArrayRef QLDIP_C_DIPSerializationQLDIPObjectWithByte(QLDIP_C_Byte * byte, uint32_t byteLen, QLDIP_C_Error ** errRefRef);
QLDIP_C_DataRef QLDIP_C_DIPSerializationQLDIPDataWithArray(QLDIP_C_ArrayRef theArray, QLDIP_C_Error ** errRefRef);



int64_t QLDIP_C_DIPPopIntWithByteLen(QLDIP_C_Byte * byte, uint32_t popLen);

QLDIP_C_Byte * QLDIP_C_DIPByteFromInt64WithByteLen(int64_t number, uint32_t byteLen);


QLDIP_C_DataRef QLDIP_C_DataFromInt64WithByteLen(int64_t num, uint32_t byteLen);

int64_t QLDIP_C_DataPopInt64WithRange(QLDIP_C_DataRef theData, QLDIP_C_Range byteRange, QLDIP_C_Error ** errRefRef);


//拓展方法

QLDIP_C_DataRef QLDIP_C_DataFromInt64(int64_t num);
QLDIP_C_DataRef QLDIP_C_DataFromInt32(int32_t num);
QLDIP_C_DataRef QLDIP_C_DataFromInt16(int16_t num);
QLDIP_C_DataRef QLDIP_C_DataFromInt8(int8_t num);

QLDIP_C_DataRef QLDIP_C_DataFromUInt64(uint64_t num);
QLDIP_C_DataRef QLDIP_C_DataFromUInt32(uint32_t num);
QLDIP_C_DataRef QLDIP_C_DataFromUInt16(uint16_t num);
QLDIP_C_DataRef QLDIP_C_DataFromUInt8(uint8_t num);

int64_t QLDIP_C_DataPopInt64(QLDIP_C_DataRef theData, uint32_t index, QLDIP_C_Error ** errRefRef);
int32_t QLDIP_C_DataPopInt32(QLDIP_C_DataRef theData, uint32_t index, QLDIP_C_Error ** errRefRef);
int16_t QLDIP_C_DataPopInt16(QLDIP_C_DataRef theData, uint32_t index, QLDIP_C_Error ** errRefRef);
int8_t QLDIP_C_DataPopInt8(QLDIP_C_DataRef theData, uint32_t index, QLDIP_C_Error ** errRefRef);

uint64_t QLDIP_C_DataPopUInt64(QLDIP_C_DataRef theData, uint32_t index, QLDIP_C_Error ** errRefRef);
uint32_t QLDIP_C_DataPopUInt32(QLDIP_C_DataRef theData, uint32_t index, QLDIP_C_Error ** errRefRef);
uint16_t QLDIP_C_DataPopUInt16(QLDIP_C_DataRef theData, uint32_t index, QLDIP_C_Error ** errRefRef);
uint8_t QLDIP_C_DataPopUInt8(QLDIP_C_DataRef theData, uint32_t index, QLDIP_C_Error ** errRefRef);

//int8_t QLDIP_C_DIPPopInt8(QLDIP_C_Byte * byte, QLDIP_C_Range byteRange, QLDIP_C_Error ** errRefRef);

int64_t QLDIP_C_DIPPopInt64WithBeginIdx(QLDIP_C_Byte * byte, uint32_t beginIdx);
int32_t QLDIP_C_DIPPopInt32WithBeginIdx(QLDIP_C_Byte * byte, uint32_t beginIdx);
int16_t QLDIP_C_DIPPopInt16WithBeginIdx(QLDIP_C_Byte * byte, uint32_t beginIdx);
int8_t QLDIP_C_DIPPopInt8WithBeginIdx(QLDIP_C_Byte * byte, uint32_t beginIdx);

uint64_t QLDIP_C_DIPPopUInt64WithBeginIdx(QLDIP_C_Byte * byte, uint32_t beginIdx);
uint32_t QLDIP_C_DIPPopUInt32WithBeginIdx(QLDIP_C_Byte * byte, uint32_t beginIdx);
uint16_t QLDIP_C_DIPPopUInt16WithBeginIdx(QLDIP_C_Byte * byte, uint32_t beginIdx);
uint8_t QLDIP_C_DIPPopUInt8WithBeginIdx(QLDIP_C_Byte * byte, uint32_t beginIdx);

int64_t QLDIP_C_DIPPopInt64WithBeginIdxWithErrorRefRef(QLDIP_C_Byte * byte, uint32_t beginIdx, QLDIP_C_Error ** errRefRef);
int32_t QLDIP_C_DIPPopInt32WithBeginIdxWithErrorRefRef(QLDIP_C_Byte * byte, uint32_t beginIdx, QLDIP_C_Error ** errRefRef);
int16_t QLDIP_C_DIPPopInt16WithBeginIdxWithErrorRefRef(QLDIP_C_Byte * byte, uint32_t beginIdx, QLDIP_C_Error ** errRefRef);
int8_t QLDIP_C_DIPPopInt8WithBeginIdxWithErrorRefRef(QLDIP_C_Byte * byte, uint32_t beginIdx, QLDIP_C_Error ** errRefRef);

uint64_t QLDIP_C_DIPPopUInt64WithBeginIdxWithErrorRefRef(QLDIP_C_Byte * byte, uint32_t beginIdx, QLDIP_C_Error ** errRefRef);
uint32_t QLDIP_C_DIPPopUInt32WithBeginIdxWithErrorRefRef(QLDIP_C_Byte * byte, uint32_t beginIdx, QLDIP_C_Error ** errRefRef);
uint16_t QLDIP_C_DIPPopUInt16WithBeginIdxWithErrorRefRef(QLDIP_C_Byte * byte, uint32_t beginIdx, QLDIP_C_Error ** errRefRef);
uint8_t QLDIP_C_DIPPopUInt8WithBeginIdxWithErrorRefRef(QLDIP_C_Byte * byte, uint32_t beginIdx, QLDIP_C_Error ** errRefRef);


#pragma mark - <func/>


#pragma pack (0)

#pragma mark - <interface/>


#endif /* QLDIP_C_DIP_h */
