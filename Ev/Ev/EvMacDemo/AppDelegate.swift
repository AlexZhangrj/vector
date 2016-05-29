//
//  AppDelegate.swift
//  EvMacDemo
//
//  Created by 王青海 on 16/5/29.
//  Copyright © 2016年 王青海. All rights reserved.
//

import Cocoa

import Ev



@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!


    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
        
        
        test()
        
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }


}

