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

///Only Ipv6 support
open class TCPSocket {
    public enum AddressType: UInt32 {
        case Ipv4
        case Ipv6
    }
    
    
    //    var ipAddr: String?
    //    var port: UInt16?
    open var ipAddr: String
    open var port: UInt16
    open fileprivate(set) var addressType: AddressType = .Ipv6
    open let identifier: String
    open var delegateQueue: DispatchQueue?
    init(addr: String, port: UInt16, identifier: String? = nil) {
        self.ipAddr = addr
        self.port = port
        if let _identifier = identifier {
            self.identifier = _identifier
        }else {
            self.identifier = "\(addr):\(port)"
        }
    }
}

public protocol TCPAcceptedSocketDelegate: class {
    func acceptedSocket(_ socket: TCPAcceptedSocket, didReadData data: Data)
    func acceptedSocket(_ socket: TCPAcceptedSocket, didWriteDataWithTag tag: String)
    func acceptedSocketDidClose(_ socket: TCPAcceptedSocket)
    func acceptedSocketDidReconnect(_ socket: TCPAcceptedSocket)

}

open class TCPAcceptedSocket: TCPSocket {
    public enum SendDataFailureReason: UInt32 {
        case DataInRangeHasNoData
        case SocketClosed
    }
    public enum SendDataResult {
        case Success(Int)
        case Failure(SendDataFailureReason)
    }
    
    public enum ReadDataFailureReason: UInt32 {
        case SocketClosed
    }
    public enum ReadDataResult {
        case Success(Data)
        case Failure(ReadDataFailureReason)
    }
    
    
    open let sockfd: Int32
    internal var context: EvLoop
    internal var ioListener: EvIOListener!
    open weak var delegate: TCPAcceptedSocketDelegate?

    struct DataItem {
        let data: Data
        let identifier: String
    }
    internal var datas: [DataItem] = []
    internal var dataLocation: Int = 0
    internal var connected: Bool = true

    internal init(ipAddr: String, port: UInt16, addressType: TCPSocket.AddressType, sockfd: Int32, context: EvLoop) {
        self.sockfd = sockfd
        self.context = context
        super.init(addr: ipAddr, port: port, identifier: "\(ipAddr):\(port)@\(sockfd)")
        ioListener = EvIOListener(socketIdentifier: identifier, sockfd: sockfd, context: context, eventHandlers: [.ReadAble: {[weak self] (listener) in
            if let strongSelf = self {
                strongSelf.needRead()
            }
            }, .WriteAble: {[weak self] (listener) in
            if let strongSelf = self {
                strongSelf.becomeWriteAble()
            }
            }])
        self.addressType = addressType
        EvSocketSetnonblock(sockfd)
    }
    deinit {
    }
    
    static func identifierFrom(ipAddr: String, port: UInt16, addressType: TCPSocket.AddressType, sockfd: Int32, context: EvLoop) -> String {
        let identifier = "\(ipAddr):\(port)@\(sockfd)"
        return identifier
    }
    
    open var currentEvLoop: EvLoop? {
        return context
    }
    
    func sendData(_ data: Data, range: NSRange) -> SendDataResult {
        guard data.count > range.location + 1 else {
            print("there has an error   (data.length > range.location + 1) == false")
            return SendDataResult.Failure(SendDataFailureReason.DataInRangeHasNoData)
        }
        
        let begin = Int32(range.location)
        var len: Int32 = 0
        if range.location + range.length > data.count {
            len = Int32(data.count - range.location)
        }else {
            len = Int32(range.length)
        }
        
        let sendResult = SocketSend(sockfd, (data as NSData).bytes, begin, len)
        if sendResult < 0 {
            print("there has an error,   send data result < 0, result is \(sendResult)")
            return SendDataResult.Failure(SendDataFailureReason.SocketClosed)
        }else {
            return SendDataResult.Success(sendResult)
        }
    }
    
    func readData() -> ReadDataResult {
        print("readData");
        
        let result = SocketRecv(self.sockfd, self.currentEvLoop!.ioReadBuffer, Int32(self.currentEvLoop!.ioReadBufferLen))
        if result <= 0 {
            self.removeFromEvLoop()
            return ReadDataResult.Failure(TCPAcceptedSocket.ReadDataFailureReason.SocketClosed)
        }else {
            let data = Data(bytes: self.currentEvLoop!.ioReadBuffer, count: result)
            return ReadDataResult.Success(data)
        }
    }
    
    internal func close() {
        if Thread.current == context.thread {
            _close()
        }else {
            context.asyncTask({ (evLoop) in
                self._close()
            })
        }
    }
    
    private func _close() {
        if self.connected {
            SocketClose(sockfd)
            self.connected = false
        }
    }
    
    internal func needRead() {
        print("needRead");
        let result = self.readData()
        switch result {
        case .Success(let data):
            if let _delegate = self.delegate {
                if let _delegateQueue = delegateQueue {
                    _delegateQueue.async {
                        _delegate.acceptedSocket(self, didReadData: data)
                    }
                }else {
                    _delegate.acceptedSocket(self, didReadData: data)
                }
            }
        case .Failure(let reason):
            if reason == .SocketClosed {
                self.connected = false
                self.context.removeIOListener(self.ioListener)
                if let _delegate = self.delegate {
                    if let _delegateQueue = delegateQueue {
                        _delegateQueue.async {
                            _delegate.acceptedSocketDidClose(self)
                        }
                    }else {
                        _delegate.acceptedSocketDidClose(self)
                    }
                }
            }
        }
    }
    
    public func hasDataWrite() -> Bool {
        return self.datas.count > 0
    }
    
    public func sendData(data: Data, tag: String) {
        if Thread.current == context.thread {
            _sendData(data: data, tag: tag)
        }else {
            context.asyncTask({ (evLoop) in
                self._sendData(data: data, tag: tag)
            })
        }
    }
    
    internal func _sendData(data: Data, tag: String) {
        self.datas.append(DataItem(data: data, identifier: tag))
        self.needSend()
    }
    
    internal func needSend() {
        if self.datas.count > 0 {
            realSendData()
        }
    }

    internal func didReconnectSuccess() {
        print("didReconnectSuccess");
        if let _delegate = self.delegate {
            if let _delegateQueue = delegateQueue {
                _delegateQueue.async {
                    _delegate.acceptedSocketDidReconnect(self)
                }
            }else {
                _delegate.acceptedSocketDidReconnect(self)
            }
        }
        
    }
    
    func realSendData() {
        let dataItem = self.datas.first!
        let data = dataItem.data
        let range = NSRange(location: dataLocation, length: data.count - dataLocation)
        let writeResult = sendData(data, range: range)
        switch writeResult {
        case .Success(let sendCount):
            dataLocation += sendCount
            if dataLocation >= data.count {
                self.datas.removeFirst()
                if let _delegate = self.delegate {
                    if let _delegateQueue = delegateQueue {
                        _delegateQueue.async {
                            _delegate.acceptedSocket(self, didWriteDataWithTag: dataItem.identifier)
                        }
                    }else {
                        _delegate.acceptedSocket(self, didWriteDataWithTag: dataItem.identifier)
                    }
                }
            }
        case .Failure(let reason):
            if reason == .SocketClosed {
                self.connected = false
                self.context.removeIOListener(self.ioListener)
                
                if let _delegate = self.delegate {
                    if let _delegateQueue = delegateQueue {
                        _delegateQueue.async {
                            _delegate.acceptedSocketDidClose(self)
                        }
                    }else {
                        _delegate.acceptedSocketDidClose(self)
                    }
                }
            }else {
                print("reason: \(reason.rawValue)")
            }
        }
    }
    
    internal func becomeWriteAble() {
        print("date: \(NSDate())   becomeWriteAble");
        if self.hasDataWrite() {
//            sendData()
            realSendData()
        }else {
            self.ioListener.turnToListenRead()
        }
    }
    
    internal func removeFromEvLoop() {
        context.stopListenAcceptedSocket(acceptedSocket: self)
    }
    
}

public protocol TCPServiceSocketDelegate: class {
    func canAcceptNewSocket(serviceSokcet: TCPServiceSocket) -> Bool
    func evLoop(serviceSokcet: TCPServiceSocket, sockfd: Int32) -> EvLoop

    func didAcceptNewSocket(serviceSokcet: TCPServiceSocket, acceptedSocket: TCPAcceptedSocket)
    func acceptedSocketDidReconnect(serviceSokcet: TCPServiceSocket, acceptedSocket: TCPAcceptedSocket)

}

open class TCPServiceSocket: TCPSocket {
    internal weak var context: EvLoop?
    open var waitAcceptQueueLenght: Int32 = 1024

    open unowned var delegate: TCPServiceSocketDelegate
    
    internal init(ipAddr: String?, port: UInt16, context: EvLoop, delegate: TCPServiceSocketDelegate, queue: DispatchQueue?) {
        var addr: String = "localhost"
        if let _ipAddr = ipAddr {
            addr = _ipAddr
        }
        self.delegate = delegate
        super.init(addr: addr, port: port)
        self.context = context
        self.delegateQueue = queue
    }
    
    open var sockfd: Int32?
    open var binded: Bool = false
    open var listening: Bool = false
    
    open func bindNet() -> Bool {
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
        inet_pton(PF_INET6, ip.cString(using: String.Encoding.utf8)!, &addr.sin6_family)
        
        addr.sin6_addr = in6addr_any
        
        let bindResult = SocketBindIpv6(sockfd, &addr)
        if bindResult == -1 {
            return false
        }
        EvSocketSetnonblock(sockfd)
        self.sockfd = sockfd
        self.binded = true
        return true
    }
    
    open func beginListen() -> Bool {
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
    
    open func needAcceptSocket()  {
        acceptSocket()
        return
    }
    
    func acceptSocket() -> TCPAcceptedSocket? {
        if self.listening == false {
            print("self.listening is false")
            return nil
        }
        guard let evLoop = self.context else {
            print("self.context is nil")
            return nil
        }

        var addr: sockaddr_in = sockaddr_in()
        var addr_in6: sockaddr_in6 = sockaddr_in6()
        var result: Int32 = 0
        let clientSockfd = SocketAccept(self.sockfd!, &result, &addr_in6, &addr)
        
        var ipAddr: String
        var port: UInt16
        var addressType: AddressType
        if result == AcceptNewSocketResultIpv4 {
            var ipAddrBuffer: UnsafeMutablePointer<Int8>?
            ipAddrBuffer = inet_ntoa(addr.sin_addr)
            guard ipAddrBuffer != nil else {
                close(clientSockfd)
                return nil
            }
            ipAddr = String(cString: ipAddrBuffer!)
            port = UInt16(bigEndian: addr.sin_port)
            addressType = .Ipv4
        }else if result == AcceptNewSocketResultIpv6 {
            let ipAddrBuffer: UnsafeMutablePointer<Int8> = UnsafeMutablePointer<Int8>.allocate(capacity: 65)
            inet_ntop(AF_INET6, &addr_in6.sin6_addr, ipAddrBuffer, 65)
            ipAddr = String(cString: ipAddrBuffer)
            ipAddrBuffer.deinitialize()
            port = UInt16(bigEndian: addr.sin_port)
            addressType = .Ipv6
        }else {
            return nil
        }

        var canAcceptSocket: Bool = false
        var clientEvLoop: EvLoop?
        
        if let queue = delegateQueue {
            queue.sync {
                canAcceptSocket = delegate.canAcceptNewSocket(serviceSokcet: self)
                clientEvLoop = delegate.evLoop(serviceSokcet: self, sockfd: clientSockfd)
            }
        }else {
            canAcceptSocket = delegate.canAcceptNewSocket(serviceSokcet: self)
            clientEvLoop = delegate.evLoop(serviceSokcet: self, sockfd: clientSockfd)
        }
        
        
        if let client = clientEvLoop!.listenedTCPAcceptSockets[TCPAcceptedSocket.identifierFrom(ipAddr: ipAddr, port: port, addressType: addressType, sockfd: clientSockfd, context: evLoop)] {
            client.didReconnectSuccess()
            return nil
        }else {
            let clientSocket = TCPAcceptedSocket(ipAddr: ipAddr, port: port, addressType: addressType, sockfd: clientSockfd, context: clientEvLoop!)

            if canAcceptSocket {
                if let queue = delegateQueue {
                    queue.async(execute: {
                        self.delegate.didAcceptNewSocket(serviceSokcet: self, acceptedSocket: clientSocket)
                    })
                }else {
                    self.delegate.didAcceptNewSocket(serviceSokcet: self, acceptedSocket: clientSocket)
                }
            }else {
                SocketClose(clientSockfd)
            }
            
            return clientSocket
        }
    }
    
    open func closeSocket() {
        if self.listening {
            self.listening = false
        }
        if self.binded {
            self.binded = false
            if let _sockfd = sockfd {
                close(_sockfd);
                sockfd = nil
            }
        }
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
    


