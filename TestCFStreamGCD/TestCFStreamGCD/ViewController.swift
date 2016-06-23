//
//  ViewController.swift
//  TestCFStreamGCD
//
//  Created by 王青海 on 16/6/16.
//  Copyright © 2016年 王青海. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var socket: IMSocketConnect?
    var sock: GCDTCPSocket?

    var timer: NSTimer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
//        self.socket = IMSocketConnect()
//        self.socket?.connect("192.168.1.5", port: 5555, status: 0)
        
        

        
        timer = NSTimer.scheduledTimerWithTimeInterval(5, target: self, selector: #selector(timerCall), userInfo: nil, repeats: true)
        NSRunLoop.mainRunLoop().addTimer(timer!, forMode: NSDefaultRunLoopMode)
        
        sock = GCDTCPSocket(withIdAdr: "192.168.1.5", port: 5555, delegate: self)
        sock?.connect()
        print(sock)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    @objc func timerCall() {
        if let call = self.block {
            call()
        }
    }
    
    var block: dispatch_block_t?
}

extension ViewController: GCDTCPSocketDelegate {
    func connectSuccess(aSocket: GCDTCPSocket) -> Void {
        print("connectSuccess")
        
        self.block = {
            let str = "abcdefghigklmnopqrstuvwxyz1234567890-=~!@#$%^&*()_+\n\n\n"
            let mstr = NSMutableString()
            for _ in 0...50 {
                mstr.appendString(str)
            }
            
            let data = mstr.dataUsingEncoding(NSUTF8StringEncoding)
            aSocket.writeData(data!)
        }
        
    }
    func disconnect(aSocket: GCDTCPSocket) -> Void {
        print("disconnect")

    }
    
    func didReadData(aSocket: GCDTCPSocket, dataBuffer: UnsafeMutablePointer<UInt8>, len: Int) -> Void {
        print("len: \(len)")
    }
    func itemForWrite(aSocket: GCDTCPSocket) -> SocketDataProtocol?
    {
        let str = "abcdefghigklmnopqrstuvwxyz1234567890-=~!@#$%^&*()_+\n\n\n"
        let mstr = NSMutableString()
        for _ in 0...50 {
           mstr.appendString(str)
        }
        
        let data = mstr.dataUsingEncoding(NSUTF8StringEncoding)
        let wdata = NSMutableData()
        aSocket.writeData(data!)

//        for _ in 0...5000 {
//            aSocket.writeData(data!)
//
////            wdata.appendData(data!)
//        }
//        aSocket.writeData(wdata)

        return nil
    }
}
