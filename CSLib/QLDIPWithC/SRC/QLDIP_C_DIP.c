//
//  QLDIP_C_DIP.c
//  QLDIPWithC
//
//  Created by WangQinghai on 15/12/28.
//  Copyright © 2015年 ql. All rights reserved.
//

#include "QLDIP_C_DIP.h"

#include "QLDIP_C_Array.h"
#include "QLDIP_C_Error.h"
#include "QLDIP_C_Data.h"
#include "QLDIP_C_DIPSerialization.h"
#include "QLDIP_C_DIPSerializationObjRange.h"



#pragma mark - <interface>

//QLDIP_C_Byte * Byte;


typedef struct {
    uint32_t expandIntervalLen;
    QLDIP_C_Range expandIntervalLenByteRange;
    QLDIP_C_Byte *byte;
    QLDIP_C_Range byteRange;
}__QLDIP_C_NodeProtoExpand;
typedef __QLDIP_C_NodeProtoExpand * __QLDIP_C_NodeProtoExpandRef;

typedef struct {
    QLDIP_C_NodeBase nodeBase;
    uint32_t headerVerifyCode;
    QLDIP_C_Range headerVerifyCodeByteRange;
    uint32_t headerLen;
    QLDIP_C_Range headerLenByteRange;
    uint32_t version;
    QLDIP_C_Range versionByteRange;
    __QLDIP_C_NodeProtoExpand headerExpand;
}__QLDIP_C_NodeProtoHeader;
typedef __QLDIP_C_NodeProtoHeader * __QLDIP_C_NodeProtoHeaderRef;

typedef struct {
//    uint32_t bodyCount;
//    QLDIP_C_Range bodyCountByteRange;
//    uint32_t bodysTotalLen;
//    QLDIP_C_Range bodysTotalLenByteRange;
    uint32_t bodyLen;
    QLDIP_C_Range bodyLenByteRange;
    QLDIP_C_Byte * bodyByte;
    QLDIP_C_Range bodyByteRange;
}__QLDIP_C_NodeProtoBody;
typedef __QLDIP_C_NodeProtoBody * __QLDIP_C_NodeProtoBodyRef;

typedef struct {
    QLDIP_C_NodeBase nodeBase;
    uint32_t footerVerifyCode;
    QLDIP_C_Range footerVerifyCodeByteRange;
}__QLDIP_C_NodeProtoFooter;
typedef __QLDIP_C_NodeProtoFooter * __QLDIP_C_NodeProtoFooterRef;

typedef struct {
    QLDIP_C_NodeBase nodeBase;
    __QLDIP_C_NodeProtoHeader header;
    __QLDIP_C_NodeProtoBody body;
    __QLDIP_C_NodeProtoFooter footer;
}__QLDIP_C_NodeProto;
typedef __QLDIP_C_NodeProto * __QLDIP_C_NodeProtoRef;

typedef struct {
    uint32_t bodyLen;
    QLDIP_C_Range bodyLenByteRange;
    QLDIP_C_Byte * bodyItemByte;
    QLDIP_C_Range bodyItemByteRange;
}__QLDIP_C_NodeProtoBodyItem;
typedef __QLDIP_C_NodeProtoBodyItem * __QLDIP_C_NodeProtoBodyItemRef;



int64_t __QLDIP_C_DataPopInt64(QLDIP_C_DataRef theData, QLDIP_C_Range byteRange, QLDIP_C_Error ** errRefRef);

int64_t __QLDIP_C_DIPPopInt64(QLDIP_C_Byte * theByte, QLDIP_C_Range byteRange);

int64_t __QLDIP_C_DIPPopInt64WithRangeWithErrorRefRef(QLDIP_C_Byte * byte, QLDIP_C_Range range, QLDIP_C_Error ** errRefRef);

QLDIP_C_Byte * __QLDIP_C_DIPByteFromInt64WithByteLenWithBufferRef(int64_t number, uint32_t byteLen, QLDIP_C_Byte ** bufferNumByte);

void __QLDIP_C_DIPPushByteWithIntWithByteRangeWithBufferRef(int64_t number, QLDIP_C_Range range , QLDIP_C_Byte ** bufferNumByte);

QLDIP_C_ObjRef __QLDIP_C_DIPSerializationBodyItemByteToQLDIPObject(QLDIP_C_Byte * byte, uint32_t byteLen, QLDIP_C_Error ** errRefRef);

uint32_t __QLDIP_C_DIPReadObjectByteObjLen(QLDIP_C_Byte * theByte, QLDIP_C_Range range, QLDIP_C_Error ** errRefRef);


void __QLDIP_C_DIPPushHeaderExpandWithHeaderExpandWithBufferRef(__QLDIP_C_NodeProtoExpandRef headerExpandRef, QLDIP_C_Byte ** bufferByte);


#pragma mark - <interface/>

#pragma mark - <------------------------------------------------------------------------>

#pragma mark - <implementation>

#pragma mark - </public>

QLDIP_C_ArrayRef QLDIP_C_DIPSerializationByteToQLDIPObject(QLDIP_C_Byte * byte, uint32_t byteLen, QLDIP_C_Error ** errRefRef)
{
    QLDIP_C_Array * array = QLDIP_C_ArrayCreate();
    if (NULL == array) {
        if (NULL != errRefRef) {
            *errRefRef = QLDIP_C_ErrorCreateWithCharArrayAndErrorCode("返回值 开辟空间失败", QLDIP_C_ErrorCode_MallocFaild);
        }
        return NULL;
    }
    
    QLDIP_C_Error *tempErrRefRef = NULL;
    QLDIP_C_NodeProto nodeProto;
    
    QLDIP_C_Byte *tempByte = byte;
    uint32_t tempByteIdx = 0;
    
    
    //    tempRange.len = 8;
//    tempByteIdx += 4;
    if (tempByteIdx >= byteLen - QLDIP_C_Node_ProtoHeaderVerifyCodeLen) {
        if (NULL != errRefRef) {
            *errRefRef = QLDIP_C_ErrorCreateWithCharArrayAndErrorCode("数据长度不够", QLDIP_C_ErrorCode_DIP_LenthNotEnough);
        }
        QLDIP_C_Release(array);
        return NULL;
    }
    
//    nodeProto.headerVerifyCode = QLDIP_C_DIPPopUInt32WithBeginIdxWithErrorRefRef(tempByte, tempByteIdx, &tempErrRefRef);
    
    int64_t headerVerifyCode64 = QLDIP_C_DIPReadIntThenOffsetMutableBeginIdxWithIntByteWithErrorRefRef(tempByte, &tempByteIdx, QLDIP_C_Node_ProtoHeaderVerifyCodeLen, &tempErrRefRef);
    nodeProto.header.headerVerifyCode = (uint32_t)headerVerifyCode64;
    if (NULL != tempErrRefRef) {
        if (NULL != errRefRef) {
            *errRefRef = tempErrRefRef;
            QLDIP_C_Release(array);
            return NULL;
        }else {
            QLDIP_C_Release(array);
            QLDIP_C_Release(tempErrRefRef);
            return NULL;
        }
    }
    
    
    if (tempByteIdx >= byteLen - QLDIP_C_Node_ProtoHeaderLen) {
        if (NULL != errRefRef) {
            *errRefRef = QLDIP_C_ErrorCreateWithCharArrayAndErrorCode("数据长度不够", QLDIP_C_ErrorCode_DIP_LenthNotEnough);
        }
        QLDIP_C_Release(array);
        return NULL;
    }
    int64_t headerLen64 = QLDIP_C_DIPReadIntThenOffsetMutableBeginIdxWithIntByteWithErrorRefRef(tempByte, &tempByteIdx, QLDIP_C_Node_ProtoHeaderLen, &tempErrRefRef);
    nodeProto.header.headerLen = (uint32_t)headerLen64;
    if (NULL != tempErrRefRef) {
        if (NULL != errRefRef) {
            *errRefRef = tempErrRefRef;
            QLDIP_C_Release(array);
            return NULL;
        }else {
            QLDIP_C_Release(array);
            QLDIP_C_Release(tempErrRefRef);
            return NULL;
        }
    }
    
    
    QLDIP_C_Range headerRange = QLDIP_C_RangeMake(tempByteIdx, nodeProto.header.headerLen);
    
    
//    tempByteIdx += headerLen;
    if (tempByteIdx >= byteLen - QLDIP_C_Node_ProtoVersionLen) {
        if (NULL != errRefRef) {
            *errRefRef = QLDIP_C_ErrorCreateWithCharArrayAndErrorCode("数据长度不够", QLDIP_C_ErrorCode_DIP_LenthNotEnough);
        }
        QLDIP_C_Release(array);
        return NULL;
    }
    
    int64_t version64 = QLDIP_C_DIPReadIntThenOffsetMutableBeginIdxWithIntByteWithErrorRefRef(tempByte, &tempByteIdx, QLDIP_C_Node_ProtoVersionLen, &tempErrRefRef);
    
    nodeProto.header.version = (uint32_t)version64;
    if (NULL != tempErrRefRef) {
        if (NULL != errRefRef) {
            *errRefRef = tempErrRefRef;
            QLDIP_C_Release(array);
            return NULL;
        }else {
            QLDIP_C_Release(array);
            QLDIP_C_Release(tempErrRefRef);
            return NULL;
        }
    }
    
    
    if (tempByteIdx >= byteLen - QLDIP_C_Node_ProtoHeaderExpandLen) {
        if (NULL != errRefRef) {
            *errRefRef = QLDIP_C_ErrorCreateWithCharArrayAndErrorCode("数据长度不够", QLDIP_C_ErrorCode_DIP_LenthNotEnough);
        }
        QLDIP_C_Release(array);
        return NULL;
    }
    
    int64_t expandIntervalLen64 = QLDIP_C_DIPReadIntThenOffsetMutableBeginIdxWithIntByteWithErrorRefRef(tempByte, &tempByteIdx, QLDIP_C_Node_ProtoHeaderExpandLen, &tempErrRefRef);
    nodeProto.header.headerExpand.expandIntervalLen = (uint32_t)expandIntervalLen64;
    
    if (expandIntervalLen64 > 0) {
        nodeProto.header.headerExpand.byte = &(tempByte[tempByteIdx]);
    }else {
        nodeProto.header.headerExpand.byte = NULL;
    }
    
    if (NULL != tempErrRefRef) {
        if (NULL != errRefRef) {
            *errRefRef = tempErrRefRef;
            QLDIP_C_Release(array);
            return NULL;
        }else {
            QLDIP_C_Release(array);
            QLDIP_C_Release(tempErrRefRef);
            return NULL;
        }
    }
    
    
    QLDIP_C_Range headerExpandRange = QLDIP_C_RangeMake(tempByteIdx, nodeProto.header.headerExpand.expandIntervalLen);
    
    
    
    
    //body 部分
    uint32_t bodyBeginIdx = 0 + QLDIP_C_Node_ProtoHeaderVerifyCodeLen + QLDIP_C_Node_ProtoHeaderLen + QLDIP_C_Node_ProtoVersionLen + QLDIP_C_Node_ProtoHeaderExpandLen + nodeProto.header.headerExpand.expandIntervalLen;
    uint32_t tempBodyIdx = bodyBeginIdx;
    
//    int64_t bodysCount64 = QLDIP_C_DIPReadIntThenOffsetMutableBeginIdxWithIntByteWithErrorRefRef(tempByte, &tempBodyIdx, QLDIP_C_Node_ProtoBodyCountLen, &tempErrRefRef);
//    nodeProto.body.bodyCount = (int32_t)bodysCount64;
//    if (NULL != tempErrRefRef) {
//        if (NULL != errRefRef) {
//            *errRefRef = tempErrRefRef;
//            QLDIP_C_Release(array);
//            return NULL;
//        }else {
//            QLDIP_C_Release(array);
//            QLDIP_C_Release(tempErrRefRef);
//            return NULL;
//        }
//    }
//    
//    int64_t bodysTotalLen64 = QLDIP_C_DIPReadIntThenOffsetMutableBeginIdxWithIntByteWithErrorRefRef(tempByte, &tempBodyIdx, QLDIP_C_Node_ProtoBodysTotalLen, &tempErrRefRef);
//    nodeProto.body.bodysTotalLen = (int32_t)bodysTotalLen64;
//    if (NULL != tempErrRefRef) {
//        if (NULL != errRefRef) {
//            *errRefRef = tempErrRefRef;
//            QLDIP_C_Release(array);
//            return NULL;
//        }else {
//            QLDIP_C_Release(array);
//            QLDIP_C_Release(tempErrRefRef);
//            return NULL;
//        }
//    }
    
    

    int64_t bodyByteLen = QLDIP_C_DIPReadIntThenOffsetMutableBeginIdxWithIntByteWithErrorRefRef(tempByte, &tempBodyIdx, QLDIP_C_Node_ProtoBodysTotalLen, &tempErrRefRef);
    nodeProto.body.bodyLen = (int32_t)bodyByteLen;

    
    nodeProto.body.bodyByte = &(tempByte[tempBodyIdx]);
    //    int64_t bodyByteLen = QLDIP_C_DIPReadIntWithBeginIdxWithIntByteWithErrorRefRef(tempByte, tempBodyIdx, 4, &tempErrRefRef);
    
    if (NULL != tempErrRefRef) {
        if (NULL != errRefRef) {
            *errRefRef = tempErrRefRef;
            QLDIP_C_Release(array);
            return NULL;
        }else {
            QLDIP_C_Release(array);
            QLDIP_C_Release(tempErrRefRef);
            return NULL;
        }
    }
    tempBodyIdx += nodeProto.body.bodyLen;
    
    
//    QLDIP_C_Range bodysItemsRange = QLDIP_C_RangeMake(tempBodyIdx, (uint32_t)bodysTotalLen64);

    
    
//    tempBodyIdx += QLDIP_C_Node_ProtoVersionLen;
//    if (tempBodyIdx >= byteLen) {
//        if (NULL != errRefRef) {
//            *errRefRef = QLDIP_C_ErrorCreateWithCharArrayAndErrorCode("数据长度不够", QLDIP_C_ErrorCode_DIP_LenthNotEnough);
//        }
//        QLDIP_C_Release(array);
//        return NULL;
//    }
//    
//    uint32_t bodysTotalLen = QLDIP_C_DIPPopUInt32WithBeginIdxWithErrorRefRef(tempByte, tempBodyIdx, &tempErrRefRef);
//    if (NULL != tempErrRefRef) {
//        if (NULL != errRefRef) {
//            *errRefRef = tempErrRefRef;
//            QLDIP_C_Release(array);
//            return NULL;
//        }else {
//            QLDIP_C_Release(array);
//            QLDIP_C_Release(tempErrRefRef);
//            return NULL;
//        }
//    }
    
    
    //footer 部分
    uint32_t footerBeginIdx = tempBodyIdx;
    uint32_t tempFooterIdx = footerBeginIdx;
    int64_t footerVerifyCode64 = QLDIP_C_DIPReadIntThenOffsetMutableBeginIdxWithIntByteWithErrorRefRef(tempByte, &tempFooterIdx, QLDIP_C_Node_ProtoBodysTotalLen, &tempErrRefRef);
    nodeProto.footer.footerVerifyCode = (int32_t)footerVerifyCode64;
    
    if (NULL != tempErrRefRef) {
        if (NULL != errRefRef) {
            *errRefRef = tempErrRefRef;
            QLDIP_C_Release(array);
            return NULL;
        }else {
            QLDIP_C_Release(array);
            QLDIP_C_Release(tempErrRefRef);
            return NULL;
        }
    }
    //    nodeProto.
    
    
    return array;
}

//43   4+4+4+2+1+4+ 4*6 4
//     19 + 28



QLDIP_C_DataRef QLDIP_C_DIPSerializationQLDIPObjectToByte(QLDIP_C_ArrayRef nodes, QLDIP_C_Error ** errRefRef)
{
    __QLDIP_C_NodeProto nodeProto;
    
    uint32_t tempByteIdx = 0;
    
//proto/header
//proto/header/headerVerifyCode
    nodeProto.header.headerVerifyCode = QLDIP_C_Node_ProtoHeaderVerifyCode;
    nodeProto.header.headerVerifyCodeByteRange = QLDIP_C_RangeMake(tempByteIdx, QLDIP_C_Node_ProtoHeaderVerifyCodeLen);
    tempByteIdx += QLDIP_C_Node_ProtoHeaderVerifyCodeLen;

    
//proto/header/headerLen
    nodeProto.header.headerLen = 0;//----------需要在完成header.headerExpand部分后进行赋值, headerLen = QLDIP_C_Node_ProtoVersionLen + QLDIP_C_Node_ProtoHeaderExpandLen + nodeProto.header.headerExpand.expandIntervalLen;
    nodeProto.header.headerLenByteRange = QLDIP_C_RangeMake(tempByteIdx, QLDIP_C_Node_ProtoHeaderLen);
    tempByteIdx += QLDIP_C_Node_ProtoHeaderLen;
    
    
//proto/header/version
    nodeProto.header.version = QLDIP_C_Node_ProtoVersion;
    nodeProto.header.versionByteRange = QLDIP_C_RangeMake(tempByteIdx, QLDIP_C_Node_ProtoVersionLen);
    tempByteIdx += QLDIP_C_Node_ProtoVersionLen;
    
    
//proto/header/headerExpected
//proto/header/headerExpected/headerExpectedLen
    nodeProto.header.headerExpand.expandIntervalLen = 0;//----------需要在完成header.headerExpand.expandIntervalLenByte部分后进行赋值
    
    
    nodeProto.header.headerExpand.expandIntervalLenByteRange = QLDIP_C_RangeMake(tempByteIdx, QLDIP_C_Node_ProtoHeaderExpandLen);
    tempByteIdx += QLDIP_C_Node_ProtoHeaderExpandLen;
    
//proto/header/headerExpected/headerExpectedByte
    //根据版本需要 当前1版本没有用到
    nodeProto.header.headerExpand.byte = NULL;
    nodeProto.header.headerExpand.byteRange = QLDIP_C_RangeMake(tempByteIdx, 0);
    nodeProto.header.headerExpand.expandIntervalLen = 0;
    
    /*
     如果需要 则
     nodeProto.header.headerExpand.byte = &(tempByte[tempByteIdx]);
     nodeProto.header.headerExpand.expandIntervalLen = nodeProto.header.headerExpand.byte 所需的长度;
     nodeProto.header.headerExpand.byteRange = QLDIP_C_RangeMake(tempByteIdx, nodeProto.header.headerExpand.expandIntervalLen);
     tempByteIdx += nodeProto.header.headerExpand.expandIntervalLen;
     */
    nodeProto.header.headerLen = QLDIP_C_Node_ProtoVersionLen + QLDIP_C_Node_ProtoHeaderExpandLen + nodeProto.header.headerExpand.expandIntervalLen;
    
    
    
//proto/body
//proto/body/bodyCount
    nodeProto.body.bodyLenByteRange = QLDIP_C_RangeMake(tempByteIdx, QLDIP_C_Node_ProtoBodyLenLen);
    tempByteIdx += QLDIP_C_Node_ProtoBodyLenLen;

    
    nodeProto.body.bodyByteRange = __QLDIP_C_DIPPresetSerializationArrayRange(nodes,tempByteIdx);
    nodeProto.body.bodyLen = nodeProto.body.bodyByteRange.len;

    
    
    tempByteIdx += nodeProto.body.bodyByteRange.len;
    
//    nodeProto.body.bodyCount = nodes->count;//----------等于nodes 个数
//    nodeProto.body.bodyCountByteRange = QLDIP_C_RangeMake(tempByteIdx, QLDIP_C_Node_ProtoBodyCountLen);
//    tempByteIdx += QLDIP_C_Node_ProtoBodyCountLen;
//    
//    
////proto/body/bodysTotalLen
////    if (tempByteIdx >= byteLen - QLDIP_C_Node_ProtoBodysTotalLen) {
////        QLDIP_C_DataResetExpectedBufferLen(retData, sizeof(QLDIP_C_Byte) * tempByteIdx);
////        byteLen = retData->bufferLen;
////        return NULL;
////    }
//    nodeProto.body.bodysTotalLen = 0;//----------需要在确定 bodys 数据长度之后赋值
//    nodeProto.body.bodysTotalLenByteRange = QLDIP_C_RangeMake(tempByteIdx, QLDIP_C_Node_ProtoBodysTotalLen);
//    tempByteIdx += QLDIP_C_Node_ProtoBodysTotalLen;
//    
////proto/body/bodybyte
//    nodeProto.body.bodyByte = NULL;
//    nodeProto.body.bodyByteRange = QLDIP_C_RangeMake(tempByteIdx, 0);
//    
//    if (nodeProto.body.bodyCount > 0) {
//
//        QLDIP_C_Byte *bodyByte = nodeProto.body.bodyByte;
//        uint32_t bodyByteIdx = 0;
//        uint32_t bodyItemsTotalLen = 0;
//        for (int i=0; i<nodeProto.body.bodyCount; i++) {
//            __QLDIP_C_NodeProtoBodyItem
//            
//            
//            QLDIP_C_Obj *tempItem = (QLDIP_C_Obj *)QLDIP_C_ArrayGetValueAtIndex(nodes, i);
//            uint32_t tempItemLen = QLDIP_C_BaseObject_byteLenFromObj(tempItem);
//            bodyItemsTotalLen += tempItemLen;
//        }
//        
//        nodeProto.body.bodysTotalLen = bodyItemsTotalLen;
//        nodeProto.body.bodyByteRange = QLDIP_C_RangeMake(tempByteIdx, bodyItemsTotalLen);
//        
//        tempByteIdx += bodyItemsTotalLen;
//    }else {
//        
//    
//    }
    
    
    
    
//proto/footer
//proto/footer/footerVerifyCode
//    if (tempByteIdx >= byteLen - QLDIP_C_Node_ProtoFooterVerifyCodeLen) {
//        QLDIP_C_DataResetExpectedBufferLen(retData, sizeof(QLDIP_C_Byte) * tempByteIdx);
//        byteLen = retData->bufferLen;
//        return NULL;
//    }
    nodeProto.footer.footerVerifyCode = QLDIP_C_Node_ProtoFooterVerifyCode;
    nodeProto.footer.footerVerifyCodeByteRange = QLDIP_C_RangeMake(tempByteIdx, QLDIP_C_Node_ProtoFooterVerifyCodeLen);
    tempByteIdx += QLDIP_C_Node_ProtoFooterVerifyCodeLen;
    
    
    
    //proto 压数据
    uint32_t protoNeedBufferLen = tempByteIdx;
//    uint32_t pushIdx = 0;
    
    QLDIP_C_DataRef retData = QLDIP_C_DataCreateWithExpectedBufferLen(sizeof(QLDIP_C_Byte) * protoNeedBufferLen);
    if (NULL == retData) {
        if (NULL != errRefRef) {
            *errRefRef = QLDIP_C_ErrorCreateWithCharArrayAndErrorCode("返回值 开辟空间失败", QLDIP_C_ErrorCode_DIP_TargetNull);
        }
        
        return NULL;
    }
    
    
    
    __QLDIP_C_DIPPushByteWithIntWithByteRangeWithBufferRef((int64_t)nodeProto.header.headerVerifyCode, nodeProto.header.headerVerifyCodeByteRange, &(retData->data));
    
    __QLDIP_C_DIPPushByteWithIntWithByteRangeWithBufferRef((int64_t)nodeProto.header.headerLen, nodeProto.header.headerLenByteRange, &(retData->data));
    
    __QLDIP_C_DIPPushByteWithIntWithByteRangeWithBufferRef((int64_t)nodeProto.header.version, nodeProto.header.versionByteRange, &(retData->data));
    
//    __QLDIP_C_DIPPushByteWithIntWithByteRangeWithBufferRef((int64_t)nodeProto.header.headerExpand.expandIntervalLen, nodeProto.header.headerExpand.expandIntervalLenByteRange, &(retData->data));
    
    //压头拓展区
    __QLDIP_C_DIPPushHeaderExpandWithHeaderExpandWithBufferRef(&(nodeProto.header.headerExpand), &(retData->data));
    
    __QLDIP_C_DIPPushByteWithIntWithByteRangeWithBufferRef((int64_t)nodeProto.body.bodyLen, nodeProto.body.bodyLenByteRange, &(retData->data));

    //压array 转化的body
//    __QLDIP_C_DIPPushByteWithIntWithByteRangeWithBufferRef((int64_t)nodeProto.body.bodyByte, nodeProto.body.bodyByteRange, &(retData->data));
    
    __QLDIP_C_DIPPushByteWithIntWithByteRangeWithBufferRef((int64_t)nodeProto.footer.footerVerifyCode, nodeProto.footer.footerVerifyCodeByteRange, &(retData->data));
    
    
    
//    //    nodeProto.headerVerifyCode = QLDIP_C_DIPPopUInt32WithBeginIdxWithErrorRefRef(tempByte, tempByteIdx, &tempErrRefRef);
//    
//    int64_t headerVerifyCode64 = QLDIP_C_DIPReadIntThenOffsetMutableBeginIdxWithIntByteWithErrorRefRef(tempByte, &tempByteIdx, QLDIP_C_Node_ProtoHeaderVerifyCodeLen, &tempErrRefRef);
//    nodeProto.header.headerVerifyCode = (uint32_t)headerVerifyCode64;
//    if (NULL != tempErrRefRef) {
//        if (NULL != errRefRef) {
//            *errRefRef = tempErrRefRef;
//            QLDIP_C_Release(array);
//            return NULL;
//        }else {
//            QLDIP_C_Release(array);
//            QLDIP_C_Release(tempErrRefRef);
//            return NULL;
//        }
//    }
//    
//    
//    if (tempByteIdx >= byteLen - QLDIP_C_Node_ProtoHeaderLen) {
//        if (NULL != errRefRef) {
//            *errRefRef = QLDIP_C_ErrorCreateWithCharArrayAndErrorCode("数据长度不够", QLDIP_C_ErrorCode_DIP_LenthNotEnough);
//        }
//        QLDIP_C_Release(array);
//        return NULL;
//    }
//    int64_t headerLen64 = QLDIP_C_DIPReadIntThenOffsetMutableBeginIdxWithIntByteWithErrorRefRef(tempByte, &tempByteIdx, QLDIP_C_Node_ProtoHeaderLen, &tempErrRefRef);
//    nodeProto.header.headerLen = (uint32_t)headerLen64;
//    if (NULL != tempErrRefRef) {
//        if (NULL != errRefRef) {
//            *errRefRef = tempErrRefRef;
//            QLDIP_C_Release(array);
//            return NULL;
//        }else {
//            QLDIP_C_Release(array);
//            QLDIP_C_Release(tempErrRefRef);
//            return NULL;
//        }
//    }
//    
//    
//    QLDIP_C_Range headerRange = QLDIP_C_RangeMake(tempByteIdx, nodeProto.header.headerLen);
//    
//    
//    //    tempByteIdx += headerLen;
//    if (tempByteIdx >= byteLen - QLDIP_C_Node_ProtoVersionLen) {
//        if (NULL != errRefRef) {
//            *errRefRef = QLDIP_C_ErrorCreateWithCharArrayAndErrorCode("数据长度不够", QLDIP_C_ErrorCode_DIP_LenthNotEnough);
//        }
//        QLDIP_C_Release(array);
//        return NULL;
//    }
//    
//    int64_t version64 = QLDIP_C_DIPReadIntThenOffsetMutableBeginIdxWithIntByteWithErrorRefRef(tempByte, &tempByteIdx, QLDIP_C_Node_ProtoVersionLen, &tempErrRefRef);
//    
//    nodeProto.header.version = (uint32_t)version64;
//    if (NULL != tempErrRefRef) {
//        if (NULL != errRefRef) {
//            *errRefRef = tempErrRefRef;
//            QLDIP_C_Release(array);
//            return NULL;
//        }else {
//            QLDIP_C_Release(array);
//            QLDIP_C_Release(tempErrRefRef);
//            return NULL;
//        }
//    }
//    
//    
//    if (tempByteIdx >= byteLen - QLDIP_C_Node_ProtoHeaderExpandLen) {
//        if (NULL != errRefRef) {
//            *errRefRef = QLDIP_C_ErrorCreateWithCharArrayAndErrorCode("数据长度不够", QLDIP_C_ErrorCode_DIP_LenthNotEnough);
//        }
//        QLDIP_C_Release(array);
//        return NULL;
//    }
//    
//    int64_t expandIntervalLen64 = QLDIP_C_DIPReadIntThenOffsetMutableBeginIdxWithIntByteWithErrorRefRef(tempByte, &tempByteIdx, QLDIP_C_Node_ProtoHeaderExpandLen, &tempErrRefRef);
//    nodeProto.header.headerExpand.expandIntervalLen = (uint32_t)expandIntervalLen64;
//    
//    if (expandIntervalLen64 > 0) {
//        nodeProto.header.headerExpand.byte = &(tempByte[tempByteIdx]);
//    }else {
//        nodeProto.header.headerExpand.byte = NULL;
//    }
//    
//    if (NULL != tempErrRefRef) {
//        if (NULL != errRefRef) {
//            *errRefRef = tempErrRefRef;
//            QLDIP_C_Release(array);
//            return NULL;
//        }else {
//            QLDIP_C_Release(array);
//            QLDIP_C_Release(tempErrRefRef);
//            return NULL;
//        }
//    }
//    
//    
//    QLDIP_C_Range headerExpandRange = QLDIP_C_RangeMake(tempByteIdx, nodeProto.header.headerExpand.expandIntervalLen);
//    
//    
//    
//    
//    //body 部分
//    uint32_t bodyBeginIdx = 0 + QLDIP_C_Node_ProtoHeaderVerifyCodeLen + QLDIP_C_Node_ProtoHeaderLen + QLDIP_C_Node_ProtoVersionLen + QLDIP_C_Node_ProtoHeaderExpandLen + nodeProto.header.headerExpand.expandIntervalLen;
//    uint32_t tempBodyIdx = bodyBeginIdx;
//    
//    int64_t bodysCount64 = QLDIP_C_DIPReadIntThenOffsetMutableBeginIdxWithIntByteWithErrorRefRef(tempByte, &tempBodyIdx, QLDIP_C_Node_ProtoBodyCountLen, &tempErrRefRef);
//    nodeProto.body.bodyCount = (int32_t)bodysCount64;
//    if (NULL != tempErrRefRef) {
//        if (NULL != errRefRef) {
//            *errRefRef = tempErrRefRef;
//            QLDIP_C_Release(array);
//            return NULL;
//        }else {
//            QLDIP_C_Release(array);
//            QLDIP_C_Release(tempErrRefRef);
//            return NULL;
//        }
//    }
//    
//    int64_t bodysTotalLen64 = QLDIP_C_DIPReadIntThenOffsetMutableBeginIdxWithIntByteWithErrorRefRef(tempByte, &tempBodyIdx, QLDIP_C_Node_ProtoBodysTotalLen, &tempErrRefRef);
//    nodeProto.body.bodysTotalLen = (int32_t)bodysTotalLen64;
//    if (NULL != tempErrRefRef) {
//        if (NULL != errRefRef) {
//            *errRefRef = tempErrRefRef;
//            QLDIP_C_Release(array);
//            return NULL;
//        }else {
//            QLDIP_C_Release(array);
//            QLDIP_C_Release(tempErrRefRef);
//            return NULL;
//        }
//    }
//    
//    nodeProto.body.bodyByte = &(tempByte[tempBodyIdx]);
//    
//    QLDIP_C_Range bodysItemsRange = QLDIP_C_RangeMake(tempBodyIdx, (uint32_t)bodysTotalLen64);
//    
//    
//    
//    //    tempBodyIdx += QLDIP_C_Node_ProtoVersionLen;
//    //    if (tempBodyIdx >= byteLen) {
//    //        if (NULL != errRefRef) {
//    //            *errRefRef = QLDIP_C_ErrorCreateWithCharArrayAndErrorCode("数据长度不够", QLDIP_C_ErrorCode_DIP_LenthNotEnough);
//    //        }
//    //        QLDIP_C_Release(array);
//    //        return NULL;
//    //    }
//    //
//    //    uint32_t bodysTotalLen = QLDIP_C_DIPPopUInt32WithBeginIdxWithErrorRefRef(tempByte, tempBodyIdx, &tempErrRefRef);
//    //    if (NULL != tempErrRefRef) {
//    //        if (NULL != errRefRef) {
//    //            *errRefRef = tempErrRefRef;
//    //            QLDIP_C_Release(array);
//    //            return NULL;
//    //        }else {
//    //            QLDIP_C_Release(array);
//    //            QLDIP_C_Release(tempErrRefRef);
//    //            return NULL;
//    //        }
//    //    }
//    
//    
//    //footer 部分
//    uint32_t footerBeginIdx = bodysItemsRange.location + bodysItemsRange.len;
//    uint32_t tempFooterIdx = footerBeginIdx;
//    int64_t footerVerifyCode64 = QLDIP_C_DIPReadIntThenOffsetMutableBeginIdxWithIntByteWithErrorRefRef(tempByte, &tempFooterIdx, QLDIP_C_Node_ProtoBodysTotalLen, &tempErrRefRef);
//    nodeProto.footer.footerVerifyCode = (int32_t)footerVerifyCode64;
//    
//    if (NULL != tempErrRefRef) {
//        if (NULL != errRefRef) {
//            *errRefRef = tempErrRefRef;
//            QLDIP_C_Release(array);
//            return NULL;
//        }else {
//            QLDIP_C_Release(array);
//            QLDIP_C_Release(tempErrRefRef);
//            return NULL;
//        }
//    }
    //    nodeProto.
    
    

    //-------/
    
    return retData;
}




int64_t QLDIP_C_DIPPopIntWithByteLen(QLDIP_C_Byte * byte, uint32_t popLen)
{
    int64_t num = 0;
    QLDIP_C_Byte * numByte = (QLDIP_C_Byte *)(&num);
    if (NULL == byte) {
        return num;
    }
    if (QLDIP_C_ENDIAN_Little) {
        for (int i=0; i<popLen; i++) {
            numByte[i] = byte[popLen-i-1];
        }
    }else {
        for (int i=0; i<popLen; i++) {
            numByte[8-popLen+i] = byte[i];
        }
    }
    
    return num;
}

QLDIP_C_Byte * QLDIP_C_DIPByteFromInt64WithByteLen(int64_t number, uint32_t byteLen)
{
//    QLDIP_C_Byte * numByte = (QLDIP_C_Byte *)(&number);
    QLDIP_C_Byte *retByte = QLDIP_C_allocWithInit(byteLen);
    __QLDIP_C_DIPByteFromInt64WithByteLenWithBufferRef(number, byteLen, &retByte);
    return retByte;
}

QLDIP_C_DataRef QLDIP_C_DataFromInt64WithByteLen(int64_t num, uint32_t byteLen)
{
    if (0 == byteLen) {
        return QLDIP_C_DataCreate();
    }

//    QLDIP_C_DataRef retData = QLDIP_C_DataCreateWithByteArray(byte, byteLen);
    QLDIP_C_DataRef retData = QLDIP_C_DataCreateWithExpectedBufferLen(byteLen);
    __QLDIP_C_DIPByteFromInt64WithByteLenWithBufferRef(num, byteLen, &(retData->data));
    
    return retData;
}

int64_t QLDIP_C_DataPopInt64WithRange(QLDIP_C_DataRef theData, QLDIP_C_Range byteRange, QLDIP_C_Error ** errRefRef)
{
    return __QLDIP_C_DataPopInt64(theData, byteRange, errRefRef);
}

//int8_t QLDIP_C_DIPPopInt8(QLDIP_C_Byte * byte, QLDIP_C_Range byteRange, QLDIP_C_Error ** errRefRef)
//{
//    
//    
//}

//拓展方法
QLDIP_C_DataRef QLDIP_C_DataFromInt64(int64_t num)
{
    int64_t temp = (int64_t)num;
    return QLDIP_C_DataFromInt64WithByteLen(temp, 8);
}
QLDIP_C_DataRef QLDIP_C_DataFromInt32(int32_t num)
{
    int64_t temp = (int64_t)num;
    return QLDIP_C_DataFromInt64WithByteLen(temp, 4);
}
QLDIP_C_DataRef QLDIP_C_DataFromInt16(int16_t num)
{
    int64_t temp = (int64_t)num;
    return QLDIP_C_DataFromInt64WithByteLen(temp, 2);
}
QLDIP_C_DataRef QLDIP_C_DataFromInt8(int8_t num)
{
    int64_t temp = (int64_t)num;
    return QLDIP_C_DataFromInt64WithByteLen(temp, 1);
}


QLDIP_C_DataRef QLDIP_C_DataFromUInt64(uint64_t num)
{
    int64_t temp = (int64_t)num;
    return QLDIP_C_DataFromInt64WithByteLen(temp, 8);
}
QLDIP_C_DataRef QLDIP_C_DataFromUInt32(uint32_t num)
{
    int64_t temp = (int64_t)num;
    return QLDIP_C_DataFromInt64WithByteLen(temp, 4);
}
QLDIP_C_DataRef QLDIP_C_DataFromUInt16(uint16_t num)
{
    int64_t temp = (int64_t)num;
    return QLDIP_C_DataFromInt64WithByteLen(temp, 2);
}
QLDIP_C_DataRef QLDIP_C_DataFromUInt8(uint8_t num)
{
    int64_t temp = (int64_t)num;
    return QLDIP_C_DataFromInt64WithByteLen(temp, 1);
}

int64_t QLDIP_C_DataPopInt64(QLDIP_C_DataRef theData, uint32_t index, QLDIP_C_Error ** errRefRef)
{
    QLDIP_C_Range range = QLDIP_C_RangeMake(index, 8);
    int64_t retNum = QLDIP_C_DataPopInt64WithRange(theData, range, errRefRef);
    return (int64_t)retNum;
}
int32_t QLDIP_C_DataPopInt32(QLDIP_C_DataRef theData, uint32_t index, QLDIP_C_Error ** errRefRef)
{
    QLDIP_C_Range range = QLDIP_C_RangeMake(index, 4);
    int64_t retNum = QLDIP_C_DataPopInt64WithRange(theData, range, errRefRef);
    return (int32_t)retNum;
}
int16_t QLDIP_C_DataPopInt16(QLDIP_C_DataRef theData, uint32_t index, QLDIP_C_Error ** errRefRef)
{
    QLDIP_C_Range range = QLDIP_C_RangeMake(index, 2);
    int64_t retNum = QLDIP_C_DataPopInt64WithRange(theData, range, errRefRef);
    return (int16_t)retNum;
}
int8_t QLDIP_C_DataPopInt8(QLDIP_C_DataRef theData, uint32_t index, QLDIP_C_Error ** errRefRef)
{
    QLDIP_C_Range range = QLDIP_C_RangeMake(index, 1);
    int64_t retNum = QLDIP_C_DataPopInt64WithRange(theData, range, errRefRef);
    return (int8_t)retNum;
}

uint64_t QLDIP_C_DataPopUInt64(QLDIP_C_DataRef theData, uint32_t index, QLDIP_C_Error ** errRefRef)
{
    QLDIP_C_Range range = QLDIP_C_RangeMake(index, 8);
    int64_t retNum = QLDIP_C_DataPopInt64WithRange(theData, range, errRefRef);
    return (uint64_t)retNum;
}
uint32_t QLDIP_C_DataPopUInt32(QLDIP_C_DataRef theData, uint32_t index, QLDIP_C_Error ** errRefRef)
{
    QLDIP_C_Range range = QLDIP_C_RangeMake(index, 4);
    int64_t retNum = QLDIP_C_DataPopInt64WithRange(theData, range, errRefRef);
    return (uint32_t)retNum;
}
uint16_t QLDIP_C_DataPopUInt16(QLDIP_C_DataRef theData, uint32_t index, QLDIP_C_Error ** errRefRef)
{
    QLDIP_C_Range range = QLDIP_C_RangeMake(index, 2);
    int64_t retNum = QLDIP_C_DataPopInt64WithRange(theData, range, errRefRef);
    return (uint16_t)retNum;
}
uint8_t QLDIP_C_DataPopUInt8(QLDIP_C_DataRef theData, uint32_t index, QLDIP_C_Error ** errRefRef)
{
    QLDIP_C_Range range = QLDIP_C_RangeMake(index, 1);
    int64_t retNum = QLDIP_C_DataPopInt64WithRange(theData, range, errRefRef);
    return (uint8_t)retNum;
}


int64_t QLDIP_C_DIPPopInt64WithBeginIdx(QLDIP_C_Byte * byte, uint32_t beginIdx)
{
    int64_t retNum = __QLDIP_C_DIPPopInt64WithRangeWithErrorRefRef(byte, QLDIP_C_RangeMake(beginIdx, 8), NULL);
    return (int64_t)retNum;
}
int32_t QLDIP_C_DIPPopInt32WithBeginIdx(QLDIP_C_Byte * byte, uint32_t beginIdx)
{
    int64_t retNum = __QLDIP_C_DIPPopInt64WithRangeWithErrorRefRef(byte, QLDIP_C_RangeMake(beginIdx, 4), NULL);
    return (int32_t)retNum;
}
int16_t QLDIP_C_DIPPopInt16WithBeginIdx(QLDIP_C_Byte * byte, uint32_t beginIdx)
{
    int64_t retNum = __QLDIP_C_DIPPopInt64WithRangeWithErrorRefRef(byte, QLDIP_C_RangeMake(beginIdx, 2), NULL);
    return (int16_t)retNum;
}
int8_t QLDIP_C_DIPPopInt8WithBeginIdx(QLDIP_C_Byte * byte, uint32_t beginIdx)
{
    int64_t retNum = __QLDIP_C_DIPPopInt64WithRangeWithErrorRefRef(byte, QLDIP_C_RangeMake(beginIdx, 1), NULL);
    return (int8_t)retNum;
}

uint64_t QLDIP_C_DIPPopUInt64WithBeginIdx(QLDIP_C_Byte * byte, uint32_t beginIdx)
{
    int64_t retNum = __QLDIP_C_DIPPopInt64WithRangeWithErrorRefRef(byte, QLDIP_C_RangeMake(beginIdx, 8), NULL);
    return (uint64_t)retNum;
}
uint32_t QLDIP_C_DIPPopUInt32WithBeginIdx(QLDIP_C_Byte * byte, uint32_t beginIdx)
{
    int64_t retNum = __QLDIP_C_DIPPopInt64WithRangeWithErrorRefRef(byte, QLDIP_C_RangeMake(beginIdx, 4), NULL);
    return (uint32_t)retNum;
}
uint16_t QLDIP_C_DIPPopUInt16WithBeginIdx(QLDIP_C_Byte * byte, uint32_t beginIdx)
{
    int64_t retNum = __QLDIP_C_DIPPopInt64WithRangeWithErrorRefRef(byte, QLDIP_C_RangeMake(beginIdx, 2), NULL);
    return (uint16_t)retNum;
}
uint8_t QLDIP_C_DIPPopUInt8WithBeginIdx(QLDIP_C_Byte * byte, uint32_t beginIdx)
{
    int64_t retNum = __QLDIP_C_DIPPopInt64WithRangeWithErrorRefRef(byte, QLDIP_C_RangeMake(beginIdx, 1), NULL);
    return (uint8_t)retNum;
}

int64_t QLDIP_C_DIPPopInt64WithBeginIdxWithErrorRefRef(QLDIP_C_Byte * byte, uint32_t beginIdx, QLDIP_C_Error ** errRefRef)
{
    int64_t retNum = __QLDIP_C_DIPPopInt64WithRangeWithErrorRefRef(byte, QLDIP_C_RangeMake(beginIdx, 8), errRefRef);
    return (int64_t)retNum;
}
int32_t QLDIP_C_DIPPopInt32WithBeginIdxWithErrorRefRef(QLDIP_C_Byte * byte, uint32_t beginIdx, QLDIP_C_Error ** errRefRef)
{
    int64_t retNum = __QLDIP_C_DIPPopInt64WithRangeWithErrorRefRef(byte, QLDIP_C_RangeMake(beginIdx, 4), errRefRef);
    return (int32_t)retNum;
}
int16_t QLDIP_C_DIPPopInt16WithBeginIdxWithErrorRefRef(QLDIP_C_Byte * byte, uint32_t beginIdx, QLDIP_C_Error ** errRefRef)
{
    int64_t retNum = __QLDIP_C_DIPPopInt64WithRangeWithErrorRefRef(byte, QLDIP_C_RangeMake(beginIdx, 2), errRefRef);
    return (int16_t)retNum;
}
int8_t QLDIP_C_DIPPopInt8WithBeginIdxWithErrorRefRef(QLDIP_C_Byte * byte, uint32_t beginIdx, QLDIP_C_Error ** errRefRef)
{
    int64_t retNum = __QLDIP_C_DIPPopInt64WithRangeWithErrorRefRef(byte, QLDIP_C_RangeMake(beginIdx, 1), errRefRef);
    return (int8_t)retNum;
}

uint64_t QLDIP_C_DIPPopUInt64WithBeginIdxWithErrorRefRef(QLDIP_C_Byte * byte, uint32_t beginIdx, QLDIP_C_Error ** errRefRef)
{
    int64_t retNum = __QLDIP_C_DIPPopInt64WithRangeWithErrorRefRef(byte, QLDIP_C_RangeMake(beginIdx, 8), errRefRef);
    return (uint64_t)retNum;
}
uint32_t QLDIP_C_DIPPopUInt32WithBeginIdxWithErrorRefRef(QLDIP_C_Byte * byte, uint32_t beginIdx, QLDIP_C_Error ** errRefRef)
{
    int64_t retNum = __QLDIP_C_DIPPopInt64WithRangeWithErrorRefRef(byte, QLDIP_C_RangeMake(beginIdx, 4), errRefRef);
    return (uint32_t)retNum;
}
uint16_t QLDIP_C_DIPPopUInt16WithBeginIdxWithErrorRefRef(QLDIP_C_Byte * byte, uint32_t beginIdx, QLDIP_C_Error ** errRefRef)
{
    int64_t retNum = __QLDIP_C_DIPPopInt64WithRangeWithErrorRefRef(byte, QLDIP_C_RangeMake(beginIdx, 2), errRefRef);
    return (uint16_t)retNum;
}
uint8_t QLDIP_C_DIPPopUInt8WithBeginIdxWithErrorRefRef(QLDIP_C_Byte * byte, uint32_t beginIdx, QLDIP_C_Error ** errRefRef)
{
    int64_t retNum = __QLDIP_C_DIPPopInt64WithRangeWithErrorRefRef(byte, QLDIP_C_RangeMake(beginIdx, 1), errRefRef);
    return (uint8_t)retNum;
}

int64_t QLDIP_C_DIPReadIntWithBeginIdxWithIntByteWithErrorRefRef(QLDIP_C_Byte * byte, uint32_t beginIdx, uint32_t readLen, QLDIP_C_Error ** errRefRef)
{
    int64_t retNum = __QLDIP_C_DIPPopInt64WithRangeWithErrorRefRef(byte, QLDIP_C_RangeMake(beginIdx, readLen), errRefRef);
    return (int64_t)retNum;
}

int64_t QLDIP_C_DIPReadIntThenOffsetMutableBeginIdxWithIntByteWithErrorRefRef(QLDIP_C_Byte * byte, uint32_t *beginIdx, uint32_t readLen, QLDIP_C_Error ** errRefRef)
{
    int64_t retNum = __QLDIP_C_DIPPopInt64WithRangeWithErrorRefRef(byte, QLDIP_C_RangeMake(*beginIdx, readLen), errRefRef);
    *beginIdx += readLen;
    return (int64_t)retNum;
}

void QLDIP_C_DIPByteFromInt64WithByteLenWithBufferRef(int64_t number, uint32_t byteLen, QLDIP_C_Byte *bufferByte, uint32_t putInBeginIdx)
{
    QLDIP_C_Byte *buffer = bufferByte;
    buffer += putInBeginIdx;
    QLDIP_C_Byte **bufferNumByteRef = &(buffer);
    __QLDIP_C_DIPByteFromInt64WithByteLenWithBufferRef(number, byteLen, bufferNumByteRef);
}

float QLDIP_C_DIPReadFloatWithBeginIdxWithIntByteWithErrorRefRef(QLDIP_C_Byte * byte, uint32_t beginIdx, uint32_t readLen, QLDIP_C_Error ** errRefRef)
{
    
    return 0.0;
}

double QLDIP_C_DIPReadDoubleWithBeginIdxWithIntByteWithErrorRefRef(QLDIP_C_Byte * byte, uint32_t beginIdx, uint32_t readLen, QLDIP_C_Error ** errRefRef)
{
    
    return 0.0;
}

#pragma mark - </public/>

#pragma mark - </private>

int64_t __QLDIP_C_DIPPopInt64WithRangeWithErrorRefRef(QLDIP_C_Byte * byte, QLDIP_C_Range range, QLDIP_C_Error ** errRefRef)
{
    QLDIP_C_Byte *tempByte = byte;
    if (NULL == tempByte) {
        if (NULL != errRefRef) {
            *errRefRef = QLDIP_C_ErrorCreateWithCharArrayAndErrorCode("", 2);
        }
        return 0;
    }
    tempByte += range.location;
    int64_t retNum = QLDIP_C_DIPPopIntWithByteLen(tempByte, range.len);
    return (int64_t)retNum;
}



/*
 theByte nonnull
 byteRange 必须为一个有效的range
 */
int64_t __QLDIP_C_DIPPopInt64(QLDIP_C_Byte * theByte, QLDIP_C_Range byteRange)
{
    QLDIP_C_Byte * byte = theByte;
    int64_t num = 0;
    QLDIP_C_Byte * numByte = (QLDIP_C_Byte *)(&num);
    if (NULL == byte) {
        return num;
    }
    

    if (QLDIP_C_ENDIAN_Little) {
        int popLen = byteRange.len;
        if (popLen > 8) {
            popLen = 8;
        }
        for (int i=0; i<popLen; i++) {
            numByte[7-i] = byte[i];
        }
    }else {
        int popLen = byteRange.len;
        if (popLen > 8) {
            popLen = 8;
            byte += byteRange.location + (byteRange.len - 8);
        }
        for (int i=0; i<popLen; i++) {
            numByte[7-popLen+i] = byte[i];
        }
    }

    return num;
    
}









int64_t __QLDIP_C_DataPopInt64(QLDIP_C_DataRef theData, QLDIP_C_Range byteRange, QLDIP_C_Error ** errRefRef)
{
    int64_t ret = 0;
    if (NULL == theData) {
        if (NULL != errRefRef) {
            *errRefRef = QLDIP_C_ErrorCreateWithCharArrayAndErrorCode("theData is null", 2);
        }
        return ret;
    }
    if (theData->dataLen < byteRange.location + byteRange.len) {
        if (NULL != errRefRef) {
            *errRefRef = QLDIP_C_ErrorCreateWithCharArrayAndErrorCode("theData does not has enough data len", 3);
        }
        return ret;
    }
    
    ret = __QLDIP_C_DIPPopInt64(theData->data, byteRange);
    
    return ret;
}

QLDIP_C_Byte * __QLDIP_C_DIPByteFromInt64WithByteLenWithBufferRef(int64_t number, uint32_t byteLen, QLDIP_C_Byte ** bufferNumByte)
{
    int64_t tempNumber = number;
    QLDIP_C_Byte * numByte = (QLDIP_C_Byte *)(&tempNumber);
    QLDIP_C_Byte *retByte = *bufferNumByte;
    if (QLDIP_C_ENDIAN_Little) {
        for (int i=0; i<byteLen; i++) {
            retByte[i] = numByte[byteLen - 1 -i];
        }
    }else {
        for (int i=0; i<byteLen; i++) {
            retByte[i] = numByte[8-byteLen-i];
        }
    }
    return retByte;
}

void __QLDIP_C_DIPPushByteWithIntWithByteRangeWithBufferRef(int64_t number, QLDIP_C_Range range, QLDIP_C_Byte ** bufferNumByte)
{
    QLDIP_C_Byte * numByte = (QLDIP_C_Byte *)(&number);
    QLDIP_C_Byte *retByte = *bufferNumByte;
    retByte += range.location;
    if (QLDIP_C_ENDIAN_Little) {
        for (int i=0; i<range.len; i++) {
            retByte[i] = numByte[range.len - 1 -i];
        }
    }else {
        for (int i=0; i<range.len; i++) {
            retByte[i] = numByte[8-range.len-i];
        }
    }
}

QLDIP_C_ObjRef __QLDIP_C_DIPSerializationBodyItemByteToQLDIPObject(QLDIP_C_Byte * theByte, uint32_t bodyLen, QLDIP_C_Error ** errRefRef)
{
    if (NULL == theByte) {
        if (NULL != errRefRef) {
            *errRefRef = QLDIP_C_ErrorCreateWithCharArrayAndErrorCode("byte 为空", QLDIP_C_ErrorCode_DIP_ByteNull);
        }
        return NULL;
    }

    QLDIP_C_Error * tempErrRef = NULL;
    uint32_t objByteLen = __QLDIP_C_DIPReadObjectByteObjLen(theByte, QLDIP_C_RangeMake(0, bodyLen), &tempErrRef);
    if (NULL != tempErrRef) {
        if (NULL != errRefRef) {
            *errRefRef = tempErrRef;
        }
        return NULL;
    }

//    objByteLen
    
    if (NULL == theByte) {
        if (NULL != errRefRef) {
            *errRefRef = QLDIP_C_ErrorCreateWithCharArrayAndErrorCode("byte 为空", QLDIP_C_ErrorCode_DIP_ByteNull);
        }
        return NULL;
    }

    


    return NULL;
}

uint32_t __QLDIP_C_DIPReadObjectByteObjLen(QLDIP_C_Byte * theByte, QLDIP_C_Range range, QLDIP_C_Error ** errRefRef)
{
    if (NULL == theByte) {
        if (NULL != errRefRef) {
            *errRefRef = QLDIP_C_ErrorCreateWithCharArrayAndErrorCode("byte 为空", QLDIP_C_ErrorCode_DIP_ByteNull);
        }
        return 0;
    }
    
    if (range.len < QLDIP_C_DIP_ObjByte_LenLen) {
        if (NULL != errRefRef) {
            *errRefRef = QLDIP_C_ErrorCreateWithCharArrayAndErrorCode("byte len Not Enough", QLDIP_C_ErrorCode_DIP_LenthNotEnough);
        }
        return 0;
    }
    
    uint64_t objByteLen = __QLDIP_C_DIPPopInt64(theByte, QLDIP_C_RangeMake(range.location, QLDIP_C_DIP_ObjByte_LenLen));
    return (uint32_t)objByteLen;
}

uint32_t __QLDIP_C_DIPReadObjectType(QLDIP_C_Byte * theByte, QLDIP_C_Range range, QLDIP_C_Error ** errRefRef)
{
    if (NULL == theByte) {
        if (NULL != errRefRef) {
            *errRefRef = QLDIP_C_ErrorCreateWithCharArrayAndErrorCode("byte 为空", QLDIP_C_ErrorCode_DIP_ByteNull);
        }
        return 0;
    }
    
    if (range.len < QLDIP_C_DIP_ObjByte_LenLen) {
        if (NULL != errRefRef) {
            *errRefRef = QLDIP_C_ErrorCreateWithCharArrayAndErrorCode("byte len Not Enough", QLDIP_C_ErrorCode_DIP_LenthNotEnough);
        }
        return 0;
    }
    
    uint64_t objByteLen = __QLDIP_C_DIPPopInt64(theByte, QLDIP_C_RangeMake(range.location, QLDIP_C_DIP_ObjByte_LenLen));
    return (uint32_t)objByteLen;
}

void __QLDIP_C_DIPPushHeaderExpandWithHeaderExpandWithBufferRef(__QLDIP_C_NodeProtoExpandRef headerExpandRef, QLDIP_C_Byte ** bufferByte)
{
    __QLDIP_C_DIPPushByteWithIntWithByteRangeWithBufferRef((int64_t)(headerExpandRef->expandIntervalLen), headerExpandRef->expandIntervalLenByteRange, bufferByte);
    
    
    for (int i=0; i<headerExpandRef->byteRange.len; i++) {
        (*bufferByte)[i + headerExpandRef->byteRange.location] = (headerExpandRef->byte)[i];
    }
    for (int i=headerExpandRef->byteRange.len; i<headerExpandRef->expandIntervalLen; i++) {
        (*bufferByte)[i + headerExpandRef->byteRange.location] = 0;
    }
    
}

void __QLDIP_C_DIPPushBodyWithBodyWithBufferRef(__QLDIP_C_NodeProtoBodyRef bodyRef,  QLDIP_C_ArrayRef bodyObj, QLDIP_C_Byte ** bufferByte)
{
    __QLDIP_C_DIPPushByteWithIntWithByteRangeWithBufferRef((int64_t)(bodyRef->bodyLen), bodyRef->bodyLenByteRange, bufferByte);
    
//    for (int i=0; i<headerExpandRef->byteRange.len; i++) {
//        (*bufferByte)[i + headerExpandRef->byteRange.location] = (headerExpandRef->byte)[i];
//    }
//    for (int i=headerExpandRef->byteRange.len; i<headerExpandRef->expandIntervalLen; i++) {
//        (*bufferByte)[i + headerExpandRef->byteRange.location] = 0;
//    }
    
}

#pragma mark - </private/>

#pragma mark - <implementation/>





























#define INT64_TO_NET(val)   ((int64_t) ( \
(((int64_t) (val) &                       \
(int64_t) (0x00000000000000ffU)) << 56) | \
(((int64_t) (val) &                       \
(int64_t) (0x000000000000ff00U)) << 40) | \
(((int64_t) (val) &                       \
(int64_t) (0x0000000000ff0000U)) << 24) | \
(((int64_t) (val) &                       \
(int64_t) (0x00000000ff000000U)) <<  8) | \
(((int64_t) (val) &                       \
(int64_t) (0x000000ff00000000U)) >>  8) | \
(((int64_t) (val) &                       \
(int64_t) (0x0000ff0000000000U)) >> 24) | \
(((int64_t) (val) &                       \
(int64_t) (0x00ff000000000000U)) >> 40) | \
(((int64_t) (val) &                       \
(int64_t) (0xff00000000000000U)) >> 56)))

#define NET_TO_INT64(val)   ((int64_t) ( \
(((int64_t) (val) &                       \
(int64_t) (0x00000000000000ffU)) << 56) | \
(((int64_t) (val) &                       \
(int64_t) (0x000000000000ff00U)) << 40) | \
(((int64_t) (val) &                       \
(int64_t) (0x0000000000ff0000U)) << 24) | \
(((int64_t) (val) &                       \
(int64_t) (0x00000000ff000000U)) <<  8) | \
(((int64_t) (val) &                       \
(int64_t) (0x000000ff00000000U)) >>  8) | \
(((int64_t) (val) &                       \
(int64_t) (0x0000ff0000000000U)) >> 24) | \
(((int64_t) (val) &                       \
(int64_t) (0x00ff000000000000U)) >> 40) | \
(((int64_t) (val) &                       \
(int64_t) (0xff00000000000000U)) >> 56)))



// int64网络字节序转换为主机字节序
inline int64_t ntoh_int64(int64_t val)
{
    int64_t ret = val;
#if __BYTE_ORDER == __LITTLE_ENDIAN
    ret = (((int64_t)ntohl((unsigned long)val)) << 32) | ntohl((unsigned long)(val>>32));
#endif
    return ret;
}

// double网络字节序转换为主机字节序
inline double ntoh_double(double val)
{
    double ret = val;
#if __BYTE_ORDER == __LITTLE_ENDIAN
    int64_t tmp = ntoh_int64(*((int64_t*)&val));
    ret = *((double*)&tmp);
#endif
    return ret;
}


