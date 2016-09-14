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


const QLDIP_C_Byte * QLDIP_C_DataByteArrayFromData(QLDIP_C_DataRef theData, uint32_t *retLen);

//return a new malloc pointer without memory Management
const QLDIP_C_Byte * QLDIP_C_DataUnsafeByteArrayFromDataByCopy(QLDIP_C_DataRef theData, uint32_t *retLen);





#pragma mark - <interface>
void __QLDIP_C_DataReplaceByteWithRange(QLDIP_C_DataRef theData, QLDIP_C_Range range, const QLDIP_C_Byte *byte, uint32_t byteLen);
#pragma mark - <interface/>
#pragma mark - <------------------------------------------------------------------------>
#pragma mark - <implementation>
#pragma mark - </public>
void QLDIP_C_DataReplaceByteWithRange(QLDIP_C_DataRef theData, QLDIP_C_Range range, const QLDIP_C_Byte *byte, uint32_t byteLen)
{
    __QLDIP_C_DataReplaceByteWithRange(theData, range, byte, byteLen);
    
    
}
#pragma mark - </public/>

#pragma mark - </private>

void __QLDIP_C_DataReplaceByteWithRange(QLDIP_C_DataRef theData, QLDIP_C_Range range, const QLDIP_C_Byte *byte, uint32_t byteLen)
{
    if (NULL == theData) {
        return;
    }
    
//    QLDIP_C_Array_DequeRef headDeq = theArray->store;
    
    
    int isforward = 1;
    if (range.len < byteLen) {
        isforward = 0;
    }
    
    //数据减少 或者不变
    if (isforward == 1) {
        int subCount = range.len - byteLen;

    }else {
        //数据增加

    }
    
    //总元素减少 或者不变
    if (isforward == 1) {
        int subCount = range.len - byteLen;
        
        //迁移
        for (int j=range.location + range.len; j<theData->dataLen; j++) {
            __QLDIP_C_ArraySetValueAtIndex(theArray, j-subCount, __QLDIP_C_ArrayGetValueAtIndex(theArray, j));
        }
        
        for (int j=0; j<newCount; j++) {
            __QLDIP_C_ArraySetValueAtIndex(theArray, j+range.location, newValues[j]);
        }
        //        QLDIP_C_Range tempRange = QLDIP_C_RangeMake(range.location + newCount, subCount);
        QLDIP_C_Range tempRange = QLDIP_C_RangeMake(theArray->count - subCount, subCount);
        __QLDIP_C_ArraySetEmpty(theArray, tempRange);
        theArray->count = theArray->count - subCount;
    }else {
        //总元素增加
        int addCount = newCount - range.len;
        
        int cuDeqCount = theArray->deqCount;
        int needDeqCount = (theArray->count - 1 + addCount) / 1024 + 1;
        int deqAddCount = needDeqCount - cuDeqCount;
        QLDIP_C_Array_DequeRef lastDeq = headDeq;
        while (lastDeq->next) {
            lastDeq = lastDeq->next;
        }
        for (int k=0; k<deqAddCount; k++) {
            lastDeq->next = (QLDIP_C_Array_DequeRef)QLDIP_C_malloc(sizeof(QLDIP_C_Array_Deque));
            lastDeq = lastDeq->next;
        }
        
        if (theArray->count > 0) {
            int maxJ = range.location + range.len;
            for (int j=theArray->count-1; j>=maxJ; j--) {
                __QLDIP_C_ArraySetValueAtIndex(theArray, j+addCount, __QLDIP_C_ArrayGetValueAtIndex(theArray, j));
            }
        }
        
        for (int j=0; j<newCount; j++) {
            __QLDIP_C_ArraySetValueAtIndex(theArray, j+range.location, newValues[j]);
        }
        
        theArray->count = theArray->count + addCount;
        theArray->deqCount = needDeqCount;
    }
    
    
}
#pragma mark - </private/>
#pragma mark - <implementation/>





