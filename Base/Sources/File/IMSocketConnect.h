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

@property (nonatomic, strong, nonnull) dispatch_queue_t delegateQueue;
@property (nonatomic, copy, nonnull) NSString *ipAdr;
@property (nonatomic, assign) NSInteger port;



@property (nullable, nonatomic, copy) IMSocketConnectCallBack connectSuccess;
@property (nullable, nonatomic, copy) IMSocketConnectCallBack connectFailure;

@property (nullable, nonatomic, weak) id<IMConnectDelegate> delegate;


//delegateQueue 默认为mainQueue
- (void)connect:(nonnull NSString *)ipAdr port:(NSInteger)port delegateQueue:(nullable dispatch_queue_t)delegateQueue;
- (void)disconnect;
- (void)writeToConnect:(nonnull ConnectDataItem *)item;

//开始发送指定标识符的 dataItem
- (void)beginSendItems:(nonnull NSString *)identifier;

- (void)endAllItems;
- (void)endItems:(nonnull NSString *)identifier;


@end
