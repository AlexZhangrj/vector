//
//  ViewController.swift
//  ConnectKitIOSDemo
//
//  Created by CaiLianfeng on 16/8/28.
//  Copyright © 2016年 WangQinghai. All rights reserved.
//

import UIKit
import Dispatch
import ConnectKit

let SocketQueue = DispatchQueue(label: "SocketQueue", attributes: [])
class UserDefaultsInfo {
    static let IPKey = "IP"
    static let PortKey = "PortKey"

    static func string(_ forKey: String) -> String? {
        return UserDefaults.standard.object(forKey: forKey) as? String
    }
    static func saveString(_ value: String, forKey: String) {
        UserDefaults.standard.set(value, forKey: forKey)
        UserDefaults.standard.synchronize()
    }
}


class ViewController: UIViewController {

    var connect: SocketConnect!

    
    @IBOutlet weak var titleLabel: UILabel!
    
    
    @IBOutlet weak var ip: UITextField!
    
    
    @IBOutlet weak var portTextField: UITextField!
    
    @IBOutlet weak var debugTextView: UITextView!
    
    
    @IBOutlet weak var messageTextField: UITextField!
    
    
    @IBOutlet weak var connectButton: UIButton!
    
    
    
    @IBOutlet weak var closeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        
        self.connect = SocketConnect(delegateQueue: SocketQueue)
        SocketQueue.async{
            self.connect.delegate = self
        }
        self.connectButton.isEnabled = true
        self.closeButton.isEnabled = false
        connect.listenConnectStatusChanged(nil, changedTo: nil) { (connect, oldState, newState) -> ListenSignal in
            DispatchQueue.main.async {
                if newState == .disconnect {
                    self.connectButton.isEnabled = true
                    self.closeButton.isEnabled = false
                }else {
                    self.connectButton.isEnabled = false
                    self.closeButton.isEnabled = true
                }
                self.titleLabel.text = "\(newState)"
            }
            return .continue
        }
        self.portTextField.text = UserDefaultsInfo.string(UserDefaultsInfo.PortKey)
        self.ip.text = UserDefaultsInfo.string(UserDefaultsInfo.IPKey)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func connectButtonClicked(_ sender: UIButton) {
        
        UserDefaultsInfo.saveString(ip.text!, forKey: UserDefaultsInfo.IPKey)
        UserDefaultsInfo.saveString(portTextField.text!, forKey: UserDefaultsInfo.PortKey)
        SocketQueue.async {
            self.connect.tryConnect(self.ip.text!, port: Int(self.portTextField.text!)!, tlsSettings: nil)
        }
    }
    
    
    @IBAction func closeButtonClicked(_ sender: AnyObject) {
        SocketQueue.async {
            self.connect.disconnect()
        }
        
    }
    
    @IBOutlet weak var sendButtonClicked: UIButton!
    
    @IBAction func clearButtonClicked(_ sender: AnyObject) {
        
        self.debugTextView.text = ""
        
        self.connect.readOnce()
        
    }
    
    @IBAction func sendButtonClieked(_ sender: AnyObject) {
        var message: String = ""
        if let str = self.messageTextField.text {
            message = str
        }
        
        self.messageTextField.text = ""
        
        let data = message.data(using: String.Encoding.utf8)!
        
        SocketQueue.async {
            self.connect.tryWriteConnectUntilTimeout(data, option:  0, waitingTimeout: 10, successClosure: { (connect, item) in
                print("write success call back")

                }, timeoutClosure: { (connect, item) in
                    print("write timeout call back")

            })
        }
        
    }
}


extension ViewController: ConnectDelegate {
    func connectSuccess(_ connect: SocketConnect) {
        IMLog.info("connectSuccess")
        
        
        /*
         do login   then  interation = true
         
         */
        
        
        
    }
    func connectFailure(_ connect: SocketConnect, error: NSError) {
        IMLog.info("connectFailure")
    }
    func connectClosed(_ connect: SocketConnect, error: NSError?) {
        IMLog.info("connectClosed")
        
        connect.interacted = false
        
    }
    func connectDidReceiveData(_ connect: SocketConnect, data: Data) {
        IMLog.info("connectDidReceiveData")
        DispatchQueue.main.async {
            if let str = String(data: data, encoding: String.Encoding.utf8) {
                let ocStr = str as NSString
                var text: String = ""
                if ocStr.length > 100 {
                    text = ocStr.substring(to: 100)
                    text += "  剩余长度:\((ocStr.length - 100))"
                }else {
                    text = str
                }
                
                self.debugTextView.text = self.debugTextView.text! + text
            }
        }
    }
}






