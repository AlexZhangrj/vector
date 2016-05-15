//
//  QLConsoleLoger.m
//  QLLogFrameWork
//
//  Created by 王青海 on 15/11/1.
//  Copyright © 2015年 王青海. All rights reserved.
//

#import "QLConsoleLoger.h"
#import "QLLogHeaders.h"

@interface QLConsoleLoger ()

@property (nonatomic, assign) BOOL hasSetTags;

@property (nonatomic, strong) NSMutableDictionary * tag_dict;

@end

@implementation QLConsoleLoger


//子类必须重写的方法且不许调用super
- (void)log:(nonnull QLLogModel *)logModel
{
    NSString * key = [NSString stringWithFormat:@"%@", logModel.tag];
    if (self.tag_dict[key]) {
        printf("%s\n", [logModel consoleStr]);
    }
}

//子类必须重写的方法且不许调用super
- (nonnull dispatch_queue_t)getDoQueue
{
    return ql_getConsoleLogerDoQueue();
}

/*
 - (void)configWithInfo:(nullable NSDictionary *)info
 {
 if (info) {
 
 [self.tag_dict removeAllObjects];
 
 NSArray * arr = info[QLLogKeyTags];
 
 if ([arr isKindOfClass:[NSArray class]]) {
 self.hasSetTags = YES;
 for (NSNumber * keyNum in arr) {
 if ([keyNum isKindOfClass:[NSNumber class]]) {
 NSString * tagKeyStr = [NSString stringWithFormat:@"%@", keyNum];
 [self.tag_dict setObject:tagKeyStr forKey:keyNum];
 }
 }
 }else {
 self.hasSetTags = NO;
 if (arr) {
 NSLog(@"%s info[QLLogKeyTags] 需要一个数组", __func__);
 }
 }
 }else {
 self.hasSetTags = NO;
 }
 }
 */

//子类必须重写的方法且不许调用super
+ (nonnull id<QLLoger>)defaultLoger
{
    static QLConsoleLoger * ___consoleLoger = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        if (!___consoleLoger) {
            ___consoleLoger = [[QLConsoleLoger alloc]init];
        }
    });
    return ___consoleLoger;


}

@end
