//
//  SAICHTTPRequest.h
//  SAIC
//
//  Created by felix on 5/7/13.
//  Copyright (c) 2013 felix. All rights reserved.
//

#import "BSTHTTPRequest.h"
#import "BSTHTTPProtocol.h"
#import "JSONKit.h"
#import "ASIHTTPRequest.h"
#import "NSDictionary+SafeAccess.h"

#if 1

#define SERVER_MAIN_HOST_ADDRESS    @"http://tems.takeda.com.cn/iTakeda/service/"         //正式环境
//#define SERVER_MAIN_HOST_ADDRESS    @"http://192.168.142.239/iTakeda/service/"         //测试环境
//#define SERVER_MAIN_HOST_ADDRESS    @"http://192.168.142.232:8706/Sage/"


#else

#endif

#define NETWORK_CONNECT_TEST_SERVER @"www.apple.com"
//#define SERVER_VERSION              @"1.0"
//#define SECURITY_KEY                @"!Q@W#E"

@interface SAICHTTPRequest : BSTHTTPRequest<BSTHTTPRequest>

-(NSError*)requestByType:(BSTHTTPRequestTypeMode)type values:(NSDictionary *)values userInfo:(NSDictionary*)info;

- (NSError*)downloadByUrlStr:(NSString*)str destinationPath:(NSString*)path userInfo:(NSDictionary*)info progress:(id)ind tag:(NSInteger)tag;

- (NSError*)uploadByType:(BSTHTTPRequestTypeMode)type /*image:(UIImage*)i*/ postvalues:(NSDictionary *)values attachFiles:(NSArray*)files userInfo:(NSDictionary*)info progress:(id)ind;

-(NSError *)requestByCustom:(BSTHTTPRequestTypeMode)type url:(NSString *)urlStr  values:(NSDictionary *)values userInfo:(NSDictionary*)info;

- (NSString*)getInterfaceName:(NSInteger)tag;

@end
