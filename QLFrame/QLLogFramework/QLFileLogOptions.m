//
//  QLFileLogOptions.m
//  QLLogFrameWork
//
//  Created by 王青海 on 15/11/1.
//  Copyright © 2015年 王青海. All rights reserved.
//

#import "QLFileLogOptions.h"

NSString * const QLLogFileDefaultName = @"ioslog";



@interface QLFileLogOptions()

@property (nonatomic, strong) NSMutableDictionary *fileNameOptions;

@end


@implementation QLFileLogOptions

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.fileNameOptions = [NSMutableDictionary dictionary];
    }
    return self;
}

- (BOOL)setOptionsFileNameWithTag:(NSString *)tag fileName:(NSString *)fileName
{
    if (nil == fileName) {
        if (tag) {
            [self.fileNameOptions removeObjectForKey:tag];
            return YES;
        }else {
            return NO;
        }
    }else {
        if (tag && ![tag isEqualToString:@""]) {
            [self.fileNameOptions setObject:fileName forKey:tag];
            return YES;
        }else {
            NSLog(@"tag 不能为空");
            return NO;
        }
    }
}

- (void)setOptionsFileNameWithDict:(NSDictionary *)dict
{
    for (NSString *key in [dict allKeys]) {
        [self setOptionsFileNameWithTag:key fileName:[dict objectForKey:key]];
    }
}

- (NSString *)fileNameForTag:(NSString *)tag
{
    NSString *fileName = self.fileNameOptions[tag];
    if (!fileName) {
        fileName = QLLogFileDefaultName;
    }
    
    return fileName;
}






+ (QLFileLogOptions *)defaultFileLogOptions
{
    static QLFileLogOptions *____defaultFileLogOptions;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ____defaultFileLogOptions = [[[self class] alloc] init];
    });
    return ____defaultFileLogOptions;
}




@end
