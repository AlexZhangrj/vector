//
//  QLDIP_C_DIPSerializationObjRange.c
//  QLDIPWithC
//
//  Created by 蔡连凤 on 16/1/3.
//  Copyright © 2016年 ql. All rights reserved.
//

#include "QLDIP_C_DIPSerializationObjRange.h"

#include "QLDIP_C_DIPSerialization.h"


#include "QLDIP_C_DIPSerialization.h"
#include "QLDIP_C_DIP.h"

#include "QLDIP_C_Null.h"
#include "QLDIP_C_String.h"
#include "QLDIP_C_Data.h"
#include "QLDIP_C_Array.h"
#include "QLDIP_C_Map.h"



#pragma mark - <interface>




QLDIP_C_Range __QLDIP_C_DIPPresetSerializationObjectRange(void * theObj, uint32_t beginIdx);

#pragma mark - <interface/>
#pragma mark - <------------------------------------------------------------------------>
#pragma mark - <implementation>
#pragma mark - </public>



/*方法不对  应该先转型 再判断 有符号和无符号  有符号的首位肯定有值
 
QLDIP_C_Range __QLDIP_C_DIPPresetSerializationNumberValueRange(QLDIP_C_NumberRef theNumber, uint32_t beginIdx)
{
    QLDIP_C_Number_type numberType = theNumber->numberType;
    uint32_t valueLen = 0;
    switch (numberType) {
            case QLDIP_C_Number_type_Null:
        {
            
        }
            break;
            
        case QLDIP_C_Number_type_Int8:
        case QLDIP_C_Number_type_UInt8:
        {
            valueLen = 1;
        }
            break;
            
        case QLDIP_C_Number_type_Int16:
        case QLDIP_C_Number_type_UInt16:
        {
            int64_t tempNumber = theNumber->value.i64;
            int64_t ve = tempNumber >> 8;
            if (ve > 0) {
                valueLen = 2;
            }else {
                valueLen = 1;
            }
        }
            break;
            
        case QLDIP_C_Number_type_Int32:
        case QLDIP_C_Number_type_UInt32:
        {
            int64_t tempNumber = theNumber->value.i64;
            int64_t ve = tempNumber >> 24;

            if (ve > 0) {
                valueLen = 4;
            }else {
                ve = tempNumber >> 16;
                if (ve > 0) {
                    valueLen = 3;
                }else {
                    ve = tempNumber >> 8;
                    if (ve > 0) {
                        valueLen = 2;
                    }else {
                        valueLen = 1;
                    }
                }
            }
        }
            break;
        case QLDIP_C_Number_type_Int64:
        case QLDIP_C_Number_type_UInt64:
        {
            int64_t tempNumber = theNumber->value.i64;
            int64_t ve = tempNumber >> 56;
            
            if (ve > 0) {
                valueLen = 8;
            }else {
                ve = tempNumber >> 48;
                if (ve > 0) {
                    valueLen = 7;
                }else {
                    ve = tempNumber >> 40;
                    if (ve > 0) {
                        valueLen = 6;
                    }else {
                        ve = tempNumber >> 32;
                        if (ve > 0) {
                            valueLen = 5;
                        }else {
                            ve = tempNumber >> 24;
                            if (ve > 0) {
                                valueLen = 4;
                            }else {
                                ve = tempNumber >> 16;
                                if (ve > 0) {
                                    valueLen = 3;
                                }else {
                                    ve = tempNumber >> 8;
                                    if (ve > 0) {
                                        valueLen = 2;
                                    }else {
                                        valueLen = 1;
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
            break;
        case QLDIP_C_Number_type_Bool:
        {
            valueLen = 1;
        }
            break;
        case QLDIP_C_Number_type_Float:
        {
            valueLen = 4;
        }
            break;
        case QLDIP_C_Number_type_Double:
        {
            valueLen = 8;
        }
            break;
        default:
            break;
    }

    return QLDIP_C_RangeMake(beginIdx, valueLen);
}
 */

QLDIP_C_Range __QLDIP_C_DIPPresetSerializationNumberValueRange(QLDIP_C_NumberRef theNumber, uint32_t beginIdx)
{
    QLDIP_C_Number_type numberType = theNumber->numberType;
    uint32_t valueLen = 0;
    switch (numberType) {
        case QLDIP_C_Number_type_Null:
        {
            
        }
            break;
            
        case QLDIP_C_Number_type_Int8:
        case QLDIP_C_Number_type_UInt8:
        {
            valueLen = 1;
        }
            break;
            
        case QLDIP_C_Number_type_Int16:
        case QLDIP_C_Number_type_UInt16:
        {
            valueLen = 2;
        }
            break;
            
        case QLDIP_C_Number_type_Int32:
        case QLDIP_C_Number_type_UInt32:
        {
            valueLen = 4;
        }
            break;
            
        case QLDIP_C_Number_type_Int64:
        case QLDIP_C_Number_type_UInt64:
        {
            valueLen = 8;
        }
            break;
            
        case QLDIP_C_Number_type_Bool:
        {
            valueLen = 1;
        }
            break;
            
        case QLDIP_C_Number_type_Float:
        {
            valueLen = 4;
        }
            break;
            
        case QLDIP_C_Number_type_Double:
        {
            valueLen = 8;
        }
            break;
        default:
            break;
    }
    
    return QLDIP_C_RangeMake(beginIdx, valueLen);
}



QLDIP_C_Range __QLDIP_C_DIPPresetSerializationNullRange(QLDIP_C_NullRef theNull, uint32_t beginIdx)
{
    return QLDIP_C_RangeMake(beginIdx, 5);
}

QLDIP_C_Range __QLDIP_C_DIPPresetSerializationNumberRange(QLDIP_C_NumberRef theNumber, uint32_t beginIdx)
{
    uint32_t len = 0;
    len += 6;
    if (QLDIP_C_BoolValue_true == theNumber->base.hasValue) {
        QLDIP_C_Range valueRange = __QLDIP_C_DIPPresetSerializationNumberValueRange(theNumber, 0);
        len += valueRange.len;
    }
    return QLDIP_C_RangeMake(beginIdx, len);
}

QLDIP_C_Range __QLDIP_C_DIPPresetSerializationDataRange(QLDIP_C_DataRef theData, uint32_t beginIdx)
{
    uint32_t len = 0;
    len += 6;
    if (QLDIP_C_BoolValue_true == theData->base.hasValue) {
        uint32_t valueLen = theData->dataLen;
        len += valueLen;
    }
    return QLDIP_C_RangeMake(beginIdx, len);
}

QLDIP_C_Range __QLDIP_C_DIPPresetSerializationStringRange(QLDIP_C_StringRef theString, uint32_t beginIdx)
{
    uint32_t len = 0;
    len += 6;
    if (QLDIP_C_BoolValue_true == theString->base.hasValue) {
        uint32_t valueLen = 4 + theString->strLen;
        len += valueLen;
    }
    return QLDIP_C_RangeMake(beginIdx, len);
}

QLDIP_C_Range __QLDIP_C_DIPPresetSerializationArrayRange(QLDIP_C_ArrayRef theArray, uint32_t beginIdx)
{
    uint32_t len = 0;
    len += 6;
    if (QLDIP_C_BoolValue_true == theArray->base.hasValue) {
        uint32_t valueLen = 2;
        
        for (int i=0; i<theArray->count; i++) {
            QLDIP_C_Array_ItemRef tempItem = QLDIP_C_ArrayGetItemAtIndex(theArray, i);
            QLDIP_C_Range tempItemRange = __QLDIP_C_DIPPresetSerializationArrayItemRange(tempItem, 0);
            valueLen += tempItemRange.len;
        }
        
        len += valueLen;
    }
    return QLDIP_C_RangeMake(beginIdx, len);
}

QLDIP_C_Range __QLDIP_C_DIPPresetSerializationMapRange(QLDIP_C_MapRef theMap, uint32_t beginIdx)
{
    uint32_t len = 0;
    len += 6;
    if (QLDIP_C_BoolValue_true == theMap->base.hasValue) {
        uint32_t valueLen = 2;
        
        for (int i=0; i<theMap->count; i++) {
            QLDIP_C_Map_ItemRef tempItem = QLDIP_C_MapItemRefAtIndex(theMap, i);
            QLDIP_C_Range tempItemRange = __QLDIP_C_DIPPresetSerializationMapItemRange(tempItem, 0);
            valueLen += tempItemRange.len;
        }
        
        len += valueLen;
    }
    return QLDIP_C_RangeMake(beginIdx, len);
}

QLDIP_C_Range __QLDIP_C_DIPPresetSerializationArrayItemRange(QLDIP_C_Array_ItemRef theArrayItem, uint32_t beginIdx)
{
    uint32_t len = 0;
    len += 2 + 4;
    QLDIP_C_Range objRange = __QLDIP_C_DIPPresetSerializationObjectRange(theArrayItem->value, 0);
    len += objRange.len;
    return QLDIP_C_RangeMake(beginIdx, len);
}

QLDIP_C_Range __QLDIP_C_DIPPresetSerializationMapItemRange(QLDIP_C_Map_ItemRef theMapItem, uint32_t beginIdx)
{
    uint32_t len = 0;
    len += 4;//itemlen //keyLen valueLen + 4 + 4
    QLDIP_C_Range keyRange = __QLDIP_C_DIPPresetSerializationStringRange(theMapItem->keyRef, 0);
    len += keyRange.len;
    QLDIP_C_Range objRange = __QLDIP_C_DIPPresetSerializationObjectRange(theMapItem->valueRef, 0);
    len += objRange.len;
    return QLDIP_C_RangeMake(beginIdx, len);
}

#pragma mark - </public/>

#pragma mark - </private>

QLDIP_C_Range __QLDIP_C_DIPPresetSerializationObjectRange(void * theObj, uint32_t beginIdx)
{
    QLDIP_C_ObjRef obj = (QLDIP_C_ObjRef)theObj;
    switch (obj->base.objType) {
        case QLDIP_C_Object_type_Null:
        {
            return __QLDIP_C_DIPPresetSerializationNullRange((QLDIP_C_NullRef)theObj, beginIdx);
        }
            break;
        case QLDIP_C_Object_type_Number:
        {
            return __QLDIP_C_DIPPresetSerializationNumberRange((QLDIP_C_NumberRef)theObj, beginIdx);
        }
        case QLDIP_C_Object_type_Data:
        {
            return __QLDIP_C_DIPPresetSerializationDataRange((QLDIP_C_DataRef)theObj, beginIdx);
        }
        case QLDIP_C_Object_type_String:
        {
            return __QLDIP_C_DIPPresetSerializationStringRange((QLDIP_C_StringRef)theObj, beginIdx);
        }
        case QLDIP_C_Object_type_Array:
        {
            return __QLDIP_C_DIPPresetSerializationArrayRange((QLDIP_C_ArrayRef)theObj, beginIdx);
        }
        case QLDIP_C_Object_type_Map:
        {
            return __QLDIP_C_DIPPresetSerializationMapRange((QLDIP_C_MapRef)theObj, beginIdx);
        }
        default:
        {
            return QLDIP_C_RangeMake(beginIdx, 0);
        }
            break;
    }
}

#pragma mark - </private/>
#pragma mark - <implementation/>




