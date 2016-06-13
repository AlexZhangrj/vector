//
//  NSData+Base64.swift
//  Base
//
//  Created by 王青海 on 16/6/9.
//  Copyright © 2016年 王青海. All rights reserved.
//

import UIKit

public extension NSData {
    public func base64String() -> String {
        return self.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
    }
    

    
}
