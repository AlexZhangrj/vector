//
//  QLLogOptions.h
//  QLLogFrameWork
//
//  Created by 王青海 on 15/11/1.
//  Copyright © 2015年 王青海. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QLLogOptions : NSObject


@property (nonatomic, strong) NSMutableDictionary *tagSet;



- (void)addTag:(NSString *)tag;

- (void)removeTag:(NSString *)tag;

- (BOOL)containsTag:(NSString *)tag;



@end
