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
//
//
