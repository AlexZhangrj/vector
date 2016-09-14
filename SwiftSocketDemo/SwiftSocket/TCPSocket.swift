//
//  TCPSocket.swift
//  SwiftSocketDemo
//
//  Created by CaiLianfeng on 16/9/3.
//  Copyright © 2016年 WangQinghai. All rights reserved.
//

import Foundation

#if os(OSX)
    import Darwin
#elseif os(Linux)
    import Glibc
#endif

///Only ipv6 support
public class TCPSocket {
    public enum AddressType: UInt32 {
        case Ipv4
        case Ipv6
    }
    
    
//    var ipAddr: String?
//    var port: UInt16?
    public var ipAddr: String
    public var port: UInt16
    public private(set) var addressType: AddressType = .Ipv6
    init(addr: String, port: UInt16) {
        self.ipAddr = addr
        self.port = port
    }
}

public class TCPClientSocket: TCPSocket {
    public init(ipAddr: String?, port: UInt16) {
        var addr: String = "localhost"
        if let _ipAddr = ipAddr {
            addr = _ipAddr
        }
        super.init(addr: addr, port: port)
    }
}

public class TCPServiceSocket: TCPSocket {

    public var waitAcceptQueueLenght: Int32 = 1024

    public init(ipAddr: String?, port: UInt16) {
        var addr: String = "localhost"
        if let _ipAddr = ipAddr {
            addr = _ipAddr
        }
        super.init(addr: addr, port: port)
    }
    
    private var sockfd: Int32?
    private var binded: Bool = false
    private var listening: Bool = false

    public func bindNet() -> Bool {
        if self.binded {
            print("has been binded")
            return false
        }
        var addr: sockaddr_in6 = sockaddr_in6()
        let sockfd = socket(PF_INET6, SOCK_STREAM, 0)
        if sockfd == -1 {
            return false
        }
        addr.sin6_family = UInt8(PF_INET6)    // IPv6
        addr.sin6_port = port.bigEndian
        var ip: String
        if "localhost" != ipAddr {
            ip = ipAddr
        }else {
            ip = "127.0.0.1"
        }
        inet_pton(PF_INET6, ip.cStringUsingEncoding(NSUTF8StringEncoding)!, &addr.sin6_family)
        
        addr.sin6_addr = in6addr_any
        
        let bindResult = ipv6SocketBind(sockfd, &addr)
        if bindResult == -1 {
            return false
        }
        self.sockfd = sockfd
        self.binded = true
        return true
    }
    
    public func beginListen() -> Bool {
        if self.binded == false {
            print("mast begin listen after bindNet() success")
            return false
        }
        if self.listening {
            print("has been listening")
            return false
        }
        let listenResult = listen(self.sockfd!, self.waitAcceptQueueLenght)
        if listenResult == -1 {
            return false
        }
        self.listening = true
        return true
    }
    
    public func acceptClient() -> TCPClientSocket? {
        if self.listening == false {
            return nil
        }
        
        var addr: sockaddr_in = sockaddr_in()
        var addr_in6: sockaddr_in6 = sockaddr_in6()
        var result: Int32 = 0
        let clientSockfd = acceptASocket(self.sockfd!, &result, &addr_in6, &addr)
        
        if result == AcceptASocketResultIpv4 {
            var ipAddrBuffer: UnsafeMutablePointer<Int8>?
            ipAddrBuffer = inet_ntoa(addr.sin_addr)
            guard ipAddrBuffer != nil else {
                close(clientSockfd)
                return nil
            }
            let ipAddr = String(CString: ipAddrBuffer!, encoding: NSUTF8StringEncoding)
            let clientSocket = TCPClientSocket(ipAddr: ipAddr, port: UInt16(bigEndian: addr.sin_port))
            return clientSocket
        }else if result == AcceptASocketResultIpv6 {
            let ipAddrBuffer: UnsafeMutablePointer<Int8> = UnsafeMutablePointer<Int8>.alloc(65)
            inet_ntop(AF_INET6, &addr_in6.sin6_addr, ipAddrBuffer, 65)
            let ipAddr = String(CString: ipAddrBuffer, encoding: NSUTF8StringEncoding)
            ipAddrBuffer.destroy()
            let clientSocket = TCPClientSocket(ipAddr: ipAddr, port: UInt16(bigEndian: addr.sin_port))
            return clientSocket
        }else {
            return nil
        }
        
        
        return nil
    }
    
    public func closeSocket() {
        if self.listening {
            self.listening = false
        }
        if self.binded {
            self.binded = false
        }
        
        if let _sockfd = sockfd {
            close(_sockfd);
            sockfd = nil
        }
    }
    
    
    /*

     while (1) {
     len = sizeof(struct sockaddr);
     if ((new_fd =
     accept(sockfd, (struct sockaddr *) &their_addr,
     &len)) == -1) {
     perror("accept");
     exit(errno);
     } else
     printf("server: got connection from %s, port %d, socket %d/n",
     /* inet_ntoa(their_addr.sin_addr), */ // IPv4
     inet_ntop(AF_INET6, &their_addr.sin6_addr, buf, sizeof(buf)), // IPv6
     /* ntohs(their_addr.sin_port), new_fd); */ // IPv4
     their_addr.sin6_port, new_fd); // IPv6
     
     /* 开始处理每个新连接上的数据收发 */
     bzero(buf, MAXBUF + 1);
     strcpy(buf,
     "这是在连接建立成功后向客户端发送的第一个消息/n只能向new_fd这个用accept函数新建立的socket发消息，不能向sockfd这个监听socket发送消息，监听socket不能用来接收或发送消息/n");
     /* 发消息给客户端 */
     len = send(new_fd, buf, strlen(buf), 0);
     if (len < 0) {
     printf
     ("消息'%s'发送失败！错误代码是%d，错误信息是'%s'/n",
     buf, errno, strerror(errno));
     } else
     printf("消息'%s'发送成功，共发送了%d个字节！/n",
     buf, len);
     
     bzero(buf, MAXBUF + 1);
     /* 接收客户端的消息 */
     len = recv(new_fd, buf, MAXBUF, 0);
     if (len > 0)
     printf("接收消息成功:'%s'，共%d个字节的数据/n",
     buf, len);
     else
     printf
     ("消息接收失败！错误代码是%d，错误信息是'%s'/n",
     errno, strerror(errno));
     /* 处理每个新连接上的数据收发结束 */
     }
     
     close(sockfd);
     return 0;
     }
     
     */
    
/*
     int sockfd, new_fd;
     socklen_t len;
     
     /* struct sockaddr_in my_addr, their_addr; */ // IPv4
     struct sockaddr_in6 my_addr, their_addr; // IPv6
     
     unsigned int myport, lisnum;
     char buf[MAXBUF + 1];
     
     if (argv[1])
     myport = atoi(argv[1]);
     else
     myport = 7838;
     
     if (argv[2])
     lisnum = atoi(argv[2]);
     else
     lisnum = 2;
     
     /* if ((sockfd = socket(PF_INET, SOCK_STREAM, 0)) == -1) { */ // IPv4
     if ((sockfd = socket(PF_INET6, SOCK_STREAM, 0)) == -1) { // IPv6
     perror("socket");
     exit(1);
     } else
     printf("socket created/n");
     
     bzero(&my_addr, sizeof(my_addr));
     /* my_addr.sin_family = PF_INET; */ // IPv4
     my_addr.sin6_family = PF_INET6;    // IPv6
     /* my_addr.sin_port = htons(myport); */ // IPv4
     my_addr.sin6_port = htons(myport);   // IPv6
     if (argv[3])
     /* my_addr.sin_addr.s_addr = inet_addr(argv[3]); */ // IPv4
     inet_pton(AF_INET6, argv[3], &my_addr.sin6_addr);  // IPv6
     else
     /* my_addr.sin_addr.s_addr = INADDR_ANY; */ // IPv4
     my_addr.sin6_addr = in6addr_any;            // IPv6
     
     /* if (bind(sockfd, (struct sockaddr *) &my_addr, sizeof(struct sockaddr)) */ // IPv4
     if (bind(sockfd, (struct sockaddr *) &my_addr, sizeof(struct sockaddr_in6))  // IPv6
     == -1) {
     perror("bind");
     exit(1);
     } else
     printf("binded/n");
     
     if (listen(sockfd, lisnum) == -1) {
     perror("listen");
     exit(1);
     } else
     printf("begin listen/n");
     
     while (1) {
     len = sizeof(struct sockaddr);
     if ((new_fd =
     accept(sockfd, (struct sockaddr *) &their_addr,
     &len)) == -1) {
     perror("accept");
     exit(errno);
     } else
     printf("server: got connection from %s, port %d, socket %d/n",
     /* inet_ntoa(their_addr.sin_addr), */ // IPv4
     inet_ntop(AF_INET6, &their_addr.sin6_addr, buf, sizeof(buf)), // IPv6
     /* ntohs(their_addr.sin_port), new_fd); */ // IPv4
     their_addr.sin6_port, new_fd); // IPv6
     
     /* 开始处理每个新连接上的数据收发 */
     bzero(buf, MAXBUF + 1);
     strcpy(buf,
     "这是在连接建立成功后向客户端发送的第一个消息/n只能向new_fd这个用accept函数新建立的socket发消息，不能向sockfd这个监听socket发送消息，监听socket不能用来接收或发送消息/n");
     /* 发消息给客户端 */
     len = send(new_fd, buf, strlen(buf), 0);
     if (len < 0) {
     printf
     ("消息'%s'发送失败！错误代码是%d，错误信息是'%s'/n",
     buf, errno, strerror(errno));
     } else
     printf("消息'%s'发送成功，共发送了%d个字节！/n",
     buf, len);
     
     bzero(buf, MAXBUF + 1);
     /* 接收客户端的消息 */
     len = recv(new_fd, buf, MAXBUF, 0);
     if (len > 0)
     printf("接收消息成功:'%s'，共%d个字节的数据/n",
     buf, len);
     else
     printf
     ("消息接收失败！错误代码是%d，错误信息是'%s'/n",
     errno, strerror(errno));
     /* 处理每个新连接上的数据收发结束 */
     }
     
     close(sockfd);
     return 0;
     }
     
     */

}

