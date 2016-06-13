//
//  String+MD5.swift
//  Base
//
//  Created by 王青海 on 16/6/10.
//  Copyright © 2016年 王青海. All rights reserved.
//

import Foundation
import Darwin


public extension String {
    public func md5String() -> String {
//        let str = self.cStringUsingEncoding(NSUTF8StringEncoding)
//        let strLen = CC_LONG(self.lengthOfBytesUsingEncoding(NSUTF8StringEncoding))
//        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
//        let result = UnsafeMutablePointer<CUnsignedChar>.alloc(digestLen);
//        
//        CC_MD5(str!, strLen, result);
//        
//        let hash = NSMutableString();
//        for i in 0 ..< digestLen {
//            hash.appendFormat("%02x", result[i]);
//        }
//        result.destroy();
//        
//        return String(format: hash as String)
        if let data = self.dataUsingEncoding(NSUTF8StringEncoding) {
            let hashData = CC.digest(data, alg: .md5)
            
            let result = UnsafeMutablePointer<CUnsignedChar>.alloc(hashData.length);
            hashData.getBytes(result, length: hashData.length)
            let hash = NSMutableString();
            let count = hashData.length
            for i in 0 ..< count {
                hash.appendFormat("%02x", result[i]);
            }
            result.destroy();
            return hash as String
        }else {
            return self
        }
    }
    
    public func base64DecryptData() -> NSData? {
        return NSData(base64EncodedString: self, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)
    }
    
}