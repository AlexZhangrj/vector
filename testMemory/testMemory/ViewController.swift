//
//  ViewController.swift
//  testMemory
//
//  Created by wangqinghai on 16/6/7.
//  Copyright © 2016年 yimay. All rights reserved.
//

import UIKit

typealias GCDTimerTask = (currentTimer: GCDTimer) -> Void


class GCDTimer: NSObject {
    let _timer: dispatch_source_t
    private(set) var started: Bool = false
    let taskClosure: GCDTimerTask
    
    
    init(withTimeInterval time: NSTimeInterval, task: GCDTimerTask, queue: dispatch_queue_t =  dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), delta: Int64 = 2000) {
        taskClosure = task
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue)
        dispatch_source_set_timer(_timer, dispatch_walltime(nil, delta), UInt64(Double(NSEC_PER_SEC) * time), 0)
        super.init()
        let task: dispatch_block_t = { [weak self] in
            if let strongSelf = self {
                strongSelf._doTimer()
            }
        }
        dispatch_source_set_event_handler(_timer, task)
    }
    
    private func _doTimer() {
        taskClosure(currentTimer: self)
    }
    
    func start() {
        if !started {
            dispatch_resume(_timer);
            started = true
        }
    }
    
    func stop() {
        if started {
            dispatch_source_cancel(_timer)
            started = false
        }
    }
    
}



class ViewController: UIViewController {
    var timer: GCDTimer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        var times: Int = 0
        
        timer = GCDTimer(withTimeInterval: 0.3, task: { (currentTimer) in
            print("123")
            times += 1
            
            if times >= 5 {
                currentTimer.stop()
                currentTimer.start()
                times = 0
            }
            
        })
        
        timer!.start()
        
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

