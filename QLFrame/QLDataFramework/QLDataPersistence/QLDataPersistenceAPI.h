//
//  QLDataPersistence.h
//  QLKit
//
//  Created by 王青海 on 16/2/17.
//  Copyright © 2016年 王青海. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QLDataPersistenceAPI : NSObject

+ (NSString *)homeDirectoryName;
+ (NSString *)homeDirectory;



+ (NSString *)cacheHomeDirectory;
+ (NSString *)tmpHomeDirectory;


+ (void)initBase;

+ (void)prepareDirectiory:(NSString *)path;






@end
