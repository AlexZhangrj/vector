//
//  BaseNavigationController.swift
//  Ev
//
//  Created by 王青海 on 16/5/25.
//  Copyright © 2016年 王青海. All rights reserved.
//

import UIKit

public class BaseNavigationController: UINavigationController {

    public override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationBar.translucent = false
    }
    
    public override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.LightContent
    }
    
    public override func prefersStatusBarHidden() -> Bool {
        return false
    }
    
    public override func shouldAutorotate() -> Bool {
        return true
    }
    public override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
    
    public override func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation {
        return UIInterfaceOrientation.Portrait
    }
    
}
