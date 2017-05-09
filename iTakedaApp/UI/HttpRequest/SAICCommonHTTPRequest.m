//
//  SAICCommonHTTPRequest.m
//  SAIC
//
//  Created by felix on 5/7/13.
//  Copyright (c) 2013 felix. All rights reserved.
//

#import "SAICCommonHTTPRequest.h"
#import "ASIHTTPRequest.h"

@interface SAICCommonHTTPRequest()
{
    
}
@end

@implementation SAICCommonHTTPRequest
@synthesize logintokon = _logintokon;
@synthesize car_typeDic = _car_typeDic;

static SAICCommonHTTPRequest *_sharedCommonHTTPRequest = nil;

+(SAICCommonHTTPRequest*)sharedManager
{
    @synchronized(self)
    {
        if (nil == _sharedCommonHTTPRequest) {
            _sharedCommonHTTPRequest = [[self alloc] init];
        }
    }
    return _sharedCommonHTTPRequest;
}

+(id)allocWithZone:(NSZone *)zone
{
    @synchronized(self)
    {
        if (nil == _sharedCommonHTTPRequest) {
            _sharedCommonHTTPRequest = [super allocWithZone:zone];
            return _sharedCommonHTTPRequest;
        }
    }
    return nil;
}

-(void)dealloc
{
    
}

-(id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}


#pragma mark - BSTHTTPRequest Protocol

-(id)handleRequest:(ASIHTTPRequest*)request withError:(NSError**)error
{
    id response = nil;
    response = [super handleRequest:request withError:error];
    
    switch ([request tag]) {
//        case HTTPRequestTypeModeLogin:
//        case HTTPRequestTypeModeCarType:
//        case HTTPRequestTypeModeUploadChengnuoFeedBack:
//        case HTTPRequestTypeModeGetLiuShuiDetail:
//        case HTTPRequestTypeModeCarMonthData:
        default:
            break;
    }
    
    return response;
}

@end
