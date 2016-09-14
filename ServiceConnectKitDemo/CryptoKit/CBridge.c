//
//  CBridge.c
//  ServiceConnectKitDemo
//
//  Created by CaiLianfeng on 2016/9/12.
//  Copyright © 2016年 WangQinghai. All rights reserved.
//

#include "CBridge.h"


#include "md5.h"
#include "rsa.h"
#include "pem.h"
#include "err.h"

#include <stdio.h>

CRange CMakeRange(long location, long length) {
    CRange range;
    range.location = location;
    range.length = length;
    return range;
}


void *RSAPublicKeyInit(const char * formatKey) {
    BIO *bio = NULL;
    RSA *rsa = NULL;
    if ((bio = BIO_new_mem_buf(formatKey, -1)) == NULL) {//从字符串读取RSA公钥
        return NULL;
    }
    rsa = PEM_read_bio_RSA_PUBKEY(bio, NULL, NULL, NULL);   //从bio结构中得到rsa结构
    if (!rsa) {
        ERR_load_crypto_strings();
        char errBuf[512];
        ERR_error_string_n(ERR_get_error(), errBuf, sizeof(errBuf));
    }
    
    BIO_free_all(bio);
    return rsa;
}
void *RSAPrivateKeyInit(const char * formatKey) {
    BIO *bio = NULL;
    RSA *rsa = NULL;
    if ((bio = BIO_new_mem_buf(formatKey, -1)) == NULL) {
        return NULL;
    }
        
    rsa = PEM_read_bio_RSAPrivateKey(bio, NULL, NULL, NULL);
    if (!rsa) {
        ERR_load_crypto_strings();
        char errBuf[512];
        ERR_error_string_n(ERR_get_error(), errBuf, sizeof(errBuf));
    }
    
    BIO_free_all(bio);
    
    return rsa;
}

void RSAPublicKeyDeinit(void * rsa);
void RSAPrivateKeyDeinit(void * rsa);
long RSABlockSize(void * rsa) {
    RSA *publicRsa = (RSA *)rsa;
    long resultLen = RSA_size(publicRsa);
    return resultLen;
}



int RSAPublicKeyEncryptCStringToBytes(void *rsa, const char *cStr, unsigned char *resultBuffer, long * resultLen) {
    long strLen = strlen(cStr) + 1;
    RSA *publicRsa = (RSA *)rsa;
    long blockSize = RSA_size(publicRsa);
    long index = 0;
    long resultIndex = 0;
    while (index < strLen) {
        long upper = index + blockSize - 11;
        if (upper > strLen) {
            upper = strLen;
        }
        const unsigned char * bytes = (const unsigned char *)(cStr + index);
        unsigned char * targetBuffer = resultBuffer + resultIndex;
        if(RSA_public_encrypt((int)(upper - index), bytes, targetBuffer, publicRsa, RSA_PKCS1_PADDING)<0){
            ERR_load_crypto_strings();
            char errBuf[512];
            ERR_error_string_n(ERR_get_error(), errBuf, sizeof(errBuf));
            return -1;
        }
        index = upper;
        resultIndex += blockSize;
    }
    *resultLen = resultIndex;
    return 1;
}

int RSAPublicKeyDecryptBytesToCString(void *rsa, const unsigned char *bytes, long byteLen, char *resultBuffer, long * resultLen) {
    RSA *privateRsa = (RSA *)rsa;
    long blockSize = RSA_size(privateRsa);
    if (byteLen % blockSize != 0) {
        return -1;
    }
    long index = 0;
    long resultIndex = 0;
    while (index < byteLen) {
        long upper = index + blockSize;
        if (upper > byteLen) {
            upper = byteLen;
        }
        const unsigned char * bytesBlock = (const unsigned char *)(bytes + index);
        unsigned char * targetBuffer = (unsigned char *)(resultBuffer + resultIndex);
        
        if(RSA_public_decrypt((int)blockSize, bytesBlock, targetBuffer, privateRsa, RSA_PKCS1_PADDING)<0){
            ERR_load_crypto_strings();
            char errBuf[512];
            ERR_error_string_n(ERR_get_error(), errBuf, sizeof(errBuf));
            return -1;
        }
        index = upper;
        resultIndex += blockSize - 11;
    }
    *resultLen = resultIndex;
    return 1;
}

int RSAPrivateKeyEncryptCStringToBytes(void *rsa, const char *cStr, unsigned char *resultBuffer, long * resultLen) {
    long strLen = strlen(cStr) + 1;
    RSA *publicRsa = (RSA *)rsa;
    long blockSize = RSA_size(publicRsa);
    long index = 0;
    long resultIndex = 0;
    while (index < strLen) {
        long upper = index + blockSize - 11;
        if (upper > strLen) {
            upper = strLen;
        }
        const unsigned char * bytes = (const unsigned char *)(cStr + index);
        unsigned char * targetBuffer = resultBuffer + resultIndex;
        if(RSA_private_encrypt((int)(upper - index), bytes, targetBuffer, publicRsa, RSA_PKCS1_PADDING)<0){
            ERR_load_crypto_strings();
            char errBuf[512];
            ERR_error_string_n(ERR_get_error(), errBuf, sizeof(errBuf));
            return -1;
        }
        index = upper;
        resultIndex += blockSize;
    }
    *resultLen = resultIndex;
    return 1;
}
int RSAPrivateKeyDecryptBytesToCString(void *rsa, const unsigned char *bytes, long byteLen, char *resultBuffer, long * resultLen) {
    RSA *privateRsa = (RSA *)rsa;
    long blockSize = RSA_size(privateRsa);
    if (byteLen % blockSize != 0) {
        return -1;
    }
    long index = 0;
    long resultIndex = 0;
    while (index < byteLen) {
        long upper = index + blockSize;
        if (upper > byteLen) {
            upper = byteLen;
        }
        const unsigned char * bytesBlock = (const unsigned char *)(bytes + index);
        unsigned char * targetBuffer = (unsigned char *)(resultBuffer + resultIndex);
        
        if(RSA_private_decrypt((int)blockSize, bytesBlock, targetBuffer, privateRsa, RSA_PKCS1_PADDING)<0){
            ERR_load_crypto_strings();
            char errBuf[512];
            ERR_error_string_n(ERR_get_error(), errBuf, sizeof(errBuf));
            return -1;
        }
        index = upper;
        resultIndex += blockSize - 11;
    }
    *resultLen = resultIndex;
    return 1;
}

int RSAPublicKeyEncrypt(void *rsa, const unsigned char *bytes, long bytesLen, unsigned char *resultBuffer, long resultBufferBeginIndex, long * resultLen) {
    RSA *publicRsa = (RSA *)rsa;
    *resultLen = RSA_size(publicRsa);
    unsigned char * targetBuffer = resultBuffer + resultBufferBeginIndex;
    memset(targetBuffer, 0, *resultLen);
    if(RSA_public_encrypt((int)bytesLen, bytes, targetBuffer, publicRsa, RSA_PKCS1_PADDING)<0){
        ERR_load_crypto_strings();
        char errBuf[512];
        ERR_error_string_n(ERR_get_error(), errBuf, sizeof(errBuf));
        return -1;
    }
    return 1; //p_en;
}
int RSAPublicKeyDecrypt(void *rsa, const unsigned char *bytes, long bytesLen, unsigned char *resultBuffer, long * resultLen) {
    return 1;


}



int RSAPrivateKeyEncrypt(void *rsa, const unsigned char *bytes, long bytesLen, unsigned char *resultBuffer, long * resultLen) {
    return 1;

}
int RSAPrivateKeyDecrypt(void *rsa, const unsigned char *bytes, long bytesLen, unsigned char *resultBuffer, long resultBufferBeginIndex, long * resultLen) {
    RSA *privateRsa = (RSA *)rsa;
    *resultLen = RSA_size(privateRsa);
    unsigned char * targetBuffer = resultBuffer + resultBufferBeginIndex;
    memset(targetBuffer, 0, *resultLen - 11);
    if(RSA_private_decrypt((int)bytesLen, bytes, targetBuffer, privateRsa, RSA_PKCS1_PADDING)<0){
        ERR_load_crypto_strings();
        char errBuf[512];
        ERR_error_string_n(ERR_get_error(), errBuf, sizeof(errBuf));
        return -1;
    }
    return 1;
}





void * ttttttt3(const char * array) {

    BIO *bio = NULL;
    RSA *rsa = NULL;
    const char *chPublicKey = array;
    if ((bio = BIO_new_mem_buf(chPublicKey, -1)) == NULL)       //从字符串读取RSA公钥
    {
        
    }
    rsa = PEM_read_bio_RSA_PUBKEY(bio, NULL, NULL, NULL);   //从bio结构中得到rsa结构
    if (!rsa) {
        ERR_load_crypto_strings();
        char errBuf[512];
        ERR_error_string_n(ERR_get_error(), errBuf, sizeof(errBuf));
    }
    
    BIO_free_all(bio);

    return rsa;
}



void ttttttt2(char * array) {
    
    
}

//void ttttttt3(const char * array) {
//
//    printf("%s", array);
//
//}




/*
 char *my_encrypt(char *str,char *path_key){
 char *p_en;
 RSA *p_rsa;
 FILE *file;
 int flen,rsa_len;
 if((file=fopen(path_key,"r"))==NULL){
 perror("open key file error");
 return NULL;
 }
 
 //    RSA * publicKey = RSA_new();
 
 
 if((p_rsa=PEM_read_RSA_PUBKEY(file,NULL,NULL,NULL))==NULL){
 //if((p_rsa=PEM_read_RSAPublicKey(file,NULL,NULL,NULL))==NULL){   换成这句死活通不过，无论是否将公钥分离源文件
 ERR_print_errors_fp(stdout);
 return NULL;
 }
 flen=strlen(str);
 rsa_len=RSA_size(p_rsa);
 p_en=(unsigned char *)malloc(rsa_len+1);
 memset(p_en,0,rsa_len+1);
 if(RSA_public_encrypt(rsa_len,(unsigned char *)str,(unsigned char*)p_en,p_rsa,RSA_NO_PADDING)<0){
 return NULL;
 }
 RSA_free(p_rsa);
 fclose(file);
 return p_en;
 }
 char *my_decrypt(char *str,char *path_key){
 char *p_de;
 RSA *p_rsa;
 FILE *file;
 int rsa_len;
 if((file=fopen(path_key,"r"))==NULL){
 perror("open key file error");
 return NULL;
 }
 if((p_rsa=PEM_read_RSAPrivateKey(file,NULL,NULL,NULL))==NULL){
 ERR_print_errors_fp(stdout);
 return NULL;
 }
 rsa_len=RSA_size(p_rsa);
 p_de=(unsigned char *)malloc(rsa_len+1);
 memset(p_de,0,rsa_len+1);
 if(RSA_private_decrypt(rsa_len,(unsigned char *)str,(unsigned char*)p_de,p_rsa,RSA_NO_PADDING)<0){
 return NULL;
 }
 RSA_free(p_rsa);
 fclose(file);
 return p_de;
 }

 */



//
//#include "evp.h"
//#include "rand.h"
//#include "rsa.h"
//#include "pem.h"
//
//#define RSA_KEY_LENGTH 1024
//static const char rnd_seed[] = "string to make the random number generator initialized";
//
//#ifdef WIN32
//#define PRIVATE_KEY_FILE "f:\\rsapriv.key"
//#define PUBLIC_KEY_FILE "f:\\rsapub.key"
//#else   // non-win32 system
//#define PRIVATE_KEY_FILE "/tmp/avit.data.tmp1"
//#define PUBLIC_KEY_FILE  "/tmp/avit.data.tmp2"
//#endif
//
//#define RSA_PRIKEY_PSW "123"
//
//#ifdef WIN32
//#pragma comment(lib, "libeay32.lib")
//#pragma comment(lib, "ssleay32.lib")
//#endif
//
//// 生成公钥文件和私钥文件，私钥文件带密码
//int generate_key_files(const char *pub_keyfile, const char *pri_keyfile,
//                       const unsigned char *passwd, int passwd_len)
//{
//    RSA *rsa = NULL;
//    RAND_seed(rnd_seed, sizeof(rnd_seed));
//    rsa = RSA_generate_key(RSA_KEY_LENGTH, RSA_F4, NULL, NULL);
//    if(rsa == NULL)
//    {
//        printf("RSA_generate_key error!\n");
//        return -1;
//    }
//    
//    // 开始生成公钥文件
//    BIO *bp = BIO_new(BIO_s_file());
//    if(NULL == bp)
//    {
//        printf("generate_key bio file new error!\n");
//        return -1;
//    }
//    
//    if(BIO_write_filename(bp, (void *)pub_keyfile) <= 0)
//    {
//        printf("BIO_write_filename error!\n");
//        return -1;
//    }
//    
//    if(PEM_write_bio_RSAPublicKey(bp, rsa) != 1)
//    {
//        printf("PEM_write_bio_RSAPublicKey error!\n");
//        return -1;
//    }
//    
//    // 公钥文件生成成功，释放资源
//    printf("Create public key ok!\n");
//    BIO_free_all(bp);
//    
//    // 生成私钥文件
//    bp = BIO_new_file(pri_keyfile, "w+");
//    if(NULL == bp)
//    {
//        printf("generate_key bio file new error2!\n");
//        return -1;
//    }
//    
//    if(PEM_write_bio_RSAPrivateKey(bp, rsa,
//                                   EVP_des_ede3_ofb(), (unsigned char *)passwd,
//                                   passwd_len, NULL, NULL) != 1)
//    {
//        printf("PEM_write_bio_RSAPublicKey error!\n");
//        return -1;
//    }
//    
//    // 释放资源
//    printf("Create private key ok!\n");
//    BIO_free_all(bp);
//    RSA_free(rsa);
//    
//    return 0;
//}
//// 打开公钥文件，返回EVP_PKEY结构的指针
//EVP_PKEY* open_public_key(const char *keyfile)
//{
//    EVP_PKEY* key = NULL;
//    RSA *rsa = NULL;
//    
//    OpenSSL_add_all_algorithms();
//    BIO *bp = BIO_new(BIO_s_file());;
//    BIO_read_filename(bp, keyfile);
//    if(NULL == bp)
//    {
//        printf("open_public_key bio file new error!\n");
//        return NULL;
//    }
//    
//    rsa = PEM_read_bio_RSAPublicKey(bp, NULL, NULL, NULL);
//    if(rsa == NULL)
//    {
//        printf("open_public_key failed to PEM_read_bio_RSAPublicKey!\n");
//        BIO_free(bp);
//        RSA_free(rsa);
//        
//        return NULL;
//    }
//    
//    printf("open_public_key success to PEM_read_bio_RSAPublicKey!\n");
//    key = EVP_PKEY_new();
//    if(NULL == key)
//    {
//        printf("open_public_key EVP_PKEY_new failed\n");
//        RSA_free(rsa);
//        
//        return NULL;
//    }
//    
//    EVP_PKEY_assign_RSA(key, rsa);
//    return key;
//}
//// 打开私钥文件，返回EVP_PKEY结构的指针
//EVP_PKEY* open_private_key(const char *keyfile, const unsigned char *passwd)
//{
//    EVP_PKEY* key = NULL;
//    RSA *rsa = RSA_new();
//    OpenSSL_add_all_algorithms();
//    BIO *bp = NULL;
//    bp = BIO_new_file(keyfile, "rb");
//    if(NULL == bp)
//    {
//        printf("open_private_key bio file new error!\n");
//        
//        return NULL;
//    }
//    
//    rsa = PEM_read_bio_RSAPrivateKey(bp, &rsa, NULL, (void *)passwd);
//    if(rsa == NULL)
//    {
//        printf("open_private_key failed to PEM_read_bio_RSAPrivateKey!\n");
//        BIO_free(bp);
//        RSA_free(rsa);
//        
//        return NULL;
//    }
//    
//    printf("open_private_key success to PEM_read_bio_RSAPrivateKey!\n");
//    key = EVP_PKEY_new();
//    if(NULL == key)
//    {
//        printf("open_private_key EVP_PKEY_new failed\n");
//        RSA_free(rsa);
//        
//        return NULL;
//    }
//    
//    EVP_PKEY_assign_RSA(key, rsa);
//    return key;
//}
//
//// 使用密钥加密，这种封装格式只适用公钥加密，私钥解密，这里key必须是公钥
//int rsa_key_encrypt(EVP_PKEY *key, const unsigned char *orig_data, size_t orig_data_len,
//                    unsigned char *enc_data, size_t &enc_data_len)
//{
//    EVP_PKEY_CTX *ctx = NULL;
//    OpenSSL_add_all_ciphers();
//    
//    ctx = EVP_PKEY_CTX_new(key, NULL);
//    if(NULL == ctx)
//    {
//        printf("ras_pubkey_encryptfailed to open ctx.\n");
//        EVP_PKEY_free(key);
//        return -1;
//    }
//    
//    if(EVP_PKEY_encrypt_init(ctx) <= 0)
//    {
//        printf("ras_pubkey_encryptfailed to EVP_PKEY_encrypt_init.\n");
//        EVP_PKEY_free(key);
//        return -1;
//    }
//    
//    if(EVP_PKEY_encrypt(ctx,
//                        enc_data,
//                        &enc_data_len,
//                        orig_data,
//                        orig_data_len) <= 0)
//    {
//        printf("ras_pubkey_encryptfailed to EVP_PKEY_encrypt.\n");
//        EVP_PKEY_CTX_free(ctx);
//        EVP_PKEY_free(key);
//        
//        return -1;
//    }
//    
//    EVP_PKEY_CTX_free(ctx);
//    EVP_PKEY_free(key);
//    
//    return 0;
//}
//
//// 使用密钥解密，这种封装格式只适用公钥加密，私钥解密，这里key必须是私钥
//int rsa_key_decrypt(EVP_PKEY *key, const unsigned char *enc_data, size_t enc_data_len,
//                    unsigned char *orig_data, size_t &orig_data_len, const unsigned char *passwd)
//{
//    EVP_PKEY_CTX *ctx = NULL;
//    OpenSSL_add_all_ciphers();
//    
//    ctx = EVP_PKEY_CTX_new(key, NULL);
//    if(NULL == ctx)
//    {
//        printf("ras_prikey_decryptfailed to open ctx.\n");
//        EVP_PKEY_free(key);
//        return -1;
//    }
//    
//    if(EVP_PKEY_decrypt_init(ctx) <= 0)
//    {
//        printf("ras_prikey_decryptfailed to EVP_PKEY_decrypt_init.\n");
//        EVP_PKEY_free(key);
//        return -1;
//    }
//    
//    if(EVP_PKEY_decrypt(ctx,
//                        orig_data,
//                        &orig_data_len,
//                        enc_data,
//                        enc_data_len) <= 0)
//    {
//        printf("ras_prikey_decryptfailed to EVP_PKEY_decrypt.\n");
//        EVP_PKEY_CTX_free(ctx);
//        EVP_PKEY_free(key);
//        
//        return -1;
//    }
//    
//    EVP_PKEY_CTX_free(ctx);
//    EVP_PKEY_free(key);
//    return 0;
//}
//
//int main(int argc, char **argv)
//{
//    char origin_text[] = "hello world!";
//    char enc_text[512] = "";
//    char dec_text[512] = "";
//    size_t enc_len = 512;
//    size_t dec_len = 512;
//    
//    // 生成公钥和私钥文件
//    generate_key_files(PUBLIC_KEY_FILE, PRIVATE_KEY_FILE, (const unsigned char *)RSA_PRIKEY_PSW, strlen(RSA_PRIKEY_PSW));
//    
//    EVP_PKEY *pub_key = open_public_key(PUBLIC_KEY_FILE);
//    EVP_PKEY *pri_key = open_private_key(PRIVATE_KEY_FILE, (const unsigned char *)RSA_PRIKEY_PSW);
//    
//    rsa_key_encrypt(pub_key, (const unsigned char *)&origin_text, sizeof(origin_text), (unsigned char *)enc_text, enc_len);
//    rsa_key_decrypt(pri_key, (const unsigned char *)enc_text, enc_len,   
//                    (unsigned char *)dec_text, dec_len, (const unsigned char *)RSA_PRIKEY_PSW);  
//    
//    return 0;  
//}







