//
//  ViewController.swift
//  UIDemo
//
//  Created by CaiLianfeng on 16/7/18.
//  Copyright © 2016年 WangQinghai. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    weak var loopView: LoopDisplayView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.\
        
        
        
        let view = LoopDisplayView(size: CGSize(width: 100, height: 100))
        self.view.addSubview(view)
        loopView = view
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBOutlet weak var buttonAction: UIButton!
    
    
    @IBAction func buttonAction(sender: UIButton) {
        
        
        let vc = UIViewController()
        vc.view.backgroundColor = UIColor.greenColor()
        let tap = UITapGestureRecognizer(target: self, action: #selector(ViewController.tapped(_:)))
        vc.view.addGestureRecognizer(tap)
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @objc func tapped(tap: UITapGestureRecognizer) {
        print("\(loopView.window)")
    
    }
    
    
    
}

