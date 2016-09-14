//
//  QLDIP_C_Data.h
//  QLDIPWithC
//
//  Created by prsoft_mac01 on 15/12/28.
//  Copyright © 2015年 ql. All rights reserved.
//

#ifndef QLDIP_C_Data_h
#define QLDIP_C_Data_h

#include <stdio.h>
#include <stdlib.h>
#include "QLDIP_C_Type.h"

QLDIP_C_DataRef QLDIP_C_DataCreate();

QLDIP_C_DataRef QLDIP_C_DataCreateWithByteArray(const QLDIP_C_Byte * cData, uint32_t cDataLen);

QLDIP_C_DataRef QLDIP_C_DataCreateWithExpectedBufferLen(uint32_t bufferLen);

void QLDIP_C_DataSetContentByteArray(QLDIP_C_DataRef theData, const QLDIP_C_Byte * cData, uint32_t cDataLen);

void QLDIP_C_DataDealloc(QLDIP_C_DataRef theData);


QLDIP_C_DataRef QLDIP_C_DataCopy(QLDIP_C_DataRef theData);


const QLDIP_C_Byte * QLDIP_C_DataByteArrayFromData(QLDIP_C_DataRef theData, uint32_t *retLen);

//return a new malloc pointer without memory Management
const QLDIP_C_Byte * QLDIP_C_DataUnsafeByteArrayFromDataByCopy(QLDIP_C_DataRef theData, uint32_t *retLen);

void QLDIP_C_DataReplaceByteWithRange(QLDIP_C_DataRef theData, QLDIP_C_Range range, const QLDIP_C_Byte *byte, uint32_t byteLen);




#endif /* QLDIP_C_Data_h */
