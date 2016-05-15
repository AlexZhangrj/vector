//
//  QLLogEnum.h
//  QLLogFrameWork
//
//  Created by 王青海 on 15/10/31.
//  Copyright © 2015年 王青海. All rights reserved.
//

#ifndef QLLogEnum_h
#define QLLogEnum_h



////OutputType
//typedef NS_OPTIONS(NSUInteger, QLLogOptions) {
//    QLLogOptionConsole              = 1 <<  0,//控制台
//    QLLogOptionTCPOutput            = 1 <<  1,//TCP
//    QLLogOptionFile                 = 1 <<  2,//持久化 写入文件
//    QLLogOptionCustom               = 1 <<  3 //自定义
//};


typedef NS_OPTIONS(NSUInteger, QLLogTypeOptions) {
    QLLogTypeOptionConsole              = 1 <<  0,//控制台
    QLLogTypeOptionTCPOutput            = 1 <<  1,//TCP
    QLLogTypeOptionFile                 = 1 <<  2//持久化 写入文件
//    QLLogTypeOptionCustom               = 1 <<  3 //自定义
};


typedef NS_ENUM(NSUInteger, QLLogType) {
    QLLogTypeNormol                 = 0,
    QLLogTypeDebug                  = 1 <<  0,//
    QLLogTypeInfo                   = 1 <<  1,//
    QLLogTypeWarning                = 1 <<  2,//
    QLLogTypeError                  = 1 <<  3, //
    QLLogTypeCrash                  = 1 <<  4 //
};

typedef NS_ENUM(NSUInteger, QLFuncType) {
    QLFuncTypeCfunc                 = 1 <<  0,//
    QLFuncTypeOCfunc                = 1 <<  1//
};


#endif /* QLLogEnum_h */
