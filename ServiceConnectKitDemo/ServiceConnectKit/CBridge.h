//
//  CBridge.h
//  ConnectServiceDemo
//
//  Created by CaiLianfeng on 16/8/28.
//  Copyright © 2016年 WangQinghai. All rights reserved.
//

#ifndef CBridge_h
#define CBridge_h

#include "ev.h"

//Ev


struct ev_loop * EvLoopMake();
struct ev_loop * EvLoopMakeMain();
void EvLoopIdentifier(struct ev_loop * from, char * buffer);


struct ev_io *EvIOAlloc();
void EvIOInit(struct ev_io *evIO, void (*cb)(struct ev_loop *loop, struct ev_io *evIO, int revents), int sockfd, int events);
void EvIOStart(struct ev_loop *loop, struct ev_io *evIO);
void EvIOStop(struct ev_loop *loop, struct ev_io *evIO);
void EvIODealloc(struct ev_io * aEvIO);
void EvIOIdentifier(struct ev_io * aEvIO, char * buffer);


struct ev_async *EvAsyncAlloc();
void EvAsyncInit(struct ev_async *async_watcher, void (*cb)(struct ev_loop *loop, struct ev_async * evAsync, int revents));

int EvSocketSetnonblock(int sockfd);


int SeriviceMain();


//Socket

struct sockaddr_in;
struct sockaddr_in6;

static int AcceptNewSocketResultFailure = 0;
static int AcceptNewSocketResultIpv4 = 1;
static int AcceptNewSocketResultIpv6 = 2;

int SocketBindIpv4(int sockfd, const struct sockaddr_in * addr);

int SocketBindIpv6(int sockfd, const struct sockaddr_in6 * addr);

int	SocketAccept(int sockfd, int * result, struct sockaddr_in6 * addr_in6, struct sockaddr_in * addr);
int SocketAcceptThenClose(int sockfd);
int	SocketClose(int sockfd);



long SocketSend(int sockfd, const void * bytes, int beginIndex, int maxLen);
long SocketRecv(int sockfd, void * buffer, int readLen);














#endif /* CBridge_h */
