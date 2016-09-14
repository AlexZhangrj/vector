//
//  QLDIP_C_Map.h
//  QLDIPWithC
//
//  Created by prsoft_mac01 on 15/12/22.
//  Copyright © 2015年 ql. All rights reserved.
//

#ifndef QLDIP_C_Map_h
#define QLDIP_C_Map_h

#include <stdio.h>
#include <stdlib.h>
#include "QLDIP_C_Type.h"

QLDIP_C_MapRef QLDIP_C_MapCreate();
void QLDIP_C_MapDealloc(QLDIP_C_MapRef theMap);



void QLDIP_C_MapSetValueWithStringKey(QLDIP_C_MapRef theMap, void *value, QLDIP_C_StringRef key);
QLDIP_C_Map_ItemRef QLDIP_C_MapItemRefAtIndex(QLDIP_C_MapRef theMap, uint32_t index);


#endif /* QLDIP_C_Map_h */
