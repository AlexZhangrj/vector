//
//  QLPersistenceManager.m
//  QLTools
//
//  Created by 王青海 on 15/11/18.
//  Copyright © 2015年 王青海. All rights reserved.
//

#import "QLPersistenceManager.h"
#import "QLDirectoryHandleAPI.h"

#import <UIKit/UIKit.h>

#if 0

#import "SDImageCache.h"
#endif

#define QLPersistenceDir @"persistence"
#define QLPersistenceInfoPlistFileName @"persistence_info.plist"
#define QLPersistenceInfoStoreTime 300
#define QLPersistenceTimerOnceTime 30


@interface QLPersistenceManager ()

@property (nonatomic, strong) NSMutableDictionary * infoDict;

@property (nonatomic, assign) BOOL infoDictChanged;
@property (nonatomic, assign) NSUInteger timeCount;

@property (nonatomic, strong) NSTimer * timer;


@end
@implementation QLPersistenceManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [QLDirectoryHandleAPI asyncInDirWorkQueue:^{
            [self createPersistenceMainDirectoriesIfneed];
            [self prepareInfoDict];
        }];

        self.timer = [NSTimer scheduledTimerWithTimeInterval:QLPersistenceTimerOnceTime target:self selector:@selector(timerCallBack) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSDefaultRunLoopMode];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appstateChangedForceStore) name:UIApplicationWillEnterForegroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appstateChangedForceStore) name:UIApplicationDidEnterBackgroundNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appstateChangedForceStore) name:UIApplicationWillResignActiveNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appstateChangedForceStore) name:UIApplicationDidReceiveMemoryWarningNotification object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)prepareInfoDict
{
    NSMutableDictionary * infoDict = [[NSMutableDictionary alloc] initWithContentsOfFile:[QLPersistenceManager persistenceInfoPath]];
    if (infoDict && [infoDict isKindOfClass:[NSMutableDictionary class]]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.infoDict = infoDict;
        });
    }else {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.infoDict = [NSMutableDictionary dictionary];
        });
    }
}

/*创建持久化主文件夹*/
- (BOOL)createPersistenceMainDirectoriesIfneed
{
    NSArray * directoryPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * docPath = [directoryPaths objectAtIndex:0];
    NSString * persistenceDir = [docPath stringByAppendingString:QLPersistenceDir];
    NSFileManager * fileManager = [NSFileManager defaultManager];
    
    BOOL isDir = NO;
    
    BOOL isDirExist = [fileManager fileExistsAtPath:persistenceDir isDirectory:&isDir];
    if (isDirExist && isDir) {
        return YES;
    }else {
        NSError * error = nil;
        BOOL ret = [fileManager createDirectoryAtPath:persistenceDir withIntermediateDirectories:YES attributes:nil error:&error];
        if (ret) {
            return YES;
        }else {
            NSLog(@"%s ：创建失败error：%@", __func__, [error localizedDescription]);
            return NO;
        }
    }
}

- (void)timerCallBack
{
    if (self.infoDictChanged) {
        self.timeCount ++;
        if (self.timeCount > QLPersistenceInfoStoreTime / QLPersistenceTimerOnceTime) {
            [self synchronize:NULL faild:NULL];
        }
    }
}

+ (NSString *)persistenceInfoPath
{
    return [[QLPersistenceManager persistenceDirectory] stringByAppendingPathComponent:QLPersistenceInfoPlistFileName];
}

#pragma mark public funcs

- (nullable id)objectForKey:(nonnull NSString *)key
{
    return self.infoDict[key];
}

- (void)setObject:(nullable id)value forKey:(nonnull NSString *)key
{
    if (value) {
        [self.infoDict setObject:value forKey:key];
    }else {
        [self removeObjectForKey:key];
    }
    self.infoDictChanged = YES;
}

- (void)removeObjectForKey:(nonnull NSString *)key
{
    [self.infoDict removeObjectForKey:key];
    self.infoDictChanged = YES;
}

- (void)appstateChangedForceStore
{
    [self forceStoreDeep:3];
}

- (void)forceStoreDeep:(NSInteger)deep
{
    if (deep > 0) {
        [self forceStore:^{
            
        } faild:^{
            [self forceStoreDeep:deep - 1];
        }];
    }
}

- (void)forceStore:(dispatch_block_t)success faild:(dispatch_block_t)faild
{
    if (!self.infoDictChanged) {
        if (success) {
            success();
        }
        
        return;
    }
    BOOL ret;
    ret = [self.infoDict writeToFile:[QLPersistenceManager persistenceInfoPath] atomically:YES];
    
    if (ret) {
        self.timeCount = 0;
        self.infoDictChanged = NO;
    }
    
    if (ret) {
        if (success) {
            success();
        }
    }else {
        if (faild) {
            faild();
        }
    }
}

- (void)synchronize:(dispatch_block_t)success faild:(dispatch_block_t)faild
{
    if (!self.infoDictChanged) {
        if (success) {
            success();
        }
        return;
    }
    BOOL ret;
    ret = [self.infoDict writeToFile:[QLPersistenceManager persistenceInfoPath] atomically:YES];
    
    if (ret) {
        self.timeCount = 0;
        self.infoDictChanged = NO;
    }
    
    if (ret) {
        if (success) {
            success();
        }
    }else {
        if (faild) {
            faild();
        }
    }
}

+ (NSString *)persistenceDirectory
{
    static NSString * ____persistenceDirectory = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!____persistenceDirectory) {
            NSArray * directoryPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString * docPath = [directoryPaths objectAtIndex:0];
            ____persistenceDirectory = [docPath stringByAppendingString:QLPersistenceDir];
        }
    });
    return ____persistenceDirectory;
}

+ (QLPersistenceManager *)defaultManager
{
    static QLPersistenceManager * ____defaultManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!____defaultManager) {
            ____defaultManager = [[[self class] alloc] init];
        }
    });
    return ____defaultManager;
}

+ (void)cleanSDImageChache
{
#if 0
    [[SDImageCache sharedImageCache] clearDisk];
#endif
}
@end
