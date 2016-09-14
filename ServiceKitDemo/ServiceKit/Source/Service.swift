//
//  Service.swift
//  ServiceKitDemo
//
//  Created by CaiLianfeng on 16/8/9.
//  Copyright © 2016年 WangQinghai. All rights reserved.
//

import Foundation


public class Service {
    public let name: String
    public var tag: String?
    
    public init(name: String) {
        self.name = name
    }
    
    public func start() {
        
    
    
    }
    
    public func end() {
        
        
        
    }
}


public class ConsoleManager {
    let cStringBuf: UnsafeMutablePointer<Int8>
    let str: [CChar]
    let format: UnsafePointer<CChar>
    let vaList: CVaListPointer
    
    public static var share: ConsoleManager = ConsoleManager()
    
    public init(bufferLen: UInt = 2 * 1024) {
        cStringBuf =  UnsafeMutablePointer<Int8>.allocate(capacity: Int(bufferLen))
        str = "%s".cString(using: String.Encoding.utf8)!
        format = UnsafePointer<CChar>(str)
        vaList = withVaList([cStringBuf], { (_vaList) -> CVaListPointer in
            return _vaList
        })
    }
    deinit {
        cStringBuf.deinitialize()
    }
    
    public func readStringToBuffer() {
        vscanf(format, vaList)
    }
    
    public func stringFromBuffer() -> String {
        let str = String(cString: cStringBuf)
        return str
    }
    
    public func readString() -> String {
        vscanf(format, vaList)
        let str = String(cString: cStringBuf)
        return str
    }
}

public class CmdService: Service {
    public static let cmdConsoleManager = ConsoleManager(bufferLen: 1024 * 8)
    var thread: Thread!
    public init() {
        super.init(name: "CmdService")
        thread = Thread(block: {[weak self] in
            while true {
                if let strongSelf = self {
                    let str = CmdService.cmdConsoleManager.readString()
                    print(str)
                    if str == "exit" {
                        break
                    }
                }else {
                    break
                }
            }
        })
    }
    
    public override func start() {
        thread.start()
    }
    
    public override func end() {
        thread.cancel()
    }
    
    
}
