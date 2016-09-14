//
//  Base.swift
//  ConnectKitDemo
//
//  Created by CaiLianfeng on 16/8/28.
//  Copyright © 2016年 WangQinghai. All rights reserved.
//

import Foundation


struct IMLog {
    static var logCount: UInt64 = 0
    static let dateFormatter: NSDateFormatter = {
        let formatter = NSDateFormatter()
        let zone = NSTimeZone.systemTimeZone()
        formatter.timeZone = zone
        formatter.dateFormat = "HH:mm:ss SSS"
        return formatter
    }()
    
    static func info(@autoclosure message: () -> Any, _ path: String = #file, _ function: String = #function, line: Int = #line) {
            let date = NSDate()
            let zone = NSTimeZone(abbreviation: "GMT+0800")
            
            let interval = zone!.secondsFromGMTForDate(date)
            let localeDate = date.dateByAddingTimeInterval(Double(interval))
            IMLog.logCount += 1
            var msgStr: String
            if let fileName = path.componentsSeparatedByString("/").last {
                msgStr = "[IM \(IMLog.dateFormatter.stringFromDate(localeDate)) \(NSString(format: "%04d", IMLog.logCount))] thread: \(threadName()) fileName:\(fileName) function: \(function) line: \(line)\nmsg:\(message())"
            }else {
                msgStr = "[IM \(IMLog.dateFormatter.stringFromDate(localeDate)) \(NSString(format: "%04d", IMLog.logCount))] thread: \(threadName()) function: \(function) line: \(line)\nmsg:\(message())"
            }
            print(msgStr)
    }
    
    static func threadName() -> String {
        if NSThread.isMainThread() {
            return "Main"
        } else {
            if let threadName = NSThread.currentThread().name where !threadName.isEmpty {
                return threadName
            } else if let queueName = String(UTF8String:
                dispatch_queue_get_label(DISPATCH_CURRENT_QUEUE_LABEL)) where !queueName.isEmpty {
                return queueName
            } else {
                return String(format: "%p", NSThread.currentThread())
            }
        }
    }
}