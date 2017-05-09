//
//  BSTHTTPAsynProcess.h
//  SAIC
//
//  Created by zhangyu on 13-6-6.
//  Copyright (c) 2013年 felix. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BSTHTTPAsynProcess : NSObject

+(BSTHTTPAsynProcess *)sharedManager;

- (void)scheduleBlock:(dispatch_block_t)block;
@end
