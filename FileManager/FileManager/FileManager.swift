//
//  FileManager.swift
//  FileManager
//
//  Created by wangqinghai on 16/6/23.
//  Copyright © 2016年 yimay. All rights reserved.
//

import UIKit

let DefaultFileManager = NSFileManager.defaultManager()

/// 路径分割符
public let PathSeparator: String = {
    var separator = "/"
    return separator;
}()

public class FileManager: NSObject {
    public let parentDirectoryPath: DirectoryPath
    
    public init(parentDirectoryPath: DirectoryPath) {
        self.parentDirectoryPath = parentDirectoryPath
    }
    

    
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
    case RelativeDirectory
    case File
}

public protocol PathProtocol: NSObjectProtocol, Equatable {
    associatedtype PathItem
    var type: PathType { get }
    var path: String { get }
    
    var parentPath: PathItem? { get }
    
//    func relativePath() -> NSMutableString
    func relativePath(withRelativePath path: PathItem) -> String?
    func absolutePath() -> String
}


public class DirectoryPath: NSObject, PathProtocol {
    public typealias PathItem = DirectoryPath

    
    public let type: PathType
    public let path: String
    
    public var parentPath: DirectoryPath?

    
    //根路径
    public init?(path: String) {
        if path.hasPrefix(PathSeparator) {
            type = .RootParentDirectory
            self.path = path
        }else {
            return nil
        }
    }
    
    //相对路径
    public init(parentPath: DirectoryPath, path: String) {
        type = .RelativeDirectory
        self.parentPath = parentPath
        self.path = path
        
        if path.hasPrefix(PathSeparator) {
            print("\(#function) error: path.hasPrefix:\(PathSeparator)")
        }
    }
    
    
//    /**
//     相对路径 相对于根节点
//     
//     - returns: 如果是根节点返回 ""
//     */
//    public func relativePath() -> NSMutableString {
//        var result: NSMutableString
//        switch type {
//        case .RootParentDirectory:
//            result = NSMutableString()
//            break
//        case .RelativeDirectory:
//            if let parentPath = self.parentPath {
//                result = parentPath.relativePath()
//            }else {
//                result = NSMutableString()
//            }
//            break
//        case .File:
//            print("Path error 父路径是一个文件")
//            result = NSMutableString()
//            break
//        }
//        return result
//    }
    
    /**
     相对路径
     
     - parameter path: 指定节点对象
     
     - returns: 如果是自身，返回 ""
     */
    public func relativePath(withRelativePath path: PathItem) -> String? {
        var result: String?
//        let selfPath = self as PathProtocol
//        if path == self {
//            switch type {
//            case .RootParentDirectory:
//                result = String()
//                break
//            case .RelativeDirectory:
//                if let parentPath = self.parentPath {
//                    result = parentPath.relativePath(withRelativePath: path)
//                    if result != nil {
//                        result! += PathSeparator
//                        result! += self.path
//                    }
//                }
//                break
//            case .File:
//                if let parentPath = self.parentPath {
//                    result = parentPath.relativePath(withRelativePath: path)
//                    if result != nil {
//                        result! += PathSeparator
//                        result! += self.path
//                    }
//                }
//                break
//            }
//            
//        }else {
//            switch type {
//            case .RootParentDirectory:
//                result = String()
//                break
//            case .RelativeDirectory:
//                fallthrough
//            case .File:
//                if let parentPath = self.parentPath {
//                    result = parentPath.relativePath(withRelativePath: path)
//                    if result != nil {
//                        result! += PathSeparator
//                        result! += self.path
//                    }
//                }
//                break
//            }
//        }
        let absStr = self.absolutePath() as NSString
        let absStr1 = path.absolutePath() as NSString
        
        let range = absStr.rangeOfString(absStr1 as String)
        if  range.location != NSNotFound {
            result = absStr.stringByReplacingCharactersInRange(range, withString: "")
            if result!.hasPrefix("\(PathSeparator)") {
                result = (result! as NSString).stringByReplacingCharactersInRange(NSMakeRange(0, (PathSeparator as NSString).length), withString: "")
            }
        }
        
        return result
    }
    
    public func absolutePath() -> String {
        var result: String?
        switch type {
        case .RootParentDirectory:
            result = String(path)
            break
        case .RelativeDirectory:
            if let parentPath = self.parentPath {
                result = parentPath.absolutePath()
                if result != nil {
                    result! += PathSeparator
                    result! += self.path
                }
            }
            break
        default:
            result = String()
            break
        }
        return result!
    }
}

public class FilePath: NSObject, PathProtocol {
    public typealias PathItem = DirectoryPath
    
    
    public let type: PathType
    public let path: String
    
    public var parentPath: DirectoryPath?
    
    
    public init?(path: String) {
        if path.hasPrefix(PathSeparator) {
            type = .File
            self.path = path
        }else {
            return nil
        }
    }
    
    public init(parentPath: DirectoryPath, path: String) {
        type = .File
        self.parentPath = parentPath
        self.path = path
        
        if path.hasPrefix(PathSeparator) {
            print("\(#function) error: path.hasPrefix:\(PathSeparator)")
        }
    }
    
    
    /**
     相对路径 相对于根节点
     
     - returns: 如果是根节点返回 ""
     */
//    public func relativePath() -> NSMutableString {
//        var result: NSMutableString
//        
//        if let tparentPath = parentPath {
//            result = tparentPath.relativePath()
//            result.appendString(PathSeparator)
//            result.appendString(self.path)
//        }else {
//            result = NSMutableString(string: self.path)
//        }
//
//        
//        return result
//    }
    
    /**
     相对路径
     
     - parameter path: 指定节点对象
     
     - returns: 如果是自身，返回 ""
     */
    public func relativePath(withRelativePath path: PathItem) -> String? {
        var result: String?
        //        let selfPath = self as PathProtocol
//        if path == self {
//            result = String()
//        }else {
//            if let parentPath = self.parentPath {
//                result = parentPath.relativePath(withRelativePath: path)
//                if result != nil {
//                    result! += PathSeparator
//                    result! += self.path
//                }
//            }
//        }
        let absStr = self.absolutePath() as NSString
        let absStr1 = path.absolutePath() as NSString
        
        let range = absStr.rangeOfString(absStr1 as String)
        if  range.location != NSNotFound {
            result = absStr.stringByReplacingCharactersInRange(range, withString: "")
            if result!.hasPrefix("\(PathSeparator)") {
                result = (result! as NSString).stringByReplacingCharactersInRange(NSMakeRange(0, (PathSeparator as NSString).length), withString: "")
            }
        }
        
        return result
    }
    
    public func absolutePath() -> String {
        var result: String?
        if let tparentPath = parentPath {
            result = tparentPath.absolutePath()
            result! += PathSeparator
            result! += self.path
        }else {
            result = String(self.path)
        }
        return result!
    }
}

//public class Path: NSObject {
//    
//    public let type: PathType
//    public var parentPath: Path?
//    public let path: String
//    
//    //根路径
//    public init(path: String) {
//        type = .RootParentDirectory
//        self.path = path
//    }
//    
//    
//    
//    /**
//     相对路径 相对于根节点
//     
//     - returns: 如果是根节点返回 ""
//     */
//    public func relativePath() -> NSMutableString {
//        var result: NSMutableString
//        switch type {
//        case .RootParentDirectory:
//            result = NSMutableString()
//            break
//        case .RelativeDirectory:
//            if let parentPath = self.parentPath {
//                result = parentPath.relativePath()
//            }else {
//                result = NSMutableString()
//            }
//            break
//        case .File:
//            print("Path error 父路径是一个文件")
//            result = NSMutableString()
//            break
//        }
//        return result
//    }
//    
//    /**
//     相对路径 相对于指定节点对象(对象比较地址)
//     
//     - parameter path: 指定节点对象
//     
//     - returns: 如果是自身，返回 ""
//     */
//    public func relativePath(withRelativePath path: Path) -> NSMutableString? {
//        var result: NSMutableString?
//        if path == self {
//            switch type {
//            case .RootParentDirectory:
//                result = NSMutableString()
//                break
//            case .RelativeDirectory:
//                if let parentPath = self.parentPath {
//                    result = parentPath.relativePath(withRelativePath: path)
//                    if let resultString = result {
//                        resultString.appendString(self.path)
//                    }
//                }
//                break
//            case .File:
//                if let parentPath = self.parentPath {
//                    result = parentPath.relativePath(withRelativePath: path)
//                    if let resultString = result {
//                        resultString.appendString(self.path)
//                    }
//                }
//                break
//            }
//            
//        }else {
//            switch type {
//            case .RootParentDirectory:
//                break
//            case .RelativeDirectory:
//                if let parentPath = self.parentPath {
//                    result = parentPath.relativePath(withRelativePath: path)
//                    if let resultString = result {
//                        resultString.appendString(self.path)
//                    }
//                }
//                break
//            case .File:
//                if let parentPath = self.parentPath {
//                    result = parentPath.relativePath(withRelativePath: path)
//                    if let resultString = result {
//                        resultString.appendString(self.path)
//                    }
//                }
//                break
//            }
//        }
//        return result
//    }
//    
//    public func absolutePath() -> NSMutableString {
//        var result: NSMutableString?
//        switch type {
//        case .RootParentDirectory:
//            result = NSMutableString(string: path)
//            break
//        case .RelativeDirectory:
//            if let parentPath = self.parentPath {
//                result = parentPath.absolutePath()
//                if let resultString = result {
//                    resultString.appendString(self.path)
//                }
//            }
//            break
//        case .File:
//            print("Path error 父路径是一个文件")
//            result = NSMutableString()
//            break
//        }
//        
//        if let resultString = result {
//            resultString.appendString(self.path)
//        }else {
//            print("error absolutePath 不存在")
//            result = NSMutableString()
//        }
//        return result!
//    }
//}
//
//public class Path: NSObject {
//    public let type: PathType
//    
//    public var parentPath: Path?
//    
//    public let path: String
//    
//    //根路径
//    public init(path: String) {
//        type = .RootParentDirectory
//        self.path = path
//    }
//    
//    //相对路径
//    public init(parentPath: Path, path: String) {
//        type = .Relative
//        self.parentPath = parentPath
//        self.path = path
//    }
//    
//    private func relativePath() -> NSMutableString {
//        var result: NSMutableString
//        switch type {
//        case .RootParentDirectory:
//            result = NSMutableString()
//            break
//        case .Relative:
//            if let parentPath = self.parentPath {
//                result = parentPath.relativePath()
//            }else {
//                result = NSMutableString()
//            }
//            break
//        }
//        return result
//    }
//    
//    public func relativePath(withRelativePath path: Path) -> NSMutableString? {
//        var result: NSMutableString?
//        if path == self {
//            result = NSMutableString()
//        }else {
//            switch type {
//            case .RootParentDirectory:
//                break
//            case .Relative:
//                if let parentPath = self.parentPath {
//                    result = parentPath.relativePath(withRelativePath: path)
//                    if let resultString = result {
//                        resultString.appendString(self.path)
//                    }
//                }
//                break
//            }
//        }
//        return result
//    }
//    
//    public func absolutePath() -> NSMutableString {
//        var result: NSMutableString?
//        switch type {
//        case .RootParentDirectory:
//            result = NSMutableString(string: path)
//            break
//        case .Relative:
//            if let parentPath = self.parentPath {
//                result = parentPath.absolutePath()
//                if let resultString = result {
//                    resultString.appendString(self.path)
//                }
//            }
//            break
//        }
//        if let resultString = result {
//            resultString.appendString(self.path)
//        }else {
//            print("error absolutePath 不存在")
//            result = NSMutableString()
//        }
//        return result!
//    }
//}





