//
//  QLHttpRequestModel.h
//  QLFrame
//
//  Created by 王青海 on 16/2/22.
//  Copyright © 2016年 王青海. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "QLHttpRequestOptions.h"


@interface QLHttpRequestCacheModel : NSObject

@property (nonatomic, assign) NSTimeInterval requestTime;

@property (nonatomic, strong) NSString *URLString;
@property (nonatomic, strong) NSDictionary *parameters;
@property (nonatomic, assign) QLHttpRequestType requestType;

@property (nonatomic, strong) NSData *resultData;




@end
