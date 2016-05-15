//
//  QLFileLogOptions.h
//  QLLogFrameWork
//
//  Created by 王青海 on 15/11/1.
//  Copyright © 2015年 王青海. All rights reserved.
//

#import "QLLogOptions.h"



extern NSString * const QLLogFileDefaultName;

@interface QLFileLogOptions : QLLogOptions


- (BOOL)setOptionsFileNameWithTag:(NSString *)tag fileName:(NSString *)fileName;

//只会添加， 不会移除已经有的
- (void)setOptionsFileNameWithDict:(NSDictionary *)dict;


- (NSString *)fileNameForTag:(NSString *)tag;




























+ (QLFileLogOptions *)defaultFileLogOptions;


@end
