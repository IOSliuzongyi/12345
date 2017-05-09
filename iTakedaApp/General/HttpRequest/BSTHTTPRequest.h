//
//  BSTHTTPRequest.h
//  HTTPRequest
//
//  Created by felix yang on 7/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BSTHTTPProtocol.h"


#define ASIHTTP_DEBUG 1

@class ASIHTTPRequest;
@interface BSTHTTPRequest : NSObject



- (void)addDelegate:(id)delegate delegateQueue:(dispatch_queue_t)delegateQueue;
- (void)removeDelegate:(id)delegate delegateQueue:(dispatch_queue_t)delegateQueue;


- (void)requestByUrlStr:(NSString* )urlStr postValues:(NSDictionary *)values userInfo:(NSDictionary*)info tag:(NSInteger)tag;

- (void)requestByUrlStr:(NSString* )urlStr getValues:(NSDictionary *)values userInfo:(NSDictionary*)info tag:(NSInteger)tag;

- (void)downloadByUrlStr:(NSString*)str destinationPath:(NSString*)path userInfo:(NSDictionary*)info progress:(id)ind tag:(NSInteger)tag;

//modify by zhangyu
//files:::是一个包含文件信息的数组，有两种情况
/*
 1.如果是从本地文件中上传，那么这个dic的格式为
 {
 @“文件路径”，@“filepath”
 @"上传服务器要求的key只"，@"key"
 }
 2.如果是从内存中上传数据，那么dic的格式为
 {
 NSdata(内存中的上传数据),@“data”
 @“文件名”，@“filename”
 @“txt”,@"contenttype"
 @"上传服务器要求的key只"，@"key"
 }
 以上两种可以在file数组中混合使用
 */
- (void)uploadByUrlStr:(NSString*)str /*image:(UIImage*)i*/ postvalues:(NSDictionary *)values attachFiles:(NSArray *)files userInfo:(NSDictionary*)info progress:(id)ind tag:(NSInteger)tag;

// 取消 请求 下载 Queue
- (void)cancelAll;

// 取消 请求 下载 Queue 中指定type 的 Operation
- (void)cancelByType:(BSTHTTPRequestTypeMode )type;

// 设置 请求 下载  Queue 的 暂停
- (void)setAllQueueSuspended:(BOOL)suspend;

- (void)cancelByUsrInfo:(NSDictionary *)usrInfo;


//暂时写在这，给子类用的方法
- (NSString *)urlEncode:(id)object;
//For Override Add by zhangyu 2013-5-8
-(NSString*) urlEncodedString:(NSDictionary*)parameters tag:(NSInteger)tag;
-(NSDictionary* ) postValuesEncode:(NSDictionary*)parameters tag:(NSInteger)tag;


@end
