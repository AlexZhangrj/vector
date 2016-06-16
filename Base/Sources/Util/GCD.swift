////
////  GCD.swift
////  Base
////
////  Created by 王青海 on 16/6/3.
////  Copyright © 2016年 王青海. All rights reserved.
////
//
//import Foundation
//
//
//public typealias CancelableTask = (cancel: Bool) -> Void
//
//public class GCD: NSObject {
//
//    public static func asyncMainQueue(task: dispatch_block_t?) {
//        if let call = task {
//            dispatch_async(dispatch_get_main_queue(), call)
//        }
//    }
//
//    public static func syncMainQueue(task: dispatch_block_t?) {
//        if let call = task {
//            dispatch_sync(dispatch_get_main_queue(), call)
//        }
//    }
//    
//    public static func safeSyncMainQueue(task: dispatch_block_t?) {
//        if let call = task {
//            if NSThread.isMainThread() {
//                call()
//            }else {
//                dispatch_sync(dispatch_get_main_queue(), call)
//            }
//        }
//    }
//
//    public static func asyncGlobalQueue(task: dispatch_block_t?) {
//        if let call = task {
//            dispatch_async(dispatch_get_global_queue(0, 0), call)
//        }
//    }
//
//    public func delay(time: NSTimeInterval, task: dispatch_block_t?) -> CancelableTask? {
//        guard let call = task else {
//            return nil
//        }
//        
//        var finalTask: CancelableTask?
//        let cancelableTask: CancelableTask = { cancel in
//            if cancel {
//                finalTask = nil
//            } else {
//                dispatch_async(dispatch_get_main_queue(), call)
//            }
//        }
//        finalTask = cancelableTask
//        
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(time * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
//            if let task = finalTask {
//                task(cancel: false)
//            }
//        }
//        return finalTask
//    }
//    public func cancel(cancelableTask: CancelableTask?) {
//        cancelableTask?(cancel: true)
//    }
//
//    
//    public func after(time: NSTimeInterval, task: dispatch_block_t?) {
//        guard let call = task else {
//            return
//        }
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(time * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
//            call()
//        }
//    }
//    public func afterI(time: Int, task: dispatch_block_t?) {
//        guard let call = task else {
//            return
//        }
//        guard time > 0 else {
//            return
//        }
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(Double(time) * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
//            call()
//        }
//    }
//    
//    
//    
//}

//返回值是否取消timer， 取消返回true
public typealias ExponentialTimerTask = (timer: ExponentialTimer) -> Bool

public class ExponentialTimer: NSObject {
    public var currentAfterTime: NSTimeInterval
    private var _task: ExponentialTimerTask?
    private var _canceled: Bool = false
    private var queue: dispatch_queue_t?
    
    
    public init(originalAfterTime: NSTimeInterval, task: ExponentialTimerTask, queue: dispatch_queue_t? = nil) {
        self._task = task
        self.currentAfterTime = originalAfterTime
        super.init()
        if originalAfterTime > 0 {
            if let callQueue = self.queue {
                Async.customQueue(callQueue, after: originalAfterTime, block: {
                    self.doTask()
                })
            }else {
                Async.userInitiated(after: originalAfterTime, block: {
                    self.doTask()
                })
            }
        }else {
            _canceled = true
        }
    }
    
    public func cancel() {
        self._task = nil
        _canceled = true
    }
    
    public func canceled() -> Bool {
        return _canceled
    }
    
    private func doTask() {
        if let call = self._task {
            if !call(timer: self) {
                self.currentAfterTime *= 2
                
                if let callQueue = self.queue {
                    Async.customQueue(callQueue, after: self.currentAfterTime, block: {
                        self.doTask()
                    })
                }else {
                    Async.userInitiated(after: self.currentAfterTime, block: {
                        self.doTask()
                    })
                }
            }else {
                self._task = nil
                _canceled = true
            }
        }else {
            _canceled = true
        }
    }
}





















