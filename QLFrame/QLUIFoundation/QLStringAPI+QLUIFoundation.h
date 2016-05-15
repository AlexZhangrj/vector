//
//  QLStringAPI+QLUIFoundation.h
//  QLFoundation
//
//  Created by 王青海 on 16/1/28.
//  Copyright © 2016年 王青海. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QLStringAPI.h"

@interface QLStringAPI (QLUIFoundation)

+ (CGSize)sizeOfString:(NSString *)text lable:(UILabel *)lable;

+ (CGSize)sizeOfString:(NSString *)text boldSystemFontOfSize:(CGFloat)boldSystemFontOfSize maxWidth:(CGFloat)maxWidth;

+ (CGSize)sizeOfString:(NSString *)text systemFontOfSize:(CGFloat)systemFontOfSize maxWidth:(CGFloat)maxWidth;

+ (CGSize)sizeOfString:(NSString *)text font:(UIFont *)font maxWidth:(CGFloat)maxWidth;

+ (CGSize)sizeOfString:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize;




+ (NSString *)addressOfObject2String:(id)object;

@end
