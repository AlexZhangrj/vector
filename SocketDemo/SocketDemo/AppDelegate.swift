//
//  AppDelegate.swift
//  SocketDemo
//
//  Created by CaiLianfeng on 16/9/3.
//  Copyright © 2016年 WangQinghai. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!


    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        print(NSHomeDirectory())
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

