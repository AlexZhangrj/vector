

#import <UIKit/UIKit.h>





static inline UIColor * QLColor16(NSInteger color16)
{
   return [UIColor colorWithRed:((float)((color16 & 0xFF0000) >> 16))/255.0 green:((float)((color16 & 0xFF00) >> 8))/255.0 blue:((float)(color16 & 0xFF))/255.0 alpha:1.0];
}

static inline UIColor * QLColorRGBA(float r, float g, float b, float a)
{
    return [UIColor colorWithRed:r green:g blue:b alpha:a];
}

static inline UIColor * QLColorRGB(float r, float g, float b)
{
    return [UIColor colorWithRed:r green:g blue:b alpha:1.0f];
}

static inline UIColor * QLColor255RGBA(NSInteger r, NSInteger g, NSInteger b, float a)
{
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a];
}

static inline UIColor * QLColor255RGB(NSInteger r, NSInteger g, NSInteger b)
{
    return [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0f];
}

static inline UIColor * QLGrayColorG(NSInteger gray)
{
    return [UIColor colorWithRed:gray/255.0 green:gray/255.0 blue:gray/255.0 alpha:1.0f];
}

static inline UIColor * QLGrayColorGA(NSInteger gray, float a)
{
    return [UIColor colorWithRed:gray/255.0 green:gray/255.0 blue:gray/255.0 alpha:a];
}




static inline  CGPoint QLFrameCenter(CGRect frame)
{
    return CGPointMake(frame.origin.x + frame.size.width/2, frame.origin.y + frame.size.height/2);
}



#pragma mark - <1.QLImage>

@interface QLImageTool : NSObject

/**创建单色image图片*/
+ (UIImage *)createImageWithColor:(UIColor *)color size:(CGSize)size;

//返回特定尺寸的UImage  ,  image参数为原图片，size为要设定的图片大小
/**压缩图片，会失真的压缩，简单的裁剪*/
+ (UIImage*)resizeImageToSize:(CGSize)size image:(UIImage*)image;

/**返回指定view生成的图片*/
+ (UIImage *)imageFromView:(UIView *)view;

/**返回指定视图中指定范围生成的image图片*/
+ (UIImage *)imageFromView:(UIView *)view inRect:(CGRect)rect;

/**把图片写入到手机相册*/
+ (void)writeImageToSavedPhotosAlbum:(UIImage *)image;



@end

#pragma mark - <2.QLColor>
@interface QLColorTool : NSObject

/**RGB值生成颜色 取值范围0-255*/
+ (UIColor *)createColorWithR:(NSInteger)red G:(NSInteger)green B:(NSInteger)blue;

/**RGB值生成颜色 取值范围0-255 alpha透明度*/
+ (UIColor *)createColorWithR:(NSInteger)red G:(NSInteger)green B:(NSInteger)blue alpha:(CGFloat)alpha;


@end


#pragma mark - <3.QLDeviceAttribute>
/**得到设备相关属性的方法*/
@interface QLDeviceAttributeTool : NSObject

/**
 *  获取屏幕宽度
 *
 *  @return 手机屏幕宽度
 */
+(CGFloat)deviceWidth;

+(CGFloat)deviceHeight;

/**
 *  获取屏幕宽度
 *
 *  @return 屏幕宽度
 */
+(CGFloat)currentScreenWidth;


/**
 *  获取屏幕高度
 *
 *  @return 屏幕高度
 */
+(CGFloat)currentScreenHeight;


/**
 *  获取屏幕大小
 *
 *  @return 屏幕大小
 */
+(CGSize)currentScreenSize;


/**
 *  获取操作系统版本号
 *
 *  @return 操作系统版本号
 */
+(NSString *)currentVersion;


/**
 *  获取设备型号
 *
 *  @return 设备型号
 */
+(NSString *)currentModel;


@end

#pragma mark - <4.QLTableView>
@interface QLTableViewTool : NSObject
+ (UITableView *)createTableViewWithFrame:(CGRect)frame viewController:(UIViewController<UITableViewDataSource, UITableViewDelegate> *)vc;

+ (UITableView *)createTableViewWithFrame:(CGRect)frame superView:(UIView *)view delegateViewController:(UIViewController<UITableViewDataSource, UITableViewDelegate> *)delegate;

+ (UITableView *)createTableViewWithFrame:(CGRect)frame superView:(UIView *)view delegate:(id<UITableViewDataSource, UITableViewDelegate>)delegate;
@end

#pragma mark - <5.QLGestureRecognizerTool>
@interface QLGestureRecognizerTool : NSObject

//添加单击手势
+ (UITapGestureRecognizer *)addSingleGestureInView:(UIView *)view target:(id)target action:(SEL)action;


@end

#pragma mark - <6.QLButtonTool>
@interface QLButtonTool : NSObject


+ (UIButton *)createButtonWithBGImageName:(NSString *)bgImageName addTarget:(id)target action:(SEL)action title:(NSString *)title titleColor:(UIColor *)titleColor isSizeToFit:(BOOL)isSizeToFit;

/**根据传入的图片大小生成一个Button*/
+ (UIButton *)createButtonWithBGImageName:(NSString *)bgImageName addTarget:(id)target action:(SEL)action title:(NSString *)title titleColor:(UIColor *)titleColor;

/**根据传入的图片大小生成一个Button, 并添加到父视图上*/
+ (UIButton *)createButtonWithBGImageName:(NSString *)bgImageName addTarget:(id)target action:(SEL)action title:(NSString *)title titleColor:(UIColor *)titleColor superView:(UIView *)superView;

+ (UIButton *)createButtonWithTitle:(NSString *)title titleColor:(UIColor *)titleColor titleFont:(UIFont *)font addTarget:(id)target action:(SEL)action;

+ (void)addTarget:(id)target action:(SEL)action onButton:(UIButton *)btn;

+ (UIButton *)createButtonWithBGNormalImageName:(NSString *)bgImageName hightImageName:(NSString *)hightImageName addTarget:(id)target action:(SEL)action isSizeToFit:(BOOL)isSizeToFit;

+ (UIButton *)createButtonWithBGNormalImageName:(NSString *)bgImageName selectImageName:(NSString *)selectImageName addTarget:(id)target action:(SEL)action isSizeToFit:(BOOL)isSizeToFit;

@end

#pragma mark - <7.QLLabelTool>
@interface QLLabelTool : NSObject

/**
 *  创建lable，设置标题颜色（颜色为nil时，为黑色） 文本字体大小
 *
 *  @param frame     <#frame description#>
 *  @param textColor <#textColor description#>
 *  @param size      <#size description#>
 *
 *  @return lable
 */
+ (UILabel *)createLableWithFrame:(CGRect)frame textColor:(UIColor *)textColor textFontOfSize:(CGFloat)size;

/**
 *  创建lable，设置标题颜色（颜色为nil时，为黑色） 文本字体
 *
 *  @param frame     <#frame description#>
 *  @param textColor textColor description
 *  @param size      <#size description#>
 *
 *  @return lable
 */
+ (UILabel *)createLableWithFrame:(CGRect)frame textColor:(UIColor *)textColor font:(UIFont *)font;


+ (UILabel *)createLableWithTextColor:(UIColor *)textColor textFontOfSize:(CGFloat)size;
+ (UILabel *)createLableWithTextColor:(UIColor *)textColor font:(UIFont *)font;



@end

#pragma mark - <8.QLLayoutConstraintTool>

@interface QLLayoutConstraintTool : NSObject

+ (NSArray *)constraintsWithVisualFormat:(NSString *)format views:(NSDictionary *)views;

@end

#pragma mark - <9.QLScrollViewTool>

@interface QLScrollViewTool : NSObject

+ (UIScrollView *)createScrollView;


@end


@interface QLUITool : NSObject

//- (NSMutableArray*) getPersonInfo;

@end

//#define QLAfter(time, block) {dispatch_time_t afterTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)((time) * NSEC_PER_SEC)); \
//                            dispatch_after(afterTime, dispatch_get_main_queue(), ^(void) block);}

//#define QLShareCodeBlock(objname)       static dispatch_once_t once;\
//                                        dispatch_once(&once, ^{\
//                                            if (objname == nil) {\
//                                                objname = [[[self class] alloc]init];\
//                                            }\
//                                        });
//
//
//#define QLAddTestOnMainQueue(block) dispatch_async(dispatch_get_main_queue(), ^(void) block);


//+ (id)disPatcht
//{
//    static id obj;
//    
//    QLShareCodeBlock(obj);
//    
//    return obj;
//}







/*
 //第一种 每一秒执行一次（重复性）
 double delayInSeconds = 1.0;
 timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0));
 dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC, 0.0);
 dispatch_source_set_event_handler(timer, ^{
 NSLog(@"timer date 1== %@",[NSDate date]);
 });
 dispatch_resume(timer);
 
 //第二种 二秒后执行 （一次性）
 double delayInSeconds = 2.0;
 dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
 dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
 NSLog(@"timer date 2== %@",[NSDate date]);
 });
 
 */
