//
//  QFDatabase.m
//  QLKit
//
//  Created by 王青海 on 16/1/10.
//  Copyright (c) 2016年 王青海. All rights reserved.
//

#import "QLDatabase.h"
#import "QLDataPersistenceAPI.h"


NSString *QLDBDirectoryRelpath = @"DB";
NSString *QLDocDBRelpath = @"coreservice.db";


//#import "NSObject+DHF.h"
@interface QLDatabase()

//@property (nonatomic, strong) NSMutableDictionary * ainfo;

@end
@implementation QLDatabase


+ (QLDatabase*)share
{
    static QLDatabase * db;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        if (!db) {
            db=[[[self class] alloc] init];
        }
    });
    return db;
}



//-(BOOL)insertArray:(NSArray *)array
//{
//    //捕获异常
//    @try {
//        //开始事务
//        [_db beginTransaction];
//        for (id model in array) {
//            [self insertModel:model];
//        }
//    }
//    @catch (NSException *exception) {
//    }
//    @finally {
//        //提交数据
//        [_db commit];
//    }
//    return YES;
//}


-(instancetype)init
{
    if (self=[super init]) {
        self.DBDirectoryPath = [[QLDataPersistenceAPI homeDirectory] stringByAppendingPathComponent:QLDBDirectoryRelpath];
        self.docDBPath = [self.DBDirectoryPath stringByAppendingPathComponent:QLDocDBRelpath];

        self.DBDirectoryPath = [[QLDataPersistenceAPI homeDirectory] stringByAppendingPathComponent:QLDBDirectoryRelpath];
        self.docDBPath = [self.DBDirectoryPath stringByAppendingPathComponent:QLDocDBRelpath];
        
        self.DBDirectoryPath = [[QLDataPersistenceAPI homeDirectory] stringByAppendingPathComponent:QLDBDirectoryRelpath];
        self.docDBPath = [self.DBDirectoryPath stringByAppendingPathComponent:QLDocDBRelpath];
        
        
        _DB = [[FMDatabase alloc] initWithPath:self.docDBPath];
//        if ([_DB open]) {
//            
//        }
    }
    return self;
}
- (void)dealloc
{
//    [_DB close];
}




@end