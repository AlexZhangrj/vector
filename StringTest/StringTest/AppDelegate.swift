//
//  AppDelegate.swift
//  StringTest
//
//  Created by CaiLianfeng on 2016/9/8.
//  Copyright © 2016年 WangQinghai. All rights reserved.
//

import Cocoa
import Dispatch

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: 64)
        let str = String(cString: buffer)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

