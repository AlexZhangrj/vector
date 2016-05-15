
#import "QLBaseModel.h"

@implementation QLBaseModel

#pragma mark - <JSONModel>
/**从underscore(下划线)方式 转化成Camel(骆驼)方法*/
//+(JSONKeyMapper*)keyMapper {
//    return [JSONKeyMapper mapperFromUnderscoreCaseToCamelCase];
//}

// 这里的属性都是可选的 如果Model中属性多了 也不要管
+(BOOL)propertyIsOptional:(NSString*)propertyName {
    return  YES;
}
#pragma mark - <JSONModel/>


//- (instancetype)initWithData:(NSData *)data
//{
//    if (self = [super init]) {
//        
//    }
//    return self;
//}

- (instancetype)initWithAttributeDict:(NSDictionary *)attrubuteDict
{
    if (self = [super init]) {
        [self configModelWithDict:attrubuteDict];
    }
    return self;
}



+ (NSString *)createModelAttributesByDictionary:(NSDictionary *)dict
{
    NSMutableString * mStr = [NSMutableString string];
    NSArray * arr = [dict allKeys];
    for (NSInteger i=0; i<arr.count; i++) {
        NSString * strongOrCopy;
        NSString * key = arr[i];
        NSString * className;
        NSString * remark;
        
        id obj = [dict objectForKey:arr[i]];
        switch ([QLBaseModel classNameOfObject:obj]) {
            case NSStringClass:
            {
                className = @"NSString";
                strongOrCopy = @"copy";
                remark = @"";
            }
                break;
            case NSNumberClass:
            {
                className = @"NSNumber";
                strongOrCopy = @"strong";
                remark = @"";
            }
                break;
            case NSArrayClass:
            {
                className = @"NSArray";
                strongOrCopy = @"strong";
                remark = @"//---className";
            }
                break;
            case NSDictionaryClass:
            {
                className = @"NSDictionary";
                strongOrCopy = @"strong";
                remark = @"//---className";
            }
                break;
            case NSNullClass:
            {
                className = @"NSNull";
                strongOrCopy = @"strong";
                remark = @"//---className";
            }
                break;
            case UnknowClass:
            {
                className = @"UnknowClass";
                strongOrCopy = @"strong";
                remark = @"//---className";
            }
                break;
            default:
                break;
        }
        
        [mStr appendString:[NSString stringWithFormat:@"\n@property (nonatomic, %@) %@ * %@;%@", strongOrCopy, className, key, remark]];
        
    }
    NSLog(@"%@", mStr);
    return mStr;
}

- (void)analysisNSNumber
{
    
}


+ (ClassName)classNameOfObject:(id)obj
{
    if ([obj isKindOfClass:[NSString class]]) {
        return NSStringClass;
    }else if ([obj isKindOfClass:[NSArray class]]){
        return NSArrayClass;
    }else if ([obj isKindOfClass:[NSDictionary class]]){
        return NSDictionaryClass;
    }else if ([obj isKindOfClass:[NSNumber class]]){
        return NSNumberClass;
    }else if ([obj isKindOfClass:[NSNull class]]){
        return NSNullClass;
    }else {
        return UnknowClass;
    }
}


//+ (NSString *)classStrOfObject:(id)obj
//{
//    if ([obj isKindOfClass:[NSString class]]) {
//        return @"NSString";
//    }else if ([obj isKindOfClass:[NSArray class]]){
//        return @"NSArray";
//    }else if ([obj isKindOfClass:[NSDictionary class]]){
//        return @"NSDictionary";
//    }else if ([obj isKindOfClass:[NSNumber class]]){
//        return @"NSNumber";
//    }else if ([obj isKindOfClass:[NSNull class]]){
//        return @"NSNull";
//    }else {
//        return @"UnknowClass";
//    }
//}

+ (NSString *)classStrFromClassName:(ClassName)className
{
    switch (className) {
        case NSStringClass:
            return @"NSString";
        case NSArrayClass:
            return @"NSArray";
        case NSDictionaryClass:
            return @"NSDictionary";
        case NSNumberClass:
            return @"NSNumber";
        case NSNullClass:
            return @"NSNull";
        case UnknowClass:
            return @"UnknowClass";
        default:
            break;
    }
    return nil;
}

- (void)configModelWithDict:(NSDictionary *)dict
{
    NSArray * arr = [dict allKeys];
    for (NSString * key in arr) {
        NSObject * obj = [dict objectForKey:key];
        if ([obj isKindOfClass:[NSNull class]]) {
//            [self setNilValueForKey:key];
        }else {
            [self setValue:obj forKey:key];
        }
    }
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
//    NSLog(@"%s", __FUNCTION__);
}

@end
