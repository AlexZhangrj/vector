//
//  CSBase.h
//  CSFoundationDemo
//
//  Created by CaiLianfeng on 16/8/26.
//  Copyright © 2016年 WangQinghai. All rights reserved.
//

#ifndef CSBase_h
#define CSBase_h

#include <stdio.h>
#include <pthread.h>

#endif /* CSBase_h */




#pragma mark - <Types>

typedef int Int;
typedef uint UInt;

typedef uint64_t UInt64;
typedef uint32_t UInt32;
typedef uint16_t UInt16;
typedef uint8_t UInt8;

typedef int64_t Int64;
typedef int32_t Int32;
typedef int16_t Int16;
typedef int8_t Int8;

typedef double Double;
typedef float Float;

typedef UInt32 CSObjectType;
typedef struct {
    pthread_mutex_t lock;
    UInt32 refCount;
}CSLock;
typedef CSLock * CSLockRef;
typedef UInt32 CSBool;
static CSBool CSTrue = 1;
static CSBool CSFalse = 0;



#pragma mark - <Types/>
CSLockRef CSLockInit();
void CSLockRetain(CSLockRef lockRef);
void CSLockRelease(CSLockRef lockRef);

void CSLockLock(CSLockRef lockRef);
void CSLockUnlock(CSLockRef lockRef);



typedef struct {
    CSObjectType objType;
    UInt32 refCount;
    CSLockRef lockRef;
    void * valueRef;
}CSObject;

typedef CSObject * CSObjectRef;

//void CSObjectLook(CSObjectRef obj);






CSObjectRef CSObjectInit(CSObjectType objType, CSLockRef lockRef, void *value);
void CSObjectPrint(CSObjectRef obj);



void CSSafeRetain(CSObjectRef obj);
void CSSafeRelease(CSObjectRef obj);

void CSUnsafeRetain(CSObjectRef obj);
void CSUnsafeRelease(CSObjectRef obj);

