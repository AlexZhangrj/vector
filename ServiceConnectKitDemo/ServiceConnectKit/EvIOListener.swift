//
//  EvIOListener.swift
//  ServiceConnectKitDemo
//
//  Created by CaiLianfeng on 2016/9/10.
//  Copyright © 2016年 WangQinghai. All rights reserved.
//

import Foundation

open class EvIOListener {
    public typealias SelfClosure = (EvIOListener) -> Void
    
    enum ListenType: Int32 {
        case None = 0x08
        case Read = 0x01
        case WriteRead = 0x02
        
        var eventsCode: Int32 {
            switch self {
            case .None:
                return 0
            case .Read:
                return 1
            case .WriteRead:
                return 3
            }
        }
    }
    
    public enum IOEvent: Int32 {
        case None = 0x08
        case ReadAble = 0x01
        case WriteAble = 0x02
        
        var eventCode: Int32 {
            switch self {
            case .None:
                return 0
            case .ReadAble:
                return 0x01
            case .WriteAble:
                return 0x02
            }
        }
        
        static func eventsCode(_ events: [IOEvent]) -> Int32 {
            var value: Int32 = 0
            for event in events {
                value |= event.eventCode
            }
            return value
        }
        
        static func IOEvents(_ eventsValue: Int32) -> [IOEvent] {
            var events: [IOEvent] = []
            if eventsValue & IOEvent.None.eventCode == IOEvent.None.eventCode {
                events.append(.None)
            }
            if eventsValue & IOEvent.ReadAble.eventCode == IOEvent.ReadAble.eventCode {
                events.append(.ReadAble)
            }
            if eventsValue & IOEvent.WriteAble.eventCode == IOEvent.WriteAble.eventCode {
                events.append(.WriteAble)
            }
            return events
        }
    }
    
    var listenType: ListenType = .None {
        didSet(oldType) {
            if oldType != listenType {
                switch oldType {
                case .None:
                    switch listenType {
                    case .None:
                        
                        break
                    case .Read:
                        self.start()
                        break
                    case .WriteRead:
                        self.start()
                        break
                    }
                    break
                case .Read:
                    switch listenType {
                    case .None:
                        self.stop()
                        break
                    case .Read:
                        break
                    case .WriteRead:
                        self.stop()
                        self.start()
                        break
                    }
                    break
                case .WriteRead:
                    switch listenType {
                    case .None:
                        self.stop()
                        break
                    case .Read:
                        self.stop()
                        self.start()
                        break
                    case .WriteRead:
                        break
                    }
                    break
                }
            }
        }
    }
    
    
    let idenfifier: String
    
    let coreEvIO: UnsafeMutablePointer<ev_io>
    var context: EvLoop
    
    let sockfd: Int32
    var eventHandlers: [IOEvent: SelfClosure] {
        didSet(oldValue) {
            var events: [IOEvent] = []
            for (key, _) in eventHandlers {
                events.append(key)
            }
            self.events = events
        }
    }
    var events: [IOEvent]
    
    open let socketIdentifier: String
    
    public init(socketIdentifier: String, sockfd: Int32, context: EvLoop, eventHandlers: [IOEvent: SelfClosure]) {
        self.sockfd = sockfd
        self.context = context
        self.eventHandlers = eventHandlers
        var events: [IOEvent] = []
        for (key, _) in eventHandlers {
            events.append(key)
        }
        self.socketIdentifier = socketIdentifier
        self.events = events
        let cEvIO = EvIOAlloc()
        idenfifier = EvIOListener.identifier(withContext: cEvIO!)
        self.coreEvIO = cEvIO!
    }
    deinit {
        EvIODealloc(coreEvIO)
    }
    
    
    internal func start() {
        var events: [IOEvent] = []
        for (key, _) in eventHandlers {
            events.append(key)
        }
        
        EvIOInit(coreEvIO, { (loop, aEvIO, events) in
            autoreleasepool(invoking: {
                let identifier = EvLoop.identifier(withContext: loop!)
                if let evLoop = DefaultEvLoopManager.evLoop(identifier) {
                    evLoop.handleIOEvent(aEvIO!, events: events)
                }
            })
            }, sockfd, IOEvent.eventsCode(events) & listenType.eventsCode)
        EvIOStart(context.context, coreEvIO)
    }
    
    internal func stop() {
        EvIOStop(context.context, coreEvIO)
    }
    
    open func turnToListenWriteRead() {
        self.listenType = .WriteRead
    }
    open func turnToListenRead() {
        self.listenType = .Read
    }
    open func turnToListenNone() {
        self.listenType = .None
    }
    
    open func handleIOEvent(_ loop: EvLoop, events: Int32) {
        let IOEvents = IOEvent.IOEvents(events)
        for IOEventItem in IOEvents {
            if let call = eventHandlers[IOEventItem] {
                call(self)
            }
        }
    }
    
    static func identifier(withContext context: UnsafeMutablePointer<ev_io>) -> String {
        let buffer = UnsafeMutablePointer<Int8>.allocate(capacity: 64)
        EvIOIdentifier(context, buffer)
        let idenfifier = String(cString: buffer)
        buffer.deinitialize()
        return idenfifier
    }
}
