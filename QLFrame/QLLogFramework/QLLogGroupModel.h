//
//  QLLogGroupModel.h
//  QLLogFrameWork
//
//  Created by 王青海 on 15/11/1.
//  Copyright © 2015年 王青海. All rights reserved.
//

#import <Foundation/Foundation.h>


@class QLLogModel;

@interface QLLogGroupModel : NSObject

@property (nonatomic, strong) NSDate *date;

@property (nonatomic, readonly) NSString *dateString;

@property (nonatomic, readonly) NSMutableArray *logModels;


@property (nonatomic, assign) BOOL dateLoged;


- (NSString *)logModelDateString:(QLLogModel *)logModel;






@end
