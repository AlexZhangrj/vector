//
//  CBridge.c
//  ConnectServiceDemo
//
//  Created by CaiLianfeng on 16/8/28.
//  Copyright © 2016年 WangQinghai. All rights reserved.
//


#include "CBridge.h"

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <errno.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <sys/ioctl.h>

#include <pthread.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <net/if.h>
#include <netinet/in.h>
#include <fcntl.h>

//#define OPENSSLKEY "test.key"
//#define PUBLICKEY "test_pub.key"
//#define BUFFSIZE 1024
//char* my_encrypt(char *str,char *path_key);//加密
//char* my_decrypt(char *str,char *path_key);//解密

/*
 int nPublicKeyLen = strPublicKey.size();      //strPublicKey为base64编码的公钥字符串
 for(int i = 64; i < nPublicKeyLen; i+=64)
 {
 if(strPublicKey[i] != '\n')
 {
 strPublicKey.insert(i, "\n");
 }
 i++;
 }
 strPublicKey.insert(0, "-----BEGIN PUBLIC KEY-----\n");
 strPublicKey.append("\n-----END PUBLIC KEY-----\n");
 
 BIO *bio = NULL;
 RSA *rsa = NULL;
 char *chPublicKey = const_cast<char *>(strPublicKey.c_str());
 if ((bio = BIO_new_mem_buf(chPublicKey, -1)) == NULL)       //从字符串读取RSA公钥
 {
 cout<<"BIO_new_mem_buf failed!"<<endl;
 }
 rsa = PEM_read_bio_RSA_PUBKEY(bio, NULL, NULL, NULL);   //从bio结构中得到rsa结构
 if (!rsa)
 {
 ERR_load_crypto_strings();
 char errBuf[512];
 ERR_error_string_n(ERR_get_error(), errBuf, sizeof(errBuf));
 cout<< "load public key failed["<<errBuf<<"]"<<endl;
 BIO_free_all(bio);
 }
 */

//12 int main(void){
//    13     char *source="i like dancing !";
//    14     char *ptr_en,*ptr_de;
//    15     printf("source is    :%s\n",source);
//    16     ptr_en=my_encrypt(source,PUBLICKEY);
//    17     printf("after encrypt:%s\n",ptr_en);
//    18     ptr_de=my_decrypt(ptr_en,OPENSSLKEY);
//    19     printf("after decrypt:%s\n",ptr_de);
//    20     if(ptr_en!=NULL){
//        21         free(ptr_en);
//        22     }
//    23     if(ptr_de!=NULL){
//        24         free(ptr_de);
//        25     }
//    26     return 0;
//    27 }
//
//void test() {
// 
////        PEM_read_RSA_PUBKEY
//    
//}
//
//
//char *my_encrypt(char *str,char *path_key){
//     char *p_en;
//     RSA *p_rsa;
//     FILE *file;
//     int flen,rsa_len;
//     if((file=fopen(path_key,"r"))==NULL){
//             perror("open key file error");
//             return NULL;
//         }
//    
////    RSA * publicKey = RSA_new();
//    
//    
//     if((p_rsa=PEM_read_RSA_PUBKEY(file,NULL,NULL,NULL))==NULL){
//         //if((p_rsa=PEM_read_RSAPublicKey(file,NULL,NULL,NULL))==NULL){   换成这句死活通不过，无论是否将公钥分离源文件
//             ERR_print_errors_fp(stdout);
//             return NULL;
//         }
//     flen=strlen(str);
//     rsa_len=RSA_size(p_rsa);
//     p_en=(unsigned char *)malloc(rsa_len+1);
//     memset(p_en,0,rsa_len+1);
//     if(RSA_public_encrypt(rsa_len,(unsigned char *)str,(unsigned char*)p_en,p_rsa,RSA_NO_PADDING)<0){
//             return NULL;
//         }
//     RSA_free(p_rsa);
//     fclose(file);
//     return p_en;
//}
//char *my_decrypt(char *str,char *path_key){
//    char *p_de;
//    RSA *p_rsa;
//    FILE *file;
//    int rsa_len;
//    if((file=fopen(path_key,"r"))==NULL){
//            perror("open key file error");
//            return NULL;
//        }
//    if((p_rsa=PEM_read_RSAPrivateKey(file,NULL,NULL,NULL))==NULL){
//            ERR_print_errors_fp(stdout);
//            return NULL;
//        }
//    rsa_len=RSA_size(p_rsa);
//    p_de=(unsigned char *)malloc(rsa_len+1);
//    memset(p_de,0,rsa_len+1);
//    if(RSA_private_decrypt(rsa_len,(unsigned char *)str,(unsigned char*)p_de,p_rsa,RSA_NO_PADDING)<0){
//            return NULL;
//        }
//    RSA_free(p_rsa);
//    fclose(file);
//      return p_de;
//}



struct ev_loop * EvLoopMake() {
    struct ev_loop * aEvLoop = ev_loop_new(0);
    return aEvLoop;
}

struct ev_loop * EvLoopMakeMain() {
    return ev_default_loop(0);
}
void EvLoopIdentifier(struct ev_loop * from, char * buffer) {
    snprintf(buffer, 32, "%p", from);
}


struct ev_io *EvIOAlloc() {
    ev_io * evIO = (ev_io *)malloc(sizeof(ev_io));
    return evIO;
}
void EvIOInit(struct ev_io *evIO, void (*cb)(struct ev_loop *loop, struct ev_io *evIO, int revents), int sockfd, int events) {
    ev_io_init(evIO, cb, sockfd, events);
}
void EvIOStart(struct ev_loop *loop, struct ev_io *evIO) {
    ev_io_start(loop, evIO);
}

void EvIOStop(struct ev_loop *loop, struct ev_io *evIO) {
    ev_io_stop(loop, evIO);
}
void EvIODealloc(struct ev_io * aEvIO) {
    free(aEvIO);
}
void EvIOIdentifier(struct ev_io * aEvIO, char * buffer) {
    snprintf(buffer, 32, "%p", aEvIO);
}


struct ev_async *EvAsyncAlloc() {
    struct ev_async * async = (struct ev_async *)malloc(sizeof(struct ev_async));
    return async;
}

void EvAsyncInit(struct ev_async *async_watcher, void (*cb)(struct ev_loop *loop, struct ev_async *evAsync, int revents)) {
    ev_async_init(async_watcher, cb);
}

int EvSocketSetnonblock(int sockfd) {
    int flags;
    flags = fcntl(sockfd, F_GETFL);
    flags |= O_NONBLOCK;
    return fcntl(sockfd, F_SETFL, flags);
}

/**************************************************************************************************************/
int SocketBindIpv4(int sockfd, const struct sockaddr_in * addr) {
    return bind(sockfd, (const struct sockaddr *)addr, sizeof(struct sockaddr_in));
}

int SocketBindIpv6(int sockfd, const struct sockaddr_in6 * addr) {
    return bind(sockfd, (const struct sockaddr * )addr, sizeof(struct sockaddr_in6));
}


int	SocketAccept(int sockfd, int * result, struct sockaddr_in6 * addr_in6, struct sockaddr_in * addr) {
    int newfd;
    struct sockaddr_in6 sin;
    socklen_t addrlen = sizeof(struct sockaddr_in6);
    while ((newfd = accept(sockfd, (struct sockaddr *)&sin, &addrlen)) < 0)
    {
        if (errno == EAGAIN || errno == EWOULDBLOCK)
        {
            //these are transient, so don't log anything.
            continue;
        }
        else
        {
            printf("accept error.[%s]\n", strerror(errno));
            break;
        }
    }
    if (addrlen == sizeof(struct sockaddr_in6)) {
        *result = AcceptNewSocketResultIpv6;
    }else if (addrlen == sizeof(struct sockaddr_in)) {
        *result = AcceptNewSocketResultIpv4;
    }else {
        close(newfd);
        printf("unknow error, addrlen error  not ipv4, not ipv6\n");
        *result = AcceptNewSocketResultFailure;
    }

    *addr_in6 = sin;
    *addr = *((struct sockaddr_in *)&sin);
    return newfd;
}
int SocketAcceptThenClose(int sockfd) {
    int newfd;
    struct sockaddr_in6 sin;
    socklen_t addrlen = sizeof(struct sockaddr_in6);
    while ((newfd = accept(sockfd, (struct sockaddr *)&sin, &addrlen)) < 0)
    {
        if (errno == EAGAIN || errno == EWOULDBLOCK)
        {
            //these are transient, so don't log anything.
            continue;
        }
        else
        {
            printf("accept error.[%s]\n", strerror(errno));
            break;
        }
    }
    close(newfd);
    return 1;
}


int	SocketClose(int sockfd) {
    return close(sockfd);
}

long SocketSend(int sockfd, const void * bytes, int beginIndex, int maxLen) {
    
    char *begin = (char *)bytes;
    size_t remainLen = maxLen;
    ssize_t result = 1;
    result = send(sockfd, begin, remainLen, 0);
    printf("write result: %zd\n", result);
    return result;
}

long SocketRecv(int sockfd, void * buffer, int readLen) {
    long ret =0;
loop:
    ret = recv(sockfd, buffer, readLen, 0);
    if(ret > 0)
    {
        return ret;
    }
    else if(ret ==0)
    {
        printf("remote socket closed!socket fd: %d\n", sockfd);
        close(sockfd);
        return -1;
    }
    else
    {
        if(errno == EAGAIN ||errno == EWOULDBLOCK)
        {
            goto loop;
        }
        else
        {
            printf("ret :%ld ,close socket fd : %d\n", ret, sockfd);
            close(sockfd);
            return -1;
        }
    }
}







