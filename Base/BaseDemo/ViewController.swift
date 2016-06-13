//
//  ViewController.swift
//  BaseDemo
//
//  Created by 王青海 on 16/6/3.
//  Copyright © 2016年 王青海. All rights reserved.
//

import UIKit

import Base



class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        let cache = DefaultCache
        let keya = NSString(string: "123")
        let valuea = NSString(string: "456")

        cache[keya] = valuea
        
        let keyb = NSMutableString()
        keyb.appendString("123")
        
        let valueb = cache[keyb]
        
        print(valueb)
        
        let (privateKey, publicKey) = try! CC.RSA.generateKeyPair(2048)
        let privateKeyStr = privateKey.base64String()
        let publicKeyStr = publicKey.base64String()

        print("private: \(privateKeyStr)   \n\n public: \(publicKeyStr) ")
        
//        
//        do {
//            let dh = try CC.DH.DH(dhParam: .rfc3526Group5)
//            let myPubKey = try dh.generateKey()
//            let commonKey = try dh.computeKey(partnerPubKey!)
//            
//            try CC.crypt(.encrypt, blockMode: .cbc, algorithm: .aes, padding: .pkcs7Padding, data: data, key: aesKey, iv: iv)
//            try CC.crypt(.decrypt, blockMode: .cfb, algorithm: .aes, padding: .pkcs7Padding, data: data, key: aesKey, iv: iv)
//        } catch let error as NSError {
//        
//        
//        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

