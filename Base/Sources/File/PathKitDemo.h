//
//  PathKitDemo.h
//  Base
//
//  Created by 王青海 on 16/6/23.
//  Copyright © 2016年 王青海. All rights reserved.
//

#ifndef PathKitDemo_h
#define PathKitDemo_h


#endif /* PathKitDemo_h */
/*
 Usage
 let path = Path("/usr/bin/swift")
 Joining paths
 let path = Path("/usr/bin") + Path("swift")
 Determine if a path is absolute
 path.isAbsolute()
 Determine if a path is relative
 path.isRelative()
 Determine if a file or directory exists at the path
 path.exists()
 Determine if a path is a directory
 path.isDirectory()
 Get an absolute path
 let absolutePath = path.absolute()
 Normalize a path
 This cleans up any redundant..or.and double slashes in paths.
 
 let normalizedPath = path.normalize()
 Deleting a path
 path.delete()
 Moving a path
 path.move(newPath)
 Current working directory
 Path.current
 Path.current = "/usr/bin"
 Changing the current working directory
 path.chdir { // Path.current would be set to path during execution of this closure }
 Children paths
 path.children()
 Reading
 path.read()
 Writing
 path.write("Hello World!")
 */