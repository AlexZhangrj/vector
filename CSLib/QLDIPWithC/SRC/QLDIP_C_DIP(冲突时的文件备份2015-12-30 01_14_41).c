//
//  QLDIP_C_DIP.c
//  QLDIPWithC
//
//  Created by WangQinghai on 15/12/28.
//  Copyright © 2015年 ql. All rights reserved.
//

#include "QLDIP_C_DIP.h"

#include "QLDIP_C_Array.h"
#include "QLDIP_C_Error.h"
#include "QLDIP_C_Data.h"



#pragma mark - <interface>

int64_t __QLDIP_C_DataPopInt64(QLDIP_C_DataRef theData, QLDIP_C_Range byteRange, QLDIP_C_Error ** errRefRef);

int64_t __QLDIP_C_DIPPopInt64(QLDIP_C_Byte * theByte, QLDIP_C_Range byteRange);

int64_t __QLDIP_C_DIPPopUInt64WithRangeWithErrorRefRef(QLDIP_C_Byte * byte, QLDIP_C_Range range, QLDIP_C_Error ** errRefRef);


#pragma mark - <interface/>

#pragma mark - <------------------------------------------------------------------------>

#pragma mark - <implementation>

#pragma mark - </public>

QLDIP_C_ArrayRef QLDIP_C_DIPSerializationQLDIPObjectWithByte(QLDIP_C_Byte * byte, uint32_t byteLen, QLDIP_C_Error ** errRefRef)
{
    QLDIP_C_Array * array = QLDIP_C_ArrayCreate();
    if (NULL == array) {
        if (NULL != errRefRef) {
            *errRefRef = QLDIP_C_ErrorCreateWithCharArrayAndErrorCode("返回值 开辟空间失败", QLDIP_C_ErrorCode_MallocFaild);
        }
        return NULL;
    }
    
    QLDIP_C_Error *tempErrRefRef = NULL;
    QLDIP_C_NodeProto nodeProto;
    
    QLDIP_C_Byte *tempByte = byte;
    uint32_t tempByteIdx = 0;
    QLDIP_C_Range tempRange = QLDIP_C_RangeMake(tempByteIdx, 0);
    
    
    
//    tempRange.len = 8;
    tempByteIdx += 4;
    if (tempByteIdx >= byteLen) {
        if (NULL != errRefRef) {
            *errRefRef = QLDIP_C_ErrorCreateWithCharArrayAndErrorCode("数据长度不够", QLDIP_C_ErrorCode_DIP_LenthNotEnough);
        }
        QLDIP_C_Release(array);
        return NULL;
    }
    
    nodeProto.headerVerifyCode = QLDIP_C_DIPPopUInt32WithBeginIdxWithErrorRefRef(tempByte, tempByteIdx, &tempErrRefRef);
    if (NULL != tempErrRefRef) {
        if (NULL != errRefRef) {
            *errRefRef = tempErrRefRef;
            QLDIP_C_Release(array);
            return NULL;
        }else {
            QLDIP_C_Release(array);
            QLDIP_C_Release(tempErrRefRef);
            return NULL;
        }
    }
    
    
    tempByteIdx += QLDIP_C_Node_ProtoHeaderVerifyCodeLen;
    if (tempByteIdx >= byteLen) {
        if (NULL != errRefRef) {
            *errRefRef = QLDIP_C_ErrorCreateWithCharArrayAndErrorCode("数据长度不够", QLDIP_C_ErrorCode_DIP_LenthNotEnough);
        }
        QLDIP_C_Release(array);
        return NULL;
    }
    
    uint32_t headerLen = QLDIP_C_DIPPopUInt32WithBeginIdxWithErrorRefRef(tempByte, tempByteIdx, &tempErrRefRef);
    if (NULL != tempErrRefRef) {
        if (NULL != errRefRef) {
            *errRefRef = tempErrRefRef;
            QLDIP_C_Release(array);
            return NULL;
        }else {
            QLDIP_C_Release(array);
            QLDIP_C_Release(tempErrRefRef);
            return NULL;
        }
    }
    
    
    QLDIP_C_Range headerRange = QLDIP_C_RangeMake(tempByteIdx + QLDIP_C_Node_ProtoVersionLen, headerLen);
    
    
    tempByteIdx += QLDIP_C_Node_ProtoVersionLen;
    if (tempByteIdx >= byteLen) {
        if (NULL != errRefRef) {
            *errRefRef = QLDIP_C_ErrorCreateWithCharArrayAndErrorCode("数据长度不够", QLDIP_C_ErrorCode_DIP_LenthNotEnough);
        }
        QLDIP_C_Release(array);
        return NULL;
    }
    
    nodeProto.version = QLDIP_C_DIPPopUInt32WithBeginIdxWithErrorRefRef(tempByte, tempByteIdx, &tempErrRefRef);
    if (NULL != tempErrRefRef) {
        if (NULL != errRefRef) {
            *errRefRef = tempErrRefRef;
            QLDIP_C_Release(array);
            return NULL;
        }else {
            QLDIP_C_Release(array);
            QLDIP_C_Release(tempErrRefRef);
            return NULL;
        }
    }
    
    
    //拓展
    QLDIP_C_NodeProtoExpand nodeProtoExpand;
    
    tempByteIdx += QLDIP_C_Node_ProtoVersionLen;
    if (tempByteIdx >= byteLen) {
        if (NULL != errRefRef) {
            *errRefRef = QLDIP_C_ErrorCreateWithCharArrayAndErrorCode("数据长度不够", QLDIP_C_ErrorCode_DIP_LenthNotEnough);
        }
        QLDIP_C_Release(array);
        return NULL;
    }
    
    nodeProtoExpand.expandIntervalLen = QLDIP_C_DIPPopUInt16WithBeginIdxWithErrorRefRef(tempByte, tempByteIdx, &tempErrRefRef);
    if (NULL != tempErrRefRef) {
        if (NULL != errRefRef) {
            *errRefRef = tempErrRefRef;
            QLDIP_C_Release(array);
            return NULL;
        }else {
            QLDIP_C_Release(array);
            QLDIP_C_Release(tempErrRefRef);
            return NULL;
        }
    }
    
    
    QLDIP_C_Range headerExpandRange = QLDIP_C_RangeMake(tempByteIdx + 4, nodeProtoExpand.expandIntervalLen);
    
    
    
    
    //body 部分
    uint32_t bodyBeginIdx = 0 + QLDIP_C_Node_ProtoHeaderVerifyCodeLen + QLDIP_C_Node_ProtoVersionLen + QLDIP_C_Node_ProtoHeaderExpandLen + nodeProtoExpand.expandIntervalLen;
    uint32_t tempBodyIdx = bodyBeginIdx;
    uint32_t bodysCount = QLDIP_C_DIPPopUInt8WithBeginIdxWithErrorRefRef(tempByte, bodyBeginIdx, &tempErrRefRef);
    if (NULL != tempErrRefRef) {
        if (NULL != errRefRef) {
            *errRefRef = tempErrRefRef;
            QLDIP_C_Release(array);
            return NULL;
        }else {
            QLDIP_C_Release(array);
            QLDIP_C_Release(tempErrRefRef);
            return NULL;
        }
    }
    
    
    
    tempBodyIdx += QLDIP_C_Node_ProtoVersionLen;
    if (tempBodyIdx >= byteLen) {
        if (NULL != errRefRef) {
            *errRefRef = QLDIP_C_ErrorCreateWithCharArrayAndErrorCode("数据长度不够", QLDIP_C_ErrorCode_DIP_LenthNotEnough);
        }
        QLDIP_C_Release(array);
        return NULL;
    }
    
    uint32_t bodysTotalLen = QLDIP_C_DIPPopUInt32WithBeginIdxWithErrorRefRef(tempByte, tempBodyIdx, &tempErrRefRef);
    if (NULL != tempErrRefRef) {
        if (NULL != errRefRef) {
            *errRefRef = tempErrRefRef;
            QLDIP_C_Release(array);
            return NULL;
        }else {
            QLDIP_C_Release(array);
            QLDIP_C_Release(tempErrRefRef);
            return NULL;
        }
    }
    
    QLDIP_C_Range bodysRange = QLDIP_C_RangeMake(tempBodyIdx + QLDIP_C_Node_ProtoBodysTotalLen, bodysTotalLen);

    //footer 部分
    uint32_t footerBeginIdx = bodyBeginIdx + QLDIP_C_Node_ProtoBodyCountLen + QLDIP_C_Node_ProtoBodysTotalLen;
    uint32_t tempFooterIdx = footerBeginIdx;
    uint32_t footer = QLDIP_C_DIPPopUInt32WithBeginIdxWithErrorRefRef(tempByte, footerBeginIdx, &tempErrRefRef);
    if (NULL != tempErrRefRef) {
        if (NULL != errRefRef) {
            *errRefRef = tempErrRefRef;
            QLDIP_C_Release(array);
            return NULL;
        }else {
            QLDIP_C_Release(array);
            QLDIP_C_Release(tempErrRefRef);
            return NULL;
        }
    }

    
    //    nodeProto.
    
    
    return array;
}

QLDIP_C_DataRef QLDIP_C_DIPSerializationQLDIPDataWithArray(QLDIP_C_ArrayRef theArray, QLDIP_C_Error ** errRefRef)
{
    if (NULL == theArray) {
        if (NULL != errRefRef) {
            *errRefRef = QLDIP_C_ErrorCreateWithCharArrayAndErrorCode("目标数组为空", QLDIP_C_ErrorCode_DIP_TargetNull);
        }
        return NULL;
    }
    
    
    QLDIP_C_DataRef dataRef = NULL;
    dataRef = QLDIP_C_DataCreateWithExpectedBufferLen(512);


    return dataRef;
}

int64_t QLDIP_C_DIPPopIntWithByteLen(QLDIP_C_Byte * byte, uint32_t popLen)
{
    int64_t num = 0;
    QLDIP_C_Byte * numByte = (QLDIP_C_Byte *)(&num);
    if (NULL == byte) {
        return num;
    }
    if (QLDIP_C_ENDIAN_Little) {
        for (int i=0; i<popLen; i++) {
            numByte[7-i] = byte[i];
        }
    }else {
        for (int i=0; i<popLen; i++) {
            numByte[7-popLen+i] = byte[i];
        }
    }
    
    return num;
}

QLDIP_C_Byte * QLDIP_C_DIPByteFromInt64WithByteLen(int64_t number, uint32_t byteLen)
{
    QLDIP_C_Byte * numByte = (QLDIP_C_Byte *)(&number);
    QLDIP_C_Byte *retByte = QLDIP_C_allocWithInit(byteLen);
    if (QLDIP_C_ENDIAN_Little) {
        for (int i=0; i<byteLen; i++) {
            retByte[i] = numByte[7-i];
        }
    }else {
        for (int i=0; i<byteLen; i++) {
            retByte[i] = numByte[7-byteLen-i];
        }
    }
    return retByte;
}

QLDIP_C_DataRef QLDIP_C_DataFromInt64WithByteLen(int64_t num, uint32_t byteLen)
{
    if (0 == byteLen) {
        return QLDIP_C_DataCreate();
    }
    
    QLDIP_C_Byte * byte = QLDIP_C_DIPByteFromInt64WithByteLen(num, byteLen);
    if (NULL == byte) {
        return NULL;
    }
    QLDIP_C_DataRef retData = QLDIP_C_DataCreateWithByteArray(byte, byteLen);
    QLDIP_C_Dealloc(byte);
    
    return retData;
}

int64_t QLDIP_C_DataPopInt64WithRange(QLDIP_C_DataRef theData, QLDIP_C_Range byteRange, QLDIP_C_Error ** errRefRef)
{
    return __QLDIP_C_DataPopInt64(theData, byteRange, errRefRef);
}

//int8_t QLDIP_C_DIPPopInt8(QLDIP_C_Byte * byte, QLDIP_C_Range byteRange, QLDIP_C_Error ** errRefRef)
//{
//    
//    
//}

//拓展方法
QLDIP_C_DataRef QLDIP_C_DataFromInt64(int64_t num)
{
    int64_t temp = (int64_t)num;
    return QLDIP_C_DataFromInt64WithByteLen(temp, 8);
}
QLDIP_C_DataRef QLDIP_C_DataFromInt32(int32_t num)
{
    int64_t temp = (int64_t)num;
    return QLDIP_C_DataFromInt64WithByteLen(temp, 4);
}
QLDIP_C_DataRef QLDIP_C_DataFromInt16(int16_t num)
{
    int64_t temp = (int64_t)num;
    return QLDIP_C_DataFromInt64WithByteLen(temp, 2);
}
QLDIP_C_DataRef QLDIP_C_DataFromInt8(int8_t num)
{
    int64_t temp = (int64_t)num;
    return QLDIP_C_DataFromInt64WithByteLen(temp, 1);
}


QLDIP_C_DataRef QLDIP_C_DataFromUInt64(uint64_t num)
{
    int64_t temp = (int64_t)num;
    return QLDIP_C_DataFromInt64WithByteLen(temp, 8);
}
QLDIP_C_DataRef QLDIP_C_DataFromUInt32(uint32_t num)
{
    int64_t temp = (int64_t)num;
    return QLDIP_C_DataFromInt64WithByteLen(temp, 4);
}
QLDIP_C_DataRef QLDIP_C_DataFromUInt16(uint16_t num)
{
    int64_t temp = (int64_t)num;
    return QLDIP_C_DataFromInt64WithByteLen(temp, 2);
}
QLDIP_C_DataRef QLDIP_C_DataFromUInt8(uint8_t num)
{
    int64_t temp = (int64_t)num;
    return QLDIP_C_DataFromInt64WithByteLen(temp, 1);
}

int64_t QLDIP_C_DataPopInt64(QLDIP_C_DataRef theData, uint32_t index, QLDIP_C_Error ** errRefRef)
{
    QLDIP_C_Range range = QLDIP_C_RangeMake(index, 8);
    int64_t retNum = QLDIP_C_DataPopInt64WithRange(theData, range, errRefRef);
    return (int64_t)retNum;
}
int32_t QLDIP_C_DataPopInt32(QLDIP_C_DataRef theData, uint32_t index, QLDIP_C_Error ** errRefRef)
{
    QLDIP_C_Range range = QLDIP_C_RangeMake(index, 4);
    int64_t retNum = QLDIP_C_DataPopInt64WithRange(theData, range, errRefRef);
    return (int32_t)retNum;
}
int16_t QLDIP_C_DataPopInt16(QLDIP_C_DataRef theData, uint32_t index, QLDIP_C_Error ** errRefRef)
{
    QLDIP_C_Range range = QLDIP_C_RangeMake(index, 2);
    int64_t retNum = QLDIP_C_DataPopInt64WithRange(theData, range, errRefRef);
    return (int16_t)retNum;
}
int8_t QLDIP_C_DataPopInt8(QLDIP_C_DataRef theData, uint32_t index, QLDIP_C_Error ** errRefRef)
{
    QLDIP_C_Range range = QLDIP_C_RangeMake(index, 1);
    int64_t retNum = QLDIP_C_DataPopInt64WithRange(theData, range, errRefRef);
    return (int8_t)retNum;
}

uint64_t QLDIP_C_DataPopUInt64(QLDIP_C_DataRef theData, uint32_t index, QLDIP_C_Error ** errRefRef)
{
    QLDIP_C_Range range = QLDIP_C_RangeMake(index, 8);
    int64_t retNum = QLDIP_C_DataPopInt64WithRange(theData, range, errRefRef);
    return (uint64_t)retNum;
}
uint32_t QLDIP_C_DataPopUInt32(QLDIP_C_DataRef theData, uint32_t index, QLDIP_C_Error ** errRefRef)
{
    QLDIP_C_Range range = QLDIP_C_RangeMake(index, 4);
    int64_t retNum = QLDIP_C_DataPopInt64WithRange(theData, range, errRefRef);
    return (uint32_t)retNum;
}
uint16_t QLDIP_C_DataPopUInt16(QLDIP_C_DataRef theData, uint32_t index, QLDIP_C_Error ** errRefRef)
{
    QLDIP_C_Range range = QLDIP_C_RangeMake(index, 2);
    int64_t retNum = QLDIP_C_DataPopInt64WithRange(theData, range, errRefRef);
    return (uint16_t)retNum;
}
uint8_t QLDIP_C_DataPopUInt8(QLDIP_C_DataRef theData, uint32_t index, QLDIP_C_Error ** errRefRef)
{
    QLDIP_C_Range range = QLDIP_C_RangeMake(index, 1);
    int64_t retNum = QLDIP_C_DataPopInt64WithRange(theData, range, errRefRef);
    return (uint8_t)retNum;
}


int64_t QLDIP_C_DIPPopInt64WithBeginIdx(QLDIP_C_Byte * byte, uint32_t beginIdx)
{
    int64_t retNum = __QLDIP_C_DIPPopUInt64WithRangeWithErrorRefRef(byte, QLDIP_C_RangeMake(beginIdx, 8), NULL);
    return (int64_t)retNum;
}
int32_t QLDIP_C_DIPPopInt32WithBeginIdx(QLDIP_C_Byte * byte, uint32_t beginIdx)
{
    int64_t retNum = __QLDIP_C_DIPPopUInt64WithRangeWithErrorRefRef(byte, QLDIP_C_RangeMake(beginIdx, 4), NULL);
    return (int32_t)retNum;
}
int16_t QLDIP_C_DIPPopInt16WithBeginIdx(QLDIP_C_Byte * byte, uint32_t beginIdx)
{
    int64_t retNum = __QLDIP_C_DIPPopUInt64WithRangeWithErrorRefRef(byte, QLDIP_C_RangeMake(beginIdx, 2), NULL);
    return (int16_t)retNum;
}
int8_t QLDIP_C_DIPPopInt8WithBeginIdx(QLDIP_C_Byte * byte, uint32_t beginIdx)
{
    int64_t retNum = __QLDIP_C_DIPPopUInt64WithRangeWithErrorRefRef(byte, QLDIP_C_RangeMake(beginIdx, 1), NULL);
    return (int8_t)retNum;
}

uint64_t QLDIP_C_DIPPopUInt64WithBeginIdx(QLDIP_C_Byte * byte, uint32_t beginIdx)
{
    int64_t retNum = __QLDIP_C_DIPPopUInt64WithRangeWithErrorRefRef(byte, QLDIP_C_RangeMake(beginIdx, 8), NULL);
    return (uint64_t)retNum;
}
uint32_t QLDIP_C_DIPPopUInt32WithBeginIdx(QLDIP_C_Byte * byte, uint32_t beginIdx)
{
    int64_t retNum = __QLDIP_C_DIPPopUInt64WithRangeWithErrorRefRef(byte, QLDIP_C_RangeMake(beginIdx, 4), NULL);
    return (uint32_t)retNum;
}
uint16_t QLDIP_C_DIPPopUInt16WithBeginIdx(QLDIP_C_Byte * byte, uint32_t beginIdx)
{
    int64_t retNum = __QLDIP_C_DIPPopUInt64WithRangeWithErrorRefRef(byte, QLDIP_C_RangeMake(beginIdx, 2), NULL);
    return (uint16_t)retNum;
}
uint8_t QLDIP_C_DIPPopUInt8WithBeginIdx(QLDIP_C_Byte * byte, uint32_t beginIdx)
{
    int64_t retNum = __QLDIP_C_DIPPopUInt64WithRangeWithErrorRefRef(byte, QLDIP_C_RangeMake(beginIdx, 1), NULL);
    return (uint8_t)retNum;
}

int64_t QLDIP_C_DIPPopInt64WithBeginIdxWithErrorRefRef(QLDIP_C_Byte * byte, uint32_t beginIdx, QLDIP_C_Error ** errRefRef)
{
    int64_t retNum = __QLDIP_C_DIPPopUInt64WithRangeWithErrorRefRef(byte, QLDIP_C_RangeMake(beginIdx, 8), errRefRef);
    return (int64_t)retNum;
}
int32_t QLDIP_C_DIPPopInt32WithBeginIdxWithErrorRefRef(QLDIP_C_Byte * byte, uint32_t beginIdx, QLDIP_C_Error ** errRefRef)
{
    int64_t retNum = __QLDIP_C_DIPPopUInt64WithRangeWithErrorRefRef(byte, QLDIP_C_RangeMake(beginIdx, 4), errRefRef);
    return (int32_t)retNum;
}
int16_t QLDIP_C_DIPPopInt16WithBeginIdxWithErrorRefRef(QLDIP_C_Byte * byte, uint32_t beginIdx, QLDIP_C_Error ** errRefRef)
{
    int64_t retNum = __QLDIP_C_DIPPopUInt64WithRangeWithErrorRefRef(byte, QLDIP_C_RangeMake(beginIdx, 2), errRefRef);
    return (int16_t)retNum;
}
int8_t QLDIP_C_DIPPopInt8WithBeginIdxWithErrorRefRef(QLDIP_C_Byte * byte, uint32_t beginIdx, QLDIP_C_Error ** errRefRef)
{
    int64_t retNum = __QLDIP_C_DIPPopUInt64WithRangeWithErrorRefRef(byte, QLDIP_C_RangeMake(beginIdx, 1), errRefRef);
    return (int8_t)retNum;
}

uint64_t QLDIP_C_DIPPopUInt64WithBeginIdxWithErrorRefRef(QLDIP_C_Byte * byte, uint32_t beginIdx, QLDIP_C_Error ** errRefRef)
{
    int64_t retNum = __QLDIP_C_DIPPopUInt64WithRangeWithErrorRefRef(byte, QLDIP_C_RangeMake(beginIdx, 8), errRefRef);
    return (uint64_t)retNum;
}
uint32_t QLDIP_C_DIPPopUInt32WithBeginIdxWithErrorRefRef(QLDIP_C_Byte * byte, uint32_t beginIdx, QLDIP_C_Error ** errRefRef)
{
    int64_t retNum = __QLDIP_C_DIPPopUInt64WithRangeWithErrorRefRef(byte, QLDIP_C_RangeMake(beginIdx, 4), errRefRef);
    return (uint32_t)retNum;
}
uint16_t QLDIP_C_DIPPopUInt16WithBeginIdxWithErrorRefRef(QLDIP_C_Byte * byte, uint32_t beginIdx, QLDIP_C_Error ** errRefRef)
{
    int64_t retNum = __QLDIP_C_DIPPopUInt64WithRangeWithErrorRefRef(byte, QLDIP_C_RangeMake(beginIdx, 2), errRefRef);
    return (uint16_t)retNum;
}
uint8_t QLDIP_C_DIPPopUInt8WithBeginIdxWithErrorRefRef(QLDIP_C_Byte * byte, uint32_t beginIdx, QLDIP_C_Error ** errRefRef)
{
    int64_t retNum = __QLDIP_C_DIPPopUInt64WithRangeWithErrorRefRef(byte, QLDIP_C_RangeMake(beginIdx, 1), errRefRef);
    return (uint8_t)retNum;
}

#pragma mark - </public/>

#pragma mark - </private>

int64_t __QLDIP_C_DIPPopUInt64WithRangeWithErrorRefRef(QLDIP_C_Byte * byte, QLDIP_C_Range range, QLDIP_C_Error ** errRefRef)
{
    QLDIP_C_Byte *tempByte = byte;
    if (NULL == tempByte) {
        if (NULL != errRefRef) {
            *errRefRef = QLDIP_C_ErrorCreateWithCharArrayAndErrorCode("", 2);
        }
        return 0;
    }
    tempByte += range.location;
    int64_t retNum = QLDIP_C_DIPPopIntWithByteLen(tempByte, range.len);
    return (int64_t)retNum;
}



/*
 theByte nonnull
 byteRange 必须为一个有效的range
 */
int64_t __QLDIP_C_DIPPopInt64(QLDIP_C_Byte * theByte, QLDIP_C_Range byteRange)
{
    QLDIP_C_Byte * byte = theByte;
    int64_t num = 0;
    QLDIP_C_Byte * numByte = (QLDIP_C_Byte *)(&num);
    if (NULL == byte) {
        return num;
    }
    

    if (QLDIP_C_ENDIAN_Little) {
        int popLen = byteRange.len;
        if (popLen > 8) {
            popLen = 8;
        }
        for (int i=0; i<popLen; i++) {
            numByte[7-i] = byte[i];
        }
    }else {
        int popLen = byteRange.len;
        if (popLen > 8) {
            popLen = 8;
            byte += byteRange.location + (byteRange.len - 8);
        }
        for (int i=0; i<popLen; i++) {
            numByte[7-popLen+i] = byte[i];
        }
    }

    return num;
    
}









int64_t __QLDIP_C_DataPopInt64(QLDIP_C_DataRef theData, QLDIP_C_Range byteRange, QLDIP_C_Error ** errRefRef)
{
    int64_t ret = 0;
    if (NULL == theData) {
        if (NULL != errRefRef) {
            *errRefRef = QLDIP_C_ErrorCreateWithCharArrayAndErrorCode("theData is null", 2);
        }
        return ret;
    }
    if (theData->dataLen < byteRange.location + byteRange.len) {
        if (NULL != errRefRef) {
            *errRefRef = QLDIP_C_ErrorCreateWithCharArrayAndErrorCode("theData does not has enough data len", 3);
        }
        return ret;
    }
    
    ret = __QLDIP_C_DIPPopInt64(theData->data, byteRange);
    
    return ret;
}

#pragma mark - </private/>

#pragma mark - <implementation/>





























#define INT64_TO_NET(val)   ((int64_t) ( \
(((int64_t) (val) &                       \
(int64_t) (0x00000000000000ffU)) << 56) | \
(((int64_t) (val) &                       \
(int64_t) (0x000000000000ff00U)) << 40) | \
(((int64_t) (val) &                       \
(int64_t) (0x0000000000ff0000U)) << 24) | \
(((int64_t) (val) &                       \
(int64_t) (0x00000000ff000000U)) <<  8) | \
(((int64_t) (val) &                       \
(int64_t) (0x000000ff00000000U)) >>  8) | \
(((int64_t) (val) &                       \
(int64_t) (0x0000ff0000000000U)) >> 24) | \
(((int64_t) (val) &                       \
(int64_t) (0x00ff000000000000U)) >> 40) | \
(((int64_t) (val) &                       \
(int64_t) (0xff00000000000000U)) >> 56)))

#define NET_TO_INT64(val)   ((int64_t) ( \
(((int64_t) (val) &                       \
(int64_t) (0x00000000000000ffU)) << 56) | \
(((int64_t) (val) &                       \
(int64_t) (0x000000000000ff00U)) << 40) | \
(((int64_t) (val) &                       \
(int64_t) (0x0000000000ff0000U)) << 24) | \
(((int64_t) (val) &                       \
(int64_t) (0x00000000ff000000U)) <<  8) | \
(((int64_t) (val) &                       \
(int64_t) (0x000000ff00000000U)) >>  8) | \
(((int64_t) (val) &                       \
(int64_t) (0x0000ff0000000000U)) >> 24) | \
(((int64_t) (val) &                       \
(int64_t) (0x00ff000000000000U)) >> 40) | \
(((int64_t) (val) &                       \
(int64_t) (0xff00000000000000U)) >> 56)))



// int64网络字节序转换为主机字节序
inline int64_t ntoh_int64(int64_t val)
{
    int64_t ret = val;
#if __BYTE_ORDER == __LITTLE_ENDIAN
    ret = (((int64_t)ntohl((unsigned long)val)) << 32) | ntohl((unsigned long)(val>>32));
#endif
    return ret;
}

// double网络字节序转换为主机字节序
inline double ntoh_double(double val)
{
    double ret = val;
#if __BYTE_ORDER == __LITTLE_ENDIAN
    int64_t tmp = ntoh_int64(*((int64_t*)&val));
    ret = *((double*)&tmp);
#endif
    return ret;
}


