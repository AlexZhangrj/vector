//: Playground - noun: a place where people can play

import UIKit
import Base



var str = "Hello, playgroundlet str.dataUsingEncoding(NSUTF8StringEncodinglet str2 = data?.base64EncodedStringWithOption(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)print(str2)let str3 = data?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding76CharacterLineLength)print(str3)let str4 = data?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.EncodingEndLineWithCarriageReturn)print(str4)let str5 = data?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.EncodingEndLineWithLineFeedprint(str5)1"

let data = str.dataUsingEncoding(NSUTF8StringEncoding)

let str2 = data?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding64CharacterLineLength)
print(str2)
print("")



let str3 = data?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.Encoding76CharacterLineLength)
print(str3)
print("")

let str4 = data?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.EncodingEndLineWithCarriageReturn)
print(str4)
print("")

let str6 = data?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions.EncodingEndLineWithLineFeed)
print(str6)
print("")

let str5 = data?.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
print(str5)
print("")

let aa = NSDataBase64EncodingOptions.EncodingEndLineWithLineFeed.rawValue

let UUID = NSUUID()
let UUIDStr = UUID.UUIDString
var uuidbyte: [UInt8] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
UUID.getUUIDBytes(&uuidbyte)
print(uuidbyte)
let UUIDData = NSData(bytes: uuidbyte, length: 16)
let UUIDStr2 = UUIDData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions(rawValue: 0))
let UUIDStr3 = NSString(data: UUIDData, encoding: NSUTF8StringEncoding)


func t0() {
    let (privateKey, publicKey) = try! CC.RSA.generateKeyPair(2048)
    let privateKeyStr = privateKey.base64String()
    let publicKeyStr = publicKey.base64String()
    
    print("private: \(privateKeyStr)   \n\n public: \(publicKeyStr) ")
}

func t1() -> String{
    let data = "asdfaserw".dataUsingEncoding(NSUTF8StringEncoding)!
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
}


//RSA
func t2(){
    let data: NSData = "\n\n\n\n\nMIIBCgKCAQEA2wcq9+0npuRohFBP0xwaF6h1ITngFg9hW65ARvk3tj4ChsQxTzS3ls2qnyo19nmphdWUxJBRF1".dataUsingEncoding(NSUTF8StringEncoding)!
    do {
        let retdataa = try CC.RSA.encrypt(data, derKey: Config.RSAPublicKey(), tag: NSData(), padding: .oaep, digest: .sha1)
        let (retdatab, count) = try CC.RSA.decrypt(retdataa, derKey: Config.RSAPrivateKey(), tag: NSData(), padding: .oaep, digest: .sha1)
        let str = String(data: retdatab, encoding: NSUTF8StringEncoding)
        print(str)
    }catch let error as NSError {
    
    }
}
t2()



func t4() {
    let data = CC.generateRandom(256)
    let dataStr = data.base64String()
    print(dataStr)
}
t4()


//AES
func t3() {
        let data: NSData = "\n\n\n\n\nMIIBCgKCAQEA2wcq9+0npuRohFBP0xwaF6h1ITngFg9hW65ARvk3tj4ChsQxTzS3ls2qnyo19nmphdWUxJBRF1".dataUsingEncoding(NSUTF8StringEncoding)!
    let key = "EF79nY6Kn9ahOsAarwubv/t+OtFFhwb6oINiWATPdunheImYk38YhXxbnTvGWsxgTvWGMIqHdk9nVRN+ALx7vz96oZSOHfAHehK/Uou8n/SbQV0OCRAUzF//LAgKyEIycK+YhSBggXmo3audLMHQGFvz3q1h1Y/NF9C6RMJqJjca7MHtPYkRDq2LWrbvU+OTBPXLZ7HEoL6DgKDxqq8us7dsGt1egDJByI+XIDFYyymhIq1cxo2xIK98gpJak7ZP2AkEIsaOIAOuc47kEgnypC3s9kQoAt7+odKaxcNrQOv++Z/anOkR2djuUKicTUEsgY31927afkX2IGQaK0wNXA==".base64DecryptData()!
    
    do {
        try CC.crypt(.encrypt, blockMode: .cbc, algorithm: .aes, padding: .pkcs7Padding, data: data, key: aesKey, iv: iv)
        try CC.crypt(.decrypt, blockMode: .cfb, algorithm: .aes, padding: .pkcs7Padding, data: data, key: aesKey, iv: iv)
        print(str)
    }catch let error as NSError {
        
    }
    

}


t3()

