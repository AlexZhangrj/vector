//
//  FileManager.swift
//  FileManager
//
//  Created by wangqinghai on 16/6/23.
//  Copyright © 2016年 yimay. All rights reserved.
//

import UIKit

public class FileManager: NSObject {
    public let parentDirectoryPath: Path
    
    public init(parentDirectoryPath: Path) {
        self.parentDirectoryPath = parentDirectoryPath
    }
    
    /// 路径分割符
    public static let Separator: String = {
        var separator = "/"
        return separator;
    }()
    
    public static func tryRemoveItemAtPath(path: String) {
        do {
            try NSFileManager.defaultManager().removeItemAtPath(path)
        } catch let error {
            //            log.error(error)
            print(error)
        }
    }
    
    public static func tryCreateDirectoryAtPath(path: String) {
        do {
            try NSFileManager.defaultManager().createDirectoryAtPath(path, withIntermediateDirectories: true, attributes: nil)
        } catch let error {
            //            log.error(error)
            print(error)
        }
    }
    
}

public enum PathType: UInt32 {
    case RootParentDirectory
    case Relative
}

public class Path: NSObject {
    public let type: PathType
    
    public var parentPath: Path?
    
    public let path: String
    
    //根路径
    public init(path: String) {
        type = .RootParentDirectory
        self.path = path
    }
    
    //相对路径
    public init(parentPath: Path, path: String) {
        type = .Relative
        self.parentPath = parentPath
        self.path = path
    }
    
    private func relativePath() -> NSMutableString {
        var result: NSMutableString
        switch type {
        case .RootParentDirectory:
            result = NSMutableString()
            break
        case .Relative:
            if let parentPath = self.parentPath {
                result = parentPath.relativePath()
            }else {
                result = NSMutableString()
            }
            break
        }
        return result
    }
    
    public func relativePath(withRelativePath path: Path) -> NSMutableString? {
        var result: NSMutableString?
        if path == self {
            result = NSMutableString()
        }else {
            switch type {
            case .RootParentDirectory:
                break
            case .Relative:
                if let parentPath = self.parentPath {
                    result = parentPath.relativePath(withRelativePath: path)
                    if let resultString = result {
                        resultString.appendString(self.path)
                    }
                }
                break
            }
        }
        return result
    }
    
    public func absolutePath() -> NSMutableString {
        var result: NSMutableString?
        switch type {
        case .RootParentDirectory:
            result = NSMutableString(string: path)
            break
        case .Relative:
            if let parentPath = self.parentPath {
                result = parentPath.absolutePath()
                if let resultString = result {
                    resultString.appendString(self.path)
                }
            }
            break
        }
        if let resultString = result {
            resultString.appendString(self.path)
        }else {
            print("error absolutePath 不存在")
            result = NSMutableString()
        }
        return result!
    }
}





