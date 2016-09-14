//
//  CBridge.h
//  SwiftSocketDemo
//
//  Created by CaiLianfeng on 16/9/3.
//  Copyright © 2016年 WangQinghai. All rights reserved.
//

#ifndef CBridge_h
#define CBridge_h

struct sockaddr_in;
struct sockaddr_in6;

static int AcceptASocketResultFailure = 0;
static int AcceptASocketResultIpv4 = 1;
static int AcceptASocketResultIpv6 = 2;

int ipv4SocketBind(int sockfd, const struct sockaddr_in * addr);

int ipv6SocketBind(int sockfd, const struct sockaddr_in6 * addr);

int	acceptASocket(int sockfd, int * result, struct sockaddr_in6 * addr_in6, struct sockaddr_in * addr);




#endif /* CBridge_h */
