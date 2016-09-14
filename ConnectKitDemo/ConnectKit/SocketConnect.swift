//
//  Connect.swift
//  ConnectKitDemo
//
//  Created by CaiLianfeng on 16/8/28.
//  Copyright © 2016年 WangQinghai. All rights reserved.
//

import Foundation



public protocol ConnectDelegate: class {
    func connectSuccess(connect: SocketConnect)
    func connectFailure(connect: SocketConnect, error: NSError)
    func connectClosed(connect: SocketConnect, error: NSError?)
    func connectDidReceiveData(connect: SocketConnect, data: NSData)
}




public typealias ClientConnectClosure = (SocketConnect) -> Void

public class SocketConnect : NSObject {
    public typealias DataItemClosure = (connect: SocketConnect, item: SocketConnect.DataItem) -> Void
    
    public class DataItem: NSObject {
        public enum State: UInt32 {
            case Waiting = 0
            case Sending = 1
            case WaitTimeouted = 2
            case SendFailure = 3
            case SendSuccess = 4
        }
        
        public let data: NSData
        private var tag: Int = 0

        public dynamic private(set) var stateRawValue: UInt32 = 0
        public private(set) var state: State = .Waiting {
            didSet(oldValue) {
                if oldValue != state {
                    stateRawValue = state.rawValue
                }
            }
        }
        
        private var successClosure: DataItemClosure?
        private var timeoutClosure: DataItemClosure?
        private var failureClosure: DataItemClosure?

        public init(data: NSData) {
            self.data = data
        }
        
    }
    
    public enum State : UInt32 {
        case Disconnect
        case Connecting
        case Connected
    }
    
    //连接状态
    public dynamic private(set) var stateRawValue: UInt32 = 0
    public var state: State = .Disconnect {
        didSet(oldValue) {
            if oldValue != state {
                stateRawValue = state.rawValue
            }
        }
    }
    private var sendItems: [DataItem] = []
    
    private var tagSequence: SequenceGenerator<Int> = SequenceGenerator(sequence: 0)
    //socket
    internal var socket: GCDAsyncSocket?
    
    //代理队列
    public let delegateQueue: dispatch_queue_t
    
    //socket ip
    internal var ipAdr: String = ""
    
    //socket 端口
    internal var port: Int = 0
    
    internal var connectSuccess: ClientConnectClosure?
    internal var connectFailure: ClientConnectClosure?
    
    public weak var delegate: ConnectDelegate?
    internal var tlsSettings: [NSObject : AnyObject]?
    
    
    public init(delegateQueue: dispatch_queue_t = dispatch_get_main_queue()) {
        self.delegateQueue = delegateQueue
    }
    
    //must call in delegateQueue, default queue is mainQueue, when call this will disconnect old stream, then all items will send faild
    public func connect(ipAdr: String, port: Int, tlsSettings: [NSObject : AnyObject]?) {
        self.ipAdr = ipAdr
        self.port = port
        self.tlsSettings = tlsSettings
        if let _socket = socket {
            _socket.delegate = nil
            _socket.disconnect()
        }
        
        let oldSendItems = self.sendItems
        self.sendItems = []
        for item in oldSendItems {
            item.state = .SendFailure
            item.failureClosure?(connect: self, item: item)
            item.timeoutClosure = nil
            item.successClosure = nil
            item.failureClosure = nil
        }
        
        socket = GCDAsyncSocket(delegate: self, delegateQueue: self.delegateQueue)
        do {
            try socket!.connectToHost(self.ipAdr, onPort: UInt16(self.port))
        }catch let error {
            dispatch_async(self.delegateQueue, {
                self.state = .Disconnect
                self.delegate?.connectFailure(self, error: error as NSError)
            })
        }
        self.state = .Connecting
    }
    internal func disconnect() {
        if let csocket = socket {
            csocket.disconnect()
        }
    }
    internal func removeAllSendItems() {
        sendItems.removeAll()
    }

    //default timeout time = 300, min time = 3, max = 3600
    public func writeToConnect(item: DataItem, waitingTimeout: NSTimeInterval = 300, successClosure: DataItemClosure? = nil, timeoutClosure: DataItemClosure? = nil, failureClosure: DataItemClosure? = nil) {
        
        if let _ = self.sendItems.indexOf(item) {
            IMLog.info("item has been send more than once")
            return
        }
        item.state = .Waiting
        item.tag = tagSequence.nextSequence()
        item.successClosure = successClosure
        item.timeoutClosure = timeoutClosure
        item.failureClosure = failureClosure

        sendItems.append(item)
        
        var timeout: NSTimeInterval
        if waitingTimeout < 3 {
            timeout = 3
        }else if waitingTimeout > 3600 {
            timeout = 3600
        }else {
            timeout = waitingTimeout
        }
        let nanoSeconds = Int64(timeout * Double(NSEC_PER_SEC))
        let time = dispatch_time(DISPATCH_TIME_NOW, nanoSeconds)
        dispatch_after(time, self.delegateQueue, {
            if item.state == .Waiting {
                if let index = self.sendItems.indexOf(item) {
                    self.sendItems.removeAtIndex(index)
                }
                item.state = .WaitTimeouted
                item.timeoutClosure?(connect: self, item: item)
                item.timeoutClosure = nil
                item.successClosure = nil
                item.failureClosure = nil
            }
        })
        _setNeedWrite()
    }

    private func _setNeedWrite() {
        if state == .Connected {
            _writeItem()
        }
    }
    
    private func _suitableItem() -> DataItem? {
        for item in sendItems {
            if item.state == DataItem.State.Waiting {
                return item
            }
        }
        return nil
    }
    
    private func _writeItem() {
        while true {
            if let item = _suitableItem() {
                if let csocket = self.socket {
                    item.state = .Sending
                    csocket.writeData(item.data, withTimeout: -1, tag: item.tag)
                    IMLog.info("socket: writedata:\(item.data.length) tag: \(item.tag) ")
                }
            }else {
                break
            }
        }
    }
    
    private func _socketDidConnect(sock: GCDAsyncSocket) {
        IMLog.info("connect success:\(self.ipAdr) port:\(self.port)")
        self.state = .Connected
        self.delegate?.connectSuccess(self)
        self._setNeedWrite()
        sock.readDataWithTimeout(-1, tag: 0)
    }
    private func _item(withTag tag: Int) -> DataItem? {
        for item in sendItems {
            if item.tag == tag {
                return item
            }
        }
        return nil
    }
}

// MARK: -  Socket Delegate
extension SocketConnect: GCDAsyncSocketDelegate {
    
    public func socket(sock: GCDAsyncSocket!, didConnectToHost host: String!, port: UInt16) {
        if let _tlsSettings = tlsSettings {
            IMLog.info("socket:\(sock) host:\(host) port:\(port) 建联成功，开始ssl握手")
            sock.startTLS(_tlsSettings)
        }else {
            _socketDidConnect(sock)
        }
    }
    
    public func socketDidSecure(sock: GCDAsyncSocket!) {
        IMLog.info("socket:\(sock) ssl握手完成)")
        _socketDidConnect(sock)
    }
    
    public func socket(sock: GCDAsyncSocket!, didWriteDataWithTag tag: Int) {
        if let item = _item(withTag: tag) {
            item.state = .SendSuccess
            if let index = self.sendItems.indexOf(item) {
                self.sendItems.removeAtIndex(index)
            }
            item.successClosure?(connect: self, item: item)
            item.successClosure = nil
            item.timeoutClosure = nil
            item.failureClosure = nil
        }
        IMLog.info("socket:\(sock) didWriteDataWithTag) tag:\(tag)")
    }
    
    public func socket(sock: GCDAsyncSocket!, didReadData data: NSData!, withTag tag: Int) {
        IMLog.info("socket:\(sock) didReadData:  dataLen\(data.length) tag:\(tag))")
        self.delegate?.connectDidReceiveData(self, data: data)
        sock.readDataWithTimeout(-1, tag: 0)
    }
    
    public func socketDidDisconnect(sock: GCDAsyncSocket!, withError err: NSError?) {
        if self.state == .Connected {
            IMLog.info("socket:\(sock) socketDidDisconnect err:\(err))")
            self.state = .Disconnect
            disconnect()
            self.delegate?.connectClosed(self, error: err)
        }else {
            var error: NSError
            if let _err = err {
                error = _err
            }else {
                error = NSError(domain: "未知错误", code: 0, userInfo: nil)
            }
            self.delegate?.connectFailure(self, error: error)
        }
    }
}








