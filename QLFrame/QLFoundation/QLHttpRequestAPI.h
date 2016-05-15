//
//  QLHttpRequestAPI.h
//  QLTools
//
//  Created by 王青海 on 15/11/26.
//  Copyright © 2015年 王青海. All rights reserved.
//


#import <Foundation/Foundation.h>


static NSString * const QLWebChangeCanReachable2NotReachable = @"QLWebChangeCanReachable2NotReachable";
static NSString * const QLWebChangeNotReachable2CanReachable = @"QLWebChangeNotReachable2CanReachable";

static inline dispatch_queue_t QLGetHttpResultDataHandleQueue()
{
    static dispatch_queue_t ___httpResultDataHandleQueue = NULL;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        if (!___httpResultDataHandleQueue) {
            ___httpResultDataHandleQueue = dispatch_queue_create("com.ql.app.httpResultDataHandleQueue", DISPATCH_QUEUE_SERIAL);
        }
    });
    return ___httpResultDataHandleQueue;
}



@interface QLWebMonitors : NSObject

@property (nonatomic, assign) BOOL canCheckNetwork;

+ (BOOL)webIsOK:(NSError **)error;

//检测web能否正常访问 能正常访问， 则返回yes 否则no
- (BOOL)webIsOK:(NSError **)error;

+ (QLWebMonitors *)share;

@end


static inline void QLAsyncToHttpRequestCallBackQueue(dispatch_block_t block) {
    dispatch_async(QLGetHttpResultDataHandleQueue(), block);
}

static inline void QLSyncToHttpRequestCallBackQueue(dispatch_block_t block) {
    dispatch_sync(QLGetHttpResultDataHandleQueue(), block);
}


@class UIImage;
@class QLHttpRequestModel;

@interface QLHttpRequestAPI : NSObject

//typedef void(^QLHttpResultCallBlock)(NSData *responseData);
typedef void(^QLHttpResultDataCallBlock)(NSData *responseData);
typedef void(^QLHttpResultDictCallBlock)(NSDictionary *responseDict);
typedef void(^QLHttpResultErrorCallBlock)(NSError *error);






+ (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(NSDictionary *)parameters
              completionQueue:(dispatch_queue_t)completionQueue
                 resultToJSON:(BOOL)resultToJSON
                      success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;

+ (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(NSDictionary *)parameters
               completionQueue:(dispatch_queue_t)completionQueue
        acceptableContentTypes:(NSSet *)acceptableContentTypes
                  resultToJSON:(BOOL)resultToJSON
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;



/*
 默认回调到  QLGetHttpResultDataHandleQueue() 队列
 */
+ (NSURLSessionDataTask *)GETData:(NSString *)URLString
                       parameters:(NSDictionary *)parameters
                          success:(QLHttpResultDataCallBlock)success
                          failure:(QLHttpResultErrorCallBlock)failure;

/*
 默认回调到  QLGetHttpResultDataHandleQueue() 队列
 */
+ (NSURLSessionDataTask *)POSTWithDataResult:(NSString *)URLString
                                  parameters:(NSDictionary *)parameters
                                     success:(QLHttpResultDataCallBlock)success
                                     failure:(QLHttpResultErrorCallBlock)failure;




/*
 默认回调到  QLGetHttpResultDataHandleQueue() 队列
 */
+ (NSURLSessionDataTask *)GETJSON:(NSString *)URLString
                       parameters:(NSDictionary *)parameters
                          success:(QLHttpResultDictCallBlock)success
                          failure:(QLHttpResultErrorCallBlock)failure;

/*
 默认回调到  QLGetHttpResultDataHandleQueue() 队列
 */
+ (NSURLSessionDataTask *)POSTWithJSONResult:(NSString *)URLString
                                  parameters:(NSDictionary *)parameters
                                     success:(QLHttpResultDictCallBlock)success
                                     failure:(QLHttpResultErrorCallBlock)failure;





/*------------------------------------------------------------------------------
 默认回调到  QLGetHttpResultDataHandleQueue() 队列
 */
+ (QLHttpRequestModel *)request:(QLHttpRequestModel *)model
                        success:(QLHttpResultDictCallBlock)success
                        failure:(QLHttpResultErrorCallBlock)failure;






typedef void(^DownloadBlock)(id responseObj, NSError *error);
typedef void(^DownloadFinishedBlock)(id responseObj);
typedef void(^DownloadFailedBlock)(NSError *error);
typedef void(^FinallyBlock)();


+ (void)GetWithUrlString:(NSString *)urlString parms:(NSDictionary *)dict finished:(DownloadFinishedBlock)finishedBlock failed:(DownloadFailedBlock)failedBlock;

/**带finally*/
+ (void)GetWithUrlString:(NSString *)urlString parms:(NSDictionary *)dict finished:(DownloadFinishedBlock)finishedBlock failed:(DownloadFailedBlock)failedBlock finally:(FinallyBlock)finally;

+ (void)GetWithUrlString:(NSString *)urlString parms:(NSDictionary *)dict downloadBlock:(DownloadBlock)downloadBlock;


+ (void)afPostWithUrlString:(NSString *)urlString parms:(NSDictionary *)dict finished:(DownloadFinishedBlock)finishedBlock failed:(DownloadFailedBlock)failedBlock;

+ (void)PostWithUrlString:(NSString *)urlString parms:(NSDictionary *)dict downloadBlock:(DownloadBlock)downloadBlock;

+ (void)PostDataWithUrlString:(NSString *)urlString image:(UIImage *)image imageKey:(NSString *)key parms:(NSDictionary *)dict downloadBlock:(DownloadBlock)downloadBlock;

+ (void)PostDataWithUrlString:(NSString *)urlString imageType:(NSString *)type imageData:(NSData *)imageData imageKey:(NSString *)key parms:(NSDictionary *)dict downloadBlock:(DownloadBlock)downloadBlock;

+ (void)PostWWWWithUrlString:(NSString *)urlString parms:(NSDictionary *)dict downloadBlock:(DownloadBlock)downloadBlock;
@end

static inline NSData * QLDictToData(NSDictionary *dict)
{
    if (!dict) {
        return nil;
    }
    
    NSError * parseError;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&parseError];
    return jsonData;
}

static inline NSDictionary * QLJSONToDict(NSData *data)
{
    if (!data) {
        return nil;
    }
    NSError * err;
    NSDictionary * dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err];
    if (err) {
        NSLog(@"%@", err);
    }
    return dict;
}

static inline NSString * QLDictToJSONStr(NSDictionary *dict)
{
    if (!dict) {
        return nil;
    }
    
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
}
















