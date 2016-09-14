//
//  Managers.swift
//  ServiceConnectKitDemo
//
//  Created by CaiLianfeng on 16/9/4.
//  Copyright © 2016年 WangQinghai. All rights reserved.
//

import Foundation

open class ClientSocketsGroup {
    let evLoop: EvLoop
    
    public init(evLoop: EvLoop) {
        self.evLoop = evLoop
    }
    
    
    
    
    
    
    
}

open class ClientSocketsManager {
    var clientSocketsGroups: [String: ClientSocketsGroup] = [:]
    
    public init() {
        
    }





}
