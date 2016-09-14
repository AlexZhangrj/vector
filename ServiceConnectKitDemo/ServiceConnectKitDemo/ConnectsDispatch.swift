//
//  ConnectsDispatch.swift
//  ServiceConnectKitDemo
//
//  Created by CaiLianfeng on 16/9/7.
//  Copyright © 2016年 WangQinghai. All rights reserved.
//

import Foundation
import ServiceConnectKit



let DefaultConnectsDispatch = ConnectsDispatch()
class ConnectsDispatch: NSObject {

    

}


extension ConnectsDispatch: TCPServiceSocketDelegate {
    func canAcceptNewSocket(serviceSokcet: TCPServiceSocket) -> Bool {
        return true
    }

    func evLoop(serviceSokcet: TCPServiceSocket, sockfd: Int32) -> EvLoop {
        return eevLoop!
    }
    
    
    
    func didAcceptNewSocket(serviceSokcet: TCPServiceSocket, acceptedSocket: TCPAcceptedSocket) {
        print("didAcceptNewSocket acceptedSocket: \(acceptedSocket)")
        eevLoop?.asyncTask({ (evl) in
            evl.startListenAcceptedSocket(acceptedSocket: acceptedSocket)
        })
    }
    func acceptedSocketDidReconnect(serviceSokcet: TCPServiceSocket, acceptedSocket: TCPAcceptedSocket) {
        print("acceptedSocketDidReconnect acceptedSocket: \(acceptedSocket)")

    }

}


extension ConnectsDispatch: TCPAcceptedSocketDelegate {
    
    func acceptedSocket(_ socket: TCPAcceptedSocket, didReadData data: Data) {
    
    }
    func acceptedSocket(_ socket: TCPAcceptedSocket, didWriteDataWithTag tag: String) {
    
    }
    func acceptedSocketDidClose(_ socket: TCPAcceptedSocket) {
    
    }
    func acceptedSocketDidReconnect(_ socket: TCPAcceptedSocket) {
    
    }
    
 
    
}
