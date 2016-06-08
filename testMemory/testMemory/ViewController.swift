//
//  ViewController.swift
//  testMemory
//
//  Created by wangqinghai on 16/6/7.
//  Copyright © 2016年 yimay. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        let ttt = MemoryTest()
        let aa = ttt.availableMemory()
        let bb = ttt.usedMemory()

        print("aa: \(aa) bb:\(bb)")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

