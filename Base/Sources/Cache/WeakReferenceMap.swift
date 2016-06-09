//
//  WeakReferenceMap.swift
//  Base
//
//  Created by 王青海 on 16/6/8.
//  Copyright © 2016年 王青海. All rights reserved.
//

import Foundation



internal class WeakContainer<Value: AnyObject> {
    weak var value: Value? = nil
    init(_ obj: Value) {
        self.value = obj
    }
}
public class WeakReferenceMap<Key: Hashable, Value: AnyObject> : NSObject {
    private var _entries: [Key : WeakContainer<Value>] = [:]
    private var _cacheContainers: [WeakContainer<Value>] = []
    private var _cacheContainersMaxCount = 20
    private let _lock = NSLock()
//    
//    String
//    
//    weak var cache: NSCache?
//    var aa: AnyObject?

    public override init() {
        
    }
    
    private func _createWeakContainer(obj: Value) -> WeakContainer<Value> {
        if let weakContainer = _cacheContainers.first {
            _cacheContainers.removeFirst()
            return weakContainer
        }else {
            return WeakContainer(obj)
        }
    }
    
    private func _recycleWeakContainer(weakContainer: WeakContainer<Value>) {
        if _cacheContainers.count < self._cacheContainersMaxCount {
            _cacheContainers.append(weakContainer)
        }
    }
    
    public func object(forKey key: Key) -> Value? {
        var object: Value?
        
        _lock.lock()
        if let entry = _entries[key] {
            object = entry.value
            if object == nil {
                _entries.removeValueForKey(key)
                _recycleWeakContainer(entry)
            }
        }
        _lock.unlock()
        
        return object
    }
    
    public func setObject(obj: Value, forKey key: Key) {
        _lock.lock()
        if let entry = _entries[key] {
            if let value = entry.value {
                print("数据重复插入，old： \(value) new： \(obj)")
            }
            entry.value = obj
        } else {
            _entries[key] = _createWeakContainer(obj)
        }
        _lock.unlock()
    }
    
    public func removeObject(forKey key: Key) {
        _lock.lock()
        if let entry = _entries[key] {
            _recycleWeakContainer(entry)
        }
        _entries.removeValueForKey(key)
        
        _lock.unlock()
    }
    
    public func removeAllObjects() {
        _lock.lock()
        _entries.removeAll()
        _lock.unlock()
    }
    
    public subscript (key: Key) -> Value? {
        get
        {
            return self.object(forKey: key)
        }
        set(newValue)
        {
            if let realNewValue = newValue {
//                if let cache = self.cache {
//                    if let keyStr = key as? String {
//                        cache.setObject(realNewValue, forKey: keyStr)
//                    }
//                }
                self.setObject(realNewValue, forKey: key)
            }else {
                self.removeObject(forKey: key)
            }
        }
    }
}








