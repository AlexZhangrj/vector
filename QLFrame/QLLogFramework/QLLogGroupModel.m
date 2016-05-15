//
//  QLLogGroupModel.m
//  QLLogFrameWork
//
//  Created by 王青海 on 15/11/1.
//  Copyright © 2015年 王青海. All rights reserved.
//

#import "QLLogGroupModel.h"

#import "QLLogModel.h"


@interface QLLogGroupModel ()

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@property (nonatomic, strong) NSDateFormatter *logModelDateFormatter;


//@property (nonatomic, readonly) NSString *dateString;





@end
@implementation QLLogGroupModel



- (instancetype)init
{
    self = [super init];
    if (self) {
        self.dateFormatter = [[NSDateFormatter alloc] init];
        [self.dateFormatter setDateFormat:@"yyyy-MM-dd HH"];
        
        self.logModelDateFormatter = [[NSDateFormatter alloc] init];
        [self.logModelDateFormatter setDateFormat:@"mm:ss.sTZD"];
        
        self.logModels = [NSMutableArray array];
    }
    return self;
}

- (NSString *)dateString
{
    NSString *retString = nil;
    if (self.date) {
        [self.dateFormatter stringFromDate:self.date];
    }else {
        retString = @"";
    }
    return retString;
}

- (void)setLogModels:(NSMutableArray *)logModels
{
    if (logModels != _logModels) {
        _logModels = logModels;
    }
}















- (NSString *)logModelDateString:(QLLogModel *)logModel
{
    NSString *retString = nil;

    if (logModel.date) {
        [self.logModelDateFormatter stringFromDate:logModel.date];
    }else {
        retString = @"";
    }
    return retString;
}




@end
