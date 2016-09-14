//
//  QLDIP_C_Map.c
//  QLDIPWithC
//
//  Created by prsoft_mac01 on 15/12/22.
//  Copyright © 2015年 ql. All rights reserved.
//

#include "QLDIP_C_Map.h"
#include "QLDIP_C_Base.h"
#include <string.h>
#include "QLDIP_C_String.h"


QLDIP_C_Map_ItemRef __QLDIP_C_MapCreateItemRef();

QLDIP_C_Map_Item __QLDIP_C_MapCreateEmptyItem();

QLDIP_C_Map_Item __QLDIP_C_MapItemAtIndex(QLDIP_C_MapRef theMap, uint32_t index);
QLDIP_C_Map_ItemRef __QLDIP_C_MapItemRefAtIndex(QLDIP_C_MapRef theMap, uint32_t index);



QLDIP_C_MapRef QLDIP_C_MapCreate()
{
    QLDIP_C_MapRef ret = NULL;
    ret = (QLDIP_C_Map *)QLDIP_C_allocWithInit(sizeof(QLDIP_C_Map));
    if (ret) {
        ret->base.objType = QLDIP_C_Object_type_Map;
        ret->base.hasValue = QLDIP_C_BoolValue_true;
        ret->base.refcount = 1;
        ret->count = 0;
        ret->deqCount = 1;
        ret->store = (QLDIP_C_Map_DequeRef)QLDIP_C_allocWithInit(sizeof(QLDIP_C_Map_Deque));
    }else {
        printf("%s 申请内存失败", __func__);
    }
    return ret;
}

void QLDIP_C_MapDealloc(QLDIP_C_MapRef theMap)
{
    if (NULL == theMap) {
        return;
    }

    QLDIP_C_Map_DequeRef headDeq = theMap->store;
    
    for (int i=0; i<theMap->count; i++) {
        QLDIP_C_Map_ItemRef tempItem = NULL;
        tempItem = __QLDIP_C_MapItemRefAtIndex(theMap, i);
        if (QLDIP_C_BoolValue_false == tempItem->empty) {
            QLDIP_C_Release(tempItem->keyRef);
            QLDIP_C_Release(tempItem->valueRef);
        }
        tempItem->keyRef = NULL;
        tempItem->valueRef = NULL;
        tempItem->hashCode = 0;
        tempItem->empty = QLDIP_C_BoolValue_true;
    }
    
    QLDIP_C_Dealloc(theMap);
    
    QLDIP_C_Map_DequeRef tempDeq = headDeq;
    while (NULL != tempDeq) {
        QLDIP_C_Map_DequeRef tempDeq2 = tempDeq->next;
        QLDIP_C_Dealloc(tempDeq);
        tempDeq = tempDeq2;
    }
    
}


QLDIP_C_Map_ItemRef __QLDIP_C_MapCreateItemRef()
{
    QLDIP_C_Map_ItemRef ret = NULL;
    ret = (QLDIP_C_Map_Item *)QLDIP_C_allocWithInit(sizeof(QLDIP_C_Map_Item));
    if (ret) {
        
    }else {
        printf("%s 申请内存失败", __func__);
    }
    return ret;
}

QLDIP_C_Map_Item __QLDIP_C_MapCreateEmptyItem()
{
    QLDIP_C_Map_Item ret;
    ret.empty = QLDIP_C_BoolValue_true;
    ret.hashCode = 0;
    ret.keyRef = NULL;
    ret.valueRef = NULL;
    
    return ret;
}


void QLDIP_C_MapSetValueWithCharArrayKey(QLDIP_C_MapRef theMap, void *value, const char *key)
{
    uint64_t hashCode = QLDIP_C_StrHashEightBit(key, strlen(key));
    
//    for (int i=0; i<theMap->count; i++) {
    int i=theMap->count + 1;
        QLDIP_C_Map_Item item = (theMap->store)->mapItems[i];
    item.hashCode = hashCode;
    item.keyRef = key;
    
        
//    }
    
    
}

QLDIP_C_Map_ItemRef QLDIP_C_MapItemRefAtIndex(QLDIP_C_MapRef theMap, uint32_t index)
{
    return __QLDIP_C_MapItemRefAtIndex(theMap, index);
}

QLDIP_C_Map_Item __QLDIP_C_MapItemAtIndex(QLDIP_C_MapRef theMap, uint32_t index)
{
    if (NULL == theMap) {
        return __QLDIP_C_MapCreateEmptyItem();
    }
    
    uint32_t deqIndex = index/1024;
    uint32_t itemIndex = index % 1024;
    

    QLDIP_C_Map_DequeRef headDeqRef = theMap->store;
    QLDIP_C_Map_DequeRef deqRef = headDeqRef;
    for (int i=0; i<deqIndex; i++) {
        deqRef = deqRef->next;
    }

    return deqRef->mapItems[itemIndex];
}

QLDIP_C_Map_ItemRef __QLDIP_C_MapItemRefAtIndex(QLDIP_C_MapRef theMap, uint32_t index)
{
    if (NULL == theMap) {
        return NULL;
    }
    
    uint32_t deqIndex = index/1024;
    uint32_t itemIndex = index % 1024;
    
    
    QLDIP_C_Map_DequeRef headDeqRef = theMap->store;
    QLDIP_C_Map_DequeRef deqRef = headDeqRef;
    for (int i=0; i<deqIndex; i++) {
        deqRef = deqRef->next;
    }
    
    return &(deqRef->mapItems[itemIndex]);
}

void __QLDIP_C_MapSetItemAtIndex(QLDIP_C_MapRef theMap, uint32_t index, QLDIP_C_Map_Item item)
{
    if (NULL == theMap) {
        return;
    }
    
    uint32_t deqIndex = index/1024;
    uint32_t itemIndex = index % 1024;
    
    
    QLDIP_C_Map_DequeRef headDeqRef = theMap->store;
    QLDIP_C_Map_DequeRef deqRef = headDeqRef;
    for (int i=0; i<deqIndex; i++) {
        deqRef = deqRef->next;
    }
    
    deqRef->mapItems[itemIndex] = item;
}

void __QLDIP_C_MapIsNeedAddDeq(QLDIP_C_MapRef theMap)
{
    if(NULL == theMap) {
        return;
    }
    QLDIP_C_Map_DequeRef headDeqRef = theMap->store;
    
    uint32_t needDeqCount = (theMap->count -1) / 1024 + 1;
    if (needDeqCount > theMap->deqCount) {
        QLDIP_C_Map_DequeRef tempDeq = headDeqRef;
        while (NULL != tempDeq->next) {
            tempDeq = tempDeq->next;
        }
        
        for (int k=0; k<needDeqCount - theMap->deqCount; k++) {
            QLDIP_C_Map_DequeRef tempD = (QLDIP_C_Map_DequeRef)QLDIP_C_allocWithInit(sizeof(QLDIP_C_Map_Deque));
            tempDeq->next = tempD;
            tempDeq = tempD;
        }
        theMap->deqCount = needDeqCount;
    }
}


void QLDIP_C_MapSetValueWithStringKey(QLDIP_C_MapRef theMap, void *value, QLDIP_C_StringRef key)
{
    if (NULL == theMap) {
        return;
    }
    
    if (NULL == key) {
        return;
    }
    
    if (QLDIP_C_BoolValue_false == key->base.hasValue) {
        return;
    }
    
    uint64_t hashCode = QLDIP_C_StrHashEightBit(QLDIP_C_StringCharArrayFromString(key), key->strLen);
    
//    strcmp
    
    //相同hashCode 的 item 索引区间
    QLDIP_C_Range range = QLDIP_C_RangeMake(0, 0);
    
    
    QLDIP_C_Map_DequeRef headDeqRef = theMap->store;
    
    int rangeLen = 0;
    
    if (theMap->count < 8) {
        //普通查找区间
        for (int i=0; i<theMap->count; i++) {
            QLDIP_C_Map_Item item = __QLDIP_C_MapItemAtIndex(theMap, i);
            if (item.hashCode == hashCode) {
                if (0 == rangeLen) {
                    range.location = i;
                    rangeLen = 1;
                }else {
                    rangeLen ++;
                }
            }
        }
        range.len = rangeLen;
    }else {
        int allCount = theMap->count;
        
        //二分查找 找range
        int start = 0;
        int end = allCount - 1;
        int mid = (start + end)/2;
        
        while(1)
        {
            QLDIP_C_Map_Item item = __QLDIP_C_MapItemAtIndex(theMap, mid);
            
            if (item.hashCode == hashCode) {
                
                QLDIP_C_Map_Item tempItem;;
                
                int tempIndex = mid;
                int tempLeftRangeLen = 0;
                while (tempIndex >= 0) {
                    tempItem = __QLDIP_C_MapItemAtIndex(theMap, mid);
                    if (tempItem.hashCode == hashCode) {
                        tempLeftRangeLen ++;
                    }else {
                        break;
                    }
                    tempIndex --;
                }
                range.location = tempIndex + 1;
                
                tempIndex = mid +1;
                while (tempIndex <= end) {
                    tempItem = __QLDIP_C_MapItemAtIndex(theMap, mid);
                    if (tempItem.hashCode == hashCode) {
                        tempLeftRangeLen ++;
                    }else {
                        break;
                    }
                    tempIndex ++;
                }
                range.len = tempLeftRangeLen;
                
                break;
            }else {
                if (item.hashCode < hashCode) {
                    if (mid + 1 > allCount - 1) {
                        range.location = mid + 1;
                        range.len = 0;
                        break;
                    }else {
                        QLDIP_C_Map_Item rightItem = __QLDIP_C_MapItemAtIndex(theMap, mid + 1);
                        if (rightItem.hashCode > hashCode) {
                            range.location = mid + 1;
                            range.len = 0;
                            break;
                        }else if (rightItem.hashCode == hashCode) {
                            mid = mid + 1;
                            continue;
                        }else {
                            start = mid + 1;
                        }
                    }
                }else {
                    if (mid - 1 < 0) {
                        range.location = 0;
                        range.len = 0;
                        break;
                    }else {
                        QLDIP_C_Map_Item leftItem = __QLDIP_C_MapItemAtIndex(theMap, mid - 1);
                        if (leftItem.hashCode < hashCode) {
                            range.location = mid;
                            range.len = 0;
                            break;
                        }else if (leftItem.hashCode == hashCode) {
                            mid = mid - 1;
                            continue;
                        }else {
                            end = mid - 1;
                        }
                    }
                }
            }
            mid = ( start + end )/2;
        }
    }

    
    //是否替换原来的
    int isReplace = 0;
    
    //获取到itemIndex;
    uint32_t itemIndex = 0;
    if (range.len == 0) {
        itemIndex = range.location;
    }else {
        itemIndex = range.location;
        for (int i=0; i<range.len; i++) {
            uint32_t tempIndex = range.location + i;
            QLDIP_C_Map_Item tempItem = __QLDIP_C_MapItemAtIndex(theMap, tempIndex);
            if (0 == strcmp(QLDIP_C_StringCharArrayFromString(tempItem.keyRef), QLDIP_C_StringCharArrayFromString(key))) {
                isReplace = 1;
                break;
            }
            itemIndex++;
        }
        
        
    }
    
    
    

    if (itemIndex == theMap->count) {
        theMap->count = theMap->count + 1;
        
        __QLDIP_C_MapIsNeedAddDeq(theMap);
        
        QLDIP_C_Map_Item item = __QLDIP_C_MapCreateEmptyItem();
        item.empty = QLDIP_C_BoolValue_false;
        item.hashCode = hashCode;
        QLDIP_C_Retain(key);
        QLDIP_C_Retain(value);
        item.keyRef = key;
        item.valueRef = value;
        __QLDIP_C_MapSetItemAtIndex(theMap, itemIndex, item);
    }else if(itemIndex < theMap->count){
        
        if (isReplace == 1) {
            //替换原来的
            
            QLDIP_C_Map_Item item = __QLDIP_C_MapItemAtIndex(theMap, itemIndex);
            QLDIP_C_Retain(key);
            QLDIP_C_Retain(value);
            QLDIP_C_Release(item.keyRef);
            QLDIP_C_Release(item.valueRef);

            item.keyRef = key;
            item.valueRef = value;
            __QLDIP_C_MapSetItemAtIndex(theMap, itemIndex, item);
        }else {
            //新添加一个
            uint64_t maxI = theMap->count - 1;
            
            
            theMap->count = theMap->count + 1;
            
            
            if (theMap->count == 1024) {
                printf("1024\n");
            }
            
            __QLDIP_C_MapIsNeedAddDeq(theMap);
            
            ;
            for (int64_t i=maxI; i>=itemIndex; i--) {
                __QLDIP_C_MapSetItemAtIndex(theMap, i+1, __QLDIP_C_MapItemAtIndex(theMap, i));
            }
            QLDIP_C_Map_Item item = __QLDIP_C_MapItemAtIndex(theMap, itemIndex);
            QLDIP_C_Retain(key);
            QLDIP_C_Retain(value);
            item.keyRef = key;
            item.valueRef = value;
            __QLDIP_C_MapSetItemAtIndex(theMap, itemIndex, item);
        }
    }else {
        printf("%s ：  发生了不可思议的错误\n", __func__);
    }
}






void * QLDIP_C_MapValueForStringKey(QLDIP_C_MapRef theMap, void *value, QLDIP_C_StringRef key)
{
    void * ret = NULL;
    if(NULL != theMap) {
    
    
    
    
    }
    return ret;
}

void * QLDIP_C_MapValueForCharArrayKey(QLDIP_C_MapRef theMap, void *value, const char *key)
{
    void * ret = NULL;
    if(NULL != theMap) {
        
        
        
        
    }
    return ret;
}


void QLDIP_C_MapReplaceValuesWithCharArrayKeys_(QLDIP_C_ArrayRef theArray, QLDIP_C_Range range, const void **newValues, const char **newKeys, uint32_t newCount)
{
    if (NULL == theArray) {
        return;
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
    
    //总元素减少
    if (isforward == 1) {
        int subCount = range.len - newCount;
        for (int j=range.location + range.len; j<theArray->count; j++) {
            __QLDIP_C_ArraySetValueAtIndex(theArray, j-subCount, __QLDIP_C_ArrayGetValueAtIndex(theArray, j));
        }
        for (int j=0; j<newCount; j++) {
            __QLDIP_C_ArraySetValueAtIndex(theArray, j+range.location, newValues[j]);
        }
        QLDIP_C_Range tempRange = QLDIP_C_RangeMake(range.location + newCount, subCount);
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
}

void QLDIP_C_MapReplaceValuesWithStringKeys(QLDIP_C_ArrayRef theArray, QLDIP_C_Range range, const void **newValues, const QLDIP_C_StringRef *newKeys, uint32_t newCount)
{
    if (NULL == theArray) {
        return;
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
    
    //总元素减少
    if (isforward == 1) {
        int subCount = range.len - newCount;
        for (int j=range.location + range.len; j<theArray->count; j++) {
            __QLDIP_C_ArraySetValueAtIndex(theArray, j-subCount, __QLDIP_C_ArrayGetValueAtIndex(theArray, j));
        }
        for (int j=0; j<newCount; j++) {
            __QLDIP_C_ArraySetValueAtIndex(theArray, j+range.location, newValues[j]);
        }
        QLDIP_C_Range tempRange = QLDIP_C_RangeMake(range.location + newCount, subCount);
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
}



//--------------------------------------------------------
/*
QLDIP_C_ArrayRef QLDIP_C_ArrayCreate()
{
    QLDIP_C_ArrayRef ret = NULL;
    ret = (QLDIP_C_ArrayRef)QLDIP_C_allocWithInit(sizeof(QLDIP_C_Array));
    if (ret) {
        ret->base.hasValue = QLDIP_C_BoolValue_true;
        ret->base.refcount = 1;
        ret->count = 0;
        ret->deqCount = 1;
        ret->store = (QLDIP_C_Array_DequeRef)malloc(sizeof(QLDIP_C_Array_Deque));
    }else {
        printf("%s 申请内存失败", __func__);
    }
    return ret;
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
    
    return tempDeque->element[listIndex];
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
    
    return tempDeque->element[listIndex];
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
    
    tempDeque->element[listIndex] = (void *)value;
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


void QLDIP_C_ArrayReplaceValues(QLDIP_C_ArrayRef theArray, QLDIP_C_Range range, const void **newValues, uint32_t newCount)
{
    if (NULL == theArray) {
        return;
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
    
    //总元素减少
    if (isforward == 1) {
        int subCount = range.len - newCount;
        for (int j=range.location + range.len; j<theArray->count; j++) {
            __QLDIP_C_ArraySetValueAtIndex(theArray, j-subCount, __QLDIP_C_ArrayGetValueAtIndex(theArray, j));
        }
        for (int j=0; j<newCount; j++) {
            __QLDIP_C_ArraySetValueAtIndex(theArray, j+range.location, newValues[j]);
        }
        QLDIP_C_Range tempRange = QLDIP_C_RangeMake(range.location + newCount, subCount);
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
            lastDeq->next = (QLDIP_C_Array_DequeRef)malloc(sizeof(QLDIP_C_Array_Deque));
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

void __QLDIP_C_ArraySetEmpty(QLDIP_C_ArrayRef theArray, QLDIP_C_Range range)
{
    QLDIP_C_Array_DequeRef headDeque = theArray->store;
    int currentDeqCount = (theArray->count - 1) / 1024 + 1;
    for (int i=range.location; i<range.location + range.len; i++) {
        __QLDIP_C_ArraySetValueAtIndex(theArray, i, NULL);
    }
}
*/















