//
//  IMSocketConnect.m


#import "IMSocketConnect.h"
#import "IMConfig.h"
#import "IMBP.h"

//#import "IMDemo-Swift.h"

//#import "NSStream+NSStreamAddition.h"
//#import "DDSendBuffer.h"
//#import "DDTcpProtocolHeader.h"
////#import "DDDispatchTask.h"
#import "DDDataInputStream.h"
//#import "DDDataOutputStream.h"
//#import "DDAPISchedule.h"
//#import "DDClientState.h"
//#import "MTTNotification.h"


#import <IMKit/IMKit-Swift.h>

#define UseGCDSocket 1


typedef NS_ENUM(NSUInteger, SocketConnectState) {
    DisConnect = 0,
    Connecting = 1,
    Connected = 2
};



@interface IMDataItemGroups : NSObject

@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, assign) uint64_t priority;

@property (nonatomic, assign) BOOL canSend;

- (instancetype)initWithIdentifier:(NSString *)identifier;


@end

@implementation IMDataItemGroups

- (instancetype)initWithIdentifier:(NSString *)identifier{
    if (self = [super init]) {
        self.identifier = identifier;
    }
    return self;
}


@end

#if !UseGCDSocket


NSDictionary *loadIMCertificateSettingsWithPeerName(NSString *peer)
{
    NSData *pkcs12data = [[NSData alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"jiuxiu" ofType:@"p12"]];
    CFDataRef inPKCS12Data = (__bridge CFDataRef)pkcs12data;
    
    CFStringRef password = CFSTR("jiuxiu");
    const void *keys[] = { kSecImportExportPassphrase };
    const void *values[] = { password };
    CFDictionaryRef options = CFDictionaryCreate(NULL, keys, values, 1, NULL, NULL);
    
    CFArrayRef items = CFArrayCreate(NULL, 0, 0, NULL);
    
    OSStatus securityError = SecPKCS12Import(inPKCS12Data, options, &items);
    CFRelease(options);
    CFRelease(password);
    
    if(securityError == errSecSuccess)
        NSLog(@"Success opening p12 certificate.");
    
    CFDictionaryRef identityDict = CFArrayGetValueAtIndex(items, 0);
    SecIdentityRef myIdent = (SecIdentityRef)CFDictionaryGetValue(identityDict,kSecImportItemIdentity);
    
    SecIdentityRef  certArray[1] = { myIdent };
    CFArrayRef myCerts = CFArrayCreate(NULL, (void *)certArray, 1, NULL);
    
    NSMutableDictionary *settings = [NSMutableDictionary dictionaryWithCapacity:3];
    [settings setObject:[NSNumber numberWithBool:NO] forKey:(NSString *)kCFStreamSSLValidatesCertificateChain];
    [settings setObject:peer forKey:(NSString *)kCFStreamSSLPeerName];
    [settings setObject:(NSString *)kCFStreamSocketSecurityLevelSSLv3 forKey:(NSString*)kCFStreamSSLLevel];
    [settings setObject:(NSString *)kCFStreamSocketSecurityLevelSSLv3 forKey:(NSString*)kCFStreamPropertySocketSecurityLevel];
    [settings setObject:(__bridge id)myCerts forKey:(NSString *)kCFStreamSSLCertificates];
    [settings setObject:[NSNumber numberWithBool:NO] forKey:(NSString *)kCFStreamSSLIsServer];
    return settings;
}

void getStreamsToHostNamed(NSString *hostName, NSInteger port, NSInputStream **inputStream, NSOutputStream **outputStream)
{
    //  host的引用
    CFHostRef           host;
    //  读取端的stream引用 - CF的Stream
    CFReadStreamRef     readStream;
    //  写入端的stream引用
    CFWriteStreamRef    writeStream;
    
    readStream = NULL;
    writeStream = NULL;
    
    //  通过host创建一个Stream，拿到读端和写端
    host = CFHostCreateWithName(NULL, (__bridge CFStringRef) hostName);
    if (host != NULL) {
        // 创建连接到一个特定主机的特定端口的一对可读写流
        (void) CFStreamCreatePairWithSocketToCFHost(NULL, host, (SInt32)port, &readStream, &writeStream);
        CFRelease(host);
    }
    
    //    NSDictionary *sslSettings = [X509Credential loadIMCertificateSettingsWithPeerName:[NSString stringWithFormat:@"%@:%ld",hostName,(long)port]];
    NSDictionary *sslSettings = loadIMCertificateSettingsWithPeerName([NSString stringWithFormat:@"%@:%ld",hostName,(long)port]);
    
    //  如果没指定inputStream，则释放创建好的readStream，否则把inputStream指向readStream
    if (inputStream == NULL) {
        if (readStream != NULL) {
            CFRelease(readStream);
        }
    } else {
        CFReadStreamSetProperty(readStream, kCFStreamPropertySSLSettings, (__bridge CFTypeRef)(sslSettings));
        //        CFReadStreamSetProperty(readStream, kCFStreamSSLLevel, @"kCFStreamSocketSecurityLevelTLSv1_0SSLv3");
        *inputStream = (__bridge NSInputStream *) readStream;
    }
    //  逻辑同inputStream
    if (outputStream == NULL) {
        if (writeStream != NULL) {
            CFRelease(writeStream);
        }
    } else {
        CFWriteStreamSetProperty(writeStream, kCFStreamPropertySSLSettings, (__bridge CFTypeRef)(sslSettings));
        *outputStream =(__bridge NSOutputStream *) writeStream;
    }
}
//------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

@interface IMSocketConnect ()<NSStreamDelegate>


{
@private
    //  输入流
    NSInputStream *_inStream;
    //  输出流
    NSOutputStream *_outStream;
    
    
    //  接收锁
//    NSLock *_receiveLock;
    //  接收数据缓冲
    NSMutableData *_receiveBuffer;
    //  发送锁
//    NSLock *_sendLock;
    //  发送数据缓冲
//    NSMutableArray *_sendBuffers;
    //  最后的发送缓冲？
//    DDSendBuffer *_lastSendBuffer;
    //  表征当前是否有数据在发送
//    BOOL _noDataSent;
    //  数据长度
//    int32_t cDataLen;
}

@property (nonatomic, strong) NSMutableDictionary *sendItemGroups;

@property (nonatomic, strong) NSMutableArray *sendItems;
@property (nonatomic, strong) ConnectDataItem *sendingItem;


@property (nonatomic, assign) SocketConnectState state;


- (void)p_handleConntectOpenCompletedStream:(NSStream *)aStream;
- (void)p_handleEventErrorOccurredStream:(NSStream *)aStream;
- (void)p_handleEventEndEncounteredStream:(NSStream *)aStream;
- (void)p_handleEventHasBytesAvailableStream:(NSStream *)aStream;
- (void)p_handleEventHasSpaceAvailableStream:(NSStream *)aStream;

@end


@implementation IMSocketConnect

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.sendItemGroups = [NSMutableDictionary dictionary];
        self.sendItems = [NSMutableArray array];
    }
    return self;
}

//+ (instancetype)instance
//{
//    static DDTcpClientManager* g_tcpClientManager;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        g_tcpClientManager = [[DDTcpClientManager alloc] init];
//    });
//    return g_tcpClientManager;
//}

#pragma mark - PublicAPI

- (void)beginSendItems:(nonnull NSString *)identifier
{
    IMDataItemGroups *groupModel = self.sendItemGroups[identifier];
    if (!groupModel) {
        groupModel = [[IMDataItemGroups alloc] initWithIdentifier:identifier];
        self.sendItemGroups[identifier] = groupModel;
    }
    groupModel.canSend = YES;
    [self _setNeedWrite];
}

- (void)endAllItems
{
    NSArray *array = self.sendItemGroups.allValues;
    for (IMDataItemGroups *groupModel in array) {
        groupModel.canSend = NO;
    }
}

- (void)endItems:(nonnull NSString *)identifier
{
    IMDataItemGroups *groupModel = self.sendItemGroups[identifier];
    if (!groupModel) {
        groupModel = [[IMDataItemGroups alloc] initWithIdentifier:identifier];
        self.sendItemGroups[identifier] = groupModel;
    }
    groupModel.canSend = NO;
}

- (void)connect:(nonnull NSString *)ipAdr port:(NSInteger)port delegateQueue:(nullable dispatch_queue_t)delegateQueue;
{
    IMConnectLog(@"im client do :connect ipAdr:%@ port:%ld",ipAdr,(long)port);
    self.ipAdr = ipAdr;
    self.port = port;
    if (delegateQueue) {
        self.delegateQueue = delegateQueue;
    }else {
        self.delegateQueue = dispatch_get_main_queue();
    }
    
    
    //  初始化一些东西
//    cDataLen = 0;   //TODO: 干嘛用的？
    _inStream.delegate = nil;
    _outStream.delegate = nil;
    [_inStream close];
    [_outStream close];
    
    [self.sendItems removeAllObjects];
    
    _receiveBuffer = [NSMutableData data];
//    _sendBuffers = [NSMutableArray array];
//    _noDataSent = NO;   //  表征当前是否有数据在发送
    
//    _receiveLock = [[NSLock alloc] init];
//    _sendLock = [[NSLock alloc] init];
    self.state = Connecting;

    NSInputStream  *tempInput  = nil;
    NSOutputStream *tempOutput = nil;
    
    //  打开一个Stream，规定id地址和端口号，输入端和输出端
//    [NSStream getStreamsToHostNamed:ipAdr port:port inputStream:&tempInput outputStream:&tempOutput];
    getStreamsToHostNamed(ipAdr, port, &tempInput, &tempOutput);
    _inStream  = tempInput;
    _outStream = tempOutput;
    
    //  设置代理
    [_inStream setDelegate:self];
    [_outStream setDelegate:self];
    
    //  添加进runloop中
//    [_inStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
//    [_outStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    
    CFReadStreamSetDispatchQueue((__bridge CFReadStreamRef)_inStream, self.delegateQueue);
    CFWriteStreamSetDispatchQueue((__bridge CFWriteStreamRef)_outStream, self.delegateQueue);
    
    //  打开接收端和输出端
    [_inStream open];
    [_outStream open];
}

-(void)disconnect
{
    IMConnectLog(@"MTalk Client:disconnect");
    if(_inStream)
    {
        [_inStream close];
    }
	_inStream = nil;
    //  同inStream
    if (_outStream) {
        [_outStream close];
    }
	
	_outStream = nil;
    self.state = DisConnect;
    self.sendingItem = nil;
    //  清空一些初始化的东西
	_receiveBuffer = nil;
}

-(void)writeToConnect:(nonnull ConnectDataItem *)item
{
    if (item) {
        [self.sendItems addObject:item];
        if (item.timeOut != 0) {
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(item.timeOut * NSEC_PER_SEC)), self.delegateQueue, ^{
                [self timeOutTimerCallBack:item];
            });
        }
        [self _setNeedWrite];
    }
}

- (void)timeOutTimerCallBack:(ConnectDataItem *)item
{
    if (!item.sending) {
        NSTimeInterval time = [item willTimeOut];
        if (time < 0.2) {
            [item sendFailure];
            [self.sendItems removeObject:item];
            if (self.sendingItem == item) {
                IMConnectLog(@" 一个非常严重的逻辑错误");
                
                self.sendingItem = nil;
                [self _setNeedWrite];
            }
        }else {
            
        }
    }else {
        item.isTimeOut = YES;
    }
}

#pragma mark - NSStream Delegate
//  Stream代理事件
- (void)stream:(NSStream *)aStream handleEvent:(NSStreamEvent)eventCode
{
    switch(eventCode) {
        case NSStreamEventNone:
			IMConnectLog(@"Event type: EventNone");
			break;
        case NSStreamEventOpenCompleted:    //  Stream开启成功，connect方法后调
			[self p_handleConntectOpenCompletedStream:aStream]; //  Stream开启成功，发通知说Tcp连接建立好了，更新ClientState
			break;
		case NSStreamEventHasSpaceAvailable:          //Stream可以写数据了
            [self p_handleEventHasSpaceAvailableStream:aStream];
            break;
		case NSStreamEventErrorOccurred:    //  发生错误了 - 断开连接并下线
			[self p_handleEventErrorOccurredStream:aStream];
			break;
		case NSStreamEventEndEncountered:   //  到了stream的末尾部分 - cDataLen = 0;
			[self p_handleEventEndEncounteredStream:aStream];
			break;
        case NSStreamEventHasBytesAvailable:
            [self p_handleEventHasBytesAvailableStream:aStream];    //  输入缓冲区有内容了（接到服务器推来的消息了）
            break;
    }
}

#pragma mark - PrivateAPI

//- (ConnectDataItem *)sendingItem {
//    return self.sendItems.firstObject;
//}

- (ConnectDataItem *)_suitableItem
{
    for (ConnectDataItem *item in self.sendItems) {
        NSString *identifier = [item identifier];
        IMDataItemGroups *group = self.sendItemGroups[identifier];
        if (group.canSend) {
            return item;
        }
    }
    return nil;
}

- (void)_setNeedWrite
{
//    if (!self.sendingItem) {
        if (Connected == self.state) {
            dispatch_async(self.delegateQueue, ^{
                [self _writeItem];
            });
        }
//    }
}

- (void)_writeItem
{
    IMConnectLog(@"%@", [NSThread currentThread]);
    
    @try {
        while (true) {
            ConnectDataItem *item = self.sendingItem;
            if (item) {    //  如果显式告诉你：没数据在发送
                [item writeDataToBuffer:_outStream];
                [item bufferDataSendSuccess];
                BOOL sendEnd = [item sendEnd];
                if (sendEnd) {
                    [item sendSuccess];
                    [self.sendItems removeObject:item];
                    self.sendingItem = nil;
                }else {
                    break;
                }
            }else {  //  如果没显式告诉你：没数据在发送
                ConnectDataItem *item = [self _suitableItem];
                if (item) {
                    self.sendingItem = item;
                    item.sending = YES;
                    [item writeDataToBuffer:_outStream];
                    [item bufferDataSendSuccess];
                    BOOL sendEnd = [item sendEnd];
                    if (sendEnd) {
                        [item sendSuccess];
                        [self.sendItems removeObject:item];
                        self.sendingItem = nil;
                    }else {
                        break;
                    }
                }else {
                    break;
                }
            }
        }
        
        
    }
    @catch (NSException *exception) {
        IMConnectLog(@" ***** NSException:%@ in writeToSocket of MGJMTalkClient *****",exception);
    }
}

//  Stream开启成功，发通知说Tcp连接建立好了，更新ClientState
- (void)p_handleConntectOpenCompletedStream:(NSStream *)aStream
{
    self.state = Connected;
    
    IMConnectLog(@"handleConntectOpenCompleted");
    if (aStream == _outStream) {
        __strong id<IMConnectDelegate> strongDelegate = self.delegate;
        [strongDelegate connectSuccess];
//        [MTTNotification postNotification:DDNotificationTcpLinkConnectComplete userInfo:nil object:nil];
//         [DDClientState shareInstance].userState = DDUserOnline;
    }
}


//可以发送数据了，开始从数据队列中取数据发送
- (void)p_handleEventHasSpaceAvailableStream:(NSStream *)aStream
{
    @try {
        if (aStream == _outStream) {
            [self _writeItem];
        }
    }
    @catch (NSException *exception) {
        IMConnectLog(@" ***** NSException in MGJMTalkCleint :%@  ******* ",exception);
    }
}

//socket 断开
- (void)p_handleEventErrorOccurredStream:(NSStream *)aStream
{
    IMConnectLog(@"handle eventErrorOccurred  socket 断开连接 %@", [aStream.streamError localizedDescription]);
    __strong id<IMConnectDelegate> strongDelegate = self.delegate;
    [strongDelegate connectErrorOccurred];
    
    if (self.sendingItem) {
        self.sendingItem.sending = NO;
        self.sendingItem.alreadySendLen = 0;
        if (self.sendingItem.isTimeOut) {
            [self.sendingItem sendFailure];
            [self.sendItems removeObject:self.sendingItem];
            self.sendingItem = nil;
        }
    }
    self.state = DisConnect;
    [self disconnect];
//    [DDClientState shareInstance].userState = DDUserOffLine;
}


//服务器关闭socket
- (void)p_handleEventEndEncounteredStream:(NSStream *)aStream
{
    IMConnectLog(@"handle eventEndEncountered 到了stream的末尾部分");
    
    self.state = DisConnect;
    
    [self disconnect];
    __strong id<IMConnectDelegate> strongDelegate = self.delegate;
    [strongDelegate connectClosed];
    
    if (aStream == _outStream) {
        IMConnectLog(@"handle _setNeedWrite");
        
//        [self _setNeedWrite];
        
    }
}

//  接收到服务端发来的消息了
/*
    PDU通信协议走的是二进制协议——即固定长度的协议头（16个字节） + 协议体方式。协议头包括整个协议包的大小、版本、模块号（moduleid）、命令号(commandid)等。模块号（moduleid）和业务模块对应，commandid对应具体的网络传输命令，这样做的好处是通过包头就可以知道这个包是属于那个业务模块处理的。
 */
- (void)p_handleEventHasBytesAvailableStream:(NSStream *)aStream
{
    IMConnectLog(@"handle eventHasBytesAvailable");
    if (aStream) {
        uint8_t buf[1024];  //  给定一个1024大的缓冲区
        NSInteger len = 0;

        
        while(YES) {
            len = [(NSInputStream *)aStream read:buf maxLength:1024];   //  读入给定字节数的信息到给定缓冲区中
            if (len > 0) {
                [_receiveBuffer appendBytes:(const void *)buf length:len];  //  添加缓冲区中的东西到 receiveBuffer
            }else {
                break;
            }
            if (len != 1024) {
                break;
            }
        }
        IMConnectLog(@"readdata   %@: bufferlen: %ld", aStream, _receiveBuffer.length);

        
        
        while ([_receiveBuffer length] >= 16) { //  截取16个字节的PDU协议头拆包分析
            NSRange range = NSMakeRange(0, 16);
            NSData *headerData = [_receiveBuffer subdataWithRange:range];    // 取出PDU协议头
            
            DDDataInputStream *inputData = [DDDataInputStream dataInputStreamWithData:headerData];  //  使用headerData创建一个DataInputStream
            
            //  PDU通信协议
            uint32_t pduLen = [inputData readInt];  //  读取接收到数据的int值
            if (pduLen > (uint32_t)[_receiveBuffer length]) //  数据验全
            {
                IMConnectLog(@"not enough data received");
                break;
            }
            
            //  创建一个Tcp协议头
            IMProtocolHeader* tcpHeader = [[IMProtocolHeader alloc] init];
            //  依次从UDP协议头中读取版本号、flag、服务器号、命令号、reserved、error
            tcpHeader.version = [inputData readShort];
            tcpHeader.flag = [inputData readShort];
            tcpHeader.serviceId = [inputData readShort];
            tcpHeader.commandId = [inputData readShort];
            tcpHeader.reserved = [inputData readShort];
            tcpHeader.error = [inputData readShort];
            
            IMConnectLog(@"receive a packet serviceId=%d, commandId=%d", tcpHeader.serviceId, tcpHeader.commandId);
            
            //  拿到协议体数据
            range = NSMakeRange(16, pduLen - 16);
            NSData *payloadData = [_receiveBuffer subdataWithRange:range];  //  payload:装载量
            //  这俩data感觉没区别啊
            uint32_t remainLen = (int)[_receiveBuffer length] - pduLen; //  remain:逗留
            range = NSMakeRange(pduLen, remainLen);
            NSData *remainData = [_receiveBuffer subdataWithRange:range];
            //  把协议体数据放进receiveBuffer中
            [_receiveBuffer setData:remainData];
            //                //  将取出来的协议头生成一个结构体
            //                ServerDataType dataType = DDMakeServerDataType(tcpHeader.serviceId, tcpHeader.commandId, tcpHeader.reserved);
            
            //  如果有协议体 -> 不是一个简单的心跳包 ->同过DDAPISchedule分发任务
            if (payloadData.length > 0) {
                //                    [[DDAPISchedule instance] receiveServerData:payloadData forDataType:dataType];
            }else {
                payloadData = nil;
            }
            
            __strong id<IMConnectDelegate> strongDelegate = self.delegate;
            if (strongDelegate) {
                [strongDelegate receiveServerData:payloadData header:tcpHeader];
            }
        }
    }
}

@end

#else

#import "GCDAsyncSocket.h"

@interface IMSocketConnect ()

{
@private
    NSMutableData *_receiveBuffer;
}

@property (nonatomic, strong) NSMutableDictionary *sendItemGroups;

@property (nonatomic, strong) NSMutableArray *sendItems;
@property (nonatomic, strong) ConnectDataItem *sendingItem;


@property (nonatomic, strong) GCDAsyncSocket *asyncSocket;

@property (nonatomic, assign) SocketConnectState state;
@property (nonatomic, assign) long writeTag;


@end

NSDictionary *loadGCDSocketCertificateSettingsWithPeerName(NSString *peer, NSData *pkcs12data)
{
    CFDataRef inPKCS12Data = (__bridge CFDataRef)pkcs12data;
    
    CFStringRef password = CFSTR("jiuxiu");
    const void *keys[] = { kSecImportExportPassphrase };
    const void *values[] = { password };
    CFDictionaryRef options = CFDictionaryCreate(NULL, keys, values, 1, NULL, NULL);
    
    CFArrayRef items = CFArrayCreate(NULL, 0, 0, NULL);
    
    OSStatus securityError = SecPKCS12Import(inPKCS12Data, options, &items);
    CFRelease(options);
    CFRelease(password);
    
    if(securityError == errSecSuccess)
        NSLog(@"Success opening p12 certificate.");
    
    CFDictionaryRef identityDict = CFArrayGetValueAtIndex(items, 0);
    SecIdentityRef myIdent = (SecIdentityRef)CFDictionaryGetValue(identityDict,kSecImportItemIdentity);
    
    SecIdentityRef  certArray[1] = { myIdent };
    CFArrayRef myCerts = CFArrayCreate(NULL, (void *)certArray, 1, NULL);
    
    NSMutableDictionary *settings = [NSMutableDictionary dictionaryWithCapacity:3];
    [settings setObject:peer forKey:(NSString *)kCFStreamSSLPeerName];
    //    [settings setObject:(NSString *)kCFStreamSocketSecurityLevelSSLv3 forKey:(NSString*)kCFStreamSSLLevel];
    [settings setObject:(NSString *)kCFStreamSocketSecurityLevelSSLv3 forKey:(NSString*)kCFStreamPropertySocketSecurityLevel];
    [settings setObject:(__bridge id)myCerts forKey:(NSString *)kCFStreamSSLCertificates];
    [settings setObject:[NSNumber numberWithBool:NO] forKey:(NSString *)kCFStreamSSLIsServer];
    
    
    //    kSSLProtocolUnknown = 0,                /* no protocol negotiated/specified; use default */
    //    kSSLProtocol3       = 2,				/* SSL 3.0 */
    //    kTLSProtocol1       = 4,				/* TLS 1.0 */
    //    kTLSProtocol11      = 7,				/* TLS 1.1 */
    //    kTLSProtocol12      = 8,				/* TLS 1.2 */
    //    kDTLSProtocol1      = 9,                /* DTLS 1.0 */
    //
    //    /* DEPRECATED on iOS */
    //    kSSLProtocol2       = 1,				/* SSL 2.0 */
    //    kSSLProtocol3Only   = 3,                /* SSL 3.0 Only */
    //    kTLSProtocol1Only   = 5,                /* TLS 1.0 Only */
    //    kSSLProtocolAll     = 6,                /* All TLS supported protocols */
    
    //
    //    *		kSSLProtocol3
    //    * 		kTLSProtocol1
    //    * 		kTLSProtocol11
    //    * 		kTLSProtocol12
    [settings setObject:[NSNumber numberWithInteger:2] forKey:GCDAsyncSocketSSLProtocolVersionMin];
    
    //    * For TLS contexts, legal values for minVersion are :
    //        *		kSSLProtocol3
    //        * 		kTLSProtocol1
    //        * 		kTLSProtocol11
    //        * 		kTLSProtocol12
    //        *
    //        * For DTLS contexts, legal values for minVersion are :
    //            *      kDTLSProtocol1
    [settings setObject:[NSNumber numberWithInteger:4] forKey:GCDAsyncSocketSSLProtocolVersionMax];
    
    settings[(NSString *)kCFStreamSSLValidatesCertificateChain]	= [NSNumber numberWithBool:NO];
    settings[GCDAsyncSocketUseCFStreamForTLS] = [NSNumber numberWithBool:YES];
    return settings;
}

@implementation IMSocketConnect


- (void)connect:(nonnull NSString *)ipAdr port:(NSInteger)port delegateQueue:(nullable dispatch_queue_t)delegateQueue {
    IMConnectLog(@"im client do :connect ipAdr:%@ port:%ld",ipAdr,(long)port);
    
    [self.sendItems removeAllObjects];
    _receiveBuffer = [NSMutableData data];
    self.state = Connecting;
    
    self.ipAdr = ipAdr;
    self.port = port;
    if (delegateQueue) {
        self.delegateQueue = delegateQueue;
    }else {
        self.delegateQueue = dispatch_get_main_queue();
    }
    [self.asyncSocket disconnect];
    self.asyncSocket = nil;
    self.asyncSocket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:self.delegateQueue];
    
    NSError *error = nil;
    if (![self.asyncSocket connectToHost:ipAdr onPort:port error:&error])
    {
        dispatch_async(self.delegateQueue, ^{
            self.state = DisConnect;
            [self.delegate connectFailure:error];
        });
    }
}


#pragma mark Socket Delegate
//连接成功
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(UInt16)port
{
    IMConnectLog(@"socket:%p didConnectToHost:%@ port:%hu", sock, host, port);
    
//#if USE_SECURE_CONNECTION
//    {
//        // Connected to secure server (HTTPS)
//        
//#if ENABLE_BACKGROUNDING && !TARGET_IPHONE_SIMULATOR
//        {
//            // Backgrounding doesn't seem to be supported on the simulator yet
//            
//            [sock performBlock:^{
//                if ([sock enableBackgroundingOnSocket])
//                    DDLogInfo(@"Enabled backgrounding on socket");
//                else
//                    DDLogWarn(@"Enabling backgrounding failed!");
//            }];
//        }
//#endif
//        NSDictionary *sslSettings = loadIMCertificateSettingsWithPeerName([NSString stringWithFormat:@"%@:%ld",host,(long)port]);
        NSDictionary *sslSettings = loadGCDSocketCertificateSettingsWithPeerName([NSString stringWithFormat:@"%@:%ld",host,(long)port], [[NSData alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"jiuxiu" ofType:@"p12"]]);
        
        // Configure SSL/TLS settings
        //		NSMutableDictionary *settings = [NSMutableDictionary dictionaryWithCapacity:3];
        
        // If you simply want to ensure that the remote host's certificate is valid,
        // then you can use an empty dictionary.
        
        // If you know the name of the remote host, then you should specify the name here.
        //
        // NOTE:
        // You should understand the security implications if you do not specify the peer name.
        // Please see the documentation for the startTLS method in GCDAsyncSocket.h for a full discussion.
        
        // To connect to a test server, with a self-signed certificate, use settings similar to this:
        
        //	// Allow expired certificates
        //	[settings setObject:[NSNumber numberWithBool:YES]
        //				 forKey:(NSString *)kCFStreamSSLAllowsExpiredCertificates];
        //
        //	// Allow self-signed certificates
        //	[settings setObject:[NSNumber numberWithBool:YES]
        //				 forKey:(NSString *)kCFStreamSSLAllowsAnyRoot];
        //
        //	// In fact, don't even validate the certificate chain
        //	[settings setObject:[NSNumber numberWithBool:NO]
        //				 forKey:(NSString *)kCFStreamSSLValidatesCertificateChain];
        
        IMConnectLog(@"----- Starting TLS with settings:\n");
        
        [sock startTLS:sslSettings];
        
        // You can also pass nil to the startTLS method, which is the same as passing an empty dictionary.
        // Again, you should understand the security implications of doing so.
        // Please see the documentation for the startTLS method in GCDAsyncSocket.h for a full discussion.
//    }
//#else
//    {
//        // Connected to normal server (HTTP)
//        
//#if ENABLE_BACKGROUNDING && !TARGET_IPHONE_SIMULATOR
//        {
//            // Backgrounding doesn't seem to be supported on the simulator yet
//            
//            [sock performBlock:^{
//                if ([sock enableBackgroundingOnSocket])
//                    DDLogInfo(@"Enabled backgrounding on socket");
//                else
//                    DDLogWarn(@"Enabling backgrounding failed!");
//            }];
//        }
//#endif
//    }
//#endif
}


//ssl握手成功
- (void)socketDidSecure:(GCDAsyncSocket *)sock
{
    IMConnectLog(@"--------socketDidSecure:%p", sock);
    self.state = Connected;
    
//    IMBP after
//    [IMBP async:^{
//        [self.delegate connectSuccess];
//        [self _setNeedWrite];
//    }];
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), self.delegateQueue, ^{
        [self.delegate connectSuccess];
        [self _setNeedWrite];
//    });
    [sock readDataWithTimeout:-1 tag:0];
}

//WriteData成功的回调
- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag
{
    IMConnectLog(@"socket:%p didWriteDataWithTag:%ld", sock, tag);
}

//readdata回调
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    IMConnectLog(@"socket:%p didReadData:withTag:%ld", sock, tag);
    [_receiveBuffer appendData:data];
    while ([_receiveBuffer length] >= 16) { //  截取16个字节的PDU协议头拆包分析
        NSRange range = NSMakeRange(0, 16);
        NSData *headerData = [_receiveBuffer subdataWithRange:range];    // 取出PDU协议头
        
        DDDataInputStream *inputData = [DDDataInputStream dataInputStreamWithData:headerData];  //  使用headerData创建一个DataInputStream
        
        //  PDU通信协议
        uint32_t pduLen = [inputData readInt];  //  读取接收到数据的int值
        if (pduLen > (uint32_t)[_receiveBuffer length]) //  数据验全
        {
            IMConnectLog(@"not enough data received");
            break;
        }
        
        //  创建一个Tcp协议头
        IMProtocolHeader* tcpHeader = [[IMProtocolHeader alloc] init];
        //  依次从UDP协议头中读取版本号、flag、服务器号、命令号、reserved、error
        tcpHeader.version = [inputData readShort];
        tcpHeader.flag = [inputData readShort];
        tcpHeader.serviceId = [inputData readShort];
        tcpHeader.commandId = [inputData readShort];
        tcpHeader.reserved = [inputData readShort];
        tcpHeader.error = [inputData readShort];
        
        IMConnectLog(@"receive a packet serviceId=%d, commandId=%d", tcpHeader.serviceId, tcpHeader.commandId);
        
        //  拿到协议体数据
        range = NSMakeRange(16, pduLen - 16);
        NSData *payloadData = [_receiveBuffer subdataWithRange:range];  //  payload:装载量
        //  这俩data感觉没区别啊
        uint32_t remainLen = (int)[_receiveBuffer length] - pduLen; //  remain:逗留
        range = NSMakeRange(pduLen, remainLen);
        NSData *remainData = [_receiveBuffer subdataWithRange:range];
        //  把协议体数据放进receiveBuffer中
        [_receiveBuffer setData:remainData];
        //                //  将取出来的协议头生成一个结构体
        //                ServerDataType dataType = DDMakeServerDataType(tcpHeader.serviceId, tcpHeader.commandId, tcpHeader.reserved);
        
        //  如果有协议体 -> 不是一个简单的心跳包 ->同过DDAPISchedule分发任务
        if (payloadData.length > 0) {
            //                    [[DDAPISchedule instance] receiveServerData:payloadData forDataType:dataType];
        }else {
            payloadData = nil;
        }
        
        __strong id<IMConnectDelegate> strongDelegate = self.delegate;
        if (strongDelegate) {
            [strongDelegate receiveServerData:payloadData header:tcpHeader];
        }
    }
    [sock readDataWithTimeout:-1 tag:0];
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    IMConnectLog(@"socketDidDisconnect:%p withError: %@", sock, err);
    
    __strong id<IMConnectDelegate> strongDelegate = self.delegate;
    [strongDelegate connectErrorOccurred];
    
    if (self.sendingItem) {
        self.sendingItem.sending = NO;
        self.sendingItem.alreadySendLen = 0;
        if (self.sendingItem.isTimeOut) {
            [self.sendingItem sendFailure];
            [self.sendItems removeObject:self.sendingItem];
            self.sendingItem = nil;
        }
    }
    self.state = DisConnect;
    [self disconnect];
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.sendItemGroups = [NSMutableDictionary dictionary];
        self.sendItems = [NSMutableArray array];
    }
    return self;
}


#pragma mark - PublicAPI
- (void)beginSendItems:(nonnull NSString *)identifier
{
    IMDataItemGroups *groupModel = self.sendItemGroups[identifier];
    if (!groupModel) {
        groupModel = [[IMDataItemGroups alloc] initWithIdentifier:identifier];
        self.sendItemGroups[identifier] = groupModel;
    }
    groupModel.canSend = YES;
    [self _setNeedWrite];
}

- (void)endAllItems
{
    NSArray *array = self.sendItemGroups.allValues;
    for (IMDataItemGroups *groupModel in array) {
        groupModel.canSend = NO;
    }
}

- (void)endItems:(nonnull NSString *)identifier
{
    IMDataItemGroups *groupModel = self.sendItemGroups[identifier];
    if (!groupModel) {
        groupModel = [[IMDataItemGroups alloc] initWithIdentifier:identifier];
        self.sendItemGroups[identifier] = groupModel;
    }
    groupModel.canSend = NO;
}


-(void)disconnect
{
    IMConnectLog(@"MTalk Client:disconnect");
    self.state = DisConnect;
    self.sendingItem = nil;
    [self.asyncSocket disconnect];
    //  清空一些初始化的东西
    _receiveBuffer = nil;
}

-(void)writeToConnect:(nonnull ConnectDataItem *)item
{
    if (item) {
        [self.sendItems addObject:item];
        if (item.timeOut != 0) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(item.timeOut * NSEC_PER_SEC)), self.delegateQueue, ^{
                [self timeOutTimerCallBack:item];
            });
        }
        [self _setNeedWrite];
    }
}

- (void)timeOutTimerCallBack:(ConnectDataItem *)item
{
    if (!item.sending) {
        NSTimeInterval time = [item willTimeOut];
        if (time < 0.2) {
            [item sendFailure];
            [self.sendItems removeObject:item];
            if (self.sendingItem == item) {
                IMConnectLog(@" 一个非常严重的逻辑错误");
                self.sendingItem = nil;
                [self _setNeedWrite];
            }
        }else {
            
        }
    }else {
        item.isTimeOut = YES;
    }
}

#pragma mark - PrivateAPI

//- (ConnectDataItem *)sendingItem {
//    return self.sendItems.firstObject;
//}

- (ConnectDataItem *)_suitableItem
{
    for (ConnectDataItem *item in self.sendItems) {
        NSString *identifier = [item identifier];
        IMDataItemGroups *group = self.sendItemGroups[identifier];
        if (group.canSend) {
            return item;
        }
    }
    return nil;
}

- (void)_setNeedWrite
{
    //    if (!self.sendingItem) {
    if (Connected == self.state) {
        dispatch_async(self.delegateQueue, ^{
            [self _writeItem];
        });
    }
    //    }
}

- (void)_writeItem
{
    IMConnectLog(@"%@", [NSThread currentThread]);
    
    @try {
        while (true) {
            ConnectDataItem *item = self.sendingItem;
            if (item) {    //  如果显式告诉你：没数据在发送
                [self.asyncSocket writeData:item.data withTimeout:-1 tag:++self.writeTag];
                
                IMConnectLog(@"%@   writeData len:%ld   tag:%ld", [NSThread currentThread], item.data.length, self.writeTag);
                
                item.alreadySendLen = item.data.length;
                [item bufferDataSendSuccess];
                BOOL sendEnd = [item sendEnd];
                if (sendEnd) {
                    [item sendSuccess];
                    [self.sendItems removeObject:item];
                    self.sendingItem = nil;
                }else {
                    break;
                }
            }else {  //  如果没显式告诉你：没数据在发送
                ConnectDataItem *item = [self _suitableItem];
                if (item) {
                    self.sendingItem = item;
                    item.sending = YES;
                    [self.asyncSocket writeData:item.data withTimeout:-1 tag: ++self.writeTag];
                    IMConnectLog(@"%@   writeData len:%ld   tag:%ld", [NSThread currentThread], item.data.length, self.writeTag);
                    item.alreadySendLen = item.data.length;
                    [item bufferDataSendSuccess];
                    BOOL sendEnd = [item sendEnd];
                    if (sendEnd) {
                        [item sendSuccess];
                        [self.sendItems removeObject:item];
                        self.sendingItem = nil;
                    }else {
                        break;
                    }
                }else {
                    break;
                }
            }
        }
    }
    @catch (NSException *exception) {
        IMConnectLog(@" ***** NSException:%@ in writeToSocket of MGJMTalkClient *****",exception);
    }
}
//socket 断开
- (void)p_handleEventErrorOccurredStream:(NSStream *)aStream
{
    IMConnectLog(@"handle eventErrorOccurred  socket 断开连接 %@", [aStream.streamError localizedDescription]);
    __strong id<IMConnectDelegate> strongDelegate = self.delegate;
    [strongDelegate connectErrorOccurred];
    
    if (self.sendingItem) {
        self.sendingItem.sending = NO;
        self.sendingItem.alreadySendLen = 0;
        if (self.sendingItem.isTimeOut) {
            [self.sendingItem sendFailure];
            [self.sendItems removeObject:self.sendingItem];
            self.sendingItem = nil;
        }
    }
    self.state = DisConnect;
    [self disconnect];
    //    [DDClientState shareInstance].userState = DDUserOffLine;
}




@end


#endif






