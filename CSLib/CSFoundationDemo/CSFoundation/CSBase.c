//
//  CSBase.c
//  CSFoundationDemo
//
//  Created by CaiLianfeng on 16/8/26.
//  Copyright © 2016年 WangQinghai. All rights reserved.
//

#include "CSBase.h"

#include <memory.h>
#include <stdlib.h>


#define __CSLockInit ((pthread_mutex_t)PTHREAD_ERRORCHECK_MUTEX_INITIALIZER)

#define __CSLock(LP) { (void)pthread_mutex_lock(LP); }
#define __CSUnlock(LP) { (void)pthread_mutex_unlock(LP); }

#define __CSDefaultLock { __CSLock(&(lockRef->lock)); }
#define __CSDefaultUnlock { __CSUnlock(&(lockRef->lock)); }

#define __CSRootLock() { (void)pthread_mutex_lock(&__CSRootLock); }
#define __CSRootUnlock() { (void)pthread_mutex_lock(&__CSRootLock); }


static pthread_mutex_t __CSRootLock = __CSLockInit;


CSLockRef CSLockInit() {
    CSLockRef obj = (CSLockRef)malloc(sizeof(CSLockRef));
    obj->refCount = 1;
    pthread_mutex_init(&(obj->lock), NULL);
    return obj;
}
static inline void CSLockDeinit(CSLockRef lockRef) {
    pthread_mutex_destroy(&(lockRef->lock));
    free(lockRef);
}

void CSLockRetain(CSLockRef lockRef) {
    __CSRootLock()
    lockRef->refCount ++;
    __CSRootUnlock()
}
void CSLockRelease(CSLockRef lockRef) {
    __CSRootLock()
    if (lockRef->refCount > 1) {
        lockRef->refCount --;
    }else {
        CSLockDeinit(lockRef);
    }
    __CSRootUnlock()
}
void CSLockLock(CSLockRef lockRef) {
    __CSLock(&(lockRef->lock))
}
void CSLockUnlock(CSLockRef lockRef) {
    __CSUnlock(&(lockRef->lock))
}



static CSLockRef __CSPreferencesLockRef = NULL;

#define __CSRelease { if (lockRef->refCount > 1) { obj->refCount --; }else { CSObjectDeinit(obj);} }


CSObjectRef CSObjectInit(CSObjectType objType, CSLockRef lockRef, void *value) {
    CSObjectRef obj =  (CSObjectRef)malloc(sizeof(CSObjectRef));
    obj->objType = objType;
    obj->refCount = 1;
    if (NULL == lockRef) {
        obj->lockRef = __CSPreferencesLockRef;
    }else {
        obj->lockRef = lockRef;
    }
    obj->valueRef = value;
    return obj;
}


static inline void CSObjectDeinit(CSObjectRef obj) {
    CSLockRelease((CSLockRef)(obj->lockRef));
    free(obj);
}

static inline void __CSUnsafeRetain(CSObjectRef obj) {
    obj->refCount ++;
}

static inline void __CSUnsafeRelease(CSObjectRef obj) {
    if (obj->refCount > 1) {
        obj->refCount --;
    }else {
        CSObjectDeinit(obj);
    }
}


void CSSafeRetain(CSObjectRef obj) {
#if DEBUG
    if (NULL == obj) {
        printf("error: %s obj count't be NULL\n", __func__);
        return;
    }
#endif
    
    CSLockRef lockRef = obj->lockRef;
    __CSDefaultLock
    __CSUnsafeRetain(obj);
    __CSDefaultUnlock
}

void CSSafeRelease(CSObjectRef obj) {
#if DEBUG
    if (NULL == obj) {
        printf("error: %s obj count't be NULL\n", __func__);
        return;
    }
#endif
    CSLockRef lockRef = obj->lockRef;
    __CSDefaultLock
    __CSUnsafeRelease(obj);
    __CSDefaultUnlock
}

void CSUnsafeRetain(CSObjectRef obj) {
#if DEBUG
    if (NULL == obj) {
        printf("error: %s obj count't be NULL\n", __func__);
        return;
    }
#endif
    __CSUnsafeRetain(obj);
}

void CSUnsafeRelease(CSObjectRef obj) {
#if DEBUG
    if (NULL == obj) {
        printf("error: %s obj count't be NULL\n", __func__);
        return;
    }
#endif
    __CSUnsafeRelease(obj);
}


void CSObjectPrint(CSObjectRef obj) {
    printf("obj: %p, type: %llu, refCount: %llu,  lock: %p, value: ", obj, (UInt64)(obj->objType), (UInt64)(obj->refCount),  obj->lockRef);

    if ( 0 == obj->valueRef) {
        printf("NULL\n");
    }else {
        printf("%p\n", obj->valueRef);
    }

}







static CSBool __CSFoundationInited = 0;
void CSFoundationInit() {
    __CSRootLock()
    if (CSFalse == __CSFoundationInited) {
        __CSPreferencesLockRef = CSLockInit();
        __CSFoundationInited = CSTrue;
    }
    __CSRootUnlock()
}



