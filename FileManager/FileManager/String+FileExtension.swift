//
//  String+FileExtension.swift
//  FileManager
//
//  Created by wangqinghai on 16/6/29.
//  Copyright © 2016年 yimay. All rights reserved.
//

import Foundation





public extension String {
    
    public static func pathWithComponents(components: [String]) -> String {
        return NSString.pathWithComponents(components)
    }
    public var pathComponents: [String] {
        get {
            return (self as NSString).pathComponents
        }
    }
    
    public var absolutePath: Bool {
        get {
            return (self as NSString).absolutePath
        }
    }
    
    public var lastPathComponent: String {
        get {
            return (self as NSString).lastPathComponent
        }
    }
    public var stringByDeletingLastPathComponent: String {
        get {
            return (self as NSString).stringByDeletingLastPathComponent
        }
    }
    public func stringByAppendingPathComponent(str: String) -> String {
        return (self as NSString).stringByAppendingPathComponent(str)
    }
    
    public var pathExtension: String {
        get {
            return (self as NSString).pathExtension
        }
    }
    public var stringByDeletingPathExtension: String {
        get {
            return (self as NSString).stringByDeletingPathExtension
        }
    }
    public func stringByAppendingPathExtension(str: String) -> String? {
        return (self as NSString).stringByAppendingPathExtension(str)
    }
    
    public var stringByAbbreviatingWithTildeInPath: String {
        get {
            return (self as NSString).stringByAbbreviatingWithTildeInPath
        }
    }
    public var stringByExpandingTildeInPath: String {
        get {
            return (self as NSString).stringByExpandingTildeInPath
        }
    }
    
    public var stringByStandardizingPath: String {
        get {
            return (self as NSString).stringByStandardizingPath
        }
    }
    
    public var stringByResolvingSymlinksInPath: String { get {
        return (self as NSString).stringByResolvingSymlinksInPath
        }
    }
    
    public func stringsByAppendingPaths(paths: [String]) -> [String] {
        return (self as NSString).stringsByAppendingPaths(paths)
    }
    
    public func completePathIntoString(outputName: AutoreleasingUnsafeMutablePointer<NSString?>, caseSensitive flag: Bool, matchesIntoArray outputArray: AutoreleasingUnsafeMutablePointer<NSArray?>, filterTypes: [String]?) -> Int {
        return (self as NSString) .completePathIntoString(outputName, caseSensitive: flag, matchesIntoArray: outputArray, filterTypes: filterTypes)
    }
    
    public var fileSystemRepresentation: UnsafePointer<Int8> {
        get {
            return (self as NSString).fileSystemRepresentation
        }
    }
    public func getFileSystemRepresentation(cname: UnsafeMutablePointer<Int8>, maxLength max: Int) -> Bool {
        return (self as NSString).getFileSystemRepresentation(cname, maxLength: max)
    }
}

