//
//  ConnectDataItem.swift
//  IMDemo
//
//  Created by wangqinghai on 16/5/17.
//  Copyright © 2016年 st. All rights reserved.
//

import UIKit


@objc public protocol IMConnectDelegate: NSObjectProtocol {
    
    func receiveServerData(data: NSData)
    //    func receiveServerHeartBeat()
    func connectSuccess()
    func connectErrorOccurred()
    
    
    
}

//数据传输层

public enum SendFailureReason {
    case timeout
    case connectDisconnect
    case userClean
}

public class IM: NSObject {
    
    //Business Process 业务处理串行队列
    public static let bpQueue: dispatch_queue_t = dispatch_queue_create("dispatch_queue_t", DISPATCH_QUEUE_SERIAL)
    
    public class func async(block: dispatch_block_t?) {
        if let task = block {
            dispatch_async(bpQueue, task);
        }
    }
    
    public class func sync(block: dispatch_block_t?) {
        if let task = block {
            dispatch_sync(bpQueue, task);
        }
    }
    
    public static func after(delayInSeconds: NSTimeInterval, block: dispatch_block_t?) {
        guard let task = block else {return}
        
        let when: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(delayInSeconds * Double(NSEC_PER_SEC)))
        dispatch_after(when, bpQueue, task)
    }
}



public typealias ConnectDataItemCallBack =  (ConnectDataItem) -> Void
public typealias ConnectDataItemSendFailureCallBack =  (ConnectDataItem, SendFailureReason) -> Void


//返回nil 则立马timeout,发送失败被回调，从数据队列中移除，不再发送   否则还是会发送, 默认反悔nil，返回值为弹性时间
public typealias ConnectDataSenderShouldTimeOutCallBack =  (ConnectDataItem) -> NSTimeInterval?



//@objc public protocol ConnectDataSendOCProtocol {
//    func setTimeOut(timeOut: NSTimeInterval,
//                    shouldTimeOutCallBack: dispatch_block_t?,
//                    shouldTimeOutCallBackQueue: dispatch_queue_t?
//        ) -> Void
//    
//    
//}

public protocol ConnectDataSendProtocol {
    
    //callBackQueue 为nil 时，默认在IMPBQueue调用
    func setSendSuccessCallBack(callBack: ConnectDataItemCallBack, callBackQueue: dispatch_queue_t?) -> Void
    func setSendFailureCallBack(callBack: ConnectDataItemSendFailureCallBack, callBackQueue: dispatch_queue_t?) -> Void
    
    
    //shouldTimeOutCallBackQueue 为nil 时，默认在IMThread调用, timeoutCallBackQueue 为nil 时，默认在IMPBQueue调用
    func setTimeOut(timeOut: NSTimeInterval,
                    shouldTimeOutCallBack: ConnectDataSenderShouldTimeOutCallBack?,
                    shouldTimeOutCallBackQueue: dispatch_queue_t?
        ) -> Void
    
    //    func setTimeOut(timeOut: NSTimeInterval)
    
    //    //shouldTimeOutCallBack 在imthread中调用，timeoutCallBack在IMPBQueue调用
    //    func setTimeOut(timeOut: NSTimeInterval,
    //                    shouldTimeOutCallBack: ConnectDataSenderShouldTimeOutCallBack?,
    //                    sendFailureCallBack: ConnectDataSenderCallBack?) -> Void
    
}


//所有协议方法都在IMThread中调用
@objc public protocol ConnectDataSendDelegateProtocol {
    
    func willTimeOut() -> NSTimeInterval
    func writeDataToBuffer(outputStream: NSOutputStream)
    func bufferDataSendSuccess()
    func sendEnd() -> Bool
    func sendSuccess()
    func sendFailure()
    
    //标识符
    func identifier() -> String
}


@objc public class ConnectDataItem: NSObject {
    public var itemIdentifier: String?
    
    public var date: NSDate
    
    public var data: NSData
    public dynamic var alreadySendLen = 0
    public dynamic var bufferedLen = 0
    public dynamic var sending = false
    
    var sendSuccessCallBackQueue: dispatch_queue_t? = nil
    var sendSuccessCallBack: ConnectDataItemCallBack? = nil
    
    public var timeOut: NSTimeInterval = 0//超时时间，发送前设置有效
    public var isTimeOut: Bool = false//已经超时标记位(超时时间到，但是数据已经开始发送了一部分)
    public var shouldTimeOutCallBackQueue: dispatch_queue_t? = nil
    var shouldTimeOutCallBack: ConnectDataSenderShouldTimeOutCallBack? = nil
    public var sendFailureCallBackQueue: dispatch_queue_t? = nil
    var sendFailureCallBack: ConnectDataItemSendFailureCallBack? = nil
    
    @objc public init(data: NSData) {
        self.date = NSDate()
        self.data = data
    }
}

extension ConnectDataItem: ConnectDataSendProtocol {
    
    //callBackQueue 为nil 时，默认在IMPBQueue调用
    public func setSendSuccessCallBack(callBack: ConnectDataItemCallBack, callBackQueue: dispatch_queue_t?) -> Void {
        self.sendSuccessCallBack = callBack
        self.sendSuccessCallBackQueue = callBackQueue
    }
    
    public func setSendFailureCallBack(callBack: ConnectDataItemSendFailureCallBack, callBackQueue: dispatch_queue_t?) -> Void {
        self.sendFailureCallBack = callBack
        self.sendFailureCallBackQueue = callBackQueue
    }
    
    //shouldTimeOutCallBackQueue 为nil 时，默认在IMThread调用, timeoutCallBackQueue 为nil 时，默认在IMPBQueue调用
    public func setTimeOut(timeOut: NSTimeInterval,
                           shouldTimeOutCallBack: ConnectDataSenderShouldTimeOutCallBack?,
                           shouldTimeOutCallBackQueue: dispatch_queue_t?
        ) -> Void {
        self.timeOut = timeOut
        self.shouldTimeOutCallBack = shouldTimeOutCallBack
        self.shouldTimeOutCallBackQueue = shouldTimeOutCallBackQueue
    }
}


extension ConnectDataItem: ConnectDataSendDelegateProtocol {
    
    public func willTimeOut() -> NSTimeInterval {
        if let shouldTimeOut = self.shouldTimeOutCallBack {
            var shouldTimeOutResult: NSTimeInterval?
            if let shouldTimeOutCallQueue = self.shouldTimeOutCallBackQueue {
                dispatch_sync(shouldTimeOutCallQueue, {
                    shouldTimeOutResult = shouldTimeOut(self)
                })
            }else {
                shouldTimeOutResult = shouldTimeOut(self)
            }
            if let timeOutBuffer = shouldTimeOutResult{
                return timeOutBuffer
            }else {
                return 0
            }
        }else {
            return 0
        }
    }
    public func writeDataToBuffer(outputStream: NSOutputStream) {
        let len = DataHelper.outputStream(outputStream, data: self.data, beginIndex: self.alreadySendLen)
        self.bufferedLen += len
        
        print("len:writeDataToBuffer      \(len)")
    }
    public func bufferDataSendSuccess() {
        self.alreadySendLen += bufferedLen
        self.bufferedLen = 0
    }
    public func sendEnd() -> Bool {
        if self.alreadySendLen == self.data.length {
            return true
        }else if self.alreadySendLen > self.data.length{
            print("非常严重的逻辑错误   sendEnd error: 发送的数据长度大于原生数据长度\(#line)")
            return true
        }
        return false
    }
    public func sendSuccess() {
        if let sendSuccessCall = self.sendSuccessCallBack {
            if let sendSuccessCallQueue = self.sendSuccessCallBackQueue {
                dispatch_async(sendSuccessCallQueue, {
                    sendSuccessCall(self)
                })
            }else {
                IM.async({
                    sendSuccessCall(self)
                })
            }
        }
    }
    public func sendFailure() {
        self.alreadySendLen = 0
        self.bufferedLen = 0
    }
    
    //标识符
    public func identifier() -> String {
        if let str = itemIdentifier {
            return str
        }else {
            return "Normal"
        }
    }
}