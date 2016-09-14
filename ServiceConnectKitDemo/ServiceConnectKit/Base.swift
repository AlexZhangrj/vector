//
//  Base.swift
//  ServiceConnectKitDemo
//
//  Created by CaiLianfeng on 2016/9/10.
//  Copyright © 2016年 WangQinghai. All rights reserved.
//

import Foundation

public class ThreadCacheItem {
    var dict: [String: Any] = [:]
    
    public func removeCacheItem(identifier: String) {
        dict.removeValue(forKey: identifier)
    }
    
    public func cacheItem(item: Any, identifier: String) {
        dict[identifier] = item
    }
    public func cachedItem<T: Any>(identifier: String, type: T.Type) -> T? {
        return dict[identifier] as? T
    }
}

public class ThreadCacheCenter {
    private let _lock: NSLock = NSLock()
    public static let `default` = ThreadCacheCenter()
    private var map: [Thread: ThreadCacheItem] = [:]

    private init() {
        NotificationCenter.default.addObserver(forName: NSNotification.Name.NSThreadWillExit, object: nil, queue: OperationQueue.main) {[weak self] (notif) in
            guard let strongSelf = self else {return}
            guard let obj = notif.object else {return}
            guard let thread = obj as? Thread else {return}
            strongSelf.removeCacheItem(thread: thread)
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    public func removeCacheItem(thread: Thread) {
        _lock.lock()
        map.removeValue(forKey: thread)
        _lock.unlock()
    }

    public func cachedItem(thread: Thread) -> ThreadCacheItem {
        _lock.lock()
        var resultItem: ThreadCacheItem
        if let item = map[thread] {
            resultItem = item
        }else {
            let aitem = ThreadCacheItem()
            map[thread] = aitem
            resultItem = aitem
            if thread.isCancelled {
                DispatchQueue.main.async {
                    self.removeCacheItem(thread: thread)
                }
            }
        }
        _lock.unlock()
        return resultItem
    }
    
    

}
