//
//  QLDIP_C_DIPSerialization.c
//  QLDIPWithC
//
//  Created by 蔡连凤 on 16/1/1.
//  Copyright © 2016年 ql. All rights reserved.
//

#include "QLDIP_C_DIPSerialization.h"
#include "QLDIP_C_DIP.h"

#include "QLDIP_C_DIPSerializationObjRange.h"

#include "QLDIP_C_Null.h"
#include "QLDIP_C_Number.h"
#include "QLDIP_C_String.h"
#include "QLDIP_C_Array.h"
#include "QLDIP_C_Map.h"




#pragma mark - <interface>
QLDIP_C_BoolValue __QLDIP_C_ObjSerializationBaseInit(__QLDIP_C_ObjSerializationBase *baseRef);


__QLDIP_C_NullSerialization __QLDIP_C_DIPPresetSerializationNullToByte(QLDIP_C_NullRef theNull);

__QLDIP_C_NumberSerialization __QLDIP_C_DIPPresetSerializationNumberToByte(QLDIP_C_NumberRef theNumber);

__QLDIP_C_DataSerialization __QLDIP_C_DIPPresetSerializationDataToByte(QLDIP_C_DataRef theData);

__QLDIP_C_StringSerialization __QLDIP_C_DIPPresetSerializationStringToByte(QLDIP_C_StringRef theString);



QLDIP_C_NullRef __QLDIP_C_DIPSerializationByteToNull(QLDIP_C_Byte *readByte, __QLDIP_C_ObjHeader header);

void __QLDIP_C_DIPSerializationNumberValueToByte(QLDIP_C_NumberRef theNumber, QLDIP_C_Byte *putInByte, QLDIP_C_Range putInRange);
QLDIP_C_NumberRef __QLDIP_C_DIPSerializationByteToNumberWithByte(QLDIP_C_Byte *readByte, __QLDIP_C_NumberSerialization numberSrlt);



#pragma mark - <interface/>
#pragma mark - <------------------------------------------------------------------------>
#pragma mark - <implementation>
#pragma mark - </public>
__QLDIP_C_NumberSerialization __QLDIP_C_NumberSerializationMakeInit()
{
    __QLDIP_C_NumberSerialization retNS;
    
    __QLDIP_C_ObjSerializationBaseInit(&(retNS.base));
    
    return retNS;
}




QLDIP_C_ObjRef __QLDIP_C_DIPSerializationByteToObj(QLDIP_C_Byte *readByte, QLDIP_C_Range objByteRange)
{
    uint32_t readBeginIdx = objByteRange.location;
    QLDIP_C_Byte *byte = readByte;
    byte += readBeginIdx;
    
    uint32_t objLen = QLDIP_C_DIPPopUInt32WithBeginIdx(byte, 0);
    uint8_t objTypeTemp = QLDIP_C_DIPPopUInt8WithBeginIdx(byte, 4);
    QLDIP_C_Object_type objType = (uint32_t)objTypeTemp;
    __QLDIP_C_ObjHeader header;
    header.objLen = objLen;
    header.objType = objType;
    

    
    switch (objType) {
        case QLDIP_C_Object_type_Null:
        {
            header.selfRange = QLDIP_C_RangeMake(objByteRange.location, 5);
            QLDIP_C_NullRef retNull = __QLDIP_C_DIPSerializationByteToNull(readByte, header);
            return (QLDIP_C_ObjRef)retNull;
        }
            
            break;
        case QLDIP_C_Object_type_Number:
        {
            uint8_t hasValue = QLDIP_C_DIPPopUInt8WithBeginIdx(byte, 5);
            if (0 == hasValue) {
                header.hasValue = QLDIP_C_BoolValue_false;
            }else {
                header.hasValue = QLDIP_C_BoolValue_true;
            }
            
            return NULL;
        }
            
            break;
        default:
            return NULL;
            break;
    }
}

//null----------------------------
__QLDIP_C_NullSerialization __QLDIP_C_DIPSerializationNullToByte(QLDIP_C_NullRef theNull, QLDIP_C_Byte *putInByte, uint32_t putInBeginIdx)
{

    
    __QLDIP_C_NullSerialization retNS = __QLDIP_C_DIPPresetSerializationNullToByte(theNull);
    QLDIP_C_Byte *byte = putInByte;
    byte += putInBeginIdx;
    
    
    int64_t objLen = (int64_t)retNS.base.objLen;
    QLDIP_C_DIPByteFromInt64WithByteLenWithBufferRef(objLen, retNS.base.objLenByteRange.len, byte, retNS.base.objLenByteRange.location);
    
    int64_t objType = (int64_t)retNS.base.objType;
    QLDIP_C_DIPByteFromInt64WithByteLenWithBufferRef(objType, retNS.base.objTypeByteRange.len, byte, retNS.base.objTypeByteRange.location);
    
    retNS.base.selfRange.location = putInBeginIdx;
    
    return retNS;
}


QLDIP_C_NullRef __QLDIP_C_DIPSerializationByteToNull(QLDIP_C_Byte *readByte, __QLDIP_C_ObjHeader header)
{
    QLDIP_C_NullRef theNull = NULL;
    
    if (header.selfRange.len == 5) {
        theNull = QLDIP_C_NullCreate();
    }
    
    return theNull;
}

//number----------------------------
__QLDIP_C_NumberSerialization __QLDIP_C_DIPSerializationNumberToByte(QLDIP_C_NumberRef theNumber, QLDIP_C_Byte *putInByte, uint32_t putInBeginIdx)
{
    __QLDIP_C_NumberSerialization retNS = __QLDIP_C_DIPPresetSerializationNumberToByte(theNumber);
  
    QLDIP_C_Byte *byte = putInByte;
    byte += putInBeginIdx;
    
    
    int64_t objLen = (int64_t)retNS.base.objLen;
    QLDIP_C_DIPByteFromInt64WithByteLenWithBufferRef(objLen, retNS.base.objLenByteRange.len, byte, retNS.base.objLenByteRange.location);
    
    int64_t objType = (int64_t)retNS.base.objType;
    QLDIP_C_DIPByteFromInt64WithByteLenWithBufferRef(objType, retNS.base.objTypeByteRange.len, byte, retNS.base.objTypeByteRange.location);
    
    int64_t hasValue = (int64_t)retNS.base.hasValue;
    QLDIP_C_DIPByteFromInt64WithByteLenWithBufferRef(hasValue, retNS.base.hasValueByteRange.len, byte, retNS.base.hasValueByteRange.location);

    //numberValue 部分
    __QLDIP_C_DIPSerializationNumberValueToByte(theNumber, putInByte, retNS.numberTypeByteRange);
    
    retNS.base.selfRange.location = putInBeginIdx;
    
    
    return retNS;
}

QLDIP_C_NumberRef __QLDIP_C_DIPSerializationByteToNumber(QLDIP_C_Byte *readByte, __QLDIP_C_ObjHeader header)
{
    __QLDIP_C_NumberSerialization numberS;
    numberS.numberTypeByteRange = QLDIP_C_RangeMake(header.objBodyRange.location, 1);
    
    numberS.numberByteRange = QLDIP_C_RangeMake(header.objBodyRange.location + 1, header.objBodyRange.len - 1);
    
    return __QLDIP_C_DIPSerializationByteToNumberWithByte(readByte, numberS);
}


//string----------------------------
__QLDIP_C_StringSerialization __QLDIP_C_DIPSerializationStringToByte(QLDIP_C_StringRef theString, QLDIP_C_Byte *putInByte, uint32_t putInBeginIdx)
{
    __QLDIP_C_StringSerialization retSS = __QLDIP_C_DIPPresetSerializationStringToByte(theString);
    
    QLDIP_C_Byte *byte = putInByte;
    byte += putInBeginIdx;
    
    
    int64_t objLen = (int64_t)retSS.base.objLen;
    QLDIP_C_DIPByteFromInt64WithByteLenWithBufferRef(objLen, retSS.base.objLenByteRange.len, byte, retSS.base.objLenByteRange.location);
    
    int64_t objType = (int64_t)retSS.base.objType;
    QLDIP_C_DIPByteFromInt64WithByteLenWithBufferRef(objType, retSS.base.objTypeByteRange.len, byte, retSS.base.objTypeByteRange.location);
    
    int64_t hasValue = (int64_t)retSS.base.hasValue;
    QLDIP_C_DIPByteFromInt64WithByteLenWithBufferRef(hasValue, retSS.base.hasValueByteRange.len, byte, retSS.base.hasValueByteRange.location);
    
    //stringValue 部分
    int64_t stringType = (int64_t)retSS.stringType;
    QLDIP_C_DIPByteFromInt64WithByteLenWithBufferRef(stringType, retSS.stringTypeByteRange.len, byte, retSS.stringTypeByteRange.location);
    
    for (int i=0; i<retSS.stringByteRange.len; i++) {
        uint32_t idex = retSS.stringByteRange.location + i;
        byte[idex] = theString->string[i];
    }
    
    
    retSS.base.selfRange.location = putInBeginIdx;
    
    
    return retSS;
}

QLDIP_C_StringRef __QLDIP_C_DIPSerializationByteToString(QLDIP_C_Byte *readByte, uint32_t readBeginIdx, uint32_t objLen)
{
    QLDIP_C_StringRef retString = NULL;
    
    retString = QLDIP_C_StringCreate();
    char * cString =
    
    
    
    
    
    //    retString->base.hasValue = ;
    
    return retString;
}








__QLDIP_C_DataSerialization __QLDIP_C_DIPSerializationDataToByte(QLDIP_C_DataRef theData, QLDIP_C_Byte *putInByte, uint32_t putInBeginIdx)
{
    __QLDIP_C_DataSerialization retDS;
    //    if (NULL == theNumber) {//不考虑此情况
    //        __QLDIP_C_ObjSerializationBaseInit(&(retNS.base));
    //        retNS.numberType = QLDIP_C_Number_type_Null;
    //        retNS.numberTypeByteRange = QLDIP_C_RangeMakeZero();
    //        retNS.numberByteRange = QLDIP_C_RangeMakeZero();
    //    }else {
    
    //    retNS.base.objLen = 0;
    retDS.base.objLenByteRange = QLDIP_C_RangeMake(0, 4);
    retDS.base.objType = QLDIP_C_Object_type_Data;
    retDS.base.objTypeByteRange = QLDIP_C_RangeMake(4, 1);
    retDS.base.hasValue = theData->base.hasValue;
    retDS.base.hasValueByteRange = QLDIP_C_RangeMake(5, 1);
    
    if(retDS.base.hasValue) {
        retDS.dataByteRange = QLDIP_C_RangeMake(6, theData->dataLen);
        retDS.base.objLen = retDS.dataByteRange.location + retDS.dataByteRange.len - (retDS.base.objLenByteRange.location + retDS.base.objLenByteRange.len);
    }else {
        retDS.dataByteRange = QLDIP_C_RangeMake(6, 0);
        retDS.base.objLen = retDS.base.hasValueByteRange.location + retDS.base.hasValueByteRange.len - (retDS.base.objLenByteRange.location + retDS.base.objLenByteRange.len);
    }
    //    }
    retDS.base.selfRange = QLDIP_C_RangeMake(0, retDS.base.objLen + retDS.base.objLenByteRange.location + retDS.base.objLenByteRange.len);
    return retDS;
}










__QLDIP_C_NullSerialization __QLDIP_C_DIPPresetSerializationNullToByte(QLDIP_C_NullRef theNull)
{
    __QLDIP_C_NullSerialization retNS;
    //    if (NULL == theNumber) {//不考虑此情况
    //        __QLDIP_C_ObjSerializationBaseInit(&(retNS.base));
    //        retNS.numberType = QLDIP_C_Number_type_Null;
    //        retNS.numberTypeByteRange = QLDIP_C_RangeMakeZero();
    //        retNS.numberByteRange = QLDIP_C_RangeMakeZero();
    //    }else {
    
    //    retNS.base.objLen = 0;
    retNS.base.objLenByteRange = QLDIP_C_RangeMake(0, 4);
    retNS.base.objType = QLDIP_C_Object_type_Null;
    retNS.base.objTypeByteRange = QLDIP_C_RangeMake(4, 1);
    retNS.base.hasValue = QLDIP_C_BoolValue_true;
    retNS.base.hasValueByteRange = QLDIP_C_RangeMake(5, 0);
    retNS.base.objLen = 1;

    retNS.base.selfRange = QLDIP_C_RangeMake(0, retNS.base.objLen + retNS.base.objLenByteRange.location + retNS.base.objLenByteRange.len);
    return retNS;
}



__QLDIP_C_NumberSerialization __QLDIP_C_DIPPresetSerializationNumberToByte(QLDIP_C_NumberRef theNumber)
{
    __QLDIP_C_NumberSerialization retNS;
//    if (NULL == theNumber) {//不考虑此情况
//        __QLDIP_C_ObjSerializationBaseInit(&(retNS.base));
//        retNS.numberType = QLDIP_C_Number_type_Null;
//        retNS.numberTypeByteRange = QLDIP_C_RangeMakeZero();
//        retNS.numberByteRange = QLDIP_C_RangeMakeZero();
//    }else {
  
//    retNS.base.objLen = 0;
    retNS.base.objLenByteRange = QLDIP_C_RangeMake(0, 4);
    retNS.base.objType = QLDIP_C_Object_type_Number;
    retNS.base.objTypeByteRange = QLDIP_C_RangeMake(4, 1);
    retNS.base.hasValue = theNumber->base.hasValue;
    retNS.base.hasValueByteRange = QLDIP_C_RangeMake(5, 1);
    
    if(retNS.base.hasValue) {
        retNS.numberType = theNumber->numberType;
        retNS.numberTypeByteRange = QLDIP_C_RangeMake(6, 1);
        retNS.numberByteRange = __QLDIP_C_DIPPresetSerializationNumberValueRange(theNumber, 7);
        retNS.base.objLen = retNS.numberByteRange.location + retNS.numberByteRange.len - (retNS.base.objLenByteRange.location + retNS.base.objLenByteRange.len);
    }else {
        retNS.numberType = QLDIP_C_Number_type_Null;
        retNS.numberTypeByteRange = QLDIP_C_RangeMake(6, 0);
        retNS.numberByteRange = QLDIP_C_RangeMake(6, 0);
        retNS.base.objLen = retNS.base.hasValueByteRange.location + retNS.base.hasValueByteRange.len - (retNS.base.objLenByteRange.location + retNS.base.objLenByteRange.len);
    }
//    }
    retNS.base.selfRange = QLDIP_C_RangeMake(0, retNS.base.objLen + retNS.base.objLenByteRange.location + retNS.base.objLenByteRange.len);
    return retNS;
}

__QLDIP_C_DataSerialization __QLDIP_C_DIPPresetSerializationDataToByte(QLDIP_C_DataRef theData)
{
    __QLDIP_C_DataSerialization retDS;
    //    if (NULL == theNumber) {//不考虑此情况
    //        __QLDIP_C_ObjSerializationBaseInit(&(retNS.base));
    //        retNS.numberType = QLDIP_C_Number_type_Null;
    //        retNS.numberTypeByteRange = QLDIP_C_RangeMakeZero();
    //        retNS.numberByteRange = QLDIP_C_RangeMakeZero();
    //    }else {
    
    //    retNS.base.objLen = 0;
    retDS.base.objLenByteRange = QLDIP_C_RangeMake(0, 4);
    retDS.base.objType = QLDIP_C_Object_type_Data;
    retDS.base.objTypeByteRange = QLDIP_C_RangeMake(4, 1);
    retDS.base.hasValue = theData->base.hasValue;
    retDS.base.hasValueByteRange = QLDIP_C_RangeMake(5, 1);
    
    if(retDS.base.hasValue) {
        retDS.dataByteRange = QLDIP_C_RangeMake(6, theData->dataLen);
        retDS.base.objLen = retDS.dataByteRange.location + retDS.dataByteRange.len - (retDS.base.objLenByteRange.location + retDS.base.objLenByteRange.len);
    }else {
        retDS.dataByteRange = QLDIP_C_RangeMake(6, 0);
        retDS.base.objLen = retDS.base.hasValueByteRange.location + retDS.base.hasValueByteRange.len - (retDS.base.objLenByteRange.location + retDS.base.objLenByteRange.len);
    }
    //    }
        retDS.base.selfRange = QLDIP_C_RangeMake(0, retDS.base.objLen + retDS.base.objLenByteRange.location + retDS.base.objLenByteRange.len);
    return retDS;
}

__QLDIP_C_StringSerialization __QLDIP_C_DIPPresetSerializationStringToByte(QLDIP_C_StringRef theString)
{
    __QLDIP_C_StringSerialization retSS;
    //    if (NULL == theNumber) {//不考虑此情况
    //        __QLDIP_C_ObjSerializationBaseInit(&(retNS.base));
    //        retNS.numberType = QLDIP_C_Number_type_Null;
    //        retNS.numberTypeByteRange = QLDIP_C_RangeMakeZero();
    //        retNS.numberByteRange = QLDIP_C_RangeMakeZero();
    //    }else {
    
    //    retNS.base.objLen = 0;
    retSS.base.objLenByteRange = QLDIP_C_RangeMake(0, 4);
    retSS.base.objType = QLDIP_C_Object_type_String;
    retSS.base.objTypeByteRange = QLDIP_C_RangeMake(4, 1);
    retSS.base.hasValue = theString->base.hasValue;
    retSS.base.hasValueByteRange = QLDIP_C_RangeMake(5, 1);
    
    if(retSS.base.hasValue) {
        retSS.stringType = theString->stringType;
        retSS.stringTypeByteRange = QLDIP_C_RangeMake(6, 4);
        retSS.stringByteRange = QLDIP_C_RangeMake(10, theString->strLen);
        retSS.base.objLen = retSS.stringByteRange.location + retSS.stringByteRange.len - (retSS.base.objLenByteRange.location + retSS.base.objLenByteRange.len);
    }else {
        retSS.stringType = QLDIP_C_String_Null;
        retSS.stringTypeByteRange = QLDIP_C_RangeMake(6, 0);
        retSS.stringByteRange = QLDIP_C_RangeMake(6, 0);
        retSS.base.objLen = retSS.stringByteRange.location + retSS.stringByteRange.len - (retSS.base.objLenByteRange.location + retSS.base.objLenByteRange.len);
    }
    //    }
        retSS.base.selfRange = QLDIP_C_RangeMake(0, retSS.base.objLen + retSS.base.objLenByteRange.location + retSS.base.objLenByteRange.len);
    return retSS;
}

__QLDIP_C_ArraySerialization __QLDIP_C_DIPPresetSerializationArrayToByte(QLDIP_C_ArrayRef theArray)
{
    __QLDIP_C_ArraySerialization retAS;
    //    if (NULL == theNumber) {//不考虑此情况
    //        __QLDIP_C_ObjSerializationBaseInit(&(retNS.base));
    //        retNS.numberType = QLDIP_C_Number_type_Null;
    //        retNS.numberTypeByteRange = QLDIP_C_RangeMakeZero();
    //        retNS.numberByteRange = QLDIP_C_RangeMakeZero();
    //    }else {
    
    //    retNS.base.objLen = 0;
    retAS.base.objLenByteRange = QLDIP_C_RangeMake(0, 4);
    retAS.base.objType = QLDIP_C_Object_type_Map;
    retAS.base.objTypeByteRange = QLDIP_C_RangeMake(4, 1);
    retAS.base.hasValue = theArray->base.hasValue;
    retAS.base.hasValueByteRange = QLDIP_C_RangeMake(5, 1);
    
    if(retAS.base.hasValue) {
        retAS.count = theArray->count;
        retAS.countByteRange = QLDIP_C_RangeMake(6, 4);
        retAS.arrayByteRange = QLDIP_C_RangeMake(10, 5);
        retAS.base.objLen = retAS.arrayByteRange.location + retAS.arrayByteRange.len - (retAS.base.objLenByteRange.location + retAS.base.objLenByteRange.len);
    }else {
        retAS.count = theArray->count;
        retAS.countByteRange = QLDIP_C_RangeMake(6, 0);
        retAS.arrayByteRange = QLDIP_C_RangeMake(6, 0);
        retAS.base.objLen = retAS.arrayByteRange.location + retAS.arrayByteRange.len - (retAS.base.objLenByteRange.location + retAS.base.objLenByteRange.len);
    }
    //    }
        retAS.base.selfRange = QLDIP_C_RangeMake(0, retAS.base.objLen + retAS.base.objLenByteRange.location + retAS.base.objLenByteRange.len);
    return retAS;
}


__QLDIP_C_ArraySerialization __QLDIP_C_DIPSerializationArrayToByte(QLDIP_C_ArrayRef theArray, QLDIP_C_Byte *putInByte, uint32_t putInBeginIdx)
{
//    QLDIP_C_Range putInRange = QLDIP_C_RangeMake(putInBeginIdx, 0);
    __QLDIP_C_ArraySerialization retAS;
    //    if (NULL == theNumber) {//不考虑此情况
    //        __QLDIP_C_ObjSerializationBaseInit(&(retNS.base));
    //        retNS.numberType = QLDIP_C_Number_type_Null;
    //        retNS.numberTypeByteRange = QLDIP_C_RangeMakeZero();
    //        retNS.numberByteRange = QLDIP_C_RangeMakeZero();
    //    }else {
    
    //    retNS.base.objLen = 0;
    retAS.base.objLenByteRange = QLDIP_C_RangeMake(0, 4);
    retAS.base.objType = QLDIP_C_Object_type_Map;
    retAS.base.objTypeByteRange = QLDIP_C_RangeMake(4, 1);
    retAS.base.hasValue = theArray->base.hasValue;
    retAS.base.hasValueByteRange = QLDIP_C_RangeMake(5, 1);
    
    if(retAS.base.hasValue) {
        retAS.count = theArray->count;
        retAS.countByteRange = QLDIP_C_RangeMake(6, 4);
        retAS.arrayByteRange = QLDIP_C_RangeMake(10, 5);
        
        
        
        
        retAS.base.objLen = retAS.arrayByteRange.location + retAS.arrayByteRange.len - (retAS.base.objLenByteRange.location + retAS.base.objLenByteRange.len);
    }else {
        retAS.count = theArray->count;
        retAS.countByteRange = QLDIP_C_RangeMake(6, 0);
        retAS.arrayByteRange = QLDIP_C_RangeMake(6, 0);
        retAS.base.objLen = retAS.arrayByteRange.location + retAS.arrayByteRange.len - (retAS.base.objLenByteRange.location + retAS.base.objLenByteRange.len);
    }
    //    }
    retAS.base.selfRange = QLDIP_C_RangeMake(putInBeginIdx, putInBeginIdx + retAS.base.objLen + retAS.base.objLenByteRange.location + retAS.base.objLenByteRange.len);
    
    
    
    
    
    
    
    
    return retAS;
}








//__QLDIP_C_ArrayItemSerialization __QLDIP_C_DIPSerializationMapToByte(QLDIP_C_Array_ItemRef theArrayItem, uint32_t itemIdx, QLDIP_C_Byte *putInByte, uint32_t putInBeginIdx)
//{
//    __QLDIP_C_ArrayItemSerialization retAIS;
//    
//    retAIS.selfRange = QLDIP_C_RangeMake(0, 4);
//    retAIS.idx = itemIdx;
//    retAIS.idxByteRange = QLDIP_C_RangeMake(0, 4);
//    retAIS.itemByteRange = QLDIP_C_RangeMake(4, 0);
//    
//    retMS.countByteRange = QLDIP_C_RangeMake(6, 4);
//    retMS.mapByteRange = QLDIP_C_RangeMake(10, 5);
//    retMS.base.objLen = retMS.mapByteRange.location + retMS.mapByteRange.len - (retMS.base.objLenByteRange.location + retMS.base.objLenByteRange.len);
//
//    
//    return retMS;
//}
//
//__QLDIP_C_MapSerialization __QLDIP_C_DIPPresetSerializationMapToByte(QLDIP_C_MapRef theMap)
//{
//    __QLDIP_C_MapSerialization retMS;
//    //    if (NULL == theNumber) {//不考虑此情况
//    //        __QLDIP_C_ObjSerializationBaseInit(&(retNS.base));
//    //        retNS.numberType = QLDIP_C_Number_type_Null;
//    //        retNS.numberTypeByteRange = QLDIP_C_RangeMakeZero();
//    //        retNS.numberByteRange = QLDIP_C_RangeMakeZero();
//    //    }else {
//    
//    //    retNS.base.objLen = 0;
//    retMS.base.objLenByteRange = QLDIP_C_RangeMake(0, 4);
//    retMS.base.objType = QLDIP_C_Object_type_Map;
//    retMS.base.objTypeByteRange = QLDIP_C_RangeMake(4, 1);
//    retMS.base.hasValue = theMap->base.hasValue;
//    retMS.base.hasValueByteRange = QLDIP_C_RangeMake(5, 1);
//    
//    if(retMS.base.hasValue) {
//        retMS.count = theMap->count;
//        retMS.countByteRange = QLDIP_C_RangeMake(6, 4);
//        retMS.mapByteRange = QLDIP_C_RangeMake(10, 5);
//        retMS.base.objLen = retMS.mapByteRange.location + retMS.mapByteRange.len - (retMS.base.objLenByteRange.location + retMS.base.objLenByteRange.len);
//    }else {
//        retMS.count = theMap->count;
//        retMS.countByteRange = QLDIP_C_RangeMake(6, 0);
//        retMS.mapByteRange = QLDIP_C_RangeMake(6, 0);
//        retMS.base.objLen = retMS.mapByteRange.location + retMS.mapByteRange.len - (retMS.base.objLenByteRange.location + retMS.base.objLenByteRange.len);
//    }
//    //    }
//    retMS.base.selfRange = QLDIP_C_RangeMake(0, retMS.base.objLen + retaMS.base.objLenByteRange.location + retMS.base.objLenByteRange.len);
//    return retMS;
//}
//
//__QLDIP_C_MapSerialization __QLDIP_C_DIPPresetSerializationMapToByte(QLDIP_C_MapRef theMap)
//{
//    __QLDIP_C_MapSerialization retMS;
//    //    if (NULL == theNumber) {//不考虑此情况
//    //        __QLDIP_C_ObjSerializationBaseInit(&(retNS.base));
//    //        retNS.numberType = QLDIP_C_Number_type_Null;
//    //        retNS.numberTypeByteRange = QLDIP_C_RangeMakeZero();
//    //        retNS.numberByteRange = QLDIP_C_RangeMakeZero();
//    //    }else {
//    
//    //    retNS.base.objLen = 0;
//    retMS.base.objLenByteRange = QLDIP_C_RangeMake(0, 4);
//    retMS.base.objType = QLDIP_C_Object_type_Map;
//    retMS.base.objTypeByteRange = QLDIP_C_RangeMake(4, 1);
//    retMS.base.hasValue = theMap->base.hasValue;
//    retMS.base.hasValueByteRange = QLDIP_C_RangeMake(5, 1);
//    
//    if(retMS.base.hasValue) {
//        retMS.count = theMap->count;
//        retMS.countByteRange = QLDIP_C_RangeMake(6, 4);
//        retMS.mapByteRange = QLDIP_C_RangeMake(10, 5);
//        retMS.base.objLen = retMS.mapByteRange.location + retMS.mapByteRange.len - (retMS.base.objLenByteRange.location + retMS.base.objLenByteRange.len);
//    }else {
//        retMS.count = theMap->count;
//        retMS.countByteRange = QLDIP_C_RangeMake(6, 0);
//        retMS.mapByteRange = QLDIP_C_RangeMake(6, 0);
//        retMS.base.objLen = retMS.mapByteRange.location + retMS.mapByteRange.len - (retMS.base.objLenByteRange.location + retMS.base.objLenByteRange.len);
//    }
//    //    }
//    
//    return retMS;
//}


#pragma mark - </public/>

#pragma mark - </private>
QLDIP_C_BoolValue __QLDIP_C_ObjSerializationBaseInit(__QLDIP_C_ObjSerializationBase *baseRef)
{
    if (NULL == baseRef) {
        return QLDIP_C_BoolValue_false;
    }
    
    baseRef->objLen = 0;
    baseRef->objLenByteRange = QLDIP_C_RangeMake(0, 0);
    baseRef->objType = 0;
    baseRef->objTypeByteRange = QLDIP_C_RangeMake(0, 0);
    baseRef->hasValue = QLDIP_C_BoolValue_false;
    baseRef->hasValueByteRange = QLDIP_C_RangeMake(0, 0);
    return QLDIP_C_BoolValue_true;
}


void __QLDIP_C_DIPSerializationNumberValueToByte(QLDIP_C_NumberRef theNumber, QLDIP_C_Byte *putInByte, QLDIP_C_Range putInRange)
{
    

}

QLDIP_C_NumberRef __QLDIP_C_DIPSerializationByteToNumberWithByte(QLDIP_C_Byte *readByte, __QLDIP_C_NumberSerialization numberSrlt)
{
    switch (numberSrlt.numberType) {
        case QLDIP_C_Number_type_Null:
        {
            return QLDIP_C_NumberCreate();
        }
            break;
            
        case QLDIP_C_Number_type_Int8:
        {
            if (numberSrlt.numberByteRange.len == 1) {
                int8_t num8 = QLDIP_C_DIPReadIntWithBeginIdxWithIntByteWithErrorRefRef(readByte, numberSrlt.numberByteRange.location, numberSrlt.numberByteRange.len, NULL);
                
                return QLDIP_C_NumberCreateWithInt8(num8);
                
            }
        }
            break;
        case QLDIP_C_Number_type_UInt8:
        {
            if (numberSrlt.numberByteRange.len == 1) {
                uint8_t num8 = QLDIP_C_DIPReadIntWithBeginIdxWithIntByteWithErrorRefRef(readByte, numberSrlt.numberByteRange.location, numberSrlt.numberByteRange.len, NULL);
                
                return QLDIP_C_NumberCreateWithUInt8(num8);
                
            }
        }
            break;
            
        case QLDIP_C_Number_type_Int16:
        {
            if (numberSrlt.numberByteRange.len == 2) {
                int16_t num16 = QLDIP_C_DIPReadIntWithBeginIdxWithIntByteWithErrorRefRef(readByte, numberSrlt.numberByteRange.location, numberSrlt.numberByteRange.len, NULL);
                
                return QLDIP_C_NumberCreateWithInt16(num16);
                
            }
        }
            break;
        case QLDIP_C_Number_type_UInt16:
        {
            if (numberSrlt.numberByteRange.len == 2) {
                uint16_t num16 = QLDIP_C_DIPReadIntWithBeginIdxWithIntByteWithErrorRefRef(readByte, numberSrlt.numberByteRange.location, numberSrlt.numberByteRange.len, NULL);
                
                return QLDIP_C_NumberCreateWithUInt16(num16);
                
            }
        }
            break;
            
        case QLDIP_C_Number_type_Int32:
        {
            if (numberSrlt.numberByteRange.len == 4) {
                int32_t num32 = (int32_t)QLDIP_C_DIPReadIntWithBeginIdxWithIntByteWithErrorRefRef(readByte, numberSrlt.numberByteRange.location, numberSrlt.numberByteRange.len, NULL);
                
                return QLDIP_C_NumberCreateWithInt32(num32);
                
            }
        }
            break;
        case QLDIP_C_Number_type_UInt32:
        {
            if (numberSrlt.numberByteRange.len == 4) {
                uint32_t num32 = (uint32_t)QLDIP_C_DIPReadIntWithBeginIdxWithIntByteWithErrorRefRef(readByte, numberSrlt.numberByteRange.location, numberSrlt.numberByteRange.len, NULL);
                
                return QLDIP_C_NumberCreateWithUInt32(num32);
                
            }
        }
            break;
            
        case QLDIP_C_Number_type_Int64:
        {
            if (numberSrlt.numberByteRange.len == 8) {
                int64_t num64 = (int64_t)QLDIP_C_DIPReadIntWithBeginIdxWithIntByteWithErrorRefRef(readByte, numberSrlt.numberByteRange.location, numberSrlt.numberByteRange.len, NULL);
                
                return QLDIP_C_NumberCreateWithInt64(num64);
                
            }
        }
            break;
        case QLDIP_C_Number_type_UInt64:
        {
            if (numberSrlt.numberByteRange.len == 8) {
                uint64_t num64 = (uint64_t)QLDIP_C_DIPReadIntWithBeginIdxWithIntByteWithErrorRefRef(readByte, numberSrlt.numberByteRange.location, numberSrlt.numberByteRange.len, NULL);
                
                return QLDIP_C_NumberCreateWithUInt64(num64);
                
            }
        }
            break;
            
        case QLDIP_C_Number_type_Bool:
        {
            if (numberSrlt.numberByteRange.len == 8) {
                int64_t num64 = (int64_t)QLDIP_C_DIPReadIntWithBeginIdxWithIntByteWithErrorRefRef(readByte, numberSrlt.numberByteRange.location, numberSrlt.numberByteRange.len, NULL);
                QLDIP_C_BoolValue theBoolValue = QLDIP_C_BoolValue_false;
                if (0 != num64) {
                    theBoolValue = QLDIP_C_BoolValue_true;
                }
                return QLDIP_C_NumberCreateWithBool(theBoolValue);
            }
        }
            break;
            
        case QLDIP_C_Number_type_Float:
        {
            if (numberSrlt.numberByteRange.len == 8) {
                float num32 = QLDIP_C_DIPReadFloatWithBeginIdxWithIntByteWithErrorRefRef(readByte, numberSrlt.numberByteRange.location, numberSrlt.numberByteRange.len, NULL);
                
                return QLDIP_C_NumberCreateWithFloat(num32);
                
            }
        }
            break;
            
        case QLDIP_C_Number_type_Double:
        {
            if (numberSrlt.numberByteRange.len == 8) {
                double num64 = QLDIP_C_DIPReadDoubleWithBeginIdxWithIntByteWithErrorRefRef(readByte, numberSrlt.numberByteRange.location, numberSrlt.numberByteRange.len, NULL);
                
                return QLDIP_C_NumberCreateWithDouble(num64);
            }
        }
            break;
        default:
            break;
    }
    return NULL;
}
#pragma mark - </private/>
#pragma mark - <implementation/>




