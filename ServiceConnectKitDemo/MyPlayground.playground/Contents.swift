//: Playground - noun: a place where people can play

import Cocoa
import CryptoKit

var str = "Hello, playground"


let privateKeyPath = "/Users/WangQinghai/Desktop/TestRSA/plainPrv.key"
let publicKeyPath = "/Users/WangQinghai/Desktop/TestRSA/plainPub.key"

let pubData = try! Data(contentsOf: URL(fileURLWithPath: publicKeyPath))
let priData = try! Data(contentsOf: URL(fileURLWithPath: privateKeyPath))

let publicKey = RSACrypt.RSAKey.publicKey(pemFileData: pubData)
let privateKey = RSACrypt.RSAKey.privateKey(pemFileData: priData)
//let privateKeyResult = RSACrypt.RSAKey.key(pemFileData: priData)
tttzzz(publicKey: publicKey!.formatString, privateKey: privateKey!.formatString)


//ttt
