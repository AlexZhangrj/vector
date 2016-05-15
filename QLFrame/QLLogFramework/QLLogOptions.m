//
//  QLLogOptions.m
//  QLLogFrameWork
//
//  Created by 王青海 on 15/11/1.
//  Copyright © 2015年 王青海. All rights reserved.
//

#import "QLLogOptions.h"

@implementation QLLogOptions


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.tagSet = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)addTag:(NSString *)tag
{
    if (!tag) {
        return;
    }
    [self.tagSet setObject:[NSNumber numberWithBool:YES] forKey:tag];
}

- (void)removeTag:(NSString *)tag
{
    if (!tag) {
        return;
    }
    [self.tagSet removeObjectForKey:tag];
}

- (BOOL)containsTag:(NSString *)tag
{
    if (!tag) {
        return NO;
    }
    return [[self.tagSet objectForKey:tag] boolValue];
}






@end
