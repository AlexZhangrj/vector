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
    let path = DirectoryPath(path: pathStr)
    return IMFileManager(parentDirectoryPath: path!)
}()

/*
 IMHomeDirectory: afc72c902548959114e2f42cce12a172
 DBDirectory: 7bdc17bd01c7a6898ed3d19e030492f8
 MediaDirectory: 45b93e8e2e31668a939ffc55af2dc51b
 AudioFileDirectory: 5ca0f58db2a44050251b8e9698ce338f
 ImageFileDirectory: 516afaeac3564a2a0f29d462e0449e9a
 tmpImageFileDirectory: 565bdf2f9ee47dd44fc55cf6222abb18
 TmpAudioFileDirectory: f7a8884f9dc70ddf7864439f81afda97
 ImageFileDirectory: 516afaeac3564a2a0f29d462e0449e9a
 */
struct IMFilePath {
    
    
    /*
     IM文件结构
     
     /afc72c902548959114e2f42cce12a172  - IMHomeDirectory
     /afc72c902548959114e2f42cce12a172/7bdc17bd01c7a6898ed3d19e030492f8  - DBDirectory  ＋
     /afc72c902548959114e2f42cce12a172/45b93e8e2e31668a939ffc55af2dc51b  - MediaDirectory message资源 －
     /afc72c902548959114e2f42cce12a172/45b93e8e2e31668a939ffc55af2dc51b/5ca0f58db2a44050251b8e9698ce338f  - AudioFileDirectory message音频文件 ＋
     /afc72c902548959114e2f42cce12a172/45b93e8e2e31668a939ffc55af2dc51b/f7a8884f9dc70ddf7864439f81afda97  - TmpAudioFileDirectory 未发送成功的message音频文件 ＋
     
     /afc72c902548959114e2f42cce12a172/45b93e8e2e31668a939ffc55af2dc51b/516afaeac3564a2a0f29d462e0449e9a  - ImageFileDirectory message图片文件 ＋
     /afc72c902548959114e2f42cce12a172/45b93e8e2e31668a939ffc55af2dc51b/565bdf2f9ee47dd44fc55cf6222abb18  - tmpImageFileDirectory 未发送成功的message图片文件 ＋
     */
    
    
    
}

private struct IMDirectoryName {
    
    #if DEBUG
    static let IMHomeDirectory: String = "IMHomeDirectory"
    static let DBDirectory: String = "DBDirectory"
    static let MediaDirectory: String = "MediaDirectory"
    static let AudioFileDirectory: String = "AudioFileDirectory"
    static let TmpAudioFileDirectory: String = "TmpAudioFileDirectory"
    static let ImageFileDirectory: String = "ImageFileDirectory"
    static let TmpImageFileDirectory: String = "TmpImageFileDirectory"
    
    #else
    static let IMHomeDirectory: String = "IMHomeDirectory".md5()
    static let DBDirectory: String = "DBDirectory".md5()
    static let MediaDirectory: String = "MediaDirectory".md5()
    static let AudioFileDirectory: String = "AudioFileDirectory".md5()
    static let TmpAudioFileDirectory: String = "TmpAudioFileDirectory".md5()
    static let ImageFileDirectory: String = "ImageFileDirectory".md5()
    static let TmpImageFileDirectory: String = "TmpImageFileDirectory".md5()
    
    #endif
    
    
    static func HomeDirectory(uid: UInt64) -> String {
        var str = "\(uid)"
        #if DEBUG
            str = "user_\(str)"
        #else
            str = str.md5()
        #endif
        return str
    }
    
}




internal class IMFileManager: FileManager {
    
    /// IM根相对路径(相对：parentDirectoryPath)，会监测路径存在不存在，不存在就创建 /afc72c902548959114e2f42cce12a172
//    internal let homeDirectoryRelativePath: String
//    
//    /// 数据库根路径，会监测路径存在不存在，不存在就创建
//    internal let DBHomeDirectoryRelativePath: String
    
//    internal let homeDirectoryRelativePath: Path
//    internal let DBHomeDirectoryRelativePath: Path
    
    var IMHomeDirectory: DirectoryPath {
        get {
            return parentDirectoryPath
        }
    }
    let DBDirectory: DirectoryPath
    private let MediaDirectory: DirectoryPath
    let AudioFileDirectory: DirectoryPath
    let TmpAudioFileDirectory: DirectoryPath
    let ImageFileDirectory: DirectoryPath
    let TmpImageFileDirectory: DirectoryPath
    
    required override init(parentDirectoryPath: DirectoryPath) {
        
        DBDirectory = DirectoryPath(parentPath: parentDirectoryPath, path: IMDirectoryName.DBDirectory)
        MediaDirectory = DirectoryPath(parentPath: parentDirectoryPath, path: IMDirectoryName.MediaDirectory)
        AudioFileDirectory = DirectoryPath(parentPath: MediaDirectory, path: IMDirectoryName.AudioFileDirectory)
        TmpAudioFileDirectory = DirectoryPath(parentPath: MediaDirectory, path: IMDirectoryName.TmpAudioFileDirectory)
        ImageFileDirectory = DirectoryPath(parentPath: MediaDirectory, path: IMDirectoryName.ImageFileDirectory)
        TmpImageFileDirectory = DirectoryPath(parentPath: MediaDirectory, path: IMDirectoryName.TmpImageFileDirectory)
        
        super.init(parentDirectoryPath: parentDirectoryPath)
        prepareAllDirectory()
    }

    convenience init(uid: UInt64) {
        var homePathStr = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.LibraryDirectory,  NSSearchPathDomainMask.UserDomainMask, true).first!
        homePathStr += PathSeparator
        homePathStr += IMDirectoryName.IMHomeDirectory
        homePathStr += PathSeparator
        homePathStr += IMDirectoryName.HomeDirectory(uid)
        let parentDirectoryPath = DirectoryPath(path: homePathStr)
        
        self.init(parentDirectoryPath: parentDirectoryPath!)
    }
    
    private func prepareDirectory(path: String) {
        let filePath = path
        var isDir: ObjCBool = false
        if (NSFileManager.defaultManager().fileExistsAtPath(filePath, isDirectory: &isDir)) {
            if isDir.boolValue == false {
                FileManager.tryRemoveItemAtPath(filePath)
                FileManager.tryCreateDirectoryAtPath(filePath)
            }
        }else {
            FileManager.tryCreateDirectoryAtPath(filePath)
        }
    }
    private func prepareAllDirectory() {
        let parentDirectoryPathStr = parentDirectoryPath.absolutePath()
        prepareDirectory(parentDirectoryPathStr)
        print(parentDirectoryPathStr)
        
        let DBDirectoryPath = DBDirectory.absolutePath()
        prepareDirectory(DBDirectoryPath)
        print(DBDirectoryPath)

        let MediaDirectoryPath = MediaDirectory.absolutePath()
        prepareDirectory(MediaDirectoryPath)
        print(MediaDirectoryPath)

        let AudioFileDirectoryPath = AudioFileDirectory.absolutePath()
        prepareDirectory(AudioFileDirectoryPath)
        print(AudioFileDirectoryPath)

        let TmpAudioFileDirectoryPath = TmpAudioFileDirectory.absolutePath()
        prepareDirectory(TmpAudioFileDirectoryPath)
        print(TmpAudioFileDirectoryPath)

        let ImageFileDirectoryPath = ImageFileDirectory.absolutePath()
        prepareDirectory(ImageFileDirectoryPath)
        print(ImageFileDirectoryPath)

        let TmpImageFileDirectoryPath = TmpImageFileDirectory.absolutePath()
        prepareDirectory(TmpImageFileDirectoryPath)
        print(TmpImageFileDirectoryPath)

    }

}





