//
//  ViewController.swift
//  FileManager
//
//  Created by wangqinghai on 16/6/22.
//  Copyright © 2016年 yimay. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        DefaultIMFilePathManager
        
        
        print("\(NSHomeDirectory())")
        
        
        
        let pathStr = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory,  NSSearchPathDomainMask.UserDomainMask, true).first!
        let path = pathStr + "/a/b/c"
        
        tryCreateDirectoryAtPath(path)
        
        print(path)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


func tryCreateDirectoryAtPath(path: String) {
    do {
        try NSFileManager.defaultManager().createDirectoryAtPath(path, withIntermediateDirectories: true, attributes: nil)
    } catch let error {
        //            log.error(error)
        print(error)
    }
}