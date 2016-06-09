//
//  Cache.swift
//  Base
//
//  Created by 王青海 on 16/6/8.
//  Copyright © 2016年 王青海. All rights reserved.
//

import Foundation


public let DefaultCache = Cache()

public class Cache : NSObject {
    let cache: NSCache = NSCache()
    
    public override init() {
        
    }

    public func objectForKey(key: AnyObject) -> AnyObject? {
        return cache.objectForKey(key)
    }
    public func setObject(obj: AnyObject, forKey key: AnyObject) {
        return cache.setObject(obj, forKey: key)
    }
    public func setObject(obj: AnyObject, forKey key: AnyObject, cost g: Int) {
        return cache.setObject(obj, forKey: key, cost: g)
    }
    public func removeObjectForKey(key: AnyObject) {
        cache.removeObjectForKey(key)
    }
    
    public func removeAllObjects() {
        cache.removeAllObjects()
    }
    
    public static func defaultCache() -> Cache {
        return DefaultCache
    }
    
    public subscript (key: AnyObject) -> AnyObject? {
        get
        {
            return cache[key]
        }
        set(newValue)
        {
            cache[key] = newValue
        }
    }


    
    
}
