//
//  CBridge.h
//  ServiceConnectKitDemo
//
//  Created by CaiLianfeng on 2016/9/12.
//  Copyright © 2016年 WangQinghai. All rights reserved.
//

#ifndef CBridge_h
#define CBridge_h

typedef struct _CRange {
    long location;
    long length;
}CRange;

CRange CMakeRange(long location, long length);

void *RSAPublicKeyInit(const char * formatkey);
void *RSAPrivateKeyInit(const char * formatKey);
void RSAPublicKeyDeinit(void * rsa);
void RSAPrivateKeyDeinit(void * rsa);
long RSABlockSize(void * rsa);

int RSAPublicKeyEncryptCStringToBytes(void *rsa, const char *cStr, unsigned char *resultBuffer, long * resultLen);
int RSAPublicKeyDecryptBytesToCString(void *rsa, const unsigned char *bytes, long byteLen, char *resultBuffer, long * resultLen);

int RSAPrivateKeyEncryptCStringToBytes(void *rsa, const char *cStr, unsigned char *resultBuffer, long * resultLen);
int RSAPrivateKeyDecryptBytesToCString(void *rsa, const unsigned char *bytes, long byteLen, char *resultBuffer, long * resultLen);


int RSAPublicKeyEncrypt(void *rsa, const unsigned char *bytes, long bytesLen, unsigned char *resultBuffer, long resultBufferBeginIndex, long * resultLen);
int RSAPublicKeyDecrypt(void *rsa, const unsigned char *bytes, long bytesLen, unsigned char *resultBuffer, long * resultLen);

int RSAPrivateKeyEncrypt(void *rsa, const unsigned char *bytes, long bytesLen, unsigned char *resultBuffer, long * resultLen);
int RSAPrivateKeyDecrypt(void *rsa, const unsigned char *bytes, long bytesLen, unsigned char *resultBuffer, long resultBufferBeginIndex, long * resultLen);

void ttttttt2(char * array);
void *ttttttt3(const char * array);

#endif /* CBridge_h */
