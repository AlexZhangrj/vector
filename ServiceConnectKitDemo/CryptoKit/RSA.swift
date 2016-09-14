//
//  RSA.swift
//  ServiceConnectKitDemo
//
//  Created by CaiLianfeng on 2016/9/10.
//  Copyright © 2016年 WangQinghai. All rights reserved.
//

import Foundation

public class DataBuffer {
    public let buffer: UnsafeMutablePointer<UInt8>
    
    init(size: Int) {
        buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: size)
    }
    
    deinit {
        buffer.deinitialize()
    }
    
    
}

public struct RSACrypt {
    internal class RSACacheItem {
        var data128Buffers: [DataBuffer] = []
        
        func buffer() -> DataBuffer {
            if let buffer = data128Buffers.first {
                data128Buffers.removeFirst()
                return buffer
            }else {
                return DataBuffer(size: 128)
            }
        }
        func storeBuffer(buffer: DataBuffer) {
            if data128Buffers.count > 8 {
                return
            }else {
                data128Buffers.append(buffer)
            }
        }
        
        static var itemKey:  String {
            return "app.thread.RSACacheItem.Buffer"
        }
        
//        static func current() {
//            if let item = 
//        
//        }

    }
    
    
    public struct RSAKey {
        public class PublicKey {
            static var prefix: String = "-----BEGIN PUBLIC KEY-----\n"
            static var suffix: String = "\n-----END PUBLIC KEY-----\n"
            public let keyData: Data
            public let formatString: String
            internal var _rsa: UnsafeMutableRawPointer!

            init(keyData: Data) {
                self.keyData = keyData
                let formatKey: String = keyData.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
                formatString = "\(RSAKey.PublicKey.prefix)\(formatKey)\(RSAKey.PublicKey.suffix)"
                
                let bytes = formatString.utf8CString
                bytes.withUnsafeBufferPointer { ptr in
                    _rsa = RSAPublicKeyInit(ptr.baseAddress)
                }
            }
            deinit {
                
            }
        }
        public class PrivateKey {
            static var prefix: String = "-----BEGIN RSA PRIVATE KEY-----\n"
            static var suffix: String = "\n-----END RSA PRIVATE KEY-----\n"
            public let keyData: Data
            public let formatString: String
            internal var _rsa: UnsafeMutableRawPointer!
            init(keyData: Data) {
                self.keyData = keyData
                let formatKey: String = keyData.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
                formatString = "\(RSAKey.PrivateKey.prefix)\(formatKey)\(RSAKey.PrivateKey.suffix)"
                let bytes = formatString.utf8CString
                bytes.withUnsafeBufferPointer { ptr in
                    _rsa = RSAPrivateKeyInit(ptr.baseAddress)
                }
            }
            deinit {
                
            }
        }

        
        
        
//        static func publicKey(pemString: String) -> PublicKey? {
//            if pemString.hasPrefix(RSAKey.PublicKey.prefix) && pemString.hasSuffix(RSAKey.PublicKey.suffix) {
//                let range = pemString.index(pemString.startIndex, offsetBy: RSAKey.PublicKey.prefix.distance(from: RSAKey.PublicKey.prefix.startIndex, to: RSAKey.PublicKey.prefix.endIndex)) ..< pemString.index(pemString.startIndex, offsetBy: pemString.distance(from: pemString.startIndex, to: pemString.endIndex) - RSAKey.PublicKey.suffix.distance(from: RSAKey.PublicKey.suffix.startIndex, to: RSAKey.PublicKey.suffix.endIndex))
//                let keyString = pemString.substring(with: range)
//                if let data = Data(base64Encoded: keyString, options: Data.Base64DecodingOptions.ignoreUnknownCharacters) {
//                    return PublicKey(keyData: data)
//                }else {
//                    return nil
//                }
//            }else {
//                return nil
//            }
//        }

//        static func privateKey(pemString: String) -> (Bool, Data?) {
//            
//            
//        }
        
        
        
        
        public enum ReadKeyFromPemFileDataResult {
            case None
            case Public(PublicKey)
            case Private(PrivateKey)
        }
        public static func key(pemFileData: Data) -> ReadKeyFromPemFileDataResult {
            if let pemString = String(data: pemFileData, encoding: String.Encoding.utf8) {
                if pemString.hasPrefix(RSAKey.PublicKey.prefix) && pemString.hasSuffix(RSAKey.PublicKey.suffix) {
                    let range = pemString.index(pemString.startIndex, offsetBy: RSAKey.PublicKey.prefix.distance(from: RSAKey.PublicKey.prefix.startIndex, to: RSAKey.PublicKey.prefix.endIndex)) ..< pemString.index(pemString.startIndex, offsetBy: pemString.distance(from: pemString.startIndex, to: pemString.endIndex) - RSAKey.PublicKey.suffix.distance(from: RSAKey.PublicKey.suffix.startIndex, to: RSAKey.PublicKey.suffix.endIndex))
                    let keyString = pemString.substring(with: range)
                    if let data = Data(base64Encoded: keyString, options: Data.Base64DecodingOptions.ignoreUnknownCharacters) {
                        let publicKey = PublicKey(keyData: data)
                        return .Public(publicKey)
                    }else {
                        return .None
                    }
                }else if pemString.hasPrefix(RSAKey.PrivateKey.prefix) && pemString.hasSuffix(RSAKey.PrivateKey.suffix) {
                    let range = pemString.index(pemString.startIndex, offsetBy: RSAKey.PrivateKey.prefix.distance(from: RSAKey.PrivateKey.prefix.startIndex, to: RSAKey.PrivateKey.prefix.endIndex)) ..< pemString.index(pemString.startIndex, offsetBy: pemString.distance(from: pemString.startIndex, to: pemString.endIndex) - RSAKey.PrivateKey.suffix.distance(from: RSAKey.PrivateKey.suffix.startIndex, to: RSAKey.PrivateKey.suffix.endIndex))
                    let keyString = pemString.substring(with: range)
                    if let data = Data(base64Encoded: keyString, options: Data.Base64DecodingOptions.ignoreUnknownCharacters) {
                        let privateKey = PrivateKey(keyData: data)
                        return .Private(privateKey)
                    }else {
                        return .None
                    }
                }else {
                    return .None
                }
            }else {
                return .None
            }
        }
        
        public static func publicKey(pemFileData: Data) -> PublicKey? {
            if let pemString = String(data: pemFileData, encoding: String.Encoding.utf8) {
                if pemString.hasPrefix(RSAKey.PublicKey.prefix) && pemString.hasSuffix(RSAKey.PublicKey.suffix) {
                    let range = pemString.index(pemString.startIndex, offsetBy: RSAKey.PublicKey.prefix.distance(from: RSAKey.PublicKey.prefix.startIndex, to: RSAKey.PublicKey.prefix.endIndex)) ..< pemString.index(pemString.startIndex, offsetBy: pemString.distance(from: pemString.startIndex, to: pemString.endIndex) - RSAKey.PublicKey.suffix.distance(from: RSAKey.PublicKey.suffix.startIndex, to: RSAKey.PublicKey.suffix.endIndex))
                    let keyString = pemString.substring(with: range)
                    if let data = Data(base64Encoded: keyString, options: Data.Base64DecodingOptions.ignoreUnknownCharacters) {
                        let publicKey = PublicKey(keyData: data)
                        return publicKey
                    }else {
                        return nil
                    }
                }else {
                    return nil
                }
            }else {
                return nil
            }
        }
        public static func privateKey(pemFileData: Data) -> PrivateKey? {
            if let pemString = String(data: pemFileData, encoding: String.Encoding.utf8) {
                if pemString.hasPrefix(RSAKey.PrivateKey.prefix) && pemString.hasSuffix(RSAKey.PrivateKey.suffix) {
                    let range = pemString.index(pemString.startIndex, offsetBy: RSAKey.PrivateKey.prefix.distance(from: RSAKey.PrivateKey.prefix.startIndex, to: RSAKey.PrivateKey.prefix.endIndex)) ..< pemString.index(pemString.startIndex, offsetBy: pemString.distance(from: pemString.startIndex, to: pemString.endIndex) - RSAKey.PrivateKey.suffix.distance(from: RSAKey.PrivateKey.suffix.startIndex, to: RSAKey.PrivateKey.suffix.endIndex))
                    let keyString = pemString.substring(with: range)
                    if let data = Data(base64Encoded: keyString, options: Data.Base64DecodingOptions.ignoreUnknownCharacters) {
                        let privateKey = PrivateKey(keyData: data)
                        return privateKey
                    }else {
                        return nil
                    }
                }else {
                    return nil
                }
            }else {
                return nil
            }
        }
        
        ///不要换行
        public static func publicKey(contentKey: String) -> PublicKey? {
            if let data = Data(base64Encoded: contentKey, options: Data.Base64DecodingOptions.ignoreUnknownCharacters) {
                let resultKey = PublicKey(keyData: data)
                return resultKey
            }else {
                return nil
            }
        }
        ///不要换行
        public static func privateKey(contentKey: String) -> PrivateKey? {
            if let data = Data(base64Encoded: contentKey, options: Data.Base64DecodingOptions.ignoreUnknownCharacters) {
                let resultKey = PrivateKey(keyData: data)
                return resultKey
            }else {
                return nil
            }
        }
    }

    
    public static func encrypt(string: String, withPublicKey key: RSAKey.PublicKey) -> Data? {
        return _encrypt(string: string, withPublicKey: key)
    }
    
    public static func encrypt(string: String, withPrivateKey key: RSAKey.PrivateKey) -> Data? {
        return _encrypt(string: string, withPrivateKey: key)
    }
    
    public static func decrypt(encryptedStringData data: Data, withPublicKey key: RSAKey.PublicKey) -> String? {
        return _decrypt(encryptedStringData: data, withPublicKey: key)
    }

    public static func decrypt(encryptedStringData data: Data, withPrivateKey key: RSAKey.PrivateKey) -> String? {
        return _decrypt(encryptedStringData: data, withPrivateKey: key)
    }
    
    static func _encrypt(string: String, withPublicKey key: RSAKey.PublicKey) -> Data? {
        let cStringArray = string.utf8CString
        let cStr = cStringArray.withUnsafeBufferPointer { (ptr) -> UnsafeBufferPointer<Int8> in
            return ptr
        }
        
        let maxEncryptBlockLen = RSABlockSize(key._rsa)
        var blockCount = cStringArray.count / (maxEncryptBlockLen - 11)
        if cStringArray.count % (maxEncryptBlockLen - 11) != 0 {
            blockCount += 1
        }
        let resultBytesCount = maxEncryptBlockLen * blockCount
        let resultBytes = UnsafeMutablePointer<UInt8>.allocate(capacity: resultBytesCount)
        let resultData = Data(bytesNoCopy: resultBytes, count: resultBytesCount, deallocator: Data.Deallocator.free)
        
        var len: Int = 0
        let result = RSAPublicKeyEncryptCStringToBytes(key._rsa, cStr.baseAddress, resultBytes, &len)
        if result == 1 {
            return resultData
        }else {
            return nil
        }
    }
    
    static func _encrypt(string: String, withPrivateKey key: RSAKey.PrivateKey) -> Data? {
        let cStringArray = string.utf8CString
        let cStr = cStringArray.withUnsafeBufferPointer { (ptr) -> UnsafeBufferPointer<Int8> in
            return ptr
        }
        
        let maxEncryptBlockLen = RSABlockSize(key._rsa)
        var blockCount = cStringArray.count / (maxEncryptBlockLen - 11)
        if cStringArray.count % (maxEncryptBlockLen - 11) != 0 {
            blockCount += 1
        }
        let resultBytesCount = maxEncryptBlockLen * blockCount
        let resultBytes = UnsafeMutablePointer<UInt8>.allocate(capacity: resultBytesCount)
        let resultData = Data(bytesNoCopy: resultBytes, count: resultBytesCount, deallocator: Data.Deallocator.free)
        
        var len: Int = 0
        let result = RSAPrivateKeyEncryptCStringToBytes(key._rsa, cStr.baseAddress, resultBytes, &len)
        if result == 1 {
            return resultData
        }else {
            return nil
        }
    }
    
    static func _decrypt(encryptedStringData data: Data, withPublicKey key: RSAKey.PublicKey) -> String? {
        let maxEncryptBlockLen = RSABlockSize(key._rsa)
        var blockCount = data.count / maxEncryptBlockLen
        if data.count % maxEncryptBlockLen != 0 {
            blockCount += 1
        }
        
        let dataPtr = data.withUnsafeBytes { (_ptr) -> UnsafePointer<UInt8> in
            return _ptr
        }
        //        var resultData = Data(count: maxEncryptBlockLen * blockCount)
        let resultBytesCount = (maxEncryptBlockLen - 11) * blockCount
        let resultBytes = UnsafeMutablePointer<Int8>.allocate(capacity: resultBytesCount)
        var len: Int = 0
        let result = RSAPublicKeyDecryptBytesToCString(key._rsa, dataPtr, data.count, resultBytes, &len)
        if result == 1 {
            return String(cString: resultBytes)
        }else {
            return nil
        }
    }
    
    static func _decrypt(encryptedStringData data: Data, withPrivateKey key: RSAKey.PrivateKey) -> String? {
        let maxEncryptBlockLen = RSABlockSize(key._rsa)
        var blockCount = data.count / maxEncryptBlockLen
        if data.count % maxEncryptBlockLen != 0 {
            blockCount += 1
        }

        let dataPtr = data.withUnsafeBytes { (_ptr) -> UnsafePointer<UInt8> in
            return _ptr
        }
        //        var resultData = Data(count: maxEncryptBlockLen * blockCount)
        let resultBytesCount = (maxEncryptBlockLen - 11) * blockCount
        let resultBytes = UnsafeMutablePointer<Int8>.allocate(capacity: resultBytesCount)
        var len: Int = 0
        let result = RSAPrivateKeyDecryptBytesToCString(key._rsa, dataPtr, data.count, resultBytes, &len)
        if result == 1 {
            return String(cString: resultBytes)
        }else {
            return nil
        }
    }
    
    
    
    
    public static func encrypt(data: Data, withPublicKey key: RSAKey.PublicKey, aBuffer: UnsafeMutablePointer<UInt8>? = nil, bufferSize: Int = 0) -> Data {
        if bufferSize >= RSABlockSize(key._rsa) - 11 {
            return _encrypt(data: data, withPublicKey: key, aBuffer: aBuffer!)
        }else {
            let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: RSABlockSize(key._rsa) - 11)
            return _encrypt(data: data, withPublicKey: key, aBuffer: buffer)
        }
    }
    
    public static func encrypt(data: Data, withPrivateKey key: RSAKey.PrivateKey, aBuffer: UnsafeMutablePointer<UInt8>? = nil, bBuffer: UnsafeMutablePointer<UInt8>? = nil, bufferSize: Int = 0) -> Data {
        return Data()
    }

    public static func decrypt(data: Data, withPublicKey key: RSAKey.PublicKey, aBuffer: UnsafeMutablePointer<UInt8>? = nil, bBuffer: UnsafeMutablePointer<UInt8>? = nil, bufferSize: Int = 0) -> Data {
        return Data()

    }

    public static func decrypt(data: Data, withPrivateKey key: RSAKey.PrivateKey, aBuffer: UnsafeMutablePointer<UInt8>? = nil, bufferSize: Int = 0) -> Data? {
        
        if bufferSize >= RSABlockSize(key._rsa) {
            return _decrypt(data: data, withPrivateKey: key, aBuffer: aBuffer!)
        }else {
            let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: RSABlockSize(key._rsa))
            return _decrypt(data: data, withPrivateKey: key, aBuffer: buffer)
        }
    }

    static func _encrypt(data: Data, withPublicKey key: RSAKey.PublicKey, aBuffer: UnsafeMutablePointer<UInt8>) -> Data {
        let str = data.base64EncodedString(options: [])
        print("\n base64edStr: \(str)\n")

        var base64edData = str.data(using: String.Encoding.utf8)!
        let maxEncryptBlockLen = RSABlockSize(key._rsa)
        var blockCount = base64edData.count / (maxEncryptBlockLen - 11)
        if base64edData.count % (maxEncryptBlockLen - 11) != 0 {
            blockCount += 1
        }
//        var resultData = Data(count: maxEncryptBlockLen * blockCount)
        let resultBytesCount = maxEncryptBlockLen * blockCount
        let resultBytes = UnsafeMutablePointer<UInt8>.allocate(capacity: resultBytesCount)
        let resultData = Data(bytesNoCopy: resultBytes, count: resultBytesCount, deallocator: Data.Deallocator.free)
        var index = 0
        var resultIndex = 0
        while index < base64edData.count {
            var upper = index + maxEncryptBlockLen - 11
            if upper > base64edData.count {
                upper = base64edData.count
            }
            let range = Range<Data.Index>(uncheckedBounds: (lower: index, upper: upper))
            index = upper
            memset(aBuffer, 0, maxEncryptBlockLen - 11)
            base64edData.copyBytes(to: aBuffer, from: range)
            var len: Int = 0
            RSAPublicKeyEncrypt(key._rsa, aBuffer, maxEncryptBlockLen - 11, resultBytes, resultIndex, &len)
            resultIndex += maxEncryptBlockLen
        }

//        print("buffer:\(buffer)");
//        RSAPrivateKeyDecrypt(privateRsa!, buffer, len, newBuffer, &len)
//        print("newBuffer:\(newBuffer)");
        
//        let data2 = Data.init(bytes: newBuffer, count: len)
//        let str = String.init(data: data2, encoding: String.Encoding.utf8)
//        print("str:\(str)");
        
        return resultData
    }
    
    static func _encrypt(data: Data, withPrivateKey key: RSAKey.PrivateKey, aBuffer: UnsafeMutablePointer<UInt8>? = nil, bBuffer: UnsafeMutablePointer<UInt8>? = nil) -> Data {
        return Data()
    }
    
    static func _decrypt(data: Data, withPublicKey key: RSAKey.PublicKey, aBuffer: UnsafeMutablePointer<UInt8>? = nil, bBuffer: UnsafeMutablePointer<UInt8>? = nil) -> Data {
        return Data()
        
    }
    
    static func _decrypt(data: Data, withPrivateKey key: RSAKey.PrivateKey, aBuffer: UnsafeMutablePointer<UInt8>) -> Data? {
        let maxEncryptBlockLen = RSABlockSize(key._rsa)
        var blockCount = data.count / maxEncryptBlockLen
        if data.count % maxEncryptBlockLen != 0 {
            blockCount += 1
        }
        //        var resultData = Data(count: maxEncryptBlockLen * blockCount)
        let resultBytesCount = (maxEncryptBlockLen - 11) * blockCount
        let resultBytes = UnsafeMutablePointer<UInt8>.allocate(capacity: resultBytesCount)
        let resultData = Data(bytesNoCopy: resultBytes, count: resultBytesCount, deallocator: Data.Deallocator.free)
        
        var index = 0
        var resultIndex = 0
        while index < data.count {
            var upper = index + maxEncryptBlockLen
            if upper > data.count {
                upper = data.count
            }
            let range = Range<Data.Index>(uncheckedBounds: (lower: index, upper: upper))
            index = upper
            data.copyBytes(to: aBuffer, from: range)
            var len: Int = 0
            RSAPrivateKeyDecrypt(key._rsa, aBuffer, maxEncryptBlockLen, resultBytes, resultIndex, &len)
            resultIndex += maxEncryptBlockLen - 11
        }
        
        //        print("buffer:\(buffer)");
        //        RSAPrivateKeyDecrypt(privateRsa!, buffer, len, newBuffer, &len)
        //        print("newBuffer:\(newBuffer)");
        
        //        let data2 = Data.init(bytes: newBuffer, count: len)
        //        let str = String.init(data: data2, encoding: String.Encoding.utf8)
        //        print("str:\(str)");
        if let resultStr = String(data: resultData, encoding: String.Encoding.utf8) {
            print("\nresultStr: \(resultStr)\n")
            
            return Data(base64Encoded: resultStr, options: Data.Base64DecodingOptions.ignoreUnknownCharacters)
        }else {
            return nil
        }
        return Data()
        
    }
    
//    static func _decrypt(data: Data,  publicKey: String, privateKey: String) {
//        let bytes = publicKey.utf8CString
//        let oldBuffer = UnsafeMutablePointer<UInt8>.allocate(capacity: 128)
//        
//        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: 128)
//        
//        let newBuffer = UnsafeMutablePointer<UInt8>.allocate(capacity: 128)
//        
//        bytes.withUnsafeBufferPointer { ptr in
//            let publicRsa: UnsafeMutableRawPointer = RSAPublicKeyInit(ptr.baseAddress)
//            //        var privateRes: UnsafeMutableRawPointer
//            var privateRsa: UnsafeMutableRawPointer?
//            
//            let bytes2 = privateKey.utf8CString
//            bytes2.withUnsafeBufferPointer { privateKeyStringPtr in
//                let aprivateRsa = RSAPrivateKeyInit(privateKeyStringPtr.baseAddress)
//                privateRsa = aprivateRsa
//            }
//            //            = RSAPublicKeyInit(ptr.baseAddress)
//            print("privateRsa:\(privateRsa)");
//            
//            
//            
//            
//            //        let data = "---------------123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890".data(using: String.Encoding.utf8)!
//            let data = "---------------123".data(using: String.Encoding.utf8)!
//            
//            
//            
//            
//            let range = Range<Data.Index>(uncheckedBounds: (lower: 0, upper: data.count))
//            let datatt = data.subdata(in: range)
//            if data == datatt {
//                print("data == datatt")
//            }
//            
//            data.copyBytes(to: oldBuffer, count: data.count)
//            print("oldBuffer:\(oldBuffer)");
//            var len: Int = 0
//            RSAPublicKeyEncrypt(publicRsa, oldBuffer, data.count, buffer, &len)
//            print("buffer:\(buffer)");
//            RSAPrivateKeyDecrypt(privateRsa!, buffer, len, newBuffer, &len)
//            print("newBuffer:\(newBuffer)");
//            
//            let data2 = Data.init(bytes: newBuffer, count: len)
//            let str = String.init(data: data2, encoding: String.Encoding.utf8)
//            print("str:\(str)");
//        }
//        buffer.deinitialize()
//    }
//
//    
//    
//    public func tttzzz(publicKey: String, privateKey: String) {
//        let bytes = publicKey.utf8CString
//        
//        
//        
//        
//        let oldBuffer = UnsafeMutablePointer<UInt8>.allocate(capacity: 128)
//        
//        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: 128)
//        
//        let newBuffer = UnsafeMutablePointer<UInt8>.allocate(capacity: 128)
//        
//        bytes.withUnsafeBufferPointer { ptr in
//            let publicRsa: UnsafeMutableRawPointer = RSAPublicKeyInit(ptr.baseAddress)
//            //        var privateRes: UnsafeMutableRawPointer
//            var privateRsa: UnsafeMutableRawPointer?
//            
//            let bytes2 = privateKey.utf8CString
//            bytes2.withUnsafeBufferPointer { privateKeyStringPtr in
//                let aprivateRsa = RSAPrivateKeyInit(privateKeyStringPtr.baseAddress)
//                privateRsa = aprivateRsa
//            }
//            //            = RSAPublicKeyInit(ptr.baseAddress)
//            print("privateRsa:\(privateRsa)");
//            
//            
//            
//            
//            //        let data = "---------------123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890".data(using: String.Encoding.utf8)!
//            let data = "---------------123".data(using: String.Encoding.utf8)!
//            
//            
//            
//            
//            let range = Range<Data.Index>(uncheckedBounds: (lower: 0, upper: data.count))
//            let datatt = data.subdata(in: range)
//            if data == datatt {
//                print("data == datatt")
//            }
//            
//            data.copyBytes(to: oldBuffer, count: data.count)
//            print("oldBuffer:\(oldBuffer)");
//            var len: Int = 0
//            RSAPublicKeyEncrypt(publicRsa, oldBuffer, data.count, buffer, 0, &len)
//            print("buffer:\(buffer)");
//            RSAPrivateKeyDecrypt(privateRsa!, buffer, len, newBuffer, &len)
//            print("newBuffer:\(newBuffer)");
//            
//            let data2 = Data.init(bytes: newBuffer, count: len)
//            let str = String.init(data: data2, encoding: String.Encoding.utf8)
//            print("str:\(str)");
//        }
//        buffer.deinitialize()
//    }
}




/*
 创建私钥：
 openssl genrsa -out plainPrv.key 1024
 
 创建对用公钥：
 openssl rsa -in plainPrv.key -pubout -out plainPub.key

 
 */

/*
 在使用bio接口从内存中读取pem格式的公钥时，总是读取公钥失败，经不断查找资料，发现在我们得到base64编码的RSA公钥后，从内存中读取这个公钥时要注意以下几点：
 
 （1）公钥字符串开头要加上“-----BEGIN PUBLIC KEY-----\n”，结尾加上“\n-----END PUBLIC KEY-----\n”。否则会出现error:0906D06C:PEM routines:PEM_read_bio:no start line
 
 （2）公钥字符串每隔64个字符要加一个换行，否则会报秘钥格式错误。
 
 c++代码实现举例：
 
 int nPublicKeyLen = strPublicKey.size();      //strPublicKey为base64编码的公钥字符串
 for(int i = 64; i < nPublicKeyLen; i+=64)
 {
 if(strPublicKey[i] != '\n')
 {
 strPublicKey.insert(i, "\n");
 }
 i++;
 }
 strPublicKey.insert(0, "-----BEGIN PUBLIC KEY-----\n");
 strPublicKey.append("\n-----END PUBLIC KEY-----\n");
 
 BIO *bio = NULL;
 RSA *rsa = NULL;
 char *chPublicKey = const_cast<char *>(strPublicKey.c_str());
 if ((bio = BIO_new_mem_buf(chPublicKey, -1)) == NULL)       //从字符串读取RSA公钥
 {
 cout<<"BIO_new_mem_buf failed!"<<endl;
 }
 rsa = PEM_read_bio_RSA_PUBKEY(bio, NULL, NULL, NULL);   //从bio结构中得到rsa结构
 if (!rsa)
 {
 ERR_load_crypto_strings();
 char errBuf[512];
 ERR_error_string_n(ERR_get_error(), errBuf, sizeof(errBuf));
 cout<< "load public key failed["<<errBuf<<"]"<<endl;
 BIO_free_all(bio);
 }
 
 由于使用RSA_vefify函数未能成功验证签名，改为使用evp相关函数进行签名验证。下面贴上使用公钥进行签名验证的代码：
 
 string strBase64DecodedSig = base64_decode(strSignature);                //strSignature为签名
 char *chInAppDataSignature = const_cast<char *>(strBase64DecodedSig.c_str());   //签名先进行base64解码
 int result = 0;
 char *chInAppData = const_cast<char *>(strUnsignedData.c_str());         //strUnsignedData为原始数据，即未加密数据
 EVP_PKEY *evpKey = NULL;
 EVP_MD_CTX ctx;
 evpKey = EVP_PKEY_new();
 if(evpKey == NULL)
 {
 cout<<"error EVP_PEKY_new"<<endl;
 RSA_free(rsa);
 BIO_free_all(bio);return;
 }
 if((result = EVP_PKEY_set1_RSA(evpKey,rsa)) != 1)
 {
 cout<<"error EVP_PKEY_set1_RSA"<<endl;
 RSA_free(rsa);
 EVP_PKEY_free(evpKey);
 BIO_free_all(bio);return;
 }
 EVP_MD_CTX_init(&ctx);
 if(result == 1 && (result = EVP_VerifyInit_ex(&ctx, EVP_sha1(), NULL)) != 1)
 {
 cout<<"error EVP_VerfyInit_ex"<<endl;
 }
 if(result == 1 && (result = EVP_VerifyUpdate(&ctx, chInAppData,strUnsignedData.size())) != 1)
 {
 cout<<"error EVP_VerifyUpdate"<<endl;
 }
 if(result == 1 && (result = EVP_VerifyFinal(&ctx, (unsigned char *)chInAppDataSignature, strBase64DecodedSig.size(), evpKey)) != 1)
 {
 cout<<"error EVP_VerifyFinal"<<endl;
 }
 if(result == 1)
 {
 cout<<"Verify success"<<endl;
 }
 else
 {
 ERR_load_crypto_strings();
 char errBuf[512];
 ERR_error_string_n(ERR_get_error(), errBuf, sizeof(errBuf));
 cout<<"verify failed["<<errBuf<<"]"<<endl;
 }
 EVP_MD_CTX_cleanup(&ctx);
 RSA_free(rsa);
 EVP_PKEY_free(evpKey);
 BIO_free_all(bio);
 

 
 */

//public func tttzzz(publicKey: String, privateKey: String) {
//    let bytes = publicKey.utf8CString
//    
//    
//    
//    
//    let oldBuffer = UnsafeMutablePointer<UInt8>.allocate(capacity: 128)
//
//    let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: 128)
//    
//    let newBuffer = UnsafeMutablePointer<UInt8>.allocate(capacity: 128)
//
//    bytes.withUnsafeBufferPointer { ptr in
//        let publicRsa: UnsafeMutableRawPointer = RSAPublicKeyInit(ptr.baseAddress)
////        var privateRes: UnsafeMutableRawPointer
//        var privateRsa: UnsafeMutableRawPointer?
//        
//        let bytes2 = privateKey.utf8CString
//        bytes2.withUnsafeBufferPointer { privateKeyStringPtr in
//            let aprivateRsa = RSAPrivateKeyInit(privateKeyStringPtr.baseAddress)
//            privateRsa = aprivateRsa
//        }
////            = RSAPublicKeyInit(ptr.baseAddress)
//        print("privateRsa:\(privateRsa)");
//
//        
//        
//        
////        let data = "---------------123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890".data(using: String.Encoding.utf8)!
//        let data = "---------------123".data(using: String.Encoding.utf8)!
//        
//        
//        
//        
//        let range = Range<Data.Index>(uncheckedBounds: (lower: 0, upper: data.count))
//        let datatt = data.subdata(in: range)
//        if data == datatt {
//            print("data == datatt")
//        }
//        
//        data.copyBytes(to: oldBuffer, count: data.count)
//        print("oldBuffer:\(oldBuffer)");
//        var len: Int = 0
//        RSAPublicKeyEncrypt(publicRsa, oldBuffer, data.count, buffer, 0, &len)
//        print("buffer:\(buffer)");
//        RSAPrivateKeyDecrypt(privateRsa!, buffer, len, newBuffer, &len)
//        print("newBuffer:\(newBuffer)");
//
//        let data2 = Data.init(bytes: newBuffer, count: len)
//        let str = String.init(data: data2, encoding: String.Encoding.utf8)
//        print("str:\(str)");
//        
//        
////        ttttttt3(ptr.baseAddress)
//        
////        ttttttt3(ptr.baseAddress)
//    }
//    buffer.deinitialize()
////    
////    bytes.withUnsafeMutableBufferPointer { (inout UnsafeMutableBufferPointer<CChar>) -> R in
////        <#code#>
////    }
////    
////    
////    UnsafeMutablePointer
////    withUnsafeMutablePointer(to: &cstr) { (result) -> UnsafeMutablePointer<Int8> in
////        return result
////    }
////    
////    var buffer = UnsafeMutableBufferPointer<Int8>.init(start: &cstr, count: cstr.count)
////    cstr.withUnsafeMutableBufferPointer { (&buffer) -> R in
////        
////    }
////    cstr.withUnsafeBufferPointer { (result) -> UnsafeBufferPointer<CChar> in
////        
////        ttttttt2(result)
////        
////        return result
////    }
////    var buffer = UnsafeMutablePointer<Int8>(str)
////
////    ttttttt2(UnsafeMutablePointer<Int8>!)
////    
////    var str = "asdf"
////    str.getCString(&<#T##buffer: [CChar]##[CChar]#>, maxLength: <#T##Int#>, encoding: <#T##String.Encoding#>)
////    str.getCString(&<#T##buffer: [CChar]##[CChar]#>, maxLength: <#T##Int#>, encoding: <#T##String.Encoding#>)
////    
////    
////    var buffer: UnsafeMutablePointer<UInt8> = UnsafeMutablePointer<UInt8>.allocate(capacity: 100)
////Data().copyBytes(to: buffer)
//}







