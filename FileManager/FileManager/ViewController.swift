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
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

