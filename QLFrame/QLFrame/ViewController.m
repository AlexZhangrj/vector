//
//  ViewController.m
//  QLFrame
//
//  Created by 王青海 on 16/2/17.
//  Copyright © 2016年 王青海. All rights reserved.
//

#import "ViewController.h"

#import "QLFoundation.h"
#import "QLUIFoundation.h"
#import "QLDataPersistence.h"


#import "QLAdress.h"

//#import "QLFileProtoHeader.h"
//#import "QLLogHeaders.h"
//#import "QLFileLoger.h"


@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *textField0;

@property (weak, nonatomic) IBOutlet UITextField *textField1;

@property (weak, nonatomic) IBOutlet UITextField *textField2;

@property (weak, nonatomic) IBOutlet UITextField *textField3;

@property (weak, nonatomic) IBOutlet UITextField *textField4;



@property (weak, nonatomic) UIView *testView;


@property (strong, nonatomic) NSValue *val;

@property (strong, nonatomic) NSPointerArray *array;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIView *view = [[UIView alloc] init];
    [self.view addSubview:view];
    
    self.testView = view;
//
//    self.val = [NSValue valueWithNonretainedObject:view];

    NSPointerArray * array = [NSPointerArray weakObjectsPointerArray];
    [array addPointer:(void *)view];
    self.array = array;
    
    
    [QLHttpRequestAPI request:nil success:^(NSDictionary *responseDict) {
        
    } failure:^(NSError *error) {
        
    }];
    
    NSLog(@"%@", [QLAdress macaddress]);
    NSLog(@"%@", [QLAdress getMacAddress]);

//    NSString * str = @"埃及人家都放假 啊就是发开😕科技😅";
//    NSString * str1 = @"😜";
//
//    
//    BOOL ye = [QLStringAPI stringContainsEmoji:str];
//    
//    NSLog(@"%ld", ye);
//    
//    
//    ye = [QLStringAPI stringIsEmoji:str1];
//    
//    NSLog(@"%ld", ye);
    
//    [QLDataPersistenceAPI initBase];
//    
//    [QLSQLServiceAPI SQLServiceWithIdentifier:QLSQLService_CoreService asyncSqlTask:^(QLSQLService *service) {
//
//        NSDictionary *sdict = @{@"21" : @"1321231"};
//        
//        NSDictionary *dict = @{
//                               @"12314" : @"1241241",
//                               @"////" : @"123//",
//                               @"1234" : sdict
//                               };
//        
//        NSData *data = [ QLDictToJSONStr(dict) dataUsingEncoding:NSUTF8StringEncoding];
//        
//        
////        [service saveStrMessage:@"A3E234" forService:@"sssss1" item:@"sssss1"];
////        
////        
////        NSString *retS1 = [service getStrMessageForService:@"sssss1" item:@"sssss1"];
////        
////        NSLog(@"retS1 %@", retS1);
//
//        [service saveDataMessage:data forService:@"sssss2" item:@"sssss2"];
//        
//        
//        NSDictionary *retS1 = QLJSONToDict([service getDataMessageForService:@"sssss2" item:@"sssss2"]);
//        
//        NSLog(@"retS1 %@", retS1);
//
//        
//    
//        
//        
////        for (NSInteger i=0; i<555; i++) {
////            [service saveMessage:@"21315454" forService:@"1213" item:[NSString stringWithFormat:@"23faf%d", i] saveSuccess:^{
////                
////            } saveFaild:^{
////                
////            }];
////            
////            if (i > 500) {
////                NSLog(@"%d", i);
////            }
////            
////        }
//        
////        [service saveMessage:@"21315454" forService:@"1213" item:@"23141" saveSuccess:^{
////            
////        } saveFaild:^{
////            
////        }];
//        
//        
//    }];
//    
//    
//    [QLLog setOutputOptions:QLLogTypeOptionFile];
//    
//    [[QLFileLogOptions defaultFileLogOptions] addTag:@"1234"];
//    [[QLFileLogOptions defaultFileLogOptions] addTag:@"321"];
//
//    [[QLFileLogOptions defaultFileLogOptions] setOptionsFileNameWithTag:@"1234" fileName:@"1234"];
//    [[QLFileLogOptions defaultFileLogOptions] setOptionsFileNameWithTag:@"321" fileName:@"321"];

    NSLog(@"%@\n\n", NSHomeDirectory());
    

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated./Users/WangQinghai/Library/Developer/CoreSimulator/Devices/190A1482-7680-4DDB-A5C5-14C0AB4D02EA/data/Containers/Data/Application/3F07BF39-52ED-4BE6-9BB5-8651B6156C83/
}



- (IBAction)action00:(id)sender {
    
//    [self downloadFile:nil];
    NSArray *ary = @[@"a3",@"A1",@"a2",@"A10",@"a24",@"A111",@"a2411"];
    
    NSMutableDictionary *mdict = [NSMutableDictionary dictionary];
    
    for (NSString *one in ary) {
        [mdict setObject:one forKey:one];
    }
    
    
    
    NSLog(@"%@",ary);
    NSLog(@"dict : %@", mdict);
    NSArray *myary = [ary sortedArrayUsingComparator:^(NSString * obj1, NSString * obj2){
        return (NSComparisonResult)[obj1 compare:obj2 options:NSForcedOrderingSearch];
    }];
    NSLog(@"%@",myary);
    NSLog(@"%@",[mdict allKeys]);

}

- (IBAction)action01:(id)sender {
    NSMutableData * endData = [NSMutableData data];
    
    uint32_t _log_packet_len = 3;
    
    NSLog(@"%u", _log_packet_len);

    HTONLL(_log_packet_len);

    NSLog(@"%u", _log_packet_len);
//    NTOHLL(1);
    
    [endData appendData:[NSData dataWithBytes:&_log_packet_len length: sizeof(uint32_t)]];
    
    
//    [endData enumerateByteRangesUsingBlock:^(const void * _Nonnull bytes, NSRange byteRange, BOOL * _Nonnull stop) {
//        
//        for (NSInteger i=byteRange.location; i<byteRange.length; i++) {
//            printf("%d : byteRange:(%ld,%ld)\n", (uint64_t)(((char *)bytes)[i]), i, byteRange.length);
//        }
//    }];

    printf("\n");
    
}

- (IBAction)action02:(id)sender {
    char * str = (char *)malloc(15);
    
    
    str[5] = '1';
    
    
    
}

- (IBAction)action03:(id)sender {
//    NSLog(@"%@\n\n", [QLFileLoger logDictsWithWithContentsOfFile:[NSString stringWithFormat:@"%@/%@", NSHomeDirectory(), @"Documents/QLLogs/160302_22_11_48/1234.qllog"]]);
    
    
    
//    [self.testView removeFromSuperview];
//    NSData *data = [@"arejkfadsdkklfa" dataUsingEncoding:NSUTF8StringEncoding];
//    
//    NSData *data1 = [QLFilePacket convertData2FileData:data];
//    
//    NSData *data2 = [QLFilePacket convertFileData2Data:data1];
//    NSLog(@"%@", [[NSString alloc] initWithData:data2 encoding:NSUTF8StringEncoding]);
    
    
}

- (IBAction)action04:(id)sender {
    
    
    for (NSInteger i=0; i<100; i++) {
//        QLOLog(@"1234", @"index : %ld", i);
        
//        QLObjLogMsgFunc(self, QLLogAPI_NowBeijingTime(), QLLogTypeNormol, __FUNCTION__, __LINE__, @"1234", @"index : %ld", i );
        
        
    }
    
    for (NSInteger i=0; i<58; i++) {
//        QLOLog(@"321", @"index : %ld", i);
        
    }

    
    
//    UIView *view = [self.array pointerAtIndex:0];;
//    NSLog(@"%@", view);
//    
//    NSLog(@"%@ %d", self.array, self.array.count);
    
//    [self.val getValue:&view];
    
//    NSLog(@"%@  %@", self.val, view);
}




-(void)downloadFile:(id)sender {
//    [QLHttpRequestAPI GET:@"http://www.xcbobo.com/m/lblist.xml" parameters:nil completionQueue:nil success:^(NSURLSessionDataTask *task, NSData *responseObject) {
//        
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        
//    }];
    
    
    
    return;
    NSURL *URL = [NSURL URLWithString:@"http://www.xcbobo.com/m/lblist.xml"];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDownloadTask *downloadTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"currentThread%@", [NSThread currentThread]);
        NSLog(@"main thread%@", [NSThread mainThread]);

        
        NSLog(@"%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);

    }];
                                              /*
                                              downloadTaskWithRequest:request
                                                            completionHandler:
                                              ^(NSURL *location, NSURLResponse *response, NSError *error) {
                                                  
                                                  
                                                  NSLog(@"%@", [NSThread currentThread]);
                                                  
                                                  // 输出下载文件原来的存放目录
                                                  NSLog(@"%@", location);
                                                  
                                                  // 设置文件的存放目标路径
                                                  NSString *documentsPath = [self getDocumentsPath];
                                                  NSURL *documentsDirectoryURL = [NSURL fileURLWithPath:documentsPath];
                                                  NSURL *fileURL = [documentsDirectoryURL URLByAppendingPathComponent:[[response URL] lastPathComponent]];
                                                  
                                                  // 如果该路径下文件已经存在，就要先将其移除，在移动文件
                                                  NSFileManager *fileManager = [NSFileManager defaultManager];
                                                  if ([fileManager fileExistsAtPath:[fileURL path] isDirectory:NULL]) {
                                                      [fileManager removeItemAtURL:fileURL error:NULL];
                                                  }
                                                  [fileManager moveItemAtURL:location toURL:fileURL error:NULL];
                                                  
                                                  // 在webView中加载图片文件
                                                  NSURLRequest *showImage_request = [NSURLRequest requestWithURL:fileURL];
                                                  [self.webView loadRequest:showImage_request];
                                                  
                                                  [self.spinner stopAnimating];
                                              }];
                                               */
    
    [downloadTask resume];
}


+ (void)tt
{
    [ViewController testRequest:@"http://www.baidu.com" dict:^(NSMutableDictionary *dict) {
        
    } sussess:^{
        
    } faild:^{
        
    }];
}


+ (void)testRequest:(NSString *)url dict:(void(^)(NSMutableDictionary *dict))setDict sussess:(dispatch_block_t)success faild:(dispatch_block_t)faild
{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    
    [dic setObject:@"ios" forKey:@"pra"];
    [dic setObject:@"xxxxxxxx" forKey:@"UDID"];

    if (setDict) {
        setDict(dic);
    }
    
    
    
}


@end
