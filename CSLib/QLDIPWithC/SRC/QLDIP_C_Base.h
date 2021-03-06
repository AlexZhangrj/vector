//
//  QLDIP_C_Base.h
//  QLDIPWithC
//
//  Created by prsoft_mac01 on 15/12/22.
//  Copyright © 2015年 ql. All rights reserved.
//

#ifndef QLDIP_C_Base_h
#define QLDIP_C_Base_h

#include <stdio.h>
#include "QLDIP_C_Type.h"


void QLDIP_C_Retain(const void * QLObjRef);

void QLDIP_C_Release(void * QLObjRef);

void * QLDIP_C_malloc(size_t size);
void * QLDIP_C_allocWithInit(size_t);
void QLDIP_C_Dealloc(void * ref);


unsigned long QLDIP_C_StrHashEightBit(const uint8_t *cContents, signed long len);

unsigned long QLDIP_C_StrHashCharacters(const uint16_t *uContents, signed long len);


QLDIP_C_BoolValue QLDIP_C_BaseSysIsBigEndian();



#pragma mark - <interface>

QLDIP_C_Object_type QLDIP_C_BaseObject_typeFromObj(QLDIP_C_Obj *theObj);
uint32_t QLDIP_C_BaseObject_byteLenFromObj(QLDIP_C_Obj *theObj);

QLDIP_C_BoolValue QLDIP_C_BaseObjectToByte(QLDIP_C_Obj *theObj, QLDIP_C_Byte *buffer, uint32_t putInBeginIdx, uint32_t *putInLen);


#pragma mark - <interface/>




#endif /* QLDIP_C_Base_h */


#pragma mark - <interface>
#pragma mark - <interface/>
//--------------------------------------------------------------------------------------
#pragma mark - <interface>
#pragma mark - <interface/>
#pragma mark - <------------------------------------------------------------------------>
#pragma mark - <implementation>
#pragma mark - </public>

#pragma mark - </public/>

#pragma mark - </private>

#pragma mark - </private/>
#pragma mark - <implementation/>

