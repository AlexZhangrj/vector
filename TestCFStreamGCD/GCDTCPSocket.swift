//
//  GCDTCPSocket.swift
//  TestCFStreamGCD
//
//  Created by 王青海 on 16/6/17.
//  Copyright © 2016年 王青海. All rights reserved.
//

import UIKit

public protocol GCDTCPSocketDelegate: NSObjectProtocol {
    func connectSuccess(aSocket: GCDTCPSocket) -> Void
    func disconnect(aSocket: GCDTCPSocket) -> Void
    func didReadData(aSocket: GCDTCPSocket, dataBuffer: UnsafeMutablePointer<UInt8>, len: Int) -> Void
    func itemForWrite(aSocket: GCDTCPSocket) -> SocketDataProtocol?



}

public enum GCDTCPSocketState: UInt32 {
    case Normal = 0
    case Connecting = 1
    case Connected = 2
    case Disconnect = 3

}

public class GCDTCPSocket: NSObject {
    let ipAdr: String
    let port: Int
    let delegateQueue: dispatch_queue_t
    weak var delegate: GCDTCPSocketDelegate?
    
    private var _streamsExit: Bool = false
    private var _inStream: NSInputStream?
    private var _outStream: NSOutputStream?
    
    private static let _reciveDataBufferMaxLen = 1024 * 32
    private var _reciveDataBuffer = UnsafeMutablePointer<UInt8>.alloc(_reciveDataBufferMaxLen)
    private var _sendingItem: SocketDataProtocol?


    

    
    
    
    public init?(withIdAdr ipAdr: String, port: Int, delegate: GCDTCPSocketDelegate, delegateQueue: dispatch_queue_t = dispatch_get_main_queue()) {
        if ipAdr == "" || port == 0 {
            return nil
        }
        self.ipAdr = ipAdr
        self.port = port
        self.delegateQueue = delegateQueue
        self.delegate = delegate
        super.init()
    }
    deinit {
        _reciveDataBuffer.destroy()
    }
    
    public func connect() -> Bool {
        if !_streamsExit {
            var host: CFHostRef? = nil
            host = CFHostCreateWithName(nil, ipAdr as CFString).takeUnretainedValue()
            
            if (host != nil) {
                var inStream: NSInputStream?
                var outStream: NSOutputStream?
                // 创建连接到一个特定主机的特定端口的一对可读写流
                //                var u = Unmanaged<CFReadStream>.fromOpaque(readStream.)
                let r = UnsafeMutablePointer<Unmanaged<CFReadStream>?>.alloc(1)
                let w = UnsafeMutablePointer<Unmanaged<CFWriteStream>?>.alloc(1)
                CFStreamCreatePairWithSocketToCFHost(nil, host!, Int32(port), r, w)
                if let read = r.memory?.takeUnretainedValue() {
                    inStream = read as NSInputStream
                }
                if let wirte = w.memory?.takeUnretainedValue() {
                    outStream = wirte as NSOutputStream
                }
                r.destroy()
                w.destroy()
                if inStream == nil || outStream == nil {
                    return false
                }else {
                    self._inStream = inStream!
                    self._outStream = outStream!
                }
            }else {
                return false
            }
            _inStream!.delegate = self
            _outStream!.delegate = self
//            CFReadStreamSetDispatchQueue(_inStream! as CFReadStream, delegateQueue);
//            CFWriteStreamSetDispatchQueue(_outStream! as CFWriteStream, delegateQueue);
            _inStream?.scheduleInRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)
            _outStream?.scheduleInRunLoop(NSRunLoop.mainRunLoop(), forMode: NSDefaultRunLoopMode)

            _inStream!.open()
            _outStream!.open()
            _streamsExit = true
            return true
        }else {
            print("多次 connect ")
            return true
        }
    }

    public func disconnect() {
        if _streamsExit {
            _inStream!.delegate = nil
            _outStream!.delegate = nil
            _inStream!.close()
            _outStream!.close()
            _inStream = nil
            _outStream = nil
            _inStreamConnected = false
            _outStreamConnected = false
            _streamsExit = false
        }
    }
    
    public func writeData(data: NSData) {
        let aa = data.bytes
        let bb = UnsafePointer<UInt8>(aa)
        if let count = _outStream?.write(bb, maxLength: data.length) {
            print("writeData len:\(count)  allLen:\(data.length)")
            if count == -1 {
                if let out = _outStream {
                    print("_outStream status:\(out.streamStatus.rawValue)  error:\(out.streamError?.localizedDescription)")
                }
            
            }
            
        }
    }
    
    public func needWrite() {
        if let item = self.delegate?.itemForWrite(self) {
//            self._sendingItem = item
//            item.writeDataToBuffer(_outStream!)
        }
    }
    
    
    
    
    
    
    private var _inStreamConnected: Bool = false
    private var _outStreamConnected: Bool = false

    private func _checkConnected() -> Bool {
        if _inStreamConnected && _outStreamConnected {
            return true
        }else {
            return false
        }
    }
    
    private func _writeItem(item: SocketDataProtocol) -> Bool {
        if _inStreamConnected && _outStreamConnected {
            return true
        }else {
            return false
        }
    }
    
    //  Stream开启成功
    private func _handleEventOpenCompletedStream(aStream: NSStream) {
        if aStream == _inStream {
            _inStreamConnected = true
            if _checkConnected() {
                self.delegate?.connectSuccess(self)
            }
        }else if aStream == _outStream {
            _outStreamConnected = true
            if _checkConnected() {
                self.delegate?.connectSuccess(self)
            }
        }
    }
    
    //可以发送数据了，开始从数据队列中取数据发送
    private func _handleEventHasSpaceAvailableStream(aStream: NSStream) {
        if aStream == _outStream {
            needWrite()
        }else if aStream == _inStream {
           print("_inStream \(aStream) _handleEventHasSpaceAvailableStream ")
        }
    }

    
    //socket 断开
    private func _handleEventErrorOccurredStream(aStream: NSStream) {
        if aStream == _outStream {
            print("_outStream \(aStream) _handleEventHasSpaceAvailableStream ")

        }else if aStream == _inStream {
            print("_inStream \(aStream) _handleEventHasSpaceAvailableStream ")
        }else {
            print("else aStream  \(aStream) _handleEventHasSpaceAvailableStream ")
        }
    }
    
    
    //socket 正常关闭
    private func _handleEventEndEncounteredStream(aStream: NSStream) {
        if aStream == _outStream {
            print("_outStream \(aStream) _handleEventEndEncounteredStream ")
            
        }else if aStream == _inStream {
            print("_inStream \(aStream) _handleEventEndEncounteredStream ")
        }else {
            print("else aStream  \(aStream) _handleEventEndEncounteredStream ")
        }
    }

    //socket 读到数据
    private func _handleEventHasBytesAvailableStream(aStream: NSStream) {
        if aStream == _outStream {
            print("_outStream \(aStream) _handleEventHasBytesAvailableStream ")
            
        }else if aStream == _inStream {
            var len = 0
            len = _inStream!.read(_reciveDataBuffer, maxLength: GCDTCPSocket._reciveDataBufferMaxLen)
            print("_inStream  \(aStream) _handleEventHasBytesAvailableStream len:\(len)")
            while len > 0 {
                self.delegate?.didReadData(self, dataBuffer: _reciveDataBuffer, len: len)
                len = _inStream!.read(_reciveDataBuffer, maxLength: GCDTCPSocket._reciveDataBufferMaxLen)
            }
            
            
        }else {
            print("else aStream  \(aStream) _handleEventHasBytesAvailableStream ")
        }
    }
    
//    if (len > 0) {  //  读取到东西了
//    //            [_receiveLock lock];    //  加锁
//    [_receiveBuffer appendBytes:(const void *)buf length:len];  //  添加缓冲区中的东西到 receiveBuffer
//    
//    
//    
//    NSString *str = [[NSString alloc] initWithData:_receiveBuffer encoding:NSUTF8StringEncoding];
//    
//    [_receiveBuffer replaceBytesInRange:NSMakeRange(0, _receiveBuffer.length) withBytes:NULL length:0];
//    
//    NSLog(@"%@", str);
//    
//    [IM after:3 block:^{
//    NSMutableString *mstr = [[NSMutableString alloc] initWithString:@"aherkjhafjdshjkasf"];
//    NSString * mstr2 = [NSString stringWithFormat:@"%@", @(arc4random())];
//    [mstr appendString:mstr2];
//    ConnectDataItem *item = [[ConnectDataItem alloc] initWithData:[mstr dataUsingEncoding:NSUTF8StringEncoding]];
//    item.itemIdentifier = @"aa";
//    
//    [self writeToConnect:item];
//    
//    
//    
//    
//    }];
//    
//    }
//    else {
//    IMConnectLog(@"No buffer!");
//    }
//    }
//    }
}

extension GCDTCPSocket: NSStreamDelegate {
    
    public func stream(aStream: NSStream, handleEvent eventCode: NSStreamEvent) {
        let code = eventCode.rawValue
        print("\(aStream)  eventCode:\(eventCode.rawValue)")
        if code & NSStreamEvent.OpenCompleted.rawValue == NSStreamEvent.OpenCompleted.rawValue {
            _handleEventOpenCompletedStream(aStream)
        }
        if code & NSStreamEvent.HasSpaceAvailable.rawValue == NSStreamEvent.HasSpaceAvailable.rawValue {
            _handleEventHasSpaceAvailableStream(aStream)
        }
        if code & NSStreamEvent.ErrorOccurred.rawValue == NSStreamEvent.ErrorOccurred.rawValue {
            _handleEventErrorOccurredStream(aStream)
        }
        if code & NSStreamEvent.EndEncountered.rawValue == NSStreamEvent.EndEncountered.rawValue {
            _handleEventEndEncounteredStream(aStream)
        }
        if code & NSStreamEvent.HasBytesAvailable.rawValue == NSStreamEvent.HasBytesAvailable.rawValue {
            _handleEventHasBytesAvailableStream(aStream)
        }
//        if code == NSStreamEvent.OpenCompleted.rawValue {
//            _handleEventOpenCompletedStream(aStream)
//        }else if code == NSStreamEvent.HasSpaceAvailable.rawValue {
//            _handleEventHasSpaceAvailableStream(aStream)
//        }else if code == NSStreamEvent.ErrorOccurred.rawValue {
//            _handleEventErrorOccurredStream(aStream)
//        }else if code == NSStreamEvent.EndEncountered.rawValue {
//            _handleEventEndEncounteredStream(aStream)
//        }else if code == NSStreamEvent.HasBytesAvailable.rawValue {
//            _handleEventHasBytesAvailableStream(aStream)
//        }else {
//            print("else aStream  \(aStream) handleEvent ")
//        }
        
    }
}




