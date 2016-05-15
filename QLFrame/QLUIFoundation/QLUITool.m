

#import "QLUITool.h"
#import "sys/sysctl.h"
#pragma mark - <1.QLImage>
@implementation QLImageTool

+ (UIImage *)createImageWithColor:(UIColor *)color size:(CGSize)size;
{
    CGRect rect = CGRectZero;
    rect.size = size;
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

+ (UIImage*)resizeImageToSize:(CGSize)size image:(UIImage*)image
{
    UIGraphicsBeginImageContext(size);
    //获取上下文内容
    CGContextRef ctx= UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(ctx, 0.0, size.height);
    CGContextScaleCTM(ctx, 1.0, -1.0);
    //重绘image
    CGContextDrawImage(ctx,CGRectMake(0.0f, 0.0f, size.width, size.height), image.CGImage);
    //根据指定的size大小得到新的image
    UIImage* scaled= UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaled;
}

+ (UIImage *)imageFromView:(UIView *)view
{
    UIGraphicsBeginImageContext(view.frame.size); //currentView 当前的view
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //从全屏中截取指定的范围
    CGImageRef imageRef = viewImage.CGImage;
    UIImage *sendImage = [[UIImage alloc] initWithCGImage:imageRef];
    return sendImage;
}

/**返回指定视图中指定范围生成的image图片*/
+ (UIImage *)imageFromView:(UIView *)view inRect:(CGRect)rect
{
    UIGraphicsBeginImageContext(view.frame.size); //currentView 当前的view
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //从全屏中截取指定的范围
    CGImageRef imageRef = viewImage.CGImage;
    
    CGImageRef imageRefRect =CGImageCreateWithImageInRect(imageRef, rect);
    UIImage *image = [[UIImage alloc] initWithCGImage:imageRefRect];
    CGImageRelease(imageRefRect);
    return image;
}

+ (void)writeImageToSavedPhotosAlbum:(UIImage *)image
{
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
}

@end


#pragma mark - <2.QLColor>
@implementation QLColorTool

+ (UIColor *)createColorWithR:(NSInteger)red G:(NSInteger)green B:(NSInteger)blue
{
    return [UIColor colorWithRed:(double)red/255.0f green:(double)green/255.0f blue:(double)blue/255.0f alpha:1.0f];
}

+ (UIColor *)createColorWithR:(NSInteger)red G:(NSInteger)green B:(NSInteger)blue alpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:(double)red/255.0f green:(double)green/255.0f blue:(double)blue/255.0f alpha:alpha];
}

@end


#pragma mark - <3.QLDeviceAttribute>
@implementation QLDeviceAttributeTool


+(CGFloat)deviceWidth
{
    return [UIScreen mainScreen].bounds.size.width < [UIScreen mainScreen].bounds.size.height ? [UIScreen mainScreen].bounds.size.width : [UIScreen mainScreen].bounds.size.height;
}

+(CGFloat)deviceHeight
{
    return [UIScreen mainScreen].bounds.size.width > [UIScreen mainScreen].bounds.size.height ? [UIScreen mainScreen].bounds.size.width : [UIScreen mainScreen].bounds.size.height;
}



//获取屏幕宽度
+(CGFloat)currentScreenWidth
{
    return [UIScreen mainScreen].bounds.size.width;
}

//获取屏幕高度
+(CGFloat)currentScreenHeight
{
    return [UIScreen mainScreen].bounds.size.height;
}

//获取屏幕大小
+(CGSize)currentScreenSize{
    return [UIScreen mainScreen].bounds.size;
}
//获取操作系统版本号
+(NSString *)currentVersion{
    return [UIDevice currentDevice].systemVersion;
}
//获取设备型号
+(NSString *)currentModel{
    return [UIDevice currentDevice].model;
}

- (NSString*) doDevicePlatform
{
    size_t size;
    int nR = sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = (char *)malloc(size);
    nR = sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    
    if ([platform isEqualToString:@"iPhone1,1"]) {
        
        platform = @"iPhone";
        
    } else if ([platform isEqualToString:@"iPhone1,2"]) {
        
        platform = @"iPhone 3G";
        
    } else if ([platform isEqualToString:@"iPhone2,1"]) {
        
        platform = @"iPhone 3GS";
        
    } else if ([platform isEqualToString:@"iPhone3,1"]||[platform isEqualToString:@"iPhone3,2"]||[platform isEqualToString:@"iPhone3,3"]) {
        
        platform = @"iPhone 4";
        
    } else if ([platform isEqualToString:@"iPhone4,1"]) {
        
        platform = @"iPhone 4S";
        
    } else if ([platform isEqualToString:@"iPhone5,1"]||[platform isEqualToString:@"iPhone5,2"]) {
        
        platform = @"iPhone 5";
        
    }else if ([platform isEqualToString:@"iPhone5,3"]||[platform isEqualToString:@"iPhone5,4"]) {
        
        platform = @"iPhone 5C";
        
    }else if ([platform isEqualToString:@"iPhone6,2"]||[platform isEqualToString:@"iPhone6,1"]) {
        
        platform = @"iPhone 5S";
        
    }else if ([platform isEqualToString:@"iPod4,1"]) {
        
        platform = @"iPod touch 4";
        
    }else if ([platform isEqualToString:@"iPod5,1"]) {
        
        platform = @"iPod touch 5";
        
    }else if ([platform isEqualToString:@"iPod3,1"]) {
        
        platform = @"iPod touch 3";
        
    }else if ([platform isEqualToString:@"iPod2,1"]) {
        
        platform = @"iPod touch 2";
        
    }else if ([platform isEqualToString:@"iPod1,1"]) {
        
        platform = @"iPod touch";
        
    } else if ([platform isEqualToString:@"iPad3,2"]||[platform isEqualToString:@"iPad3,1"]) {
        
        platform = @"iPad 3";
        
    } else if ([platform isEqualToString:@"iPad2,2"]||[platform isEqualToString:@"iPad2,1"]||[platform isEqualToString:@"iPad2,3"]||[platform isEqualToString:@"iPad2,4"]) {
        
        platform = @"iPad 2";
        
    }else if ([platform isEqualToString:@"iPad1,1"]) {
        
        platform = @"iPad 1";
        
    }else if ([platform isEqualToString:@"iPad2,5"]||[platform isEqualToString:@"iPad2,6"]||[platform isEqualToString:@"iPad2,7"]) {
        
        platform = @"ipad mini";
        
    } else if ([platform isEqualToString:@"iPad3,3"]||[platform isEqualToString:@"iPad3,4"]||[platform isEqualToString:@"iPad3,5"]||[platform isEqualToString:@"iPad3,6"]) {
        
        platform = @"ipad 3";
        
    }
    
    return platform;
}

@end

#pragma mark - <4.QLTableView>
@implementation QLTableViewTool
+ (UITableView *)createTableViewWithFrame:(CGRect)frame viewController:(UIViewController<UITableViewDataSource, UITableViewDelegate> *)vc
{
    vc.automaticallyAdjustsScrollViewInsets = NO;
    return [QLTableViewTool createTableViewWithFrame:frame superView:vc.view delegate:vc];
}


+ (UITableView *)createTableViewWithFrame:(CGRect)frame superView:(UIView *)view delegateViewController:(UIViewController<UITableViewDataSource, UITableViewDelegate> *)delegate;
{
    delegate.automaticallyAdjustsScrollViewInsets = NO;
    return [QLTableViewTool createTableViewWithFrame:frame superView:delegate.view delegate:delegate];
}

+ (UITableView *)createTableViewWithFrame:(CGRect)frame superView:(UIView *)view delegate:(id<UITableViewDataSource, UITableViewDelegate>)delegate
{
    UITableView * tv = [[UITableView  alloc]initWithFrame:frame style:UITableViewStylePlain];
    tv.delegate = delegate;
    tv.dataSource = delegate;
//    tv.separatorStyle = UITableViewCellSeparatorStyleNone;
    [view addSubview:tv];
    return tv;
}

@end

#pragma mark - <5.QLGestureRecognizerTool>
@implementation QLGestureRecognizerTool
+ (void)addGestureInView:(UIView *)view target:(id)target action:(SEL)action
{
    [self addSingleGestureInView:view target:target action:action];
}

+ (UITapGestureRecognizer *)addSingleGestureInView:(UIView *)view target:(id)target action:(SEL)action
{
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:target action:action];
    tapGesture.numberOfTapsRequired = 1;
    tapGesture.numberOfTouchesRequired = 1;
    [view addGestureRecognizer:tapGesture];
    return tapGesture;
}

@end

#pragma mark - <6.QLButtonTool>
@implementation QLButtonTool

+ (UIButton *)createButtonWithBGImageName:(NSString *)bgImageName addTarget:(id)target action:(SEL)action
{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundImage:[UIImage imageNamed:@"bgImageName"] forState:UIControlStateNormal];
    
    return btn;
}

+ (UIButton *)createButtonWithBGImageName:(NSString *)bgImageName addTarget:(id)target action:(SEL)action title:(NSString *)title titleColor:(UIColor *)titleColor
{
    return [self createButtonWithBGImageName:bgImageName addTarget:target action:action title:title titleColor:titleColor isSizeToFit:YES];
}

+ (UIButton *)createButtonWithBGImageName:(NSString *)bgImageName addTarget:(id)target action:(SEL)action title:(NSString *)title titleColor:(UIColor *)titleColor isSizeToFit:(BOOL)isSizeToFit
{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    if (bgImageName) {
        [btn setBackgroundImage:[UIImage imageNamed:bgImageName] forState:UIControlStateNormal];
    }
    
    [btn setTitle:title forState:UIControlStateNormal];
    if (titleColor) {
        [btn setTitleColor:titleColor forState:UIControlStateNormal];
    }else {
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    if (isSizeToFit) {
        [btn sizeToFit];
    }
    return btn;
}

+ (UIButton *)createButtonWithBGImageName:(NSString *)bgImageName addTarget:(id)target action:(SEL)action title:(NSString *)title titleColor:(UIColor *)titleColor superView:(UIView *)superView
{
    UIButton * btn = [self createButtonWithBGImageName:bgImageName addTarget:target action:action title:title titleColor:titleColor];
    [superView addSubview:btn];
    return btn;
}

+ (UIButton *)createButtonWithTitle:(NSString *)title titleColor:(UIColor *)titleColor titleFont:(UIFont *)font addTarget:(id)target action:(SEL)action
{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = font;
    if (titleColor) {
        [btn setTitleColor:titleColor forState:UIControlStateNormal];
    }else {
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    [btn sizeToFit];
    return btn;
}

+ (void)addTarget:(id)target action:(SEL)action onButton:(UIButton *)btn
{
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

+ (UIButton *)createButtonWithBGNormalImageName:(NSString *)bgImageName hightImageName:(NSString *)hightImageName addTarget:(id)target action:(SEL)action isSizeToFit:(BOOL)isSizeToFit
{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    if (bgImageName) {
        [btn setBackgroundImage:[UIImage imageNamed:bgImageName] forState:UIControlStateNormal];
    }
    if (hightImageName) {
        [btn setBackgroundImage:[UIImage imageNamed:hightImageName] forState:UIControlStateHighlighted];
    }
    if (isSizeToFit) {
        [btn sizeToFit];
    }
    return btn;
}

+ (UIButton *)createButtonWithBGNormalImageName:(NSString *)bgImageName selectImageName:(NSString *)selectImageName addTarget:(id)target action:(SEL)action isSizeToFit:(BOOL)isSizeToFit
{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [btn setBackgroundImage:[UIImage imageNamed:bgImageName] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:selectImageName] forState:UIControlStateSelected];
    if (isSizeToFit) {
        [btn sizeToFit];
    }
    return btn;
}

@end
#pragma mark - <7.QLLabelTool>
@implementation QLLabelTool

+ (UILabel *)createLableWithFrame:(CGRect)frame textColor:(UIColor *)textColor textFontOfSize:(CGFloat)size;
{
    UILabel * lab = [[UILabel alloc]initWithFrame:frame];
    if (textColor) {
        lab.textColor = textColor;
    }else {
        lab.textColor = [UIColor blackColor];
    }
    lab.backgroundColor = [UIColor clearColor];
    lab.font = [UIFont systemFontOfSize:size];
    return lab;
}

+ (UILabel *)createLableWithFrame:(CGRect)frame textColor:(UIColor *)textColor font:(UIFont *)font
{
    UILabel * lab = [[UILabel alloc]initWithFrame:frame];
    if (textColor) {
        lab.textColor = textColor;
    }else {
        lab.textColor = [UIColor blackColor];
    }
    lab.backgroundColor = [UIColor clearColor];
    lab.font = font;
    
    return lab;
}

+ (UILabel *)createLableWithTextColor:(UIColor *)textColor textFontOfSize:(CGFloat)size
{
    UILabel * lab = [[UILabel alloc]init];
    if (textColor) {
        lab.textColor = textColor;
    }else {
        lab.textColor = [UIColor blackColor];
    }
    lab.backgroundColor = [UIColor clearColor];
    lab.font = [UIFont systemFontOfSize:size];
    return lab;
}

+ (UILabel *)createLableWithTextColor:(UIColor *)textColor font:(UIFont *)font
{
    UILabel * lab = [[UILabel alloc]init];
    if (textColor) {
        lab.textColor = textColor;
    }else {
        lab.textColor = [UIColor blackColor];
    }
    lab.backgroundColor = [UIColor clearColor];
    lab.font = font;
    
    return lab;
}

@end

#pragma mark - <8.QLLayoutConstraintTool>

@implementation QLLayoutConstraintTool

+ (NSArray *)constraintsWithVisualFormat:(NSString *)format views:(NSDictionary *)views
{
    return [NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:nil views:views];
}

@end

#pragma mark - <9.QLScrollViewTool>

@implementation QLScrollViewTool

+ (UIScrollView *)createScrollView
{
    UIScrollView * sv = [[UIScrollView alloc]init];
    sv.showsHorizontalScrollIndicator = NO;
    sv.showsVerticalScrollIndicator = NO;
    return sv;
}


@end


@implementation QLUITool

/*
- (NSMutableArray*) getPersonInfo{
    
    self.dataArrayDic = [NSMutableArray arrayWithCapacity:0];
    //取得本地通信录名柄
    ABAddressBookRef addressBook;
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0)    {
        addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
        //取得授权状态
        ABAuthorizationStatus authStatus = ABAddressBookGetAuthorizationStatus();
        
        //等待同意后向下执行
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);//发出访问通讯录的请求
        ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error)
                                                 {
                                                     dispatch_semaphore_signal(sema);
                                                 });
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        if (authStatus !=kABAuthorizationStatusAuthorized) {
            return nil;
        }
        //        dispatch_release(sema);
    }else{
        CFErrorRef* error=nil;
        addressBook = ABAddressBookCreateWithOptions(NULL, error);
    }
    //取得本地所有联系人记录
    CFArrayRef results = ABAddressBookCopyArrayOfAllPeople(addressBook);
    for(int i = 0; i < CFArrayGetCount(results); i++)
    {
        ABRecordRef person = CFArrayGetValueAtIndex(results, i);
        ABMultiValueRef tmlphone =  ABRecordCopyValue(person, kABPersonPhoneProperty);
        NSArray * telpArray = CFBridgingRelease(ABMultiValueCopyArrayOfAllValues(tmlphone));
        for (NSInteger index = 0; index < telpArray.count; index++) {
            NSMutableDictionary *dicInfoLocal = [NSMutableDictionary dictionaryWithCapacity:0];
            //读取firstname
            NSString *first = (__bridge NSString*)ABRecordCopyValue(person, kABPersonFirstNameProperty);
            if (first==nil) {
                first = @"";
            }
            [dicInfoLocal setObject:first forKey:@"first"];
            
            NSString *last = (__bridge NSString *)ABRecordCopyValue(person, kABPersonLastNameProperty);
            if (last == nil) {
                last = @"";
            }
            [dicInfoLocal setObject:last forKey:@"last"];
            NSString * telphone = (__bridge NSString *)ABMultiValueCopyValueAtIndex(tmlphone, index);
            if (telphone == nil) {
                telphone = @"";
            }
            [dicInfoLocal setObject:telphone forKey:@"telphone"];
            
            if ([first isEqualToString:@""] == NO || [last isEqualToString:@""] == NO ) {
                if ([telphone isEqualToString:@""] == NO) {
                    [self.dataArrayDic addObject:dicInfoLocal];
                }
                
            }
        }
        CFRelease(tmlphone);
        CFRelease(person);
    }
    CFRelease(results);//new
    //    CFRelease(addressBook);//new
    
    return self.dataArrayDic;
}
*/

/* 预编译 系统选择
 #if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_0
 
 
 #endif
 */

@end
