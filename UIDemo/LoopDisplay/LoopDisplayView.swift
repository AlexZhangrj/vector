//
//  LoopDisplayView.swift
//  UIDemo
//
//  Created by CaiLianfeng on 16/7/18.
//  Copyright © 2016年 WangQinghai. All rights reserved.
//

import UIKit

public class LoopDisplayView: UIView {
    
    let aa: Int32
    
    
    
    public init(size: CGSize) {
        aa = 1
        super.init(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: size))
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        
        
    }
    override public func willMoveToWindow(newWindow: UIWindow?) {
        super.willMoveToWindow(newWindow)
        print(newWindow)
    }
    
    override public func didMoveToWindow() {
        super.didMoveToWindow()
        print("didMoveToWindow")
    }
    
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
