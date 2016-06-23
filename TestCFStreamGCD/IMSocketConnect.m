//
//  IMSocketConnect.m


#import "IMSocketConnect.h"



#import "TestCFStreamGCD-Swift.h"

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

    *inputStream = (__bridge NSInputStream *)readStream;
    *outputStream = (__bridge NSOutputStream *)writeStream;
    
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


@end


@interface IMSocketConnect(PrivateAPI)

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

-(void)connect:(NSString *)ipAdr port:(NSInteger)port status:(NSInteger)status
{
    IMConnectLog(@"JT im client do :connect ipAdr:%@ port:%ld",ipAdr,(long)port);

    _receiveBuffer = [NSMutableData data];
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
    
    CFReadStreamSetDispatchQueue((__bridge CFReadStreamRef)tempInput, [IM bpQueue]);
    CFWriteStreamSetDispatchQueue((__bridge CFWriteStreamRef)tempOutput, [IM bpQueue]);
    //  打开接收端和输出端
    [_inStream open];
    [_outStream open];
}

-(void)disconnect
{
    IMConnectLog(@"MTalk Client:disconnect");
//    cDataLen = 0;
//    //  清空一些东西
//	_receiveLock = nil;
//	_sendLock = nil;
    //  关掉inStream并移除出runloop
    if(_inStream)
    {
        [_inStream close];
        [_inStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    }
	_inStream = nil;
    //  同inStream
    if (_outStream) {
        [_outStream close];
        [_outStream removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    }
	
	_outStream = nil;
    self.state = DisConnect;
    //  清空一些初始化的东西
	_receiveBuffer = nil;
//	_sendBuffers = nil;
//	_lastSendBuffer = nil;
    
    //  发通知
//    [MTTNotification postNotification:DDNotificationTcpLinkDisconnect userInfo:nil object:nil];
}

-(void)writeToConnect:(nonnull ConnectDataItem *)item
{
    if (item) {
        [self.sendItems addObject:item];
        if (item.timeOut != 0) {
            NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:item.timeOut target:self selector:@selector(timeOutTimerCallBack:) userInfo:item repeats:NO];
            [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
        }
        [self _setNeedWrite];
    }
}

- (void)timeOutTimerCallBack:(NSTimer *)timer
{
    if ([self.sendItems containsObject:timer.userInfo]) {
        ConnectDataItem *item = timer.userInfo;
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
    if (!self.sendingItem) {
        if (Connected == self.state) {
            [self _writeItem];
        }
    }
}

- (void)_writeItem
{
    @try {
        ConnectDataItem *item = self.sendingItem;
        if (item) {    //  如果显式告诉你：没数据在发送
            [item writeDataToBuffer:_outStream];
            [item bufferDataSendSuccess];
            BOOL sendEnd = [item sendEnd];
            if (sendEnd) {
                [item sendSuccess];
                [self.sendItems removeObject:item];
                self.sendingItem = nil;
            }
            return;
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
                }
                return;
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
        
        NSMutableString *mstr = [[NSMutableString alloc] initWithString:@"aherkjhafjdshjkasf"];
        NSString * mstr2 = [NSString stringWithFormat:@"%@", @(arc4random())];
        [mstr appendString:mstr2];
        ConnectDataItem *item = [[ConnectDataItem alloc] initWithData:[mstr2 dataUsingEncoding:NSUTF8StringEncoding]];
        item.itemIdentifier = @"aa";
        [self writeToConnect:item];
        
        [self beginSendItems:@"aa"];
//        [MTTNotification postNotification:DDNotificationTcpLinkConnectComplete userInfo:nil object:nil];
//         [DDClientState shareInstance].userState = DDUserOnline;
    }
}


//可以发送数据了，开始从数据队列中取数据发送
- (void)p_handleEventHasSpaceAvailableStream:(NSStream *)aStream
{
    NSLog(@"p_handleEventHasSpaceAvailableStream");
    
    
    @try {
        if (aStream == _outStream) {
            [self _writeItem];
        }
        //  发送队列中没数据    判断是否有数据
//        if (![self.sendItems count])
//        {
//            IMConnectLog(@"WRITE - No data to send");
//            return;
//        } else    //  发送队列中有数据
//        {
        
            
            //  取出第一个待发数据
//            DDSendBuffer *sendBuffer = [_sendBuffers objectAtIndex:0];
//            //  算长度
//            NSInteger sendBufferLength = [sendBuffer length];
//            //  没长度 类似"" - 去空判断，保证发送的数据有意义  判断是否为空数据
//            if (!sendBufferLength)
//            {
//                if (sendBuffer == _lastSendBuffer)  //  前一个待发数据也没长度 为""
//                {
//                    _lastSendBuffer = nil;  //  置空lastSendBuffer
//                }
//                
//                [_sendBuffers removeObjectAtIndex:0];   //  移除掉第一个待发数据
//                
//                IMConnectLog(@"WRITE - No data to send");
//                
//                _noDataSent = YES;  //  设置状态为『无数据发送』
//                
//                return;
//            }
//            //  有长度 - 正常的可发送数据
//            else
//            {
//                //  不知道sendPos干嘛的，导致不知道这是在干嘛。
//                //  sendPos是在 SendBuffer 的 consumeData:方法被调用后+=consumData.length的
//                //  sendPos是DDSendBuffer的一个属性
//                //  DDSendBuffer初始化的时候默认sendPos为0
//                NSInteger len = ((sendBufferLength - [sendBuffer sendPos] >= 1024) ? 1024 : (sendBufferLength - [sendBuffer sendPos]));
//                if (!len)   //  如果len为0，即，sendBuffer的consumeData方法没被调过   则设定为无数据发送   - 为0代表sendBuffer已经全部发送完毕   判断数据是否发送完毕了
//                {
//                    if (sendBuffer == _lastSendBuffer)
//                    {
//                        _lastSendBuffer = nil;
//                    }
//                    
//                    [_sendBuffers removeObjectAtIndex:0];
//                    
//                    IMConnectLog(@"WRITE - No data to send");
//                    
//                    _noDataSent = YES;
//                    
//                    return;
//                }
//                else    //  数据没发完
//                {
//                    //			IMConnectLog(@"write %ld bytes", len);
//                    //  写一段数据到Stream
//                    len = [_outStream write:((const uint8_t *)[sendBuffer mutableBytes] + [sendBuffer sendPos]) maxLength:len];
//                    IMConnectLog(@"WRITE - Written directly to outStream len:%lid", (long)len);
//                    //  pos += 实际写入的长度
//                    [sendBuffer consumeData:len];
//                    
//                    //  如果senfBuffer发送完毕了
//                    if (![sendBuffer length]) {
//                        if (sendBuffer == _lastSendBuffer)
//                        {
//                            _lastSendBuffer = nil;
//                        }
//                        [_sendBuffers removeObjectAtIndex:0];
//                    }
//                    _noDataSent = NO;
//                    
//                    return;
//                }
//            }
//        }
    }
    @catch (NSException *exception) {
        IMConnectLog(@" ***** NSException in MGJMTalkCleint :%@  ******* ",exception);
    }
}

//socket 断开
- (void)p_handleEventErrorOccurredStream:(NSStream *)aStream
{
    IMConnectLog(@"handle eventErrorOccurred  socket 断开连接");
//    [IMBP async:^{
        __strong id<IMConnectDelegate> strongDelegate = self.delegate;
            [strongDelegate connectErrorOccurred];
//    }];
    
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


//缓冲区数据发送成功
- (void)p_handleEventEndEncounteredStream:(NSStream *)aStream
{
    IMConnectLog(@"handle eventEndEncountered 到了stream的末尾部分");
    if (aStream == _outStream) {
        IMConnectLog(@"handle _setNeedWrite");

        
        
        [self _setNeedWrite];
        
//        ConnectDataItem *item = [self sendingItem];
//        if (item) {
//            [item bufferDataSendSuccess];
//            BOOL sendEnd = [item sendEnd];
//            if (sendEnd) {
//                self.sendingItem = nil;
//                [self.sendItems removeObject:item];
//                [item sendSuccess];
//            }
//        }
    }
}

//  接收到服务端发来的消息了
/*
    PDU通信协议走的是二进制协议——即固定长度的协议头（16个字节） + 协议体方式。协议头包括整个协议包的大小、版本、模块号（moduleid）、命令号(commandid)等。模块号（moduleid）和业务模块对应，commandid对应具体的网络传输命令，这样做的好处是通过包头就可以知道这个包是属于那个业务模块处理的。
 */
/*
    有卵用   还不是传给api分发中心去了
 */
- (void)p_handleEventHasBytesAvailableStream:(NSStream *)aStream
{
   // IMConnectLog(@"handle eventHasBytesAvailable");
    if (aStream) {
        uint8_t buf[1024];  //  给定一个1024大的缓冲区
        NSInteger len = 0;
        len = [(NSInputStream *)aStream read:buf maxLength:1024];   //  读入给定字节数的信息到给定缓冲区中
        
        if (len > 0) {  //  读取到东西了
//            [_receiveLock lock];    //  加锁
            [_receiveBuffer appendBytes:(const void *)buf length:len];  //  添加缓冲区中的东西到 receiveBuffer
            

                
            NSString *str = [[NSString alloc] initWithData:_receiveBuffer encoding:NSUTF8StringEncoding];

            [_receiveBuffer replaceBytesInRange:NSMakeRange(0, _receiveBuffer.length) withBytes:NULL length:0];
            
            NSLog(@"%@", str);
            
            [IM after:3 block:^{
                NSMutableString *mstr = [[NSMutableString alloc] initWithString:@"aherkjhafjdshjkasf"];
                NSString * mstr2 = [NSString stringWithFormat:@"%@", @(arc4random())];
                [mstr appendString:mstr2];
                ConnectDataItem *item = [[ConnectDataItem alloc] initWithData:[mstr dataUsingEncoding:NSUTF8StringEncoding]];
                item.itemIdentifier = @"aa";

                [self writeToConnect:item];
                
                
                
                
            }];
            
        }
        else {
            IMConnectLog(@"No buffer!");
        }
    }
}

+ (void)ttest
{
    
}



@end













