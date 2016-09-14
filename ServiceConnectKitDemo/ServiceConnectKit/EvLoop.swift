//
//  EvLoop.swift
//  ServiceConnectKitDemo
//
//  Created by CaiLianfeng on 16/9/1.
//  Copyright © 2016年 WangQinghai. All rights reserved.
//

import Foundation


internal let DefaultEvLoopManager = EvLoopManager()
internal class EvLoopManager {
    fileprivate class EvLoopCacheItem {
        weak var aEvLoop: EvLoop?
        init(aEvLoop: EvLoop) {
            self.aEvLoop = aEvLoop
        }
    }
    
    fileprivate let lock: NSLock = NSLock()
    fileprivate var sequenceCount: Int64 = 10
    fileprivate var evLoops: [String: EvLoopCacheItem] = [:]
    fileprivate var mainEvLoopCacheItem: EvLoopCacheItem?

    internal func evLoop(_ identifier: String) -> EvLoop? {
        lock.lock()
        let aEvLoop: EvLoop? = evLoops[identifier]?.aEvLoop
        lock.unlock()
        return aEvLoop
    }
    
    internal func saveEvLoop(_ aEvLoop: EvLoop, identifier: String) {
        lock.lock()
        let item = EvLoopCacheItem(aEvLoop: aEvLoop)
        evLoops[identifier] = item
        if aEvLoop.isMainLoop {
            self.mainEvLoopCacheItem = item
        }
        lock.unlock()
    }
    internal func allEvLoops() -> [EvLoop] {
        lock.lock()
        let dict = evLoops
        var resultEvLoops: [EvLoop] = []
        for (_, item) in dict {
            if let value = item.aEvLoop {
                resultEvLoops.append(value)
            }
        }
        lock.unlock()
        return resultEvLoops
    }
    internal func mainEvLoop() -> MainEvLoop? {
        var result: MainEvLoop?
        lock.lock()
        if let item = self.mainEvLoopCacheItem {
            if let value = item.aEvLoop {
                result = value as? MainEvLoop
            }
        }
        lock.unlock()
        return result
    }
    
    fileprivate init() {
        
    }
}

open class EvLoop {
    public typealias SelfClosure = (EvLoop) -> Void
    internal class EvAsyncTaskItem {
        let task: EvLoop.SelfClosure
        init(task: @escaping EvLoop.SelfClosure) {
            self.task = task
        }
    }
    
    open fileprivate(set) var thread: Thread
    open fileprivate(set) var listenedServiceSockets: [String: TCPServiceSocket] = [:]
    open fileprivate(set) var listenedTCPAcceptSockets: [String: TCPAcceptedSocket] = [:]

    let idenfifier: String
    
    var context: OpaquePointer

    open var allEvLoops: [EvLoop] {
        return DefaultEvLoopManager.allEvLoops()
    }

    
    var asyncHandler: UnsafeMutablePointer<ev_async>

    var prepared: Bool = false
    fileprivate var taskItems: [EvAsyncTaskItem] = []
    fileprivate let taskItemsLock: NSLock = NSLock()
    
    internal let ioReadBufferLen: Int = 1024*8

    internal let ioReadBuffer: UnsafeMutablePointer<Int8>

    static func identifier(withContext context: OpaquePointer) -> String {
        let buffer = UnsafeMutablePointer<Int8>.allocate(capacity: 64)
        
        EvLoopIdentifier(context, buffer)
        
        let idenfifier = String(cString: buffer)
        buffer.deinitialize()
        return idenfifier
    }
    open var isMainLoop: Bool
    internal init(isMain: Bool, thread: Thread) {
        self.isMainLoop = isMain
        if isMain {
            self.context = EvLoopMakeMain()
        }else {
            self.context = EvLoopMake()
        }
        ioReadBuffer = UnsafeMutablePointer<Int8>.allocate(capacity: ioReadBufferLen)
        let buffer = UnsafeMutablePointer<Int8>.allocate(capacity: 64)
        
        EvLoopIdentifier(context, buffer)
        idenfifier = String(cString: buffer)
        buffer.deinitialize()
        
        asyncHandler = EvAsyncAlloc()
        EvAsyncInit(asyncHandler) {(loop, asyncHandler, events) in
            autoreleasepool(invoking: {
                let identifier = EvLoop.identifier(withContext: loop!)
                if let evLoop = DefaultEvLoopManager.evLoop(identifier) {
                    evLoop.handleAsyncTask(asyncHandler!, events: events)
                }
            })
        }
        self.thread = thread
        
        ev_async_start(context, asyncHandler)
        DefaultEvLoopManager.saveEvLoop(self, identifier: self.idenfifier)
        print("context: \(context), identifier: \(idenfifier)")
    }
    deinit {
        ioReadBuffer.deinitialize()
    }
    
    /*
     threadPriority 0.0~1.0
     */
    open static func makeAEvLoop(_ threadPriority: Double = 0.9, beforeLoop: @escaping ((EvLoop) -> Void)) {
        let evThread = Thread {
            autoreleasepool(invoking: {
                let aEvLoop = EvLoop(isMain: false, thread: Thread.current)
                autoreleasepool(invoking: {
                    beforeLoop(aEvLoop)
                })
                aEvLoop.start()
            })
        }
        evThread.threadPriority = threadPriority
        evThread.start()
    }
    
    open static func mainEvLoop(_ beforeLoop: @escaping ((MainEvLoop) -> Void)) {
        let evThread = Thread {
            autoreleasepool(invoking: {
                let aEvLoop = MainEvLoop(thread: Thread.current)
                autoreleasepool(invoking: {
                    beforeLoop(aEvLoop)
                })
                aEvLoop.start()
            })
        }
        evThread.threadPriority = 1.0
        evThread.start()
    }
    
    open func start() {
        ev_loop(self.context, 0)
        ev_loop_destroy(self.context)
    }
    
    fileprivate var ioListeners: [Int32: EvIOListener] = [:]
    fileprivate var sockfdMapIdentifier: [String: Int32] = [:]
    
    public enum AddListenerFailureReason {
        case HasBeenListenWithOtherListener
        
        public func description() -> String {
            switch self {
            case .HasBeenListenWithOtherListener:
                return "HasBeenListenWithOtherListener"
            }
        }
    }
    public enum AddListenerResult {
        case Success
        case Failure(AddListenerFailureReason)
    }
    
    func listened(_ sockfd: Int32) -> Bool {
        if self.thread != Thread.current {
            print("error: addIOListener must call in looped thread")
        }
        
        if let _ = self.ioListeners[sockfd] {
            return true
        }else {
            return false
        }
    }
    
    func addIOListener(_ listener: EvIOListener) -> AddListenerResult {
        if self.thread != Thread.current {
            print("error: addIOListener must call in looped thread")
        }
        
        if let _ = self.ioListeners[listener.sockfd] {
            return AddListenerResult.Failure(EvLoop.AddListenerFailureReason.HasBeenListenWithOtherListener)
        }else {
            self.ioListeners[listener.sockfd] = listener
            sockfdMapIdentifier[listener.socketIdentifier] = listener.sockfd
            listener.turnToListenWriteRead()
            return AddListenerResult.Success
        }
    }
    
    func removeIOListener(_ listener: EvIOListener)  {
        if self.thread != Thread.current {
            print("error: addIOListener must call in looped thread")
        }
        
        if let aListener = ioListeners[listener.sockfd] {
            if aListener === listener {
                listener.turnToListenNone()
                ioListeners.removeValue(forKey: listener.sockfd)
                sockfdMapIdentifier.removeValue(forKey: listener.socketIdentifier)
            }
        }
    }
    
    func removeIOListener(_ sockfd: Int32)  {
        if self.thread != Thread.current {
            print("error: addIOListener must call in looped thread")
        }
        if let aListener = ioListeners[sockfd] {
           removeIOListener(aListener)
        }
    }
    func removeIOListener(_ socketIdentifier: String)  {
        if self.thread != Thread.current {
            print("error: addIOListener must call in looped thread")
        }
        if let sockfd = sockfdMapIdentifier[socketIdentifier] {
            if let aListener = ioListeners[sockfd] {
                removeIOListener(aListener)
            }
        }
    }
    
    open func asyncTask(_ task: @escaping EvLoop.SelfClosure) {
        taskItemsLock.lock()
        taskItems.append(EvAsyncTaskItem(task: task))
        taskItemsLock.unlock()
        ev_async_send(self.context, self.asyncHandler)
    }


    func handleAsyncTask(_ asyncHandler: UnsafeMutablePointer<ev_async>, events: Int32) {
        while true {
            taskItemsLock.lock()
            if let taskItem = taskItems.first {
                taskItems.removeFirst()
                taskItemsLock.unlock()
                taskItem.task(self)
            }else {
                taskItemsLock.unlock()
                break
            }
        }
    }
    
    func handleIOEvent(_ aEvIO: UnsafeMutablePointer<ev_io>, events: Int32) {
        if let listener = ioListeners[aEvIO.pointee.fd] {
            listener.handleIOEvent(self, events: events)
        }
    }
    
    open func startTCPService(on port: UInt16, delegate: TCPServiceSocketDelegate, queue: DispatchQueue) -> TCPServiceSocket? {
        let serviceSocket = TCPServiceSocket(ipAddr: nil, port: port, context: self, delegate: delegate, queue: queue)
        if serviceSocket.bindNet() {
            if serviceSocket.beginListen() {
                let listener = EvIOListener(socketIdentifier: serviceSocket.identifier, sockfd: serviceSocket.sockfd!, context: self, eventHandlers: [.ReadAble: {[weak self] (listener) in
                    if let strongSelf = self {
                        strongSelf.listenedServiceSockets[listener.socketIdentifier]?.needAcceptSocket()
                    }
                }])
                
                let listenResult = addIOListener(listener)
                switch listenResult {
                case .Success:
                    listenedServiceSockets[serviceSocket.identifier] = serviceSocket
                    return serviceSocket
                case .Failure(let reason):
                    print("\(reason.description())")
                    serviceSocket.closeSocket()
                    return nil
                }
            }else {
                print("socket listen failure")
            }
        }else {
            print("socket bind failure")
        }
        
        return nil
    }
    open func stopTCPService(socket: TCPServiceSocket) {
        if listenedServiceSockets[socket.identifier] === socket {
            listenedServiceSockets.removeValue(forKey: socket.identifier)
            if let sockfd = socket.sockfd {
                removeIOListener(sockfd)
            }
            socket.closeSocket()
        }
    }
    open func stopTCPService(identifier: String) {
        if let socket = listenedServiceSockets[identifier] {
            listenedServiceSockets.removeValue(forKey: identifier)
            if let sockfd = socket.sockfd {
                removeIOListener(sockfd)
            }
            socket.closeSocket()
        }
    }
    
    public enum ListeneAcceptSocketFailureReason {
        case HasBeenListenWithOtherListener
        
        public func description() -> String {
            switch self {
            case .HasBeenListenWithOtherListener:
                return "HasBeenListenWithOtherListener"
            }
        }
    }
    public enum ListeneAcceptSocketResult {
        case Success
        case Failure(ListeneAcceptSocketFailureReason)
    }
    
    open func startListenAcceptedSocket(acceptedSocket: TCPAcceptedSocket) -> AddListenerResult {
        let listenResult = addIOListener(acceptedSocket.ioListener)
        switch listenResult {
        case .Success:
            listenedTCPAcceptSockets[acceptedSocket.identifier] = acceptedSocket
        case .Failure(let reason):
            print("\(reason.description())")
        }
        return listenResult
    }
    open func stopListenAcceptedSocket(acceptedSocket: TCPAcceptedSocket) {
        if listenedTCPAcceptSockets[acceptedSocket.identifier] === acceptedSocket {
            listenedTCPAcceptSockets.removeValue(forKey: acceptedSocket.identifier)
            let sockfd = acceptedSocket.sockfd
            removeIOListener(sockfd)
        }
    }
    open func stopListenAcceptedSocket(identifier: String) {
        if let socket = listenedTCPAcceptSockets[identifier] {
            listenedTCPAcceptSockets.removeValue(forKey: identifier)
            let sockfd = socket.sockfd
            removeIOListener(sockfd)
        }
    }
}

open class MainEvLoop: EvLoop {
    fileprivate init(thread: Thread) {
        super.init(isMain: true, thread: thread)
    }
}







