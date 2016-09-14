//
//  RootViewController.swift
//  ServiceConnectKitDemo
//
//  Created by CaiLianfeng on 2016/9/9.
//  Copyright © 2016年 WangQinghai. All rights reserved.
//

import Cocoa
import ServiceConnectKit


class RootViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        self.view.layer?.backgroundColor = NSColor.red.cgColor
        
        
    }
    
    @IBAction func restartAction(_ sender: AnyObject) {
        DefaultMainEvLoop?.asyncTask({ (mainEvloop) in
            if let serviceSocket = mainEvloop.startTCPService(on: 6666, delegate: DefaultConnectsDispatch, queue: DispatchQueue.main) {
                print("listen success")
                DefaultServiceSocket = serviceSocket

            }else {
                print("listen faild")
                
            }
        })
        
        
        
    }
    
    @IBAction func closeAction(_ sender: AnyObject) {
        DefaultMainEvLoop?.asyncTask({ (mainEvloop) in
            mainEvloop.stopTCPService(identifier: DefaultServiceSocket.identifier)
        })
        
    }
    
    
}
