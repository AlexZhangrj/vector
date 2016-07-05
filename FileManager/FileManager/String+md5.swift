//
//  String+md5.swift
//  FileManager
//
//  Created by wangqinghai on 16/7/5.
//  Copyright © 2016年 yimay. All rights reserved.
//

import Foundation


extension String {
    
    func md5() -> String {
        return (self as NSString).md5()
    }
}
