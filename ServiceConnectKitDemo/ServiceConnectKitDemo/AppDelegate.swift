//
//  AppDelegate.swift
//  ServiceConnectKitDemo
//
//  Created by CaiLianfeng on 16/9/1.
//  Copyright © 2016年 WangQinghai. All rights reserved.
//

import Cocoa
import ServiceConnectKit
import Dispatch
import CryptoKit

var eevLoop: EvLoop?
var DefaultMainEvLoop: MainEvLoop?
var DefaultServiceSocket: TCPServiceSocket!

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!

    var rootVC = RootViewController()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
//        let privateKeyPath = "/Users/WangQinghai/Desktop/TestRSA/plainPrv.key"
//        let publicKeyPath = "/Users/WangQinghai/Desktop/TestRSA/plainPub.key"
        
        let privateKeyPath = "/Users/WangQinghai/Desktop/TestRSA/rsa_private_key.pem"
        let publicKeyPath = "/Users/WangQinghai/Desktop/TestRSA/rsa_public_key.pem"
        
        let pubData = try! Data(contentsOf: URL(fileURLWithPath: publicKeyPath))
        let priData = try! Data(contentsOf: URL(fileURLWithPath: privateKeyPath))
        
        let publicKey = RSACrypt.RSAKey.publicKey(pemFileData: pubData)
        let privateKey = RSACrypt.RSAKey.privateKey(pemFileData: priData)
        //let privateKeyResult = RSACrypt.RSAKey.key(pemFileData: priData)
//        tttzzz(publicKey: publicKey!.formatString, privateKey: privateKey!.formatString)
        
        let dataStr = "1231313131tttzzz(publicKey: publicKey!.formatString, privateKey: privateKey!.formatString)tttzzz(publicKey: publicKey!.formatString, privateKey: privateKey!.formatString)   let dat2 = RSACrypt.encrypt(data: data, withPublicKey: publicKey!) ~~~~~~\n"
//        let data = dataStr.data(using: String.Encoding.utf8)!
//        let dat2 = RSACrypt.encrypt(data: data, withPublicKey: publicKey!)
//        if let dta3 = RSACrypt.decrypt(data: dat2, withPrivateKey: privateKey!) {
//            let str3 = String.init(data: dta3, encoding: String.Encoding.utf8)
//            print("str3 : \(str3)")
//        }

        let dat2 = RSACrypt.encrypt(string: dataStr, withPublicKey: publicKey!)
        if let dta3 = RSACrypt.decrypt(encryptedStringData: dat2!, withPrivateKey: privateKey!) {
            print("str3 : \(dta3)")
        }
        
        
        let dat4 = RSACrypt.encrypt(string: dataStr, withPrivateKey: privateKey!)
        if let dta4 = RSACrypt.decrypt(encryptedStringData: dat4!, withPublicKey: publicKey!) {
            print("str4 : \(dta4)")
        }
        
        self.window.contentViewController = rootVC
        
        DispatchQueue.global().async {
//            SeriviceMain()
            
            EvLoop.makeAEvLoop(0.9, beforeLoop: { (evloop) in
                eevLoop = evloop
                DispatchQueue.global().async {
                    EvLoop.mainEvLoop({ (mainEvloop) in
                        DefaultMainEvLoop = mainEvloop
                        
                        if let serviceSocket = mainEvloop.startTCPService(on: 6666, delegate: DefaultConnectsDispatch, queue: DispatchQueue.main) {
                            print("listen success")
                            DefaultServiceSocket = serviceSocket
                            
                        }else {
                            print("listen faild")
                        
                        }
                    })
                }
            })

//            evLoop.asyncTask({ (loop) in
//                loop.addIOListener(listener)
//            })
        }
        
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

