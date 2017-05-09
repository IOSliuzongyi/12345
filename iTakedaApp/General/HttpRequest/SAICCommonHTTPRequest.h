//
//  SAICCommonHTTPRequest.h
//  SAIC
//
//  Created by felix on 5/7/13.
//  Copyright (c) 2013 felix. All rights reserved.
//

#import "SAICHTTPRequest.h"



@interface SAICCommonHTTPRequest : SAICHTTPRequest

@property (nonatomic,copy) NSString *logintokon;
@property (nonatomic,strong) NSArray *car_typeDic;

+(SAICCommonHTTPRequest *)sharedManager;

@end
