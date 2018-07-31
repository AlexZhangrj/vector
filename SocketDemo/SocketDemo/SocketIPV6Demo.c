////
////  SocketIPV6Demo.c
////  SocketDemo
////
////  Created by CaiLianfeng on 16/9/3.
////  Copyright © 2016年 WangQinghai. All rights reserved.
////
//
//#include "SocketIPV6Demo.h"
//
//
//#include <stdio.h>
//#include <string.h>
//#include <errno.h>
//#include <sys/socket.h>
//#include <resolv.h>
//#include <stdlib.h>
//#include <netinet/in.h>
//#include <arpa/inet.h>
//#include <unistd.h>
//#define MAXBUF 1024
//int main(int argc, char **argv)
//{
//    int sockfd, len;
//    /* struct sockaddr_in dest; */ // IPv4
//    struct sockaddr_in6 dest;      // IPv6
//    char buffer[MAXBUF + 1];
//    
//    if (argc != 3) {
//        printf
//        ("参数格式错误！正确用法如下：/n/t/t%s IP地址 端口/n/t比如:/t%s 127.0.0.1 80/n此程序用来从某个 IP 地址的服务器某个端口接收最多 MAXBUF 个字节的消息",
//         argv[0], argv[0]);
//        exit(0);
//    }
//    /* 创建一个 socket 用于 tcp 通信 */
//    /* if ((sockfd = socket(AF_INET, SOCK_STREAM, 0)) < 0) { */ // IPv4
//    if ((sockfd = socket(AF_INET6, SOCK_STREAM, 0)) < 0) {      // IPv6
//        perror("Socket");
//        exit(errno);
//    }
//    printf("socket created/n");
//    
//    /* 初始化服务器端（对方）的地址和端口信息 */
//    bzero(&dest, sizeof(dest));
//    /* dest.sin_family = AF_INET; */  // IPv4
//    dest.sin6_family = AF_INET6;     // IPv6
//    /* dest.sin_port = htons(atoi(argv[2])); */ // IPv4
//    dest.sin6_port = htons(atoi(argv[2]));     // IPv6
//    /* if (inet_aton(argv[1], (struct in_addr *) &dest.sin_addr.s_addr) == 0) { */ // IPv4
//    if ( inet_pton(AF_INET6, argv[1], &dest.sin6_addr) < 0 ) {                 // IPv6
//        perror(argv[1]);
//        exit(errno);
//    }
//    printf("address created/n");
//    
//    /* 连接服务器 */
//    if (connect(sockfd, (struct sockaddr *) &dest, sizeof(dest)) != 0) {
//        perror("Connect ");
//        exit(errno);
//    }
//    printf("server connected/n");
//    
//    /* 接收对方发过来的消息，最多接收 MAXBUF 个字节 */
//    bzero(buffer, MAXBUF + 1);
//    /* 接收服务器来的消息 */
//    len = recv(sockfd, buffer, MAXBUF, 0);
//    if (len > 0)
//        printf("接收消息成功:'%s'，共%d个字节的数据/n",
//               buffer, len);
//    else
//        printf
//        ("消息接收失败！错误代码是%d，错误信息是'%s'/n",
//         errno, strerror(errno));
//    
//    bzero(buffer, MAXBUF + 1);
//    strcpy(buffer, "这是客户端发给服务器端的消息/n");
//    /* 发消息给服务器 */
//    len = send(sockfd, buffer, strlen(buffer), 0);
//    if (len < 0)
//        printf
//        ("消息'%s'发送失败！错误代码是%d，错误信息是'%s'/n",
//         buffer, errno, strerror(errno));
//    else
//        printf("消息'%s'发送成功，共发送了%d个字节！/n",
//               buffer, len);
//    
//    /* 关闭连接 */
//    close(sockfd);
//    return 0;
//}
//
//
//
//
//
//#include <stdio.h>
//#include <stdlib.h>
//#include <errno.h>
//#include <string.h>
//#include <sys/types.h>
//#include <netinet/in.h>
//#include <sys/socket.h>
//#include <sys/wait.h>
//#include <unistd.h>
//#include <arpa/inet.h>
//#define MAXBUF 1024
//int main2(int argc, char **argv)
//{
//    int sockfd, new_fd;
//    socklen_t len;
//    
//    /* struct sockaddr_in my_addr, their_addr; */ // IPv4
//    struct sockaddr_in6 my_addr, their_addr; // IPv6
//    
//    unsigned int myport, lisnum;
//    char buf[MAXBUF + 1];
//    
//    if (argv[1])
//        myport = atoi(argv[1]);
//    else
//        myport = 7838;
//    
//    if (argv[2])
//        lisnum = atoi(argv[2]);
//    else
//        lisnum = 2;
//    
//    /* if ((sockfd = socket(PF_INET, SOCK_STREAM, 0)) == -1) { */ // IPv4
//    if ((sockfd = socket(PF_INET6, SOCK_STREAM, 0)) == -1) { // IPv6
//        perror("socket");
//        exit(1);
//    } else
//        printf("socket created/n");
//    
//    bzero(&my_addr, sizeof(my_addr));
//    /* my_addr.sin_family = PF_INET; */ // IPv4
//    my_addr.sin6_family = PF_INET6;    // IPv6
//    /* my_addr.sin_port = htons(myport); */ // IPv4
//    my_addr.sin6_port = htons(myport);   // IPv6
//    if (argv[3])
//    /* my_addr.sin_addr.s_addr = inet_addr(argv[3]); */ // IPv4
//        inet_pton(AF_INET6, argv[3], &my_addr.sin6_addr);  // IPv6
//    else
//    /* my_addr.sin_addr.s_addr = INADDR_ANY; */ // IPv4
//        my_addr.sin6_addr = in6addr_any;            // IPv6
//    
//    /* if (bind(sockfd, (struct sockaddr *) &my_addr, sizeof(struct sockaddr)) */ // IPv4
//    if (bind(sockfd, (struct sockaddr *) &my_addr, sizeof(struct sockaddr_in6))  // IPv6
//        == -1) {
//        perror("bind");
//        exit(1);
//    } else
//        printf("binded/n");
//    
//    if (listen(sockfd, lisnum) == -1) {
//        perror("listen");
//        exit(1);
//    } else
//        printf("begin listen/n");
//    
//    while (1) {
//        len = sizeof(struct sockaddr);
//        if ((new_fd =
//             accept(sockfd, (struct sockaddr *) &their_addr,
//                    &len)) == -1) {
//                 perror("accept");
//                 exit(errno);
//             } else
//                 printf("server: got connection from %s, port %d, socket %d/n",
//                        /* inet_ntoa(their_addr.sin_addr), */ // IPv4
//                        inet_ntop(AF_INET6, &their_addr.sin6_addr, buf, sizeof(buf)), // IPv6
//                        /* ntohs(their_addr.sin_port), new_fd); */ // IPv4
//                        their_addr.sin6_port, new_fd); // IPv6
//        
//        /* 开始处理每个新连接上的数据收发 */
//        bzero(buf, MAXBUF + 1);
//        strcpy(buf,
//               "这是在连接建立成功后向客户端发送的第一个消息/n只能向new_fd这个用accept函数新建立的socket发消息，不能向sockfd这个监听socket发送消息，监听socket不能用来接收或发送消息/n");
//        /* 发消息给客户端 */
//        len = send(new_fd, buf, strlen(buf), 0);
//        if (len < 0) {
//            printf
//            ("消息'%s'发送失败！错误代码是%d，错误信息是'%s'/n",
//             buf, errno, strerror(errno));
//        } else
//            printf("消息'%s'发送成功，共发送了%d个字节！/n",
//                   buf, len);
//        
//        bzero(buf, MAXBUF + 1);
//        /* 接收客户端的消息 */
//        len = recv(new_fd, buf, MAXBUF, 0);
//        if (len > 0)
//            printf("接收消息成功:'%s'，共%d个字节的数据/n",
//                   buf, len);
//        else
//            printf
//            ("消息接收失败！错误代码是%d，错误信息是'%s'/n",
//             errno, strerror(errno));
//        /* 处理每个新连接上的数据收发结束 */
//    }
//    
//    close(sockfd);  
//    return 0;  
//}
