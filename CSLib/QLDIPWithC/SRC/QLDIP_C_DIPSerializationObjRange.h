//
//  QLDIP_C_DIPSerializationObjRange.h
//  QLDIPWithC
//
//  Created by 蔡连凤 on 16/1/3.
//  Copyright © 2016年 ql. All rights reserved.
//

#ifndef QLDIP_C_DIPSerializationObjRange_h
#define QLDIP_C_DIPSerializationObjRange_h

#include <stdio.h>

#include "QLDIP_C_Base.h"
#include "QLDIP_C_Type.h"



QLDIP_C_Range __QLDIP_C_DIPPresetSerializationNumberValueRange(QLDIP_C_NumberRef theNumber, uint32_t beginIdx);





QLDIP_C_Range __QLDIP_C_DIPPresetSerializationNullRange(QLDIP_C_NullRef theNull, uint32_t beginIdx);

QLDIP_C_Range __QLDIP_C_DIPPresetSerializationNumberRange(QLDIP_C_NumberRef theNumber, uint32_t beginIdx);

QLDIP_C_Range __QLDIP_C_DIPPresetSerializationDataRange(QLDIP_C_DataRef theData, uint32_t beginIdx);

QLDIP_C_Range __QLDIP_C_DIPPresetSerializationStringRange(QLDIP_C_StringRef theString, uint32_t beginIdx);

QLDIP_C_Range __QLDIP_C_DIPPresetSerializationArrayRange(QLDIP_C_ArrayRef theArray, uint32_t beginIdx);

QLDIP_C_Range __QLDIP_C_DIPPresetSerializationMapRange(QLDIP_C_MapRef theMap, uint32_t beginIdx);

QLDIP_C_Range __QLDIP_C_DIPPresetSerializationArrayItemRange(QLDIP_C_Array_ItemRef theArrayItem, uint32_t beginIdx);

QLDIP_C_Range __QLDIP_C_DIPPresetSerializationMapItemRange(QLDIP_C_Map_ItemRef theMapItem, uint32_t beginIdx);



#endif /* QLDIP_C_DIPSerializationObjRange_h */
