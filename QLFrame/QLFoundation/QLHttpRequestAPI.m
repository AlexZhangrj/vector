//
//  QLHttpRequestAPI.m
//  QLTools
//
//  Created by 王青海 on 15/11/26.
//  Copyright © 2015年 王青海. All rights reserved.
//


#import "QLHttpRequestAPI.h"
#import "AFNetworking.h"
#import <UIKit/UIKit.h>

#import "QLHttpRequestModel.h"



@interface QLWebMonitors ()

@property (nonatomic, assign) AFNetworkReachabilityStatus status;

@end
@implementation QLWebMonitors

static QLWebMonitors * __shared = nil;

- (void)setStatus:(AFNetworkReachabilityStatus)status
{
    if (status != _status) {
        if ((status == AFNetworkReachabilityStatusNotReachable || status == AFNetworkReachabilityStatusUnknown) && (_status == AFNetworkReachabilityStatusReachableViaWiFi || _status == AFNetworkReachabilityStatusReachableViaWWAN)) {
            dispatch_async(dispatch_get_main_queue(), ^{
                @autoreleasepool {
                    [[NSNotificationCenter defaultCenter]postNotificationName:QLWebChangeCanReachable2NotReachable object:nil];
                }
            });
        }else if ((_status == AFNetworkReachabilityStatusNotReachable || _status == AFNetworkReachabilityStatusUnknown) && (status == AFNetworkReachabilityStatusReachableViaWiFi || status == AFNetworkReachabilityStatusReachableViaWWAN)) {
            dispatch_async(dispatch_get_main_queue(), ^{
                @autoreleasepool {
                    [[NSNotificationCenter defaultCenter]postNotificationName:QLWebChangeNotReachable2CanReachable object:nil];
                }
            });
        }
        _status = status;
    }
    
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
        [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            self.canCheckNetwork = YES;
            self.status = status;
        }];
    }
    return self;
}

+ (BOOL)webIsOK:(NSError **)error
{
    return [[QLWebMonitors share]webIsOK:error];
}


- (BOOL)webIsOK:(NSError **)error
{
    if ([[AFNetworkReachabilityManager sharedManager] isReachable] == NO && self.canCheckNetwork == YES) {
        *error = [NSError errorWithDomain:@"网络错误" code:100 userInfo:nil];
        return NO;
    }else {
        *error = nil;
        return YES;
    }
}

+ (QLWebMonitors *)share
{
    @synchronized(self) {
        if (!__shared) {
            __shared = [[QLWebMonitors alloc]init];
        }
    }
    return __shared;
}

@end


@implementation QLHttpRequestAPI

static NSString * QLHttpRequestAcceptableContentTypeJSON = @"application/json";
static NSString * QLHttpRequestAcceptableContentTypeStr = @"text/html";

+ (NSURLSessionDataTask *)GET:(NSString *)URLString
                   parameters:(NSDictionary *)parameters
                completionQueue:(dispatch_queue_t)completionQueue
                 resultToJSON:(BOOL)resultToJSON
                      success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                      failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.completionQueue = completionQueue;
    if (!resultToJSON) {
        manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    }
    
    return [manager GET:URLString parameters:parameters success:success failure:failure];
}

+ (NSURLSessionDataTask *)POST:(NSString *)URLString
                    parameters:(NSDictionary *)parameters
               completionQueue:(dispatch_queue_t)completionQueue
        acceptableContentTypes:(NSSet *)acceptableContentTypes
                  resultToJSON:(BOOL)resultToJSON
                       success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                       failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure
{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.completionQueue = completionQueue;
    if (!resultToJSON) {
        manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    }
    manager.responseSerializer.acceptableContentTypes = acceptableContentTypes;

    return [manager POST:URLString parameters:parameters success:success failure:failure];
}


/*
 默认回调到  QLGetHttpResultDataHandleQueue() 队列
 */
+ (NSURLSessionDataTask *)GETData:(NSString *)URLString
                       parameters:(NSDictionary *)parameters
                          success:(QLHttpResultDataCallBlock)success
                          failure:(QLHttpResultErrorCallBlock)failure
{
    return [QLHttpRequestAPI GET:URLString parameters:parameters completionQueue:QLGetHttpResultDataHandleQueue() resultToJSON:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

/*
 默认回调到  QLGetHttpResultDataHandleQueue() 队列
 */
+ (NSURLSessionDataTask *)POSTWithDataResult:(NSString *)URLString
                                  parameters:(NSDictionary *)parameters
                                     success:(QLHttpResultDataCallBlock)success
                                     failure:(QLHttpResultErrorCallBlock)failure
{
    return [QLHttpRequestAPI POST:URLString parameters:parameters completionQueue:QLGetHttpResultDataHandleQueue() acceptableContentTypes:[NSSet setWithObjects:QLHttpRequestAcceptableContentTypeJSON, nil] resultToJSON:NO success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}



/*
 默认回调到  QLGetHttpResultDataHandleQueue() 队列
 */
+ (NSURLSessionDataTask *)GETJSON:(NSString *)URLString
                       parameters:(NSDictionary *)parameters
                          success:(QLHttpResultDictCallBlock)success
                          failure:(QLHttpResultErrorCallBlock)failure
{
    return [QLHttpRequestAPI GET:URLString parameters:parameters completionQueue:QLGetHttpResultDataHandleQueue() resultToJSON:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

/*
 默认回调到  QLGetHttpResultDataHandleQueue() 队列
 */
+ (NSURLSessionDataTask *)POSTWithJSONResult:(NSString *)URLString
                                  parameters:(NSDictionary *)parameters
                                     success:(QLHttpResultDictCallBlock)success
                                     failure:(QLHttpResultErrorCallBlock)failure
{
    return [QLHttpRequestAPI POST:URLString parameters:parameters completionQueue:QLGetHttpResultDataHandleQueue() acceptableContentTypes:[NSSet setWithObjects:QLHttpRequestAcceptableContentTypeJSON, nil] resultToJSON:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

/*------------------------------------------------------------------------------
 默认回调到  QLGetHttpResultDataHandleQueue() 队列
 */
+ (QLHttpRequestModel *)request:(QLHttpRequestModel *)model
                        success:(QLHttpResultDictCallBlock)success
                        failure:(QLHttpResultErrorCallBlock)failure
{
    if (!model) {
        return nil;
    }
    
    NSURLSessionDataTask *task = [QLHttpRequestAPI POST:model.URLString parameters:model.parameters completionQueue:QLGetHttpResultDataHandleQueue() acceptableContentTypes:[NSSet setWithObjects:QLHttpRequestAcceptableContentTypeJSON, nil] resultToJSON:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    
    model.task = task;
    
    return model;
}


+ (QLHttpRequestModel *)requestWithCacheModel:(void (^)(QLHttpRequestModel *modelFromCache))GetModelFromCache
                        success:(QLHttpResultDictCallBlock)success
                        failure:(QLHttpResultErrorCallBlock)failure
{
    QLHttpRequestModel *model = [[QLHttpRequestModel alloc] init];
    
    
    
    
    NSURLSessionDataTask *task = [QLHttpRequestAPI POST:model.URLString parameters:model.parameters completionQueue:QLGetHttpResultDataHandleQueue() acceptableContentTypes:[NSSet setWithObjects:QLHttpRequestAcceptableContentTypeJSON, nil] resultToJSON:YES success:^(NSURLSessionDataTask *task, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    
    model.task = task;
    
    return model;
}










//static NSInteger continuousFailedCount;
//        NSString * contenttype = @"text/html";
+ (void)GetWithUrlString:(NSString *)urlString parms:(NSDictionary *)dict finished:(DownloadFinishedBlock)finishedBlock failed:(DownloadFailedBlock)failedBlock{
//    NSError * err;
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // responseSerializer把响应原始数据返回，缺省是AFN会自动解析json
    manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    [manager GET:urlString parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        finishedBlock(responseObject);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failedBlock(error);
    }];
    
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:acceptableContentTypesStr,nil];
//    //post请求
//    [manager GET:urlString parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        //        NSLog(@"respose:%@",responseObject);
//        finishedBlock(responseObject);    //    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"error:%@",error.localizedDescription);
//        failedBlock(error.localizedDescription);
//    }];
}

+ (void)GetWithUrlString:(NSString *)urlString parms:(NSDictionary *)dict finished:(DownloadFinishedBlock)finishedBlock failed:(DownloadFailedBlock)failedBlock finally:(FinallyBlock)finally
{
    NSError * err;
    if (![QLWebMonitors webIsOK:&err]) {
        failedBlock(err);
        return;
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    // responseSerializer把响应原始数据返回，缺省是AFN会自动解析json
    manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    [manager GET:urlString parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        finishedBlock(responseObject);
        finally();
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        failedBlock(error);
        finally();
    }];
}

+ (void)GetWithUrlString:(NSString *)urlString parms:(NSDictionary *)dict downloadBlock:(DownloadBlock)downloadBlock
{
    NSError * err;
    if (![QLWebMonitors webIsOK:&err]) {
        downloadBlock(nil, err);
        return;
    }
//    NSString * contentStr = @"application/json";
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:contentStr,nil];
    [manager GET:urlString parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        downloadBlock(responseObject, nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        downloadBlock(nil, error);
    }];
}

+ (void)afPostWithUrlString:(NSString *)urlString parms:(NSDictionary *)dict finished:(DownloadFinishedBlock)finishedBlock failed:(DownloadFailedBlock)failedBlock{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:QLHttpRequestAcceptableContentTypeStr,nil];
    //post请求
    [manager POST:urlString parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //        NSLog(@"respose:%@",responseObject);
        finishedBlock(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error:%@",error.localizedDescription);
        failedBlock(error);
    }];
}

+ (void)PostWithUrlString:(NSString *)urlString parms:(NSDictionary *)dict downloadBlock:(DownloadBlock)downloadBlock
{
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString * contentStr = @"application/json";
    NSError * err;
    if (![QLWebMonitors webIsOK:&err]) {
        downloadBlock(nil, err);
        return;
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:contentStr,nil];
    //post请求
//    [manager POST:urlString parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        //        NSLog(@"respose:%@",responseObject);
//        downloadBlock(responseObject, nil);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        downloadBlock(nil, error);
//    }];
    [manager POST:urlString parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        downloadBlock(responseObject, nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        downloadBlock(nil, error);
    }];
}

+ (void)PostWWWWithUrlString:(NSString *)urlString parms:(NSDictionary *)dict downloadBlock:(DownloadBlock)downloadBlock
{
    //    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString * contentStr = @"text/html";
    NSError * err;
    if (![QLWebMonitors webIsOK:&err]) {
        downloadBlock(nil, err);
        return;
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:contentStr,nil];

    [manager POST:urlString parameters:dict success:^(NSURLSessionDataTask *task, id responseObject) {
        downloadBlock(responseObject, nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        downloadBlock(nil, error);
    }];
}


+ (void)PostDataWithUrlString:(NSString *)urlString image:(UIImage *)image imageKey:(NSString *)key parms:(NSDictionary *)dict downloadBlock:(DownloadBlock)downloadBlock
{
    //    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString * contentStr = @"x-www-form-urlencoded";
//    @"application/json";
//    @"multipart/form-data";
    NSError * err;
    if (![QLWebMonitors webIsOK:&err]) {
        downloadBlock(nil, err);
        return;
    }
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:contentStr,nil];
    NSData * imageData;
    NSString * mimeType;
//    NSString * fileName = [NSString stringWithFormat:@"avatar%lf", [NSDate date].timeIntervalSince1970];
    NSString * fileName = [NSString stringWithFormat:@"photo"];
    if ((imageData = UIImageJPEGRepresentation(image, 1.0f))) {
        mimeType = @"image/jpeg";
        fileName = [fileName stringByAppendingString:@".jpg"];
    }else if ((imageData = UIImagePNGRepresentation(image))) {
        mimeType = @"image/png";
        fileName = [fileName stringByAppendingString:@".png"];
    }else {
        err = [NSError errorWithDomain:@"不支持的图片类型" code:100 userInfo:nil];
        downloadBlock(nil, err);
        return;
    }
    
    [manager POST:urlString parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        [formData appendPartWithFormData:imageData name:key];
        [formData appendPartWithFileData:imageData
                                    name:key
                                fileName:fileName
                                mimeType:mimeType];
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        downloadBlock(responseObject, nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        downloadBlock(nil, error);
    }];

}

+ (void)PostDataWithUrlString:(NSString *)urlString imageType:(NSString *)type imageData:(NSData *)imageData imageKey:(NSString *)key parms:(NSDictionary *)dict downloadBlock:(DownloadBlock)downloadBlock
{
    NSError * err;
    if (![QLWebMonitors webIsOK:&err]) {
        downloadBlock(nil, err);
        return;
    }

    NSString * contentStr = @"application/json";
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [[AFHTTPResponseSerializer alloc] init];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:contentStr,nil];
    //    NSString * fileName = [NSString stringWithFormat:@"avatar%lf", [NSDate date].timeIntervalSince1970];
    NSString * fileName = [NSString stringWithFormat:@"photo"];
    
    
    [manager POST:urlString parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //        [formData appendPartWithFormData:imageData name:key];
        [formData appendPartWithFileData:imageData
                                    name:key
                                fileName:fileName
                                mimeType:type];
    } success:^(NSURLSessionDataTask *task, id responseObject) {
        downloadBlock(responseObject, nil);
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        downloadBlock(nil, error);
    }];
}


@end
