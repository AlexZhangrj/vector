


#import <Foundation/Foundation.h>
//#import "JSONModel.h"

typedef enum{
    NSStringClass,
    NSArrayClass,
    NSDictionaryClass,
    NSNumberClass,
    NSNullClass,
    UnknowClass
}ClassName;

@interface QLBaseModel : NSObject
//@interface QLBaseModel : JSONModel







/**一般不用  可以先创建model，再初始化数据*/
- (instancetype)initWithAttributeDict:(NSDictionary *)attrubuteDict;

+ (NSString *)createModelAttributesByDictionary:(NSDictionary *)dict;

+ (ClassName)classNameOfObject:(id)obj;

+ (NSString *)classStrFromClassName:(ClassName)className;

/**子类必须重写的方法,可以先创建model，再初始化数据*/
- (void)configModelWithDict:(NSDictionary *)dict;


@end
