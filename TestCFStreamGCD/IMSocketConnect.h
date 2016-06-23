//
//  IMSocketConnect.h

#import <Foundation/Foundation.h>
//#import <IMKit/IMKit-Swift.h>


typedef NS_ENUM(NSUInteger, IMSocketConnectState) {
    disconnect,
    connecting,
    connected,
};

@class IMSocketConnect;
@protocol IMConnectDelegate;
@class ConnectDataItem;

typedef void(^IMSocketConnectCallBack)( IMSocketConnect * _Nonnull IMConnect);

@interface IMSocketConnect : NSObject

@property (nullable, nonatomic, copy) IMSocketConnectCallBack connectSuccess;
@property (nullable, nonatomic, copy) IMSocketConnectCallBack connectFailure;

@property (nullable, nonatomic, weak) id<IMConnectDelegate> delegate;

- (void)connect:(nonnull NSString *)ipAdr port:(NSInteger)port status:(NSInteger)status;
- (void)disconnect;
- (void)writeToConnect:(nonnull ConnectDataItem *)item;


- (void)beginSendItems:(nonnull NSString *)identifier;

- (void)endAllItems;
- (void)endItems:(nonnull NSString *)identifier;


@end


#define IMConnectLog(xx, ...)                      NSLog(@"%s(%d): " xx, __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
