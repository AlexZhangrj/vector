//
//  Thread.swift
//  ServiceKitDemo
//
//  Created by CaiLianfeng on 16/8/10.
//  Copyright © 2016年 WangQinghai. All rights reserved.
//

import Foundation


#if os(Linux)

public enum DispatchTimeoutResult {
    
    case success
    
    case timedOut
}
    
public typealias DispatchQueue = RunLoopThread

public class DispatchWorkItem {
    private let closure: () -> Void
    
    
    public init(closure: () -> Void) {
        self.closure = closure
    }
    
    public func perform() {
        closure()
    }
    
    public func wait() {
    
    }
    
    public func wait(timeout: DispatchTime) -> DispatchTimeoutResult {
        return DispatchTimeoutResult.success
    }
    
    public func wait(wallTimeout: DispatchWallTime) -> DispatchTimeoutResult {
        return DispatchTimeoutResult.success
    }
    
    public func notify(queue: DispatchQueue, execute: DispatchWorkItem) {
    
    }
    
    public func cancel() {
        
    
    }
    
    public var isCancelled: Bool {
        return true
    }
}
    
    
#else
import Dispatch

#endif

public extension DispatchQueue {
    
    public class func safeSyncMain(item: DispatchWorkItem) {
        if Thread.isMainThread {
            item.perform()
        }else {
            DispatchQueue.main.sync {
                item.perform()
            }
        }
    }
}

public class RunLoopThread: NSObject {
    var thread: Thread
    static var main: RunLoopThread = {
        return RunLoopThread(anOpenRunLoopThread: Thread.main)
    }()
    
    
    private class TaskHandler: NSObject {
        var task: DispatchWorkItem?
        
        @objc func performTask() {
            task?.perform()
        }
    }
    
    //
    public init(anOpenRunLoopThread: Thread) {
        self.thread = anOpenRunLoopThread
    }
    
    public init(threadName: String? = nil, _ threadPriority: Double? = nil, _ runLoopMode: String? = nil) {
        thread = Thread(block: {
            autoreleasepool {
                RunLoop.current.run()
            }
        })
        if let name = threadName {
            thread.name = name
        }
        if let tp = threadPriority {
            thread.threadPriority = tp
        }
        thread.start()
    }
    
    public func async(task: DispatchWorkItem) {
        #if os(Linux)
        autoreleasepool { () -> Void in
            let taskHandler = TaskHandler()
            taskHandler.task = task
            taskHandler.perform(#selector(TaskHandler.performTask), on: thread, with: nil, waitUntilDone:false)
        }
        #else
        autoreleasepool { () -> Void in
            if thread.isMainThread {
                DispatchQueue.main.async {
                    task.perform()
                }
            }else {
                let taskHandler = TaskHandler()
                taskHandler.task = task
                taskHandler.perform(#selector(TaskHandler.performTask), on: thread, with: nil, waitUntilDone:false)
            }
        }
        #endif
    }
    
    public func sync(task: DispatchWorkItem) {
        #if os(Linux)
            autoreleasepool { () -> Void in
                let taskHandler = TaskHandler()
                taskHandler.task = task
                taskHandler.perform(#selector(TaskHandler.performTask), on: thread, with: nil, waitUntilDone:true)
            }
        #else
        autoreleasepool { () -> Void in
            if thread.isMainThread {
                DispatchQueue.safeSyncMain(item: task)
            }else {
                let taskHandler = TaskHandler()
                taskHandler.task = task
                taskHandler.perform(#selector(TaskHandler.performTask), on: thread, with: nil, waitUntilDone:true)
            }
        }
        #endif
    }
}

