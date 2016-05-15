//
//  QLLogModel.h
//  QLLogFrameWork
//
//  Created by 王青海 on 15/11/1.
//  Copyright © 2015年 王青海. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QLLogEnum.h"



@class QLLogModel;

typedef void(^QLLogModelCallBackBlock)(QLLogModel *model);

//QLFuncType objAddress objDes QLLogType dateStr func line msg
@interface QLLogModel : NSObject


@property (nonatomic, copy) QLLogModelCallBackBlock countBecomeTo0;


@property (nonatomic, copy) NSDate *date;

@property (nonatomic, assign) QLFuncType funcType;
@property (nonatomic, copy) NSString * objAddress;
@property (nonatomic, copy) NSString * objDes;
@property (nonatomic, assign) QLLogType logType;

//@property (nonatomic, copy) NSString * dateStr;
@property (nonatomic, copy) NSString * func;
@property (nonatomic, assign) NSUInteger line;
@property (nonatomic, copy) NSString * msg;

@property (nonatomic, strong) NSString * tag;


- (void)logCacheRetain;
- (void)logCacheRelease;

- (char *)consoleStr;
- (NSString *)fileStr;

- (NSString *)dateStr;



- (NSDictionary *)dictFromModel;

+ (QLLogModel *)logModelWithDict:(NSDictionary *)dict;

@end
