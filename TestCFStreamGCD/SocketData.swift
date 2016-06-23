//
//  SocketData.swift
//  TestCFStreamGCD
//
//  Created by 王青海 on 16/6/18.
//  Copyright © 2016年 王青海. All rights reserved.
//

import Foundation

public protocol SocketDataProtocol: NSObjectProtocol {
    
    func writeDataToBuffer(outputStream: NSOutputStream)
    func isWriteEnd() -> Bool
}






public class SocketData: NSObject {
    public dynamic var alreadyWriteLen: Int = 0
    
    public var writeToBufferCanTimeout: Bool = false
    public var writeToBufferTimeout: NSTimeInterval = 10

    public var createDate: NSDate?
    public var data: NSData
    private var _property: NSMutableDictionary?

    
    @objc public init(aData: NSData) {
        createDate = NSDate()
        data = aData
    }
    
    public func setTimeout(timeout: NSTimeInterval, can: Bool = true) {
        writeToBufferCanTimeout = can
        writeToBufferTimeout = timeout
    }
    
    public func setProperty(obj: AnyObject?, forKey key: String) {
        if let propertyDict = _property {
            if let aobj = obj {
                propertyDict.setObject(aobj, forKey: key)
            }else {
                propertyDict.removeObjectForKey(key)
            }
        }else {
            if let aobj = obj {
                let propertyDict = NSMutableDictionary()
                _property = propertyDict
                propertyDict.setObject(aobj, forKey: key)
            }
        }
    }
    public func getProperty(forKey key: String) -> AnyObject? {
        if let propertyDict = _property {
            return propertyDict.objectForKey(key)
        }else {
            return nil
        }
    }
    public func cleanProperty() {
        _property = nil
    }
    
    public subscript(key : String) -> AnyObject? {
        get
        {
            return getProperty(forKey: key)
        }
        set(newObj)
        {
            setProperty(newObj, forKey: key)
        }
    }
}

extension SocketData: SocketDataProtocol {

    public func writeDataToBuffer(outputStream: NSOutputStream) {
        let len = DataHelper.outputStream(outputStream, data: self.data, beginIndex: self.alreadyWriteLen)
        self.alreadyWriteLen += len
        
        print("len:writeDataToBuffer      \(len)")
    }

    public func isWriteEnd() -> Bool {
        if self.alreadyWriteLen == self.data.length {
            return true
        }else if self.alreadyWriteLen > self.data.length{
            print("非常严重的逻辑错误   sendEnd error: 发送的数据长度大于原生数据长度\(#line)")
            return true
        }
        return false
    }
}