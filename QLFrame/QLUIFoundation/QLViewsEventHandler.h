

#import <UIKit/UIKit.h>


@interface QLViewsEventHandler : NSObject

@property (nonatomic, strong) UIView * view;
@property (nonatomic, assign) CGRect expectFrame;

- (void)initView;

- (void)createSubViews;

@end
