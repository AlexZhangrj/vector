//
//  main.c
//  CSFoundationDemo
//
//  Created by CaiLianfeng on 16/8/26.
//  Copyright © 2016年 WangQinghai. All rights reserved.
//

#include <stdio.h>
#include <time.h>
#include <unistd.h>

#include "CSFoundation.h"



int main(int argc, const char * argv[]) {
    CSFoundationInit();
    CSLockRef lockRef = CSLockInit();
    for (int index = 0; index < 10000; index ++) {
//        CSObjectRef obj = CSObjectInit(1, NULL, NULL);
//        
//        CSObjectPrint(obj);
//        
//        CSSafeRetain(obj)
//        CSObjectPrint(obj);
//        
//        CSSafeRetain(obj)
//        CSObjectPrint(obj);
//        
//        CSSafeRetain(obj)
//        CSObjectPrint(obj);
        
        CSLockRetain(lockRef);
        
        printf("%d\n", index);
    }
    CSSafeRetain(NULL);

    
    return 0;
}
