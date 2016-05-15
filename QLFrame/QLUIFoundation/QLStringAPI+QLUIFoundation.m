//
//  QLStringAPI+QLUIFoundation.m
//  QLFoundation
//
//  Created by 王青海 on 16/1/28.
//  Copyright © 2016年 王青海. All rights reserved.
//

#import "QLStringAPI+QLUIFoundation.h"


@implementation QLStringAPI (QLUIFoundation)


+ (CGSize)sizeOfString:(NSString *)text lable:(UILabel *)lable
{
    CGSize maxSize = CGSizeMake(lable.bounds.size.width, 9999);
    UIFont * font = lable.font;
    return [QLStringAPI sizeOfString:text font:font maxSize:maxSize];
}

+ (CGSize)sizeOfString:(NSString *)text boldSystemFontOfSize:(CGFloat)boldSystemFontOfSize maxWidth:(CGFloat)maxWidth
{
    CGSize maxSize = CGSizeMake(maxWidth, 9999);
    UIFont * font = [UIFont boldSystemFontOfSize:boldSystemFontOfSize];
    return [QLStringAPI sizeOfString:text font:font maxSize:maxSize];
}

+ (CGSize)sizeOfString:(NSString *)text systemFontOfSize:(CGFloat)systemFontOfSize maxWidth:(CGFloat)maxWidth
{
    CGSize maxSize = CGSizeMake(maxWidth, 9999);
    UIFont * font = [UIFont systemFontOfSize:systemFontOfSize];
    return [QLStringAPI sizeOfString:text font:font maxSize:maxSize];
}

+ (CGSize)sizeOfString:(NSString *)text font:(UIFont *)font maxWidth:(CGFloat)maxWidth
{
    CGSize maxSize = CGSizeMake(maxWidth, 9999);
    return [QLStringAPI sizeOfString:text font:font maxSize:maxSize];
}

+ (CGSize)sizeOfString:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize
{
    CGSize size;
    CGFloat version = [[UIDevice currentDevice].systemVersion floatValue];
    if (version >= 7.0) {
        NSDictionary * dict = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil];
        size = [text boundingRectWithSize:maxSize options:(NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine|NSStringDrawingUsesLineFragmentOrigin) attributes:dict context:nil].size;
    }else {
//        size = [text boundingRectWithSize:<#(CGSize)#> options:<#(NSStringDrawingOptions)#> attributes:<#(nullable NSDictionary<NSString *,id> *)#> context:<#(nullable NSStringDrawingContext *)#>]
        
        
        size = [text sizeWithFont:font constrainedToSize:maxSize lineBreakMode:(NSLineBreakByCharWrapping)];
    }
    return size;
}

+ (NSString *)addressOfObject2String:(id)object
{
    return [NSString stringWithFormat:@"%p", object];
}

@end
