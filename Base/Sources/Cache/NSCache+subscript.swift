//
//  NSCache+subscript.swift
//  Base
//
//  Created by 王青海 on 16/6/8.
//  Copyright © 2016年 王青海. All rights reserved.
//

import Foundation

public extension NSCache {
    
    public subscript (key: AnyObject) -> AnyObject? {
        get
        {
            return self.objectForKey(key)
        }
        set(newValue)
        {
            if let realNewValue = newValue {
                self.setObject(realNewValue, forKey: key)
            }else {
                self.removeObjectForKey(key)
            }
        }
    }
}