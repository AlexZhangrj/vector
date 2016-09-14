//
//  TCPProto.swift
//  ServiceConnectKitDemo
//
//  Created by CaiLianfeng on 2016/9/11.
//  Copyright © 2016年 WangQinghai. All rights reserved.
//

import Foundation


public struct Header {
    public var version: UInt16
    public var sequence: UInt16
    public var serviceId: UInt16
    public var itemId: UInt16
    public var bodyLen: UInt16
}


