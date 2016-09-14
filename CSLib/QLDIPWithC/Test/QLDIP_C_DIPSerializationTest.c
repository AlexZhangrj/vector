//
//  QLDIP_C_DIPSerializationTest.c
//  QLDIPWithC
//
//  Created by 蔡连凤 on 16/1/3.
//  Copyright © 2016年 ql. All rights reserved.
//

#include "QLDIP_C_DIPSerializationTest.h"

#include "QLDIP_C_DIPSerialization.h"
#include "QLDIP_C_headers.h"




void QLDIP_C_DIPSerializationTestTest()
{

    QLDIP_C_NullRef tNull = QLDIP_C_NullCreate();
    
    QLDIP_C_Byte *tempByte = QLDIP_C_allocWithInit(1024);
    
    __QLDIP_C_NullSerialization nullS = __QLDIP_C_DIPSerializationNullToByte(tNull, tempByte, 0);
    
    
    QLDIP_C_ObjRef tempObj = __QLDIP_C_DIPSerializationByteToObj(tempByte, nullS.base.selfRange);
    QLDIP_C_NullRef tNull2 = NULL;
    if (NULL != tempObj) {
        tNull2 = (QLDIP_C_NullRef)tempObj;
    }

    
    
    printf("--------\n");

}