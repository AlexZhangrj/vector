//
//  ViewController.h
//  QLFrame
//
//  Created by 王青海 on 16/2/17.
//  Copyright © 2016年 王青海. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController


+ (void)testRequest:(NSString *)url dict:(void(^)(NSMutableDictionary *dict))setDict sussess:(dispatch_block_t)success faild:(dispatch_block_t)faild;


@end

