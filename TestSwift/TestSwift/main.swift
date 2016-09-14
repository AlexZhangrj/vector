//
//  main.swift
//  TestSwift
//
//  Created by CaiLianfeng on 16/8/8.
//  Copyright © 2016年 WangQinghai. All rights reserved.
//


import Foundation
#if os(Linux)
import SwiftGlibc
#else
import Darwin
#endif
let cStringBuf =  UnsafeMutablePointer<Int8>.allocate(capacity: 1024 * 1024)
let str: [CChar] = "%s".cString(using: String.Encoding.utf8)!
let format = UnsafePointer<CChar>(str)

while true {
    let vaList = withVaList([cStringBuf], { (_vaList) -> CVaListPointer in
        return _vaList
    })
    vscanf(format, vaList)

    let str = String(cString: cStringBuf)
    print(str)
    if str == "exit" {
        break
    }
}


