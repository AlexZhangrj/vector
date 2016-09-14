//
//  AppDelegate.swift
//  ConnectServiceDemo
//
//  Created by CaiLianfeng on 16/8/28.
//  Copyright © 2016年 WangQinghai. All rights reserved.
//

import Cocoa

import ConnectServiceKit

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!


    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
        
        dispatch_async(dispatch_get_global_queue(0, 0)) { 
            SeriviceMain()
        }
        
        
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }


}

