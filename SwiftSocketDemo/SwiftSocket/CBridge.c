//
//  CBridge.c
//  SwiftSocketDemo
//
//  Created by CaiLianfeng on 16/9/3.
//  Copyright © 2016年 WangQinghai. All rights reserved.
//

#include "CBridge.h"

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <errno.h>
#include <sys/types.h>
#include <netinet/in.h>
#include <sys/socket.h>
#include <pthread.h>
#include <unistd.h>

#include <arpa/inet.h>
#include <net/if.h>
#include <sys/ioctl.h>




int ipv4SocketBind(int sockfd, const struct sockaddr_in * addr) {
    return bind(sockfd, (const struct sockaddr *)addr, sizeof(struct sockaddr_in));
}

int ipv6SocketBind(int sockfd, const struct sockaddr_in6 * addr) {
    return bind(sockfd, (const struct sockaddr * )addr, sizeof(struct sockaddr_in6));
}


int	acceptASocket(int sockfd, int * result, struct sockaddr_in6 * addr_in6, struct sockaddr_in * addr) {
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
    if (addrlen == sizeof(struct sockaddr_in)) {
        *result = AcceptASocketResultIpv6;
    }else if (addrlen == sizeof(struct sockaddr_in)) {
        *result = AcceptASocketResultIpv4;
    }else {
        printf("unknow error, addrlen error  not ipv4, not ipv6\n");
        *result = AcceptASocketResultFailure;
    }
    
    
    
    
    *addr_in6 = sin;
    *addr = *((struct sockaddr_in *)&sin);
    return newfd;
}











