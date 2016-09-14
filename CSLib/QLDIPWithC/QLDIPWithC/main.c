//
//  main.c
//  QLDIPWithC
//
//  Created by prsoft_mac01 on 15/12/18.
//  Copyright © 2015年 ql. All rights reserved.
//

#include <stdio.h>
#include <string.h>
#include <unistd.h>

#include "QLDIP_C_DIP.h"

#include "QLDIP_C_DIPSerialization.h"

#include "QLDIP_C_headers.h"

#include <time.h>

#include "QLDIP_C_DIPSerializationObjRange.h"


#include "QLDIP_C_DIPSerializationTest.h"

#pragma pack (1)
typedef struct {
    char a;
    uint32_t location;
    uint32_t len;
}QLDIP_C_TT;





int isBigEndian2()
{
    int  i = 1;   /* i = 0x00000001*/
    char  c = *(char  *)&i; /* 注意不能写成 char c = (char)i; */
    return  (int )c != i;
}

int main(int argc, const char * argv[]) {
    // insert code here...
    printf("Hello, World!\n");
    
    
    
    QLDIP_C_DIPSerializationTestTest();
    
//    sleep(15);
//    return 1;
//    QLDIP_C_Array_Deque tt;
//    
//    printf("%lu  %lu\n", sizeof(QLDIP_C_Array_Deque), sizeof(tt));
//    
//    char * str = "0123456789";
//    int len = strlen(str);
//    printf("len : %d\n", len);
    
//    QLDIP_C_StringRef qlsRef = NULL;
//    qlsRef = QLDIP_C_StringCreateWithCharArray(str);
//    
//    QLDIP_C_TT st01;
//    printf("%p %p %d\n", &st01, &(st01.a), sizeof(st01));
//    
//    QLDIP_C_TT st02;
//    printf("%p %p\n", &st02, &(st02.a));
    
    
//    void ** newValue;
//    newValue = &qlsRef;
    
    QLDIP_C_ArrayRef array = QLDIP_C_ArrayCreate();
//    QLDIP_C_ArrayReplaceValues(array, QLDIP_C_RangeMake(0, 0), newValue, 1);
//    
//    for (int i=0; i<1205; i++) {
//        QLDIP_C_ArrayReplaceValues(array, QLDIP_C_RangeMake(0, 0), newValue, 1);
//    }
//    
//    void * ret = QLDIP_C_ArrayGetValueAtIndex(array, 0);
//    QLDIP_C_String * strsss = (QLDIP_C_String *)ret;
//    
//    
//    QLDIP_C_MapRef mapRef = QLDIP_C_MapCreate();
    
    
    
    
//    QLDIP_C_MapSetValueWithStringKey(mapRef, NULL, qlsRef);
    
    
//    char * str1 = "abcdefg";
//    int len1 = strlen(str1);
//    printf("len : %d\n", len1);
    
//    QLDIP_C_StringRef qlsRef1 = NULL;
//    qlsRef1 = QLDIP_C_StringCreateWithCharArray(str1);
    
//    for (int i=0; i<10; i++) {
//        QLDIP_C_MapSetValueWithStringKey(mapRef, NULL, qlsRef1);
//    }
//    QLDIP_C_MapSetValueWithStringKey(mapRef, NULL, qlsRef1);

    clock_t  c1 = clock();
    
    for (int i=0; i<2048; i++) {
//        int i={0};
        
        char key1111[5];
        char *strtttt="0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
//        srand(time(NULL));
        for(int j=0;j<4;j++)
        {
            key1111[j] = strtttt[rand()%3];
        }
        
        key1111[4] = 0;
        printf("key is:%s\n", key1111);

        QLDIP_C_StringRef tempStrRef = QLDIP_C_StringCreateWithCharArray(key1111);

        QLDIP_C_ArrayAppendObject(array, tempStrRef);
        
//        QLDIP_C_MapSetValueWithStringKey(mapRef, tempStrRef, tempStrRef);
        
        QLDIP_C_Release(tempStrRef);
    }

//    for (int i=0; i<2048; i++) {
//        QLDIP_C_ArrayRemoveObjectAtIndex(array, 0);
//    }
    
    
    
    QLDIP_C_Range range = __QLDIP_C_DIPPresetSerializationArrayRange(array, 0);
    
    clock_t  c2 = clock();
    
    printf("t1:%lu t2:%lu sub:%lu\n", c1, c2, c2 - c1);
    
//    QLDIP_C_Release(mapRef);
    QLDIP_C_Release(array);

    printf("%d  %d\n", QLDIP_C_BaseSysIsBigEndian(), isBigEndian2());
    
    
    int a;
    HTONL(a);
//#if BigLittle == 1
//    
//    printf("BigLittle");
//    
//#endif
    
    
//    QLDIP_C_DIPByteFromInt64WithByteLen(15, 4);
    
    
    int64_t num = UINT64_MAX >> 8;
//    QLDIP_C_Byte * byte = QLDIP_C_DIPByteFromInt64WithByteLen(num, 8);
    
    
//    int64_t retN = QLDIP_C_DIPPopIntWithByteLen(byte, 8);
    
    
    for (int i=0; i<6; i++) {
        printf("\n");
    }
    
    QLDIP_C_ArrayRef testProtoArray = QLDIP_C_ArrayCreate();
    
    for (int i=0; i<0; i++) {
        QLDIP_C_StringRef tempTestProtoStr = QLDIP_C_StringCreate();
        QLDIP_C_ArrayAppendObject(testProtoArray, tempTestProtoStr);
        QLDIP_C_Release(tempTestProtoStr);
    }
    
    QLDIP_C_Error *error = NULL;
    QLDIP_C_DataRef testProtoData = QLDIP_C_DIPSerializationQLDIPObjectToByte(testProtoArray, &error);
    
    QLDIP_C_ArrayRef testProtoArray2 = QLDIP_C_DIPSerializationByteToQLDIPObject(testProtoData->data, testProtoData->dataLen, &error);

    int64_t iiiii = QLDIP_C_Node_ProtoFooterVerifyCode;
    
    QLDIP_C_Release(testProtoData);
    QLDIP_C_Release(testProtoArray2);
    QLDIP_C_Release(testProtoArray);

    QLDIP_C_NumberRef numbers[8];
    
    for (int i=0; i<6; i++) {
        printf("\n");
    }
    
    
    QLDIP_C_NumberRef number0 = QLDIP_C_NumberCreateWithInt8(5);
    numbers[0] = number0;
    QLDIP_C_NumberRef number1 = QLDIP_C_NumberCreateWithInt16(456);
    numbers[1] = number1;
    QLDIP_C_NumberRef number2 = QLDIP_C_NumberCreateWithInt32(897521);
    numbers[2] = number2;
    QLDIP_C_NumberRef number3 = QLDIP_C_NumberCreateWithInt64(87897411);
    numbers[3] = number3;
    QLDIP_C_NumberRef number4 = QLDIP_C_NumberCreateWithUInt8(1);
    numbers[4] = number4;
    QLDIP_C_NumberRef number5 = QLDIP_C_NumberCreateWithUInt16(1231);
    numbers[5] = number5;
    QLDIP_C_NumberRef number6 = QLDIP_C_NumberCreateWithUInt32(123444);
    numbers[6] = number6;
    QLDIP_C_NumberRef number7 = QLDIP_C_NumberCreateWithUInt64(9985855);
    numbers[7] = number7;
    

    for (int i=0; i<8; i++) {
        QLDIP_C_NumberRef cuNumber = numbers[i];
        
        int8_t test8 = QLDIP_C_NumberInt8Value(cuNumber);
        int16_t test16 = QLDIP_C_NumberInt16Value(cuNumber);
        int32_t test32 = QLDIP_C_NumberInt32Value(cuNumber);
        int64_t test64 = QLDIP_C_NumberInt64Value(cuNumber);

        
        printf("%lld %lld %lld %lld\n", (uint64_t)test8, (uint64_t)test16, (uint64_t)test32, (uint64_t)test64);
        
        
    }
    
//    __QLDIP_C_DIPPresetSerializationNumberToByte(NULL);
    
    int64_t nnnnnnn = 4294967295 + 0;
    
    int32_t num111 = (int32_t)nnnnnnn;
    uint32_t num222 = (uint32_t)nnnnnnn;
    
    int64_t nnnnn = 0;

    
    nnnnn = (int64_t)num111;
    printf("%lld   ", nnnnn);
    nnnnn = (int64_t)num222;
    printf("%lld   \n", nnnnn);

    
    sleep(5);
    
    
     sleep(5);
    
    
     sleep(5);
    
    
     sleep(5);
    
    
     sleep(5);
    
    return 0;
}
#pragma pack ()