//
//  DataHelper.h
//  IMTestDemo
//
//  Created by wangqinghai on 16/5/13.
//  Copyright © 2016年 yimay. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataHelper : NSObject

+ (NSInteger)outputStream:(NSOutputStream *)stream data:(NSData *)data beginIndex:(NSInteger)beginIndex;

@end
