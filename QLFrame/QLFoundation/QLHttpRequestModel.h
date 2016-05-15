//
//  QLHttpRequestModel.h
//  QLTools
//
//  Created by 王青海 on 15/11/26.
//  Copyright © 2015年 王青海. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "QLHttpRequestOptions.h"



@interface QLHttpRequestModel : NSObject

@property (nonatomic, assign) NSInteger requestSequel;


@property (nonatomic, assign) NSTimeInterval requestTime;

@property (nonatomic, strong) NSString *URLString;
@property (nonatomic, strong) NSDictionary *parameters;
@property (nonatomic, assign) QLHttpRequestType requestType;



@property (nonatomic, strong) NSURLSessionDataTask *task;

@property (nonatomic, strong) NSData *resultData;


@end
