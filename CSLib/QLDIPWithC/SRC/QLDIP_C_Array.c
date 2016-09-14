//
//  QLDIP_C_Array.c
//  QLDIPWithC
//
//  Created by prsoft_mac01 on 15/12/22.
//  Copyright © 2015年 ql. All rights reserved.
//

#include "QLDIP_C_Array.h"
#include "QLDIP_C_Base.h"

void __QLDIP_C_ArraySetEmpty(QLDIP_C_ArrayRef theArray, QLDIP_C_Range range);
const void *__QLDIP_C_ArrayGetValueAtIndex(QLDIP_C_ArrayRef theArray, uint32_t idx);
QLDIP_C_Array_Item *__QLDIP_C_ArrayGetItemAtIndex(QLDIP_C_ArrayRef theArray, uint32_t idx);
void __QLDIP_C_ArraySetValueAtIndex(QLDIP_C_ArrayRef theArray, uint32_t idx, const void *value);

QLDIP_C_ArrayRef QLDIP_C_ArrayCreate()
{
    QLDIP_C_ArrayRef ret = NULL;
    ret = (QLDIP_C_ArrayRef)QLDIP_C_allocWithInit(sizeof(QLDIP_C_Array));
    if (ret) {
        ret->base.hasValue = QLDIP_C_BoolValue_true;
        ret->base.objType = QLDIP_C_Object_type_Array;
        ret->base.refcount = 1;
        ret->count = 0;
        ret->deqCount = 1;
        ret->store = (QLDIP_C_Array_DequeRef)QLDIP_C_allocWithInit(sizeof(QLDIP_C_Array_Deque));
    }else {
        printf("%s 申请内存失败", __func__);
    }
    return ret;
}

void QLDIP_C_ArrayDealloc(QLDIP_C_ArrayRef theArray)
{
    if (NULL == theArray) {
        return;
    }
    
    QLDIP_C_Array_DequeRef headDeq = theArray->store;
    
    for (int i=0; i<theArray->count; i++) {
        const void * tempAValue = NULL;
        tempAValue = __QLDIP_C_ArrayGetValueAtIndex(theArray, i);
        QLDIP_C_Release(tempAValue);
        __QLDIP_C_ArraySetValueAtIndex(theArray, i, NULL);
    }
    
    QLDIP_C_Dealloc(theArray);
    
    QLDIP_C_Array_DequeRef tempDeq = headDeq;
    while (NULL != tempDeq) {
        QLDIP_C_Array_DequeRef tempDeq2 = tempDeq->next;
        QLDIP_C_Dealloc(tempDeq);
        tempDeq = tempDeq2;
    }
    
    
}



uint32_t QLDIP_C_ArrayGetCount(QLDIP_C_ArrayRef theArray)
{
    if (NULL == theArray) {
        return 0;
    }
    return theArray->count;
}


uint32_t QLDIP_C_ArrayGetIndexOfValue(QLDIP_C_ArrayRef theArray, QLDIP_C_Range range, const void *value);


QLDIP_C_BoolValue QLDIP_C_ArrayContainsValue(QLDIP_C_ArrayRef theArray, QLDIP_C_Range range, const void *value);


const void *QLDIP_C_ArrayGetValueAtIndex(QLDIP_C_ArrayRef theArray, uint32_t idx)
{
    if (NULL == theArray) {
        return NULL;
    }
    if (idx >= theArray->count) {
        return NULL;
    }
    
    QLDIP_C_Array_DequeRef headDeque = theArray->store;
    
    int deqIndex = idx / 1024;
    int listIndex = idx % 1024;
    
    QLDIP_C_Array_DequeRef tempDeque = headDeque;
    for (int i=1; i<=deqIndex; i++) {
        tempDeque = tempDeque->next;
    }
    
    return (tempDeque->items[listIndex]).value;
}

QLDIP_C_Array_ItemRef QLDIP_C_ArrayGetItemAtIndex(QLDIP_C_ArrayRef theArray, uint32_t idx)
{
    return __QLDIP_C_ArrayGetItemAtIndex(theArray, idx);
}

const void *__QLDIP_C_ArrayGetValueAtIndex(QLDIP_C_ArrayRef theArray, uint32_t idx)
{
    if (NULL == theArray) {
        return NULL;
    }
    
    QLDIP_C_Array_DequeRef headDeque = theArray->store;
    
    int deqIndex = idx / 1024;
    int listIndex = idx % 1024;
    
    QLDIP_C_Array_DequeRef tempDeque = headDeque;
    for (int i=1; i<=deqIndex; i++) {
        tempDeque = tempDeque->next;
    }
    
    return (tempDeque->items[listIndex]).value;
}

QLDIP_C_Array_Item *__QLDIP_C_ArrayGetItemAtIndex(QLDIP_C_ArrayRef theArray, uint32_t idx)
{
    if (NULL == theArray) {
        return NULL;
    }
    
    QLDIP_C_Array_DequeRef headDeque = theArray->store;
    
    int deqIndex = idx / 1024;
    int listIndex = idx % 1024;
    
    QLDIP_C_Array_DequeRef tempDeque = headDeque;
    for (int i=1; i<=deqIndex; i++) {
        tempDeque = tempDeque->next;
    }
    
    return &(tempDeque->items[listIndex]);
}

void __QLDIP_C_ArraySetValueAtIndex(QLDIP_C_ArrayRef theArray, uint32_t idx, const void *value)
{
    if (NULL == theArray) {
        return;
    }
    
    QLDIP_C_Array_DequeRef headDeque = theArray->store;
    
    int deqIndex = idx / 1024;
    int listIndex = idx % 1024;
    
    QLDIP_C_Array_DequeRef tempDeque = headDeque;
    for (int i=1; i<=deqIndex; i++) {
        tempDeque = tempDeque->next;
    }
    
    QLDIP_C_Array_ItemRef tempItem = &(tempDeque->items[listIndex]);
    
    tempItem->value = (void *)value;
}

//void QLDIP_C_ArrayGetValues(QLDIP_C_ArrayRef theArray, CFRange range, const void **values);

//CFIndex CFArrayGetFirstIndexOfValue(CFArrayRef theArray, CFRange range, const void *value);

//CFIndex CFArrayGetLastIndexOfValue(CFArrayRef theArray, CFRange range, const void *value);

void QLDIP_C_ArrayAppendValue(QLDIP_C_ArrayRef theArray, const void *value)
{
    if (NULL == theArray) {
        return;
    }
    
    QLDIP_C_ArrayReplaceValues(theArray, QLDIP_C_RangeMake(theArray->count, 0), &value, 1);
}

void QLDIP_C_ArrayInsertValueAtIndex(QLDIP_C_ArrayRef theArray, uint32_t idx, const void *value)
{
    if (NULL == theArray) {
        return;
    }
    
    QLDIP_C_ArrayReplaceValues(theArray, QLDIP_C_RangeMake(idx, 0), &value, 1);
}

void QLDIP_C_ArrayRemoveValueAtIndex(QLDIP_C_ArrayRef theArray, uint32_t idx)
{
    if (NULL == theArray) {
        return;
    }
    
    QLDIP_C_ArrayReplaceValues(theArray, QLDIP_C_RangeMake(idx, 1), NULL, 0);
}

void QLDIP_C_ArrayRemoveAllValues(QLDIP_C_ArrayRef theArray)
{
    if (NULL == theArray) {
        return;
    }
    
    QLDIP_C_ArrayReplaceValues(theArray, QLDIP_C_RangeMake(0, theArray->count), NULL, 0);
}

void QLDIP_C_ArrayAppendObject(QLDIP_C_ArrayRef theArray, const void *newValue)
{
    if (NULL == theArray) {
        return;
    }
    QLDIP_C_ArrayReplaceValues(theArray, QLDIP_C_RangeMake(theArray->count, 0), &newValue, 1);
}

void QLDIP_C_ArrayRemoveObjectAtIndex(QLDIP_C_ArrayRef theArray, uint32_t idx)
{
    if (NULL == theArray) {
        return;
    }
    QLDIP_C_ArrayReplaceValues(theArray, QLDIP_C_RangeMake(idx, 1), NULL, 0);
}

QLDIP_C_BoolValue QLDIP_C_ArrayReplaceValues(QLDIP_C_ArrayRef theArray, QLDIP_C_Range range, const void **newValues, uint32_t newCount)
{
    if (NULL == theArray) {
        return QLDIP_C_BoolValue_false;
    }
    
    if (range.location + range.len > theArray->count) {
        return QLDIP_C_BoolValue_false;
    }
    
    
    QLDIP_C_Array_DequeRef headDeq = theArray->store;

    for (int i=range.location; i<range.location + range.len; i++) {
        if (i < theArray->count) {
            QLDIP_C_Release(__QLDIP_C_ArrayGetValueAtIndex(theArray, i));
        }
    }
    for (int j=0; j<newCount; j++) {
        QLDIP_C_Retain(newValues[j]);
    }
    
    int isforward = 1;
    if (range.len < newCount) {
        isforward = 0;
    }
    
    //总元素减少 或者不变
    if (isforward == 1) {
        int subCount = range.len - newCount;
        
        //迁移
        for (int j=range.location + range.len; j<theArray->count; j++) {
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
            lastDeq->next = (QLDIP_C_Array_DequeRef)QLDIP_C_allocWithInit(sizeof(QLDIP_C_Array_Deque));
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
    return QLDIP_C_BoolValue_true;
}




void __QLDIP_C_ArraySetEmpty(QLDIP_C_ArrayRef theArray, QLDIP_C_Range range)
{
    QLDIP_C_Array_DequeRef headDeque = theArray->store;
    int currentDeqCount = (theArray->count - 1) / 1024 + 1;
    for (int i=range.location; i<range.location + range.len; i++) {
        __QLDIP_C_ArraySetValueAtIndex(theArray, i, NULL);
    }
}
















