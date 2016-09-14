//
//  QLDIP_C_Base.c
//  QLDIPWithC
//
//  Created by prsoft_mac01 on 15/12/22.
//  Copyright © 2015年 ql. All rights reserved.
//

#include "QLDIP_C_Base.h"

#include <stdlib.h>
#include <memory.h>
#include <string.h>

#include "QLDIP_C_Number.h"
#include "QLDIP_C_String.h"
#include "QLDIP_C_Data.h"
#include "QLDIP_C_Array.h"
#include "QLDIP_C_Map.h"



typedef unsigned long CFHashCode;
typedef uint16_t                          UniChar;
typedef signed long CFIndex;


unsigned long __QLDIP_C_StrHashCharacters(const uint16_t *uContents, signed long len, signed long actualLen);
CFHashCode __QLDIP_C_StrHashEightBit(const uint8_t *cContents, signed long len);




#define HashEverythingLimit 96

#define HashNextFourUniChars(accessStart, accessEnd, pointer) \
{result = result * 67503105 + (accessStart 0 accessEnd) * 16974593  + (accessStart 1 accessEnd) * 66049  + (accessStart 2 accessEnd) * 257 + (accessStart 3 accessEnd); pointer += 4;}

#define HashNextUniChar(accessStart, accessEnd, pointer) \
{result = result * 257 + (accessStart 0 accessEnd); pointer++;}







/* In this function, actualLen is the length of the original string; but len is the number of characters in buffer. The buffer is expected to contain the parts of the string relevant to hashing.
 */
CFHashCode __CFStrHashCharacters(const UniChar *uContents, CFIndex len, CFIndex actualLen) {
    CFHashCode result = actualLen;
    if (len <= HashEverythingLimit) {
        const UniChar *end4 = uContents + (len & ~3);
        const UniChar *end = uContents + len;
        while (uContents < end4) HashNextFourUniChars(uContents[, ], uContents); 	// First count in fours
        while (uContents < end) HashNextUniChar(uContents[, ], uContents);		// Then for the last <4 chars, count in ones...
    } else {
        const UniChar *contents, *end;
        contents = uContents;
        end = contents + 32;
        while (contents < end) HashNextFourUniChars(contents[, ], contents);
        contents = uContents + (len >> 1) - 16;
        end = contents + 32;
        while (contents < end) HashNextFourUniChars(contents[, ], contents);
        end = uContents + len;
        contents = end - 32;
        while (contents < end) HashNextFourUniChars(contents[, ], contents);
    }
    return result + (result << (actualLen & 31));
}



unsigned long QLDIP_C_StrHashEightBit(const uint8_t *cContents, signed long len)
{
    return __QLDIP_C_StrHashEightBit(cContents, len);
}

unsigned long QLDIP_C_StrHashCharacters(const uint16_t *uContents, signed long len)
{
    return __QLDIP_C_StrHashCharacters(uContents, len, len);
}

/* In this function, actualLen is the length of the original string; but len is the number of characters in buffer. The buffer is expected to contain the parts of the string relevant to hashing.
 */
unsigned long __QLDIP_C_StrHashCharacters(const uint16_t *uContents, signed long len, signed long actualLen)
{
    unsigned long result = actualLen;
    if (len <= 96) {
        const uint16_t *end4 = uContents + (len & ~3);
        const uint16_t *end = uContents + len;
        while (uContents < end4) {
            result = result * 67503105 + uContents[0] * 16974593  + uContents[1] * 66049  + uContents[2] * 257 + uContents[3];
                uContents += 4;
        };
        while (uContents < end) {
            result = result * 257 + uContents[0];
            uContents++;
        };
    } else {
        const uint16_t *contents, *end;
        contents = uContents;
        end = contents + 32;
        while (contents < end) {
            result = result * 67503105 + uContents[0] * 16974593  + uContents[1] * 66049  + uContents[2] * 257 + uContents[3];
            uContents += 4;
        };
        contents = uContents + (len >> 1) - 16;
        end = contents + 32;
        while (contents < end) {
            result = result * 67503105 + uContents[0] * 16974593  + uContents[1] * 66049  + uContents[2] * 257 + uContents[3];
            uContents += 4;
        };
        end = uContents + len;
        contents = end - 32;
        while (contents < end) {
            result = result * 67503105 + uContents[0] * 16974593  + uContents[1] * 66049  + uContents[2] * 257 + uContents[3];
            uContents += 4;
        };
    }
    return result + (result << (actualLen & 31));
}


uint16_t QLDIP_C_CharToUniCharTable[256] = {
    0,   1,   2,   3,   4,   5,   6,   7,   8,   9,  10,  11,  12,  13,  14,  15,
    16,  17,  18,  19,  20,  21,  22,  23,  24,  25,  26,  27,  28,  29,  30,  31,
    32,  33,  34,  35,  36,  37,  38,  39,  40,  41,  42,  43,  44,  45,  46,  47,
    48,  49,  50,  51,  52,  53,  54,  55,  56,  57,  58,  59,  60,  61,  62,  63,
    64,  65,  66,  67,  68,  69,  70,  71,  72,  73,  74,  75,  76,  77,  78,  79,
    80,  81,  82,  83,  84,  85,  86,  87,  88,  89,  90,  91,  92,  93,  94,  95,
    96,  97,  98,  99, 100, 101, 102, 103, 104, 105, 106, 107, 108, 109, 110, 111,
    112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122, 123, 124, 125, 126, 127,
    128, 129, 130, 131, 132, 133, 134, 135, 136, 137, 138, 139, 140, 141, 142, 143,
    144, 145, 146, 147, 148, 149, 150, 151, 152, 153, 154, 155, 156, 157, 158, 159,
    160, 161, 162, 163, 164, 165, 166, 167, 168, 169, 170, 171, 172, 173, 174, 175,
    176, 177, 178, 179, 180, 181, 182, 183, 184, 185, 186, 187, 188, 189, 190, 191,
    192, 193, 194, 195, 196, 197, 198, 199, 200, 201, 202, 203, 204, 205, 206, 207,
    208, 209, 210, 211, 212, 213, 214, 215, 216, 217, 218, 219, 220, 221, 222, 223,
    224, 225, 226, 227, 228, 229, 230, 231, 232, 233, 234, 235, 236, 237, 238, 239,
    240, 241, 242, 243, 244, 245, 246, 247, 248, 249, 250, 251, 252, 253, 254, 255
};

CFHashCode __QLDIP_C_StrHashEightBit(const uint8_t *cContents, signed long len) {
    CFHashCode result = len;
    if (len <= HashEverythingLimit) {
        const uint8_t *end4 = cContents + (len & ~3);
        const uint8_t *end = cContents + len;
        while (cContents < end4) {
            result = result * 67503105 + cContents[0] * 16974593  + cContents[1] * 66049  + cContents[2] * 257 + cContents[3];
            cContents += 4;
        
        }; 	// HashNextFourUniChars(QLDIP_C_CharToUniCharTable[cContents[, ]], cContents)
        
        while (cContents < end) {
            result = result * 257 + cContents[0];
            cContents++;
        };//HashNextUniChar(QLDIP_C_CharToUniCharTable[cContents[, ]], cContents);		// Then for the last <4 chars, count in ones...
    } else {
        const uint8_t *contents, *end;
        contents = cContents;
        end = contents + 32;
        while (cContents < end) {
            result = result * 67503105 + cContents[0] * 16974593  + cContents[1] * 66049  + cContents[2] * 257 + cContents[3];
            cContents += 4;
        };//HashNextFourUniChars(QLDIP_C_CharToUniCharTable[contents[, ]], contents);
        contents = cContents + (len >> 1) - 16;
        end = contents + 32;
        while (cContents < end){
            result = result * 67503105 + cContents[0] * 16974593  + cContents[1] * 66049  + cContents[2] * 257 + cContents[3];
            cContents += 4;
        };// HashNextFourUniChars(QLDIP_C_CharToUniCharTable[contents[, ]], contents);
        end = cContents + len;
        contents = end - 32;
        while (cContents < end) {
            result = result * 67503105 + cContents[0] * 16974593  + cContents[1] * 66049  + cContents[2] * 257 + cContents[3];
            cContents += 4;
        };//HashNextFourUniChars(QLDIP_C_CharToUniCharTable[contents[, ]], contents);
    }
    return result + (result << (len & 31));
}





void QLDIP_C_Retain(const void * QLObjRef)
{
    if (NULL == QLObjRef) {
        printf("%s : 在retain一个NULL 指针\n", __func__);
        return;
    }else {
        QLDIP_C_ObjRef temp = (QLDIP_C_ObjRef)QLObjRef;
        temp->base.refcount ++;
        return;
    }
}

void QLDIP_C_Release(void * QLObjRef)
{
    if (NULL == QLObjRef) {
        printf("%s : 在release一个NULL 指针\n", __func__);
        return;
    }else {
        QLDIP_C_ObjRef temp = (QLDIP_C_ObjRef)QLObjRef;
        int refCount = temp->base.refcount - 1;
        
        if (refCount == 0) {
            
            QLDIP_C_Object_type objType = temp->base.objType;

            switch (objType) {
                case QLDIP_C_Object_type_Number:
                {
                    QLDIP_C_NumberRef theNumber = (QLDIP_C_NumberRef)QLObjRef;
                    QLDIP_C_NumberDealloc(theNumber);
                }
                    break;
                case QLDIP_C_Object_type_String:
                {
                    QLDIP_C_StringRef theString = (QLDIP_C_StringRef)QLObjRef;
                    QLDIP_C_StringDealloc(theString);
                }
                    break;
                case QLDIP_C_Object_type_Data:
                {
                    QLDIP_C_DataRef theData = (QLDIP_C_DataRef)QLObjRef;
                    QLDIP_C_DataDealloc(theData);
                }
                    break;
                case QLDIP_C_Object_type_Array:
                {
                    QLDIP_C_ArrayRef theArray = (QLDIP_C_ArrayRef)QLObjRef;
                    QLDIP_C_ArrayDealloc(theArray);
                }
                    break;
                case QLDIP_C_Object_type_Map:
                {
                    QLDIP_C_MapRef theMap = (QLDIP_C_MapRef)QLObjRef;
                    QLDIP_C_MapDealloc(theMap);
                }
                    break;
                case QLDIP_C_Object_type_Error:
                {
                    QLDIP_C_ErrorRef theError = (QLDIP_C_ErrorRef)QLObjRef;
                    QLDIP_C_ErrorDealloc(theError);
                }
                    break;
                default:
                {
                    printf("%s 为止的数据类型", __func__);
                }
                    break;
            }
        }else {
            temp->base.refcount = refCount;
        }
        return;
    }
}

static int mallocCount = 0;

void mallocCountAdd()
{
    mallocCount ++;
    printf("%s  mallocCount : %d\n", __func__, mallocCount);
}

void mallocCountSub()
{
    mallocCount --;
    printf("%s  mallocCount : %d\n", __func__, mallocCount);
}

void * QLDIP_C_allocWithInit(size_t size)
{
    void * ret =  QLDIP_C_malloc(size);
    memset(ret, 0, size);
    return ret;
}

void * QLDIP_C_malloc(size_t size)
{
    void * ret =  malloc(size);
    mallocCountAdd();
    return ret;
}

void QLDIP_C_Dealloc(void * ref)
{
    if (NULL == ref) {
        printf("%s : dealloc 一个null 指针 \n", __func__);
        return;
    }
    mallocCountSub();
    free(ref);
}


QLDIP_C_BoolValue QLDIP_C_BaseSysIsBigEndian()
{
    union QLDIP_C_BigEndianUnion
    {
        uint64_t  i;
        char  c;
    };
    union QLDIP_C_BigEndianUnion test;
    test.i = 0;
    test.c = 2;
    
    return  test.i != 2;
}



#pragma mark - <interface>
uint32_t __QLDIP_C_BaseObject_byteLenFromObj(QLDIP_C_Obj *theObj);

#pragma mark - <interface/>
#pragma mark - <------------------------------------------------------------------------>
#pragma mark - <implementation>
#pragma mark - </public>
QLDIP_C_Object_type QLDIP_C_BaseObject_typeFromObj(QLDIP_C_Obj *theObj)
{
    if (NULL == theObj) {
        return QLDIP_C_Object_type_Null;
    }
    
    return theObj->base.objType;
}

uint32_t QLDIP_C_BaseObject_byteLenFromObj(QLDIP_C_Obj *theObj)
{
    return __QLDIP_C_BaseObject_byteLenFromObj(theObj);
}

QLDIP_C_BoolValue QLDIP_C_BaseObjectToByte(QLDIP_C_Obj *theObj, QLDIP_C_Byte *buffer, uint32_t putInBeginIdx, uint32_t *putInLen)
{
    if (NULL == theObj) {
        return QLDIP_C_BoolValue_false;
    }
    if (NULL == buffer) {
        return QLDIP_C_BoolValue_false;
    }
    
    if (NULL != putInLen) {
        *putInLen = 0;
    }
    return QLDIP_C_BoolValue_true;
}
#pragma mark - </public/>

#pragma mark - </private>
uint32_t __QLDIP_C_BaseObject_byteLenFromObj(QLDIP_C_Obj *theObj)
{
    QLDIP_C_Object_type objType = QLDIP_C_BaseObject_typeFromObj(theObj);
    uint32_t retLen = 0;
    switch (objType) {
        case QLDIP_C_Object_type_Number:
        {
            
            
        }
            break;
        case QLDIP_C_Object_type_String:
        {
            
            
        }
            break;
        case QLDIP_C_Object_type_Data:
        {
            
            
        }
            break;
        case QLDIP_C_Object_type_Array:
        {
            
            
        }
            break;
        case QLDIP_C_Object_type_Map:
        {
            
            
        }
            break;
        case QLDIP_C_Object_type_Null:
        {
            
            
        }
            break;
        case QLDIP_C_Object_type_Error://不应该出现
        {
            
            
        }
            break;
            
        default://不应该出现
        {
            
        }
            break;
    }
    
    
    return retLen;
}

void __QLDIP_C_BaseNumberToByte(QLDIP_C_Number *theObj, QLDIP_C_Byte *buffer, uint32_t putInBeginIdx, uint32_t *putInLen)
{
    if (NULL != putInLen) {
        *putInLen = 0;
    }
}

void __QLDIP_C_BaseStringToByte(QLDIP_C_String *theObj, QLDIP_C_Byte *buffer, uint32_t putInBeginIdx, uint32_t *putInLen)
{
    if (NULL != putInLen) {
        *putInLen = 0;
    }
}

void __QLDIP_C_BaseDataToByte(QLDIP_C_Data *theObj, QLDIP_C_Byte *buffer, uint32_t putInBeginIdx, uint32_t *putInLen)
{
    if (NULL != putInLen) {
        *putInLen = 0;
    }
}

void __QLDIP_C_BaseArrayToByte(QLDIP_C_Array *theObj, QLDIP_C_Byte *buffer, uint32_t putInBeginIdx, uint32_t *putInLen)
{
    if (NULL != putInLen) {
        *putInLen = 0;
    }
}

void __QLDIP_C_MapToByte(QLDIP_C_Map *theObj, QLDIP_C_Byte *buffer, uint32_t putInBeginIdx, uint32_t *putInLen)
{
    if (NULL != putInLen) {
        *putInLen = 0;
    }
}



#pragma mark - </private/>
#pragma mark - <implementation/>












