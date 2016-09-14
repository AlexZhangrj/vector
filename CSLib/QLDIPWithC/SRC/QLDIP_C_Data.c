//
//  QLDIP_C_Data.c
//  QLDIPWithC
//
//  Created by prsoft_mac01 on 15/12/28.
//  Copyright © 2015年 ql. All rights reserved.
//

#include "QLDIP_C_Data.h"
#include <string.h>
#include "QLDIP_C_Base.h"




QLDIP_C_DataRef QLDIP_C_DataCreate()
{
    QLDIP_C_DataRef dataRef = NULL;
    dataRef = (QLDIP_C_DataRef)QLDIP_C_allocWithInit(sizeof(QLDIP_C_Data));
    
    if(NULL == dataRef) {
        return NULL;
    }
    
    dataRef->base.objType = QLDIP_C_Object_type_Data;
    dataRef->base.refcount = 1;
    dataRef->base.hasValue = QLDIP_C_BoolValue_false;
    
    return dataRef;
}

QLDIP_C_DataRef QLDIP_C_DataCreateWithByteArray(const QLDIP_C_Byte * cData, uint32_t cDataLen)
{
    QLDIP_C_DataRef dataRef = QLDIP_C_DataCreate();
    if (NULL == dataRef) {
        return NULL;
    }
    
    QLDIP_C_DataSetContentByteArray(dataRef, cData, cDataLen);
    
    return dataRef;
}

QLDIP_C_DataRef QLDIP_C_DataCreateWithExpectedBufferLen(uint32_t bufferLen)
{
    QLDIP_C_DataRef dataRef = QLDIP_C_DataCreate();
    if (NULL == dataRef) {
        return NULL;
    }
    
    QLDIP_C_BoolValue hasValue = dataRef->base.hasValue;
    if (QLDIP_C_BoolValue_true == hasValue) {
        QLDIP_C_Dealloc(dataRef->data);
    }
    
    dataRef->base.hasValue = QLDIP_C_BoolValue_true;
    dataRef->data = NULL;
    dataRef->dataLen = 0;
    dataRef->bufferLen = bufferLen;
    QLDIP_C_Byte * dataByte = (QLDIP_C_Byte *)QLDIP_C_allocWithInit(sizeof(QLDIP_C_Byte) * (bufferLen));
    dataRef->data = dataByte;

    return dataRef;
}

QLDIP_C_BoolValue QLDIP_C_DataResetExpectedBufferLen(QLDIP_C_DataRef theData, uint32_t bufferLen)
{
    if (NULL == theData) {
        return QLDIP_C_BoolValue_false;
    }
    
    if (theData->dataLen > bufferLen) {
        return QLDIP_C_BoolValue_false;
    }
    
    uint32_t expectedBufferLen = bufferLen;
    
    if (expectedBufferLen > theData->bufferLen) {
        uint32_t needBufferLen = 32;
        while (needBufferLen < expectedBufferLen) {
            needBufferLen *= 2;
        }
        if(QLDIP_C_BoolValue_false == theData->base.hasValue) {
            QLDIP_C_Byte *createdByte = QLDIP_C_allocWithInit(sizeof(QLDIP_C_Byte) * needBufferLen);
            theData->data = createdByte;
            theData->dataLen = 0;
            theData->bufferLen = needBufferLen;
            theData->base.hasValue = QLDIP_C_BoolValue_true;
        }else {
            QLDIP_C_Byte *createdByte = QLDIP_C_allocWithInit(sizeof(QLDIP_C_Byte) * needBufferLen);
            QLDIP_C_Byte *oldByte = theData->data;
            memcpy(createdByte, oldByte, theData->dataLen);
            theData->data = createdByte;
            QLDIP_C_Dealloc(oldByte);
            theData->bufferLen = needBufferLen;
        }
    }

    return QLDIP_C_BoolValue_true;
}


QLDIP_C_DataRef QLDIP_C_DataCopy(QLDIP_C_DataRef theData)
{
    if (NULL == theData) {
        return NULL;
    }
    QLDIP_C_DataRef retData = QLDIP_C_DataCreateWithExpectedBufferLen(theData->bufferLen);
    retData->base = theData->base;
    retData->base.refcount = 1;
    retData->dataLen = theData->dataLen;
    memcpy(retData->data, theData->data, theData->bufferLen);
    
    return retData;
}


void QLDIP_C_DataSetContentByteArray(QLDIP_C_DataRef theData, const QLDIP_C_Byte * cData, uint32_t cDataLen)
{
    QLDIP_C_DataRef dataRef = NULL;
    if (NULL == theData) {
        return;
    }
    dataRef = theData;

    QLDIP_C_BoolValue hasValue = dataRef->base.hasValue;
    if (QLDIP_C_BoolValue_true == hasValue) {
        QLDIP_C_Dealloc(dataRef->data);
    }

    if (NULL == cData) {
        dataRef->base.hasValue = QLDIP_C_BoolValue_false;
        dataRef->data = NULL;
        dataRef->dataLen = 0;
        dataRef->bufferLen = 0;
    }else {
        dataRef->base.hasValue = QLDIP_C_BoolValue_true;
        dataRef->dataLen = cDataLen;
        dataRef->bufferLen= cDataLen;
        QLDIP_C_Byte * dataByte = (QLDIP_C_Byte *)QLDIP_C_allocWithInit(sizeof(QLDIP_C_Byte) * (cDataLen));
        memcpy(dataByte, cData, cDataLen);
        dataRef->data = dataByte;
    }
    
    return;
}

void QLDIP_C_DataDealloc(QLDIP_C_DataRef theData)
{
    if (NULL == theData) {
        return;
    }
    
    if (QLDIP_C_BoolValue_true ==  theData->base.hasValue) {
        QLDIP_C_Dealloc(theData->data);
    }
    
    QLDIP_C_Dealloc(theData);
}


const QLDIP_C_Byte * QLDIP_C_DataByteArrayFromData(QLDIP_C_DataRef theData, uint32_t *retLen)
{
    if (NULL == theData) {
        return NULL;
    }
    if (NULL != retLen) {
        *retLen = theData->dataLen;
    }
    return theData->data;
}

//return a new malloc pointer without memory Management
const QLDIP_C_Byte * QLDIP_C_DataUnsafeByteArrayFromDataByCopy(QLDIP_C_DataRef theData, uint32_t *retLen)
{
    if (NULL == theData) {
        if (NULL != retLen) {
            *retLen = 0;
        }
        return NULL;
    }

    if (NULL != retLen) {
        *retLen = theData->dataLen;
    }
    QLDIP_C_Byte *retByte = QLDIP_C_malloc(theData->dataLen);

    memcpy(retByte, theData->data, theData->dataLen);
    return retByte;
}





#pragma mark - <interface>
QLDIP_C_BoolValue __QLDIP_C_DataReplaceByteWithRange(QLDIP_C_DataRef theData, QLDIP_C_Range range, const QLDIP_C_Byte *byte, uint32_t byteLen);
#pragma mark - <interface/>
#pragma mark - <------------------------------------------------------------------------>
#pragma mark - <implementation>
#pragma mark - </public>

QLDIP_C_BoolValue QLDIP_C_DataReplaceDataWithRange(QLDIP_C_DataRef theData, QLDIP_C_Range range, QLDIP_C_DataRef subData)
{
    QLDIP_C_BoolValue ret = QLDIP_C_BoolValue_false;
    if (NULL != subData && QLDIP_C_BoolValue_false != subData->base.hasValue) {
        ret = QLDIP_C_DataReplaceByteWithRange(theData, range, subData->data, subData->dataLen);
    }else {
        ret = QLDIP_C_DataReplaceByteWithRange(theData, range, NULL, 0);
    }
    return ret;
}

QLDIP_C_BoolValue QLDIP_C_DataReplaceByteWithRange(QLDIP_C_DataRef theData, QLDIP_C_Range range, const QLDIP_C_Byte *byte, uint32_t byteLen)
{
    return __QLDIP_C_DataReplaceByteWithRange(theData, range, byte, byteLen);
}

QLDIP_C_BoolValue QLDIP_C_DataAppendByte(QLDIP_C_DataRef theData, const QLDIP_C_Byte *byte, uint32_t byteLen)
{
    return __QLDIP_C_DataReplaceByteWithRange(theData, QLDIP_C_RangeMake(theData->dataLen, 0), byte, byteLen);
}

QLDIP_C_BoolValue QLDIP_C_DataAppendData(QLDIP_C_DataRef theData, QLDIP_C_DataRef subData)
{
    return QLDIP_C_DataReplaceDataWithRange(theData, QLDIP_C_RangeMake(theData->dataLen, 0), subData);
}

#pragma mark - </public/>

#pragma mark - </private>

QLDIP_C_BoolValue __QLDIP_C_DataReplaceByteWithRange(QLDIP_C_DataRef theData, QLDIP_C_Range range, const QLDIP_C_Byte *byte, uint32_t byteLen)
{
    if (NULL == theData) {
        return QLDIP_C_BoolValue_false;
    }
    
    if (range.location + range.len > theData->dataLen) {
        return QLDIP_C_BoolValue_false;
    }
    
    uint32_t expectedBufferLen = theData->dataLen - range.len + byteLen;
    
    
    
    if (expectedBufferLen > theData->bufferLen) {
        uint32_t needBufferLen = 32;
        while (needBufferLen < expectedBufferLen) {
            needBufferLen *= 2;
        }
        if(QLDIP_C_BoolValue_false == theData->base.hasValue) {
            QLDIP_C_Byte *createdByte = QLDIP_C_allocWithInit(sizeof(QLDIP_C_Byte) * needBufferLen);
            theData->data = createdByte;
            theData->dataLen = 0;
            theData->bufferLen = needBufferLen;
            theData->base.hasValue = QLDIP_C_BoolValue_true;
        }else {
            QLDIP_C_Byte *createdByte = QLDIP_C_allocWithInit(sizeof(QLDIP_C_Byte) * needBufferLen);
            QLDIP_C_Byte *oldByte = theData->data;
            memcpy(createdByte, oldByte, theData->dataLen);
            theData->data = createdByte;
            QLDIP_C_Dealloc(oldByte);
            theData->bufferLen = needBufferLen;
        }
    }
    
    
    int isforward = 1;
    if (range.len < byteLen) {
        isforward = 0;
    }
    
    QLDIP_C_Byte *currentByte = theData->data;
    
    //数据减少 或者不变
    if (isforward == 1) {
        int subCount = range.len - byteLen;
        //迁移
        for (int j=range.location + range.len; j<theData->dataLen; j++) {
            currentByte[j-subCount] = currentByte[j];
        }
        
        //置空
        for (int j=theData->dataLen + subCount; j<theData->dataLen; j++) {
            currentByte[j] = 0;
        }
        
        //新data 赋值给当前data 的range部分
        for (int j=0; j<byteLen; j++) {
            currentByte[j+range.location] = byte[j];
        }
        theData->dataLen = theData->dataLen - subCount;
    }else {
        //数据增加
        int addCount = byteLen - range.len;
        
        //迁移
        if (theData->dataLen > 0) {
            int maxJ = range.location + range.len;
            for (int j=theData->dataLen-1; j>=maxJ; j--) {
                currentByte[j+addCount] = currentByte[j];
            }
        }
        
        //新data 赋值给当前data 的range部分
        for (int j=0; j<byteLen; j++) {
            currentByte[j+range.location] = byte[j];
        }
        
        theData->dataLen = theData->dataLen + addCount;
    }
    return QLDIP_C_BoolValue_true;
}
#pragma mark - </private/>
#pragma mark - <implementation/>





