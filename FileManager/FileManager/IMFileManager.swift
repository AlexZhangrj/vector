//
//  IMFileManager.swift
//  FileManager
//
//  Created by wangqinghai on 16/6/23.
//  Copyright © 2016年 yimay. All rights reserved.
//

import UIKit

internal let DefaultIMFilePathManager: IMFileManager = {
    let pathStr = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory,  NSSearchPathDomainMask.UserDomainMask, true).first!
    let path = Path(path: pathStr)
    return IMFileManager(parentDirectoryPath: path)
}()

/*
 IMHomeDirectory: afc72c902548959114e2f42cce12a172
 DBDirectory: 7bdc17bd01c7a6898ed3d19e030492f8
 MediaDirectory: 45b93e8e2e31668a939ffc55af2dc51b
 AudioFileDirectory: 5ca0f58db2a44050251b8e9698ce338f
 ImageFileDirectory: 516afaeac3564a2a0f29d462e0449e9a
 tmpImageFileDirectory: 565bdf2f9ee47dd44fc55cf6222abb18
 tmpAudioFileDirectory: f7a8884f9dc70ddf7864439f81afda97
 ImageFileDirectory: 516afaeac3564a2a0f29d462e0449e9a
 */
struct IMFilePath {
    
    
    /*
     IM文件结构
     
     /afc72c902548959114e2f42cce12a172  - IMHomeDirectory
     /afc72c902548959114e2f42cce12a172/7bdc17bd01c7a6898ed3d19e030492f8  - DBDirectory  ＋
     /afc72c902548959114e2f42cce12a172/45b93e8e2e31668a939ffc55af2dc51b  - MediaDirectory message资源 －
     /afc72c902548959114e2f42cce12a172/45b93e8e2e31668a939ffc55af2dc51b/5ca0f58db2a44050251b8e9698ce338f  - AudioFileDirectory message音频文件 ＋
     /afc72c902548959114e2f42cce12a172/45b93e8e2e31668a939ffc55af2dc51b/f7a8884f9dc70ddf7864439f81afda97  - tmpAudioFileDirectory 未发送成功的message音频文件 ＋
     
     /afc72c902548959114e2f42cce12a172/45b93e8e2e31668a939ffc55af2dc51b/516afaeac3564a2a0f29d462e0449e9a  - ImageFileDirectory message图片文件 ＋
     /afc72c902548959114e2f42cce12a172/45b93e8e2e31668a939ffc55af2dc51b/565bdf2f9ee47dd44fc55cf6222abb18  - tmpImageFileDirectory 未发送成功的message图片文件 ＋
     */
    
    
    
}

internal class IMFileManager: FileManager {
    
    /// IM根相对路径(相对：parentDirectoryPath)，会监测路径存在不存在，不存在就创建 /afc72c902548959114e2f42cce12a172
//    internal let homeDirectoryRelativePath: String
//    
//    /// 数据库根路径，会监测路径存在不存在，不存在就创建
//    internal let DBHomeDirectoryRelativePath: String
    
    internal let homeDirectoryRelativePath: Path
    internal let DBHomeDirectoryRelativePath: Path

    
    override init(parentDirectoryPath: Path) {
        
        
        
        let tmpHomeDirectoryRelativePath =
//            IMFileManager.prepareHomeDirectoryRelativePath(parentDirectoryPath)
        homeDirectoryRelativePath = Path(parentPath: parentDirectoryPath, path: "")
        
        DBHomeDirectoryRelativePath = IMFileManager.prepareDBHomeDirectoryRelativePath(parentDirectoryPath, parentRelativePath: tmpHomeDirectoryRelativePath)
        
        super.init(parentDirectoryPath: parentDirectoryPath)
    }
    
    private static func prepareHomeDirectoryRelativePath(parentDirectoryPath: String) -> String {
        var resultRelativePath = ""
        let dirName = "IMHomeDirectory"
        
        resultRelativePath += FileManager.Separator
        resultRelativePath += dirName
        
        let filePath = (parentDirectoryPath as NSString).stringByAppendingPathComponent(dirName)
        var isDir: ObjCBool = false
        if (NSFileManager.defaultManager().fileExistsAtPath(filePath, isDirectory: &isDir)) {
            if isDir.boolValue == false {
                tryRemoveItemAtPath(filePath)
                tryCreateDirectoryAtPath(filePath)
            }
        }else {
            tryCreateDirectoryAtPath(filePath)
        }
        return resultRelativePath;
    }
    
    private static func prepareDBHomeDirectoryRelativePath(parentDirectoryPath: String, parentRelativePath: String) -> String {
        var resultRelativePath = ""
        let dirName = "IMDBDirectory"
        
        resultRelativePath += FileManager.Separator
        resultRelativePath += dirName
        
        var filePath = (parentDirectoryPath as NSString).stringByAppendingString(parentRelativePath)
        filePath = (filePath as NSString).stringByAppendingPathComponent(dirName)
        var isDir: ObjCBool = false
        if (NSFileManager.defaultManager().fileExistsAtPath(filePath, isDirectory: &isDir)) {
            if isDir.boolValue == false {
                tryRemoveItemAtPath(filePath)
                tryCreateDirectoryAtPath(filePath)
            }
        }else {
            tryCreateDirectoryAtPath(filePath)
        }
        return filePath;
    }
    
    
    
    
    
    
}