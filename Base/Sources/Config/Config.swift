//
//  Config.swift
//  Base
//
//  Created by 王青海 on 16/6/9.
//  Copyright © 2016年 王青海. All rights reserved.
//

import Foundation


public protocol ConfigHandle: NSObjectProtocol {
    
}

public let DefaultConfig = Config()


public class Config: NSObject {
    public static let accessGroup: String = "com.yq"
    public static let service: String = NSBundle.mainBundle().bundleIdentifier ?? ""
    
    //default config
    public static let uuidAccessGroup: String = accessGroup.md5String() + "uuid".md5String()
    public static let uuidService: String = "uuid".md5String()
    public static let uuidAccount: String = uuidService


    
    
    
    public let UUID: String
    
    private override init() {
        if let UUIDStr = Keychain.message(forAccount: Config.uuidAccount, service: Config.uuidService, accessGroup: Config.uuidAccessGroup) {
            UUID = UUIDStr
        }else {
            let UUIDStr = NSUUID().UUIDString
            UUID = UUIDStr
            let result = Keychain.setMessage(UUIDStr, forAccount: Config.uuidAccount, service: Config.uuidService, accessGroup: Config.uuidAccessGroup)
            if !result{
                let _ = ExponentialTimer(originalAfterTime: 1.5, task: { (timer) -> Bool in
                    return Keychain.setMessage(UUIDStr, forAccount: Config.uuidAccount, service: Config.uuidService, accessGroup: Config.uuidAccessGroup)
                })
            }
        }
    }
    
    
    
    
    //每换一个应用必须重新生成一次，用于沙盒目录下文件加密
    public static func RSAPrivateKey() -> NSData {
        let str = "MIIEowIBAAKCAQEA2wcq9+0npuRohFBP0xwaF6h1ITngFg9hW65ARvk3tj4ChsQxTzS3ls2qnyo19nmphdWUxJBRF1/BPfAIkDyzf43vtSsSQJKal4qCxQ6fqVFKimko+rG0J1dmfbTMacBejecaR8zlSD99HU7JAvIPU74dM+SEg7eLSbHV8LfDpELEgvhDjxz/Zlzhv3C1Jz2w5yznYWFe2XcWnhMSEnv7wkwlrnKDyQpTumjpabCa4ymB2DJmfKZ6q1Wj3qUwIBIOxgRnRiLMrp+Gl+Q7YpVwWOxGUJ50XD0EN1Q6WQherXF972UhPq0UCt6VBDUBX1rZ9V770+inMVV6jjJYYyvQQwIDAQABAoIBABLQ1NIjn2po6MmlFJZwLZWmtRk7nZKHk7eKip8OPcj8Hr9xD0NcpgDgfi3aNHSOExAaPwN72luFsFYfzryFWm40xUjtAE5nybwG/CDtlq22/A5T5l9S8MUIbxeRdpYHHphWKB3O7kt8mMTxxbbpEIQDKwMQOIoQNHkKO/TH9JihsvNIhUdwjVfcmhdmo6cKKci+tpnW3G6vXD/gBikR0db71qkXgscUNOhpChJu8PqMFlLA4LNt3Oy81YncrKJ+yHqcUmojg3Nf5teYW2mRlXuWUGlqfgJE3NwtOQAeaowt6RiPkv1eSWcXrin0XjdxmqCZlPtvQC58LOd/daXgxrECgYEA/fYaUK6auUMJnZVZmNClGYMXbvwWpKq9sriO80u/3aIMZ0G9WQH5g/wziSg7JqvJ1KIHxqB70rXL5M6lDCkYWmKTTapX423z8f4avYZPRBcpX4GGmTYlJ3zmQjueJFmhbahx6iY2SrTOsMCQvIDyt3qWtDcOON45mMjptEYcBQ0CgYEA3MlGsAlwr8sGDyU8tmhWh8x2QvzqaHJk3PlreTaX+PxANvh6D6Z2weRQujiAHu/BIE4e067C4Dl7dLtTDnMLwfdd9KpYtRpSifvEca18JO2mWJbCZbV32FDXxX2RB44V2Tx2Ga27UjsvZCT4Ycv0LmI3+YntRfVsTUc48nG1do8CgYEAt5/sYw38fZvFJhXI1L93wLySgwLu9F0oEEN1yOCqd/wlb7uOxv6whQgj0zYtnsZzhrUpXirHnREpveTUXbiRDTldPLjAF4d27TBH8WVdhuQgXBfxVHJb5vNeIeGtdKcCG6HBzAWZF+cn05FIlaO+239d3Cw6sk+r4ZbTtC9FLzkCgYB72n1I60LHmsB/Zog0WzuPWmdNFMv6Y5GpVFGx4apHBlqPe7wdY2hjREz06hUVRbG1CZ3JadPwLM7QoPTquibyXG3cfmLc1TNQLGf6zTNDE/2o3ImYvL/KHS+tnc7pyg7/mic2KHtYmdLv/r1HPz5vdrGnznPINvDWOQn9F0SQiQKBgEjOukG5D5JMaa99FxKfaDmhgx2wGTSgMni4ZxUFopioTl9Bgs41fsaJBwqOeaP9Io01x+YDmxYCaHm26cW2IVU6Ig9Pi10Sj+17rVnUNlPyG//iySOBDBOIN7VHjWjS5AK5/6tzSujvfbL8Ch8oZFCy++71jgC0RWrFUW3QrQ+C"
        return NSData(base64EncodedString: str, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)!
    }
    
    public static func RSAPublicKey() -> NSData {
        let str = "MIIBCgKCAQEA2wcq9+0npuRohFBP0xwaF6h1ITngFg9hW65ARvk3tj4ChsQxTzS3ls2qnyo19nmphdWUxJBRF1/BPfAIkDyzf43vtSsSQJKal4qCxQ6fqVFKimko+rG0J1dmfbTMacBejecaR8zlSD99HU7JAvIPU74dM+SEg7eLSbHV8LfDpELEgvhDjxz/Zlzhv3C1Jz2w5yznYWFe2XcWnhMSEnv7wkwlrnKDyQpTumjpabCa4ymB2DJmfKZ6q1Wj3qUwIBIOxgRnRiLMrp+Gl+Q7YpVwWOxGUJ50XD0EN1Q6WQherXF972UhPq0UCt6VBDUBX1rZ9V770+inMVV6jjJYYyvQQwIDAQAB"
        return NSData(base64EncodedString: str, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)!
    }
    
    public static func AESKey() -> NSData {
        let str = "MIIEowIBAAKCAQEA2wcq9+0npuRohFBP0xwaF6h1ITngFg9hW65ARvk3tj4ChsQxTzS3ls2qnyo19nmphdWUxJBRF1/BPfAIkDyzf43vtSsSQJKal4qCxQ6fqVFKimko+rG0J1dmfbTMacBejecaR8zlSD99HU7JAvIPU74dM+SEg7eLSbHV8LfDpELEgvhDjxz/Zlzhv3C1Jz2w5yznYWFe2XcWnhMSEnv7wkwlrnKDyQpTumjpabCa4ymB2DJmfKZ6q1Wj3qUwIBIOxgRnRiLMrp+Gl+Q7YpVwWOxGUJ50XD0EN1Q6WQherXF972UhPq0UCt6VBDUBX1rZ9V770+inMVV6jjJYYyvQQwIDAQABAoIBABLQ1NIjn2po6MmlFJZwLZWmtRk7nZKHk7eKip8OPcj8Hr9xD0NcpgDgfi3aNHSOExAaPwN72luFsFYfzryFWm40xUjtAE5nybwG/CDtlq22/A5T5l9S8MUIbxeRdpYHHphWKB3O7kt8mMTxxbbpEIQDKwMQOIoQNHkKO/TH9JihsvNIhUdwjVfcmhdmo6cKKci+tpnW3G6vXD/gBikR0db71qkXgscUNOhpChJu8PqMFlLA4LNt3Oy81YncrKJ+yHqcUmojg3Nf5teYW2mRlXuWUGlqfgJE3NwtOQAeaowt6RiPkv1eSWcXrin0XjdxmqCZlPtvQC58LOd/daXgxrECgYEA/fYaUK6auUMJnZVZmNClGYMXbvwWpKq9sriO80u/3aIMZ0G9WQH5g/wziSg7JqvJ1KIHxqB70rXL5M6lDCkYWmKTTapX423z8f4avYZPRBcpX4GGmTYlJ3zmQjueJFmhbahx6iY2SrTOsMCQvIDyt3qWtDcOON45mMjptEYcBQ0CgYEA3MlGsAlwr8sGDyU8tmhWh8x2QvzqaHJk3PlreTaX+PxANvh6D6Z2weRQujiAHu/BIE4e067C4Dl7dLtTDnMLwfdd9KpYtRpSifvEca18JO2mWJbCZbV32FDXxX2RB44V2Tx2Ga27UjsvZCT4Ycv0LmI3+YntRfVsTUc48nG1do8CgYEAt5/sYw38fZvFJhXI1L93wLySgwLu9F0oEEN1yOCqd/wlb7uOxv6whQgj0zYtnsZzhrUpXirHnREpveTUXbiRDTldPLjAF4d27TBH8WVdhuQgXBfxVHJb5vNeIeGtdKcCG6HBzAWZF+cn05FIlaO+239d3Cw6sk+r4ZbTtC9FLzkCgYB72n1I60LHmsB/Zog0WzuPWmdNFMv6Y5GpVFGx4apHBlqPe7wdY2hjREz06hUVRbG1CZ3JadPwLM7QoPTquibyXG3cfmLc1TNQLGf6zTNDE/2o3ImYvL/KHS+tnc7pyg7/mic2KHtYmdLv/r1HPz5vdrGnznPINvDWOQn9F0SQiQKBgEjOukG5D5JMaa99FxKfaDmhgx2wGTSgMni4ZxUFopioTl9Bgs41fsaJBwqOeaP9Io01x+YDmxYCaHm26cW2IVU6Ig9Pi10Sj+17rVnUNlPyG//iySOBDBOIN7VHjWjS5AK5/6tzSujvfbL8Ch8oZFCy++71jgC0RWrFUW3QrQ+C"
        return NSData(base64EncodedString: str, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)!
    }
    
    public static func AESPublicKey() -> NSData {
        let str = "MIIBCgKCAQEA2wcq9+0npuRohFBP0xwaF6h1ITngFg9hW65ARvk3tj4ChsQxTzS3ls2qnyo19nmphdWUxJBRF1/BPfAIkDyzf43vtSsSQJKal4qCxQ6fqVFKimko+rG0J1dmfbTMacBejecaR8zlSD99HU7JAvIPU74dM+SEg7eLSbHV8LfDpELEgvhDjxz/Zlzhv3C1Jz2w5yznYWFe2XcWnhMSEnv7wkwlrnKDyQpTumjpabCa4ymB2DJmfKZ6q1Wj3qUwIBIOxgRnRiLMrp+Gl+Q7YpVwWOxGUJ50XD0EN1Q6WQherXF972UhPq0UCt6VBDUBX1rZ9V770+inMVV6jjJYYyvQQwIDAQAB"
        return NSData(base64EncodedString: str, options: NSDataBase64DecodingOptions.IgnoreUnknownCharacters)!
    }
    
    static func tt(data: NSData) {
        
//        try CC.crypt(.encrypt, blockMode: .cbc, algorithm: .aes, padding: .pkcs7Padding, data: data, key: aesKey, iv: iv)
//        try CC.crypt(.decrypt, blockMode: .cfb, algorithm: .aes, padding: .pkcs7Padding, data: data, key: aesKey, iv: iv)
        
        let data: NSData = "MIIBCgKCAQEA2wcq9+0npuRohFBP0xwaF6h1ITngFg9hW65ARvk3tj4ChsQxTzS3ls2qnyo19nmphdWUxJBRF1/BPfAIkDyzf43vtSsSQJKal4qCxQ6fqVFKimko+rG0J1dmfbTMacBejecaR8zlSD99HU7JAvIPU74dM+SEg7eLSbHV8LfDpELEgvhDjxz/Zlzhv3C1Jz2w5yznYWFe2XcWnhMSEnv7wkwlrnKDyQpTumjpabCa4ymB2DJmfKZ6q1Wj3qUwIBIOxgRnRiLMrp+Gl+Q7YpVwWOxGUJ50XD0EN1Q6WQherXF972UhPq0UCt6VBDUBX1rZ9V770+inMVV6jjJYYyvQQwIDAQAB".dataUsingEncoding(NSUTF8StringEncoding)!
        
        
//        try CC.RSA.encrypt(data, derKey: RSAPublicKey(), tag: NSData(), padding: .oaep, digest: .sha1)
//        try CC.RSA.decrypt(data, derKey: RSAPrivateKey(), tag: NSData(), padding: .oaep, digest: .sha1)
//    
    }
    
    
}

public extension Keychain {
    public static func message(forAccount account: String, service: String = Config.service, accessGroup: String = Config.accessGroup) -> String? {
        return password(forAccount: account, service: service, accessGroup: accessGroup)
    }
    
    public static func setMessage(password: String, forAccount account: String, service: String = Config.service, accessGroup: String = Config.accessGroup) -> Bool {
        return setPassword(password, forAccount: account, service: service, accessGroup: accessGroup)
    }
}

