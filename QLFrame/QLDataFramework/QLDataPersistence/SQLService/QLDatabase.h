//
//  QFDatabase.h
//  QLKit
//
//  Created by 王青海 on 16/1/10.
//  Copyright (c) 2016年 王青海. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"


extern NSString *QLDBDirectoryRelpath;
extern NSString *QLDocDBRelpath;

@interface QLDatabase : NSObject


@property (nonatomic, copy) NSString *DBDirectoryPath;
@property (nonatomic, copy) NSString *docDBPath;
//@property (nonatomic, copy) NSString *db;

@property (nonatomic, copy) NSString *cacheDBDirectoryPath;
@property (nonatomic, copy) NSString *cacheDBPath;

@property (nonatomic, copy) NSString *tmpDBDirectoryPath;
@property (nonatomic, copy) NSString *tmpDBPath;


//存放在跟缓存目录下
@property (nonatomic, strong) FMDatabase *DB;

@property (nonatomic, strong) FMDatabase *cacheDB;

@property (nonatomic, strong) FMDatabase *tmpDB;





+ (QLDatabase*)share;


@end







