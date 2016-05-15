//
//  QLFileLoger.m
//  QLLogFrameWork
//
//  Created by 王青海 on 15/11/1.
//  Copyright © 2015年 王青海. All rights reserved.
//

#import "QLFileLoger.h"
#import "QLLogHeaders.h"
#import "QLFileLogOptions.h"
#import "QLLogGroupModel.h"

#import "QLFoundation.h"



@interface QLFileLoger ()

@property (nonatomic, copy) NSString * dirPath;
//@property (nonatomic, copy) NSString * filePath;
//@property (nonatomic, strong) NSFileHandle * fileHandle;

@property (nonatomic, assign) NSUInteger allBufferMaxLen;

@property (nonatomic, assign) NSUInteger eachBufferMaxLen;


@property (nonatomic, assign) BOOL hasSetTags;
@property (nonatomic, assign) BOOL hasDiyTag_filename;

@property (nonatomic, strong) NSMutableDictionary * tag_filename_dict;
@property (nonatomic, strong) NSMutableDictionary * filename_logModels;

@property (nonatomic, strong) NSMutableDictionary * filename_filepath;

@end

@implementation QLFileLoger

- (instancetype)init
{
    self = [super init];
    if (self) {
//        ql_nowBeijingTimeString();
        [self createDir];
        self.allBufferMaxLen = 1024 * 6;
        self.filename_logModels = [NSMutableDictionary dictionary];
        self.filename_filepath = [NSMutableDictionary dictionary];
    }
    return self;
}

- (BOOL)createDir
{
    NSDateFormatter * formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyMMdd_HH_mm_s";
    
    NSString * dirPath = [QLLogHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", [formatter stringFromDate:[NSDate date]]]];
    
//    NSString *filePath = [ql_logTextFileDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.qllog.text", [formatter stringFromDate:[NSDate date]]]];
    
    // 用这个方法来判断当前的文件是否存在，如果不存在，就创建一个文件
    NSError * error;
    BOOL result = [[NSFileManager defaultManager] createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:&error];
//    BOOL result = [[NSFileManager defaultManager] createFileAtPath:filePath contents:nil attributes:nil];
    if (result) {
        self.dirPath = dirPath;
    }else {
        NSLog(@"创建路径失败 %@", [error localizedDescription]);
    }
    return result;
}

//子类必须重写的方法且不许调用super
- (void)log:(nonnull QLLogModel *)logModel
{
    if (!self.dirPath) {
        NSLog(@"self.filePath 不存在 %@", self);
        [self createDir];
    }
    
    if (![[QLFileLogOptions defaultFileLogOptions] containsTag:logModel.tag]) {
        return;
    }
    
    NSString * fileName = [[QLFileLogOptions defaultFileLogOptions] fileNameForTag:logModel.tag];
    
    if (!fileName) {
        return;
    }
    
    if (![self fileExit:fileName]) {
        [self createFile:fileName];
    }
    
    
    QLLogGroupModel *groupModel = self.filename_logModels[fileName];
    if (!groupModel) {
        groupModel = [[QLLogGroupModel alloc] init];
        groupModel.date = QLLogAPI_NowBeijingTime();
        self.filename_logModels[fileName] = groupModel;
    }
    
    [groupModel.logModels addObject:logModel];
    if ([logModel.date timeIntervalSince1970] - [groupModel.date timeIntervalSince1970] > 1200) {
        [self storeAllLogs];
    }
    

    if ([groupModel.logModels count] >= 10) {
        groupModel.date = QLLogAPI_NowBeijingTime();
        
        NSMutableData *resultData = [NSMutableData data];
        
        for (NSInteger i=0; i<10; i++) {
            @autoreleasepool {
                QLLogModel *logModel = [groupModel.logModels firstObject];
                [groupModel.logModels removeObjectAtIndex:0];
                
                NSDictionary *dict = [logModel dictFromModel];
                NSData *dictData = QLDictToData(dict);
                uint32_t len = (uint32_t)dictData.length;
                
                NSData *mdata = [NSData dataWithBytes:&len length:sizeof(uint32_t)];
                [resultData appendData:mdata];
                [resultData appendData:dictData];
            }
        }
        if (![self fileExit:fileName]) {
            [self createFile:fileName];
        }

        NSFileHandle * fileHandle =  [NSFileHandle fileHandleForWritingAtPath:[self filePathWithFileName:fileName]];
        [fileHandle seekToEndOfFile];
        
        [fileHandle writeData:resultData];
        [fileHandle closeFile];
    }
    
    
    
    
//    NSMutableArray * logModels = self.filename_logModels[fileName];
//    if (!logModels) {
//        logModels = [NSMutableArray array];
//        self.filename_logModels[fileName] = logModels;
//    }
//    
//    [logModels addObject:logModel];
    
    
    
    
//    if (dataString.length > self.eachBufferMaxLen) {
//        if (![self fileExit:fileName]) {
//            [self createFile:fileName];
//        }
//        
//        NSFileHandle * fileHandle =  [NSFileHandle fileHandleForWritingAtPath:[self.dirPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.qllog.text", fileName]]];
//        NSData * data = [dataString dataUsingEncoding:NSUTF8StringEncoding];
//        [fileHandle seekToEndOfFile];
//        [fileHandle writeData:data];
//        [fileHandle closeFile];
//        [dataString replaceCharactersInRange:NSMakeRange(0, dataString.length) withString:@""];
//    }
}

- (void)storeAllLogs
{
    if (self.filename_logModels) {
        for (NSString * fileName in self.filename_logModels) {
            QLLogGroupModel *groupModel = self.filename_logModels[fileName];
            groupModel.date = QLLogAPI_NowBeijingTime();
            
            NSMutableData *resultData = [NSMutableData data];
            
            for (NSInteger i=0; i<groupModel.logModels.count; i++) {
                @autoreleasepool {
                    QLLogModel *logModel = [groupModel.logModels firstObject];
                    [groupModel.logModels removeObjectAtIndex:0];
                    
                    NSDictionary *dict = [logModel dictFromModel];
                    NSData *dictData = QLDictToData(dict);
                    uint32_t len = (uint32_t)dictData.length;
                    
                    NSData *mdata = [NSData dataWithBytes:&len length:sizeof(uint32_t)];
                    [resultData appendData:mdata];
                    [resultData appendData:dictData];
                }
            }
            if (![self fileExit:fileName]) {
                [self createFile:fileName];
            }
            
            NSFileHandle * fileHandle =  [NSFileHandle fileHandleForWritingAtPath:[self filePathWithFileName:fileName]];
            [fileHandle seekToEndOfFile];
            [fileHandle writeData:resultData];
            [fileHandle closeFile];
        }
    }
}

- (NSString *)crashFilePathWithFileName:(NSString *)fileName
{
    NSString * filePath = [self.dirPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", fileName, QLLogCrashFileSuffix]];
    
    return filePath;
}

- (NSString *)filePathWithFileName:(NSString *)fileName
{
    NSString * filePath = [self.dirPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", fileName, QLLogFileSuffix]];
    
    return filePath;
}

- (BOOL)fileExit:(NSString *)fileName
{
    if (self.filename_filepath[fileName]) {
        return YES;
    }else {
        NSString * filePath = [self filePathWithFileName:fileName];
        BOOL isDir;
        BOOL fileExists;
        fileExists = [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDir];
        if (fileExists && !isDir) {
            [self.filename_filepath setObject:filePath forKey:fileName];
            return YES;
        }else {
            return NO;
        }
    }
}

- (BOOL)createFile:(NSString *)fileName
{
    NSString * filePath = [self filePathWithFileName:fileName];
    BOOL isDir;
    BOOL fileExists;
    fileExists = [[NSFileManager defaultManager] fileExistsAtPath:filePath isDirectory:&isDir];
    if (fileExists && !isDir) {
        return YES;
    }else {
        BOOL result = [[NSFileManager defaultManager] createFileAtPath:filePath contents:nil attributes:nil];
        if (result) {
            return result;
        }else {
             NSLog(@"%s 创建日志文件失败", __func__);
        }
        return result;
    }
}

- (NSString *)fileNameWithTag:(NSUInteger)tag
{
    NSString * tagKeyStr = [NSString stringWithFormat:@"%@", @(tag)];
    if (self.hasSetTags) {
        if (self.hasDiyTag_filename) {
            return self.tag_filename_dict[tagKeyStr];
        }else {
            return QLLogFileDefaultName;
        }
    }else {
        NSString * filename = self.tag_filename_dict[tagKeyStr];
        if (filename) {
            return filename;
        }else {
            return QLLogFileDefaultName;
        }
    }
    return nil;
}


//- (BOOL)needLogWithTag:(NSUInteger)tag
//{
//    if (self.hasSetTags) {
//        NSString * tagKeyStr = [NSString stringWithFormat:@"%@", @(tag)];
//        if (self.tag_filename_dict[tagKeyStr]) {
//            return YES;
//        }
//        
//        
//    }else {
//        return YES;
//    }
//    
//    
//    return NO;
//}



//- (void)configWithInfo:(nullable NSDictionary *)info
//{
//    if (info) {
////        NSIndexPath *  NSIndexSet
//        
//        
//        [self.tag_filename_dict removeAllObjects];
//        
//        NSArray * arr = info[QLLogKeyTags];
//        NSDictionary * tag_filename = info[QLLogKeyTag_filename];
//        if ([arr isKindOfClass:[NSArray class]]) {
//            self.hasSetTags = YES;
//            
//
//            if (![tag_filename isKindOfClass:[NSDictionary class]]) {
//                tag_filename = nil;
//                NSLog(@"%s  info[QLLogKeyTag_filename] 需要一个字典数据", __func__);
//                self.hasDiyTag_filename = NO;
//            }else {
//                self.hasDiyTag_filename = YES;
//                if (!self.tag_filename_dict) {
//                    self.tag_filename_dict = [NSMutableDictionary dictionary];
//                }
//            }
//            
//            NSUInteger nameCount = 1;
//            for (NSNumber * keyNum in arr) {
//                NSString * tagKeyStr = [NSString stringWithFormat:@"%@", keyNum];
//                if (tag_filename[tagKeyStr]) {
//                    [self.tag_filename_dict setObject:tag_filename[tagKeyStr] forKey:tagKeyStr];
//                    nameCount ++;
//                }else {
//                    [self.tag_filename_dict setObject:tag_filename[tagKeyStr] forKey:QLLogFileDefaultName];
//                }
//            }
//            self.eachBufferMaxLen = self.allBufferMaxLen / nameCount;
//        }else {
//            self.hasSetTags = NO;
//            if (arr) {
//                NSLog(@"%s info[QLLogKeyTags] 需要一个数组", __func__);
//            }
//            if (!self.tag_filename_dict) {
//                self.tag_filename_dict = [NSMutableDictionary dictionary];
//            }
//            NSArray * tagsName = [tag_filename allKeys];
//            
//            for (NSString * tagKeyStr in tagsName) {
//                [self.tag_filename_dict setObject:tag_filename[tagKeyStr] forKey:tagKeyStr];
//            }
//        }
//    }else {
//        self.hasSetTags = NO;
//        self.hasDiyTag_filename = NO;
//        self.tag_filename_dict = nil;
//    }
//}



//子类必须重写的方法且不许调用super
- (nonnull dispatch_queue_t)getDoQueue
{
    return ql_getFileLogerDoQueue();
}



+ (NSArray *)logDictsWithWithContentsOfFile:(NSString *)filePath
{
    NSFileHandle * fileHandle =  [NSFileHandle fileHandleForReadingAtPath:filePath];
    
    if (!fileHandle) {
        return nil;
    }

    [fileHandle seekToEndOfFile];
    NSUInteger fileLong = [fileHandle offsetInFile];
    [fileHandle seekToFileOffset:0];
    
    NSUInteger headLen = sizeof(uint32_t);

    NSUInteger offset = 0;
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    while ((fileLong - offset) > headLen) {
        uint32_t len;
        [[fileHandle readDataOfLength:headLen] getBytes:&len length:headLen];
        
        offset += headLen;
        [fileHandle seekToFileOffset:offset];
        
        if ((fileLong - offset) >= len) {
            NSData *data = [fileHandle readDataOfLength:len];
            offset += len;
            [fileHandle seekToFileOffset:offset];
            NSDictionary *dict = QLJSONToDict(data);
            if (dict) {
                [array addObject:dict];
            }
        }else {
            break;
        }
    }

    [fileHandle closeFile];
    
    return array;
}

+ (NSArray *)logDictsWithData:(NSData *)data
{
    if (!data) {
        return nil;
    }

    NSUInteger headLen = sizeof(uint32_t);
    NSUInteger fileLong = data.length;

    NSUInteger offset = 0;
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    while ((fileLong - offset) > headLen) {
        uint32_t len;
        [data getBytes:&len range:NSMakeRange(offset, headLen)];
        
        offset += headLen;
        
        if ((fileLong - offset) >= len) {
            NSData *subdata = [data subdataWithRange:NSMakeRange(offset, len)];
            offset += len;
            NSDictionary *dict = QLJSONToDict(subdata);
            if (dict) {
                [array addObject:dict];
            }
        }else {
            break;
        }
    }
    return array;
}

- (void)logCrash:(NSException *)exception
{
    if (nil == exception)
    {
        return;
    }
    //#ifdef DEBUG
    NSLog(@"CRASH: %@", exception);
    NSLog(@"Stack Trace: %@", [exception callStackSymbols]);
    //#endif
    // Internal error reporting
    if ([[QLLog defaultLog] initSuccessed]) {
        NSString * filePath = [self crashFilePathWithFileName:[NSString stringWithFormat:@"CRASH_%@", [QLLogAPI_NowBeijingTimeString() stringByReplacingOccurrencesOfString:@" " withString:@"_"]]];
        NSString *content = [[NSString stringWithFormat:@"CRASH: %@\n", exception] stringByAppendingString:[NSString stringWithFormat:@"Stack Trace: %@\n", [exception callStackSymbols]]];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSArray *languages = [defaults objectForKey:@"AppleLanguages"];
        NSString *phoneLanguage = [languages objectAtIndex:0];
        
        content = [content stringByAppendingString:[NSString stringWithFormat:@"iPhone:%@  iOS Version:%@ Language:%@",QLLogAPI_PlatformString(), QLLogAPI_SystemVersion(),phoneLanguage]];
        NSError *error = nil;
        [content writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
        
        if (error) {
            //            QLOLogCrashs(@"%@", error);
        }
    }
}




//子类必须重写的方法且不许调用super
+ (nonnull id<QLLoger>)defaultLoger
{
    static QLFileLoger * ___fileLoger = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        if (!___fileLoger) {
            ___fileLoger = [[QLFileLoger alloc]init];
        }
    });
    return ___fileLoger;
}

@end
