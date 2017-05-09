//
//  BSTHTTPRequest.m
//  HTTPRequest
//
//  Created by felix yang on 7/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BSTHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"
#import "BSTHTTPAsynProcess.h"


#import "BSTHTTPProtocol.h"
#import "GCDMulticastDelegate.h"


#define HTTP_CONTENT_TYPE               @"Content-Type"
#define HTTP_CONTENT_TYPE_TEXT_HTML     @"text/html"
#define HTTP_CONTENT_TYPE_TEXT_PLAIN    @"text/plain"
#define HTTP_CONTENT_TYPE_JSON          @"json"
#define HTTP_CONTENT_TYPE_IMAGE         @"image"


typedef enum {
    BSTRequestStatusFinishedSuccess = 1,
    BSTRequestStatusFinishedFailure,
    BSTRequestStatusFailed,
} BSTRequestStatus;


@interface BSTHTTPRequest ()<BSTHTTPRequestDelegate,BSTHTTPRequest>

@property (nonatomic, retain) ASINetworkQueue *networkQueue;
@property (nonatomic, retain) ASINetworkQueue *fileNetworkQueue;

@property (nonatomic, retain) id multicastDelegate;

//zhangyu 代理主体失去死机修正,类内部维护队列
@property (nonatomic, retain) NSMutableArray* requestArray;
@property (nonatomic, retain) NSLock *requestArrayAccessLock;


@end


@implementation BSTHTTPRequest

@synthesize networkQueue = _networkQueue;
@synthesize fileNetworkQueue = _fileNetworkQueue;
@synthesize multicastDelegate = _multicastDelegate;
@synthesize requestArray = _requestArray;
@synthesize requestArrayAccessLock = _requestArrayAccessLock;


- (void)dealloc {
#if ASIHTTP_DEBUG
    NSLog(@"%@ dealloc",self);
#endif
    [self cancelAll];
    
    [self setNetworkQueue:nil];
    [self setFileNetworkQueue:nil];
    [self setMulticastDelegate:nil];
    //zhangyu 代理主体失去死机修正,类内部维护队列
    [self setRequestArray:nil];
    [self setRequestArrayAccessLock:nil];
    
    [super dealloc];
}


- (id)init
{
    self = [super init];
    if (self) {
        NSLog(@"start");
        ASINetworkQueue *queue = [[ASINetworkQueue alloc] init];
        [queue setShouldCancelAllRequestsOnFailure:NO];
        [queue setMaxConcurrentOperationCount:3];
        [self setNetworkQueue:queue];
        [queue release];
        
        ASINetworkQueue *fqueue = [[ASINetworkQueue alloc] init];
        [fqueue setShouldCancelAllRequestsOnFailure:NO];
        [fqueue setMaxConcurrentOperationCount:3];
        [self setFileNetworkQueue:fqueue];
        [fqueue release];
        NSLog(@"end");
        
        GCDMulticastDelegate *delegate = [[GCDMulticastDelegate alloc] init];
        [self setMulticastDelegate:delegate];
        [delegate release];
        //zhangyu 代理主体失去死机修正,类内部维护队列
        _requestArray = [[NSMutableArray alloc] initWithCapacity:0];
        _requestArrayAccessLock = [[NSLock alloc] init];
        
    }
    return self;
}

//zhangyu 代理主体失去死机修正,类内部维护队列
-(void) addToRequestArray:(id)request
{
#if ASIHTTP_DEBUG
    NSLog(@"add request %p",request);
#endif
    [_requestArrayAccessLock lock];
    [_requestArray addObject:request];
    [_requestArrayAccessLock unlock];
#if ASIHTTP_DEBUG
    NSLog(@"when add request Array = %@",_requestArray);
#endif
}
//zhangyu 代理主体失去死机修正,类内部维护队列
-(void) removeFromRequestArray:(id)request
{
#if ASIHTTP_DEBUG
    NSLog(@"remove request %p",request);
#endif
    [_requestArrayAccessLock lock];
    [_requestArray removeObject:request];
    [_requestArrayAccessLock unlock];
#if ASIHTTP_DEBUG
    NSLog(@"when remove request Array = %@",_requestArray);
#endif
}

//zhangyu 代理主体失去死机修正,类内部维护队列
-(BOOL) isRequestExistInRequestArray:(id)request
{
    BOOL ret = FALSE;
    [_requestArrayAccessLock lock];
    ret = [_requestArray containsObject:request];
    [_requestArrayAccessLock unlock];
    return ret;
}

- (void)addDelegate:(id)delegate delegateQueue:(dispatch_queue_t)delegateQueue
{
    [_multicastDelegate addDelegate:delegate delegateQueue:delegateQueue];
}


- (void)removeDelegate:(id)delegate delegateQueue:(dispatch_queue_t)delegateQueue
{
    [_multicastDelegate removeDelegate:delegate delegateQueue:delegateQueue];
}



- (NSString *)toString:(id)object {
    return [NSString stringWithFormat: @"%@", object];
}

- (NSString*)getInterfaceName:(NSInteger)tag
{
    return @"";
}

- (NSString *)urlEncode:(id)object {
    NSString *string = [self toString:object];
    return [string stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
}


-(NSString*) urlEncodedString:(NSDictionary*)parameters tag:(NSInteger)tag{
    NSMutableArray *parts = [NSMutableArray array];
    for (id key in parameters) {
        id value = [parameters objectForKey: key];
        NSString *part = [NSString stringWithFormat: @"%@=%@", [self urlEncode:key], [self urlEncode:value]];
        [parts addObject: part];
    }
    
    if ([parts count] > 0) {
        return [NSString stringWithFormat:@"?%@", [parts componentsJoinedByString: @"&"]];
    } else {
        return @"";
    } 
}


-(NSDictionary* ) postValuesEncode:(NSDictionary*)parameters tag:(NSInteger)tag
{
    return parameters;
}

- (void)requestByUrlStr:(NSString* )urlStr postValues:(NSDictionary *)values userInfo:(NSDictionary*)info tag:(NSInteger)tag{

    NSURL *url = [NSURL URLWithString:urlStr];
    
    ASIHTTPRequest *request = [ASIFormDataRequest requestWithURL:url];
    NSDictionary *postDic = [self postValuesEncode:values tag:tag];
#if ASIHTTP_DEBUG
    NSLog(@"%@:%@",url,postDic);
#endif
    for (id parameters in [postDic allKeys]) {
        [(ASIFormDataRequest*)request setPostValue:[postDic objectForKey:parameters] forKey:parameters];
    }

//    [request setShouldAttemptPersistentConnection:NO];
    [request setValidatesSecureCertificate:NO];
    [request setTimeOutSeconds:TIME_OUT_SECONDS];
//    [request setRequestHeaders:[NSMutableDictionary dictionaryWithObjectsAndKeys:
//                               @"application/x-www-form-urlencoded",@"Content-Type",
//                               nil]];
    [request setDelegate:self];
    [request setUserInfo:info];
    [request setTag:tag];
    
    //zhangyu 代理主体失去死机修正,类内部维护队列
    [self addToRequestArray:request];
    
	[_networkQueue addOperation:request];
    [_networkQueue go];
}


-(NSString *) getValuesEncodes:(NSDictionary*)parameters tag:(NSInteger)tag
{
    return [self urlEncodedString:parameters tag:tag];
}

- (void)requestByUrlStr:(NSString* )urlStr getValues:(NSDictionary *)values userInfo:(NSDictionary*)info tag:(NSInteger)tag{
    
    urlStr = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    urlStr = [urlStr stringByAppendingString:[self getValuesEncodes:values tag:tag]];
    
    NSURL *url = [NSURL URLWithString:urlStr];
//    NSURL *url = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"%@",url);
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    
//    [request setShouldAttemptPersistentConnection:NO];
    [request setValidatesSecureCertificate:NO];
    [request setTimeOutSeconds:TIME_OUT_SECONDS];
    [request setDelegate:self];
    [request setUserInfo:info];
    [request setTag:tag];
    
    
    //zhangyu 代理主体失去死机修正,类内部维护队列
    [self addToRequestArray:request];
    
	[_networkQueue addOperation:request];
    [_networkQueue go];

}

- (void)downloadByUrlStr:(NSString*)str destinationPath:(NSString*)path userInfo:(NSDictionary*)info progress:(id)ind tag:(NSInteger)tag 
{
    NSURL *url = [NSURL URLWithString:str];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setDownloadDestinationPath:path];
    NSString *tempPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"tmp"] stringByAppendingPathComponent:[path lastPathComponent]];
    [request setTimeOutSeconds:TIME_OUT_SECONDS];
    [request setTemporaryFileDownloadPath:tempPath];
    [request setAllowResumeForFileDownloads:YES];
    [request setAllowCompressedResponse:NO];
    [request setShowAccurateProgress:YES];
    [request setDownloadProgressDelegate:ind];
    [request setUserInfo:info];
    [request setDelegate:self];
    [request setDidFinishSelector:@selector(didDownloadFinished:)];
    [request setTag:tag];

    //zhangyu 代理主体失去死机修正,类内部维护队列
    [self addToRequestArray:request];
    
//    [_fileNetworkQueue setShowAccurateProgress:YES];
    [_fileNetworkQueue addOperation:request];
    [_fileNetworkQueue go];
}

- (void) didDownloadFinished:(ASIHTTPRequest *)request
{
    if (200 == [request responseStatusCode]) {
        [self delegate:BSTRequestStatusFinishedSuccess httpResponse:nil type:request.tag userInfo:[request userInfo] withError:nil];
        
    }else{
        [self delegate:BSTRequestStatusFinishedFailure httpResponse:nil type:request.tag userInfo:[request userInfo] withError:nil];
    }
    //zhangyu 代理主体失去死机修正,类内部维护队列
    if ([self isRequestExistInRequestArray:request]) {
        //zhangyu 代理主体失去死机修正,类内部维护队列
        [self removeFromRequestArray:request];
    }
}

//modify by zhangyu
//files:::是一个包含文件信息的数组，有两种情况
/*
 1.如果是从本地文件中上传，那么这个dic的格式为
 {
    @“文件路径”，@“filepath”
    @"上传服务器要求的key值"，@"key"
 }
 2.如果是从内存中上传数据，那么dic的格式为
 {
    NSdata(内存中的上传数据),@“data”
    @“文件名”，@“filename”
    @“txt”,@"contenttype"
    @"上传服务器要求的key值"，@"key"
 }
 以上两种可以在file数组中混合使用
*/
- (void)uploadByUrlStr:(NSString*)str /*image:(UIImage*)i*/ postvalues:(NSDictionary *)values attachFiles:(NSArray *)files userInfo:(NSDictionary*)info progress:(id)ind tag:(NSInteger)tag
{
    NSURL *url = [NSURL URLWithString:str];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setTimeOutSeconds:TIME_OUT_SECONDS];
    [request buildRequestHeaders]; 
    
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_4_0
	[request setShouldContinueWhenAppEntersBackground:YES];
#endif
//    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingMacChineseSimp);
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingUTF8);
    [request setStringEncoding:enc];
    
    NSDictionary *postDic = [self postValuesEncode:values tag:tag];
#if ASIHTTP_DEBUG
    NSLog(@"%@:%@",url,postDic);
#endif
    //post值设定
    for (id parameters in [postDic allKeys]) {
        [request setPostValue:[postDic objectForKey:parameters] forKey:parameters];
    }
    
    //组织上传文件
    for(id file in files)
    {
        if ([file isKindOfClass:[NSDictionary class]]) {
            NSArray *keys = [file allKeys];
            if ([keys containsObject:@"filepath"]) {
                [request addFile:[file objectForKey:@"filepath"] forKey:[file objectForKey:@"key"]];
            }
            else if([keys containsObject:@"data"]){
                NSData* uploadData = [file objectForKey:@"data"];
                if ([uploadData isKindOfClass:[NSData class]]) {
                    [request addData:uploadData withFileName:[file objectForKey:@"filename"] andContentType:[file objectForKey:@"contenttype"] forKey:[file objectForKey:@"key"]];
                }
            }else{
                
            }
        }
    }
    
//    NSData *data = UIImageJPEGRepresentation(i,0);
//    NSString *filePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"tmp"] stringByAppendingPathComponent:@"file.jpg"];
//	[data writeToFile:filePath atomically:NO];
//    
//	for (int i=0; i<8; i++) {
//		[request setFile:filePath forKey:[NSString stringWithFormat:@"file-%hi",i]];
//	}
    
//    [request setShowAccurateProgress:YES];
    [request setUploadProgressDelegate:ind];
    [request setShowAccurateProgress:YES];
    [request setUserInfo:info];
    [request setDelegate:self];

    [request setTag:tag];
    
    //zhangyu 代理主体失去死机修正,类内部维护队列
    [self addToRequestArray:request];
    
//    [_fileNetworkQueue setShowAccurateProgress:YES];
    [_fileNetworkQueue addOperation:request];
    [_fileNetworkQueue go];
}



- (void)cancelAllOperations:(NSOperationQueue*)queue
{
    for (ASIHTTPRequest *request in [queue operations]) {
        
        if (nil != request.delegate) {
            [request setDelegate:nil];
        }
        
        if (![request isCancelled]) {
            [request clearDelegatesAndCancel];
        }
    }

    [queue cancelAllOperations];

}

- (void)cancelAll
{
//    [self cancelAllOperations:_networkQueue];
//    [self cancelAllOperations:_fileNetworkQueue];
#if ASIHTTP_DEBUG
    NSLog(@"when cancelAll request Array = %@",_requestArray);
#endif
    [_requestArrayAccessLock lock];
    for (ASIHTTPRequest *request in _requestArray)
    {
        //保险点，清两遍，优先干掉代理
        [request setDelegate:nil];
        [request clearDelegatesAndCancel];
//        [_requestArray removeObject:request];
    }
    [_requestArray removeAllObjects];
    [_requestArrayAccessLock unlock];
}

- (void)cancelByUsrInfo:(NSDictionary *)usrInfo
{
#if ASIHTTP_DEBUG
    NSLog(@"when cancelByType request Array = %@",_requestArray);
#endif
    [_requestArrayAccessLock lock];
    @try {
        NSMutableArray *readyToRemoveArray = [NSMutableArray arrayWithCapacity:0];
        for (ASIHTTPRequest *request in _requestArray)
        {
            if ([request.userInfo isEqualToDictionary:usrInfo])
            {
                //保险点，清两遍，优先干掉代理
                [request setDelegate:nil];
                [request clearDelegatesAndCancel];
                //数组循环中破坏迭代器是不合适的
                //                [_requestArray removeObject:request];
                [readyToRemoveArray addObject:request];
            }
        }
        
        for (ASIHTTPRequest *request in readyToRemoveArray) {
            [_requestArray removeObject:request];
        }
        [readyToRemoveArray removeAllObjects];
    }
    @catch (NSException *exception) {
        NSLog(@"NSException for http");
    }
    @finally {
        
    }
    
    [_requestArrayAccessLock unlock];
}

- (void)cancelByType:(BSTHTTPRequestTypeMode )type
{
//    for (ASIHTTPRequest *request in [_networkQueue operations]) {
//        if (request.tag == type) {
//
//            if (nil != request.delegate) {
//                [request setDelegate:nil];
//            }
//            [request cancel];
//        }
//    }
//    
//    for (ASIHTTPRequest *request in [_fileNetworkQueue operations]) {
//        if (request.tag == type) {
//            if (nil != request.delegate) {
//                [request setDelegate:nil];
//            }
//            
//            [request cancel];
//        }
//    }
#if ASIHTTP_DEBUG
    NSLog(@"when cancelByType request Array = %@",_requestArray);
#endif
    [_requestArrayAccessLock lock];
    @try {
        NSMutableArray *readyToRemoveArray = [NSMutableArray arrayWithCapacity:0];
        for (ASIHTTPRequest *request in _requestArray)
        {
            if (request.tag == type)
            {
                //保险点，清两遍，优先干掉代理
                [request setDelegate:nil];
                [request clearDelegatesAndCancel];
                //数组循环中破坏迭代器是不合适的
//                [_requestArray removeObject:request];
                [readyToRemoveArray addObject:request];
            }
        }
        
        for (ASIHTTPRequest *request in readyToRemoveArray) {
            [_requestArray removeObject:request];
        }
        [readyToRemoveArray removeAllObjects];
    }
    @catch (NSException *exception) {
        NSLog(@"NSException for http");
    }
    @finally {
        
    }
   
    [_requestArrayAccessLock unlock];
}


- (void)setAllQueueSuspended:(BOOL)suspend
{
	[_networkQueue setSuspended:suspend];
    [_fileNetworkQueue setSuspended:suspend];
}



- (void)delegate:(BSTRequestStatus)status httpResponse:(id)response type:(BSTHTTPRequestTypeMode)mode userInfo:(id)info withError:(NSError*)error;
{
    if (mode> HTTPRequestTypeModeDownloadBegin && mode < HTTPRequestTypeModeDownloadEnd)
    {
        switch (status) {
            case BSTRequestStatusFinishedSuccess:
                [_multicastDelegate _didDownloadFinsh:mode userInfo:info];
                break;
            case BSTRequestStatusFinishedFailure:
            case BSTRequestStatusFailed:
                [_multicastDelegate _didDownloadFailed:mode userInfo:info withError:error];
                break;
            default:
                break;
        }
        
        
    }else if (mode > HTTPRequestTypeGetCustomBegin && mode < HTTPRequestTypeGetCustomEnd){
        
        switch (status) {
            case BSTRequestStatusFinishedSuccess:
                //zhangyu 2013-5-14 接口修正
                //                [_multicastDelegate _didFinishSuccess:mode  userInfo:info];
                [_multicastDelegate _didFinishSuccess:mode httpResponse:response userInfo:info];
                break;
            case BSTRequestStatusFinishedFailure:
                //zhangyu 2013-5-14 接口修正
                //                [_multicastDelegate _didFinishFailure:mode userInfo:info];
                [_multicastDelegate _didFinishFailure:mode httpResponse:response userInfo:info withError:error];
                break;
            case BSTRequestStatusFailed:
                [_multicastDelegate _didFailed:mode userInfo:info withError:error];
                break;
            default:
                break;
        }

        
    }
    else if (mode > HTTPRequestTypeModeUploadBegin && mode < HTTPRequestTypeModeUploadEnd)
    {
        switch (status) {
            case BSTRequestStatusFinishedSuccess:
                [_multicastDelegate _didUploadFinsh:mode httpResponse:response userInfo:info];
                break;
            case BSTRequestStatusFinishedFailure:
            case BSTRequestStatusFailed:
                [_multicastDelegate _didUploadFailed:mode httpResponse:response userInfo:info withError:error];
                break;
            default:
                break;
        }
        
        
    }else
    {
        switch (status) {
            case BSTRequestStatusFinishedSuccess:
                //zhangyu 2013-5-14 接口修正
//                [_multicastDelegate _didFinishSuccess:mode  userInfo:info];
                [_multicastDelegate _didFinishSuccess:mode httpResponse:response userInfo:info];
                break;
            case BSTRequestStatusFinishedFailure:
                //zhangyu 2013-5-14 接口修正
//                [_multicastDelegate _didFinishFailure:mode userInfo:info];
                [_multicastDelegate _didFinishFailure:mode httpResponse:response userInfo:info withError:error];
                break;
            case BSTRequestStatusFailed:
                [_multicastDelegate _didFailed:mode userInfo:info withError:error];
                break;
            default:
                break;
        }
        
        
    }
}


#pragma mark - BSTHTTPRequest Protocol

-(id)handleRequest:(ASIHTTPRequest*)request withError:(NSError**)error
{
    return [request responseString];
}


#pragma mark - ASIHTTPRequestDelegate
- (void)requestFinished:(ASIHTTPRequest *)request
{
    
    //异步block处理gzip解压及解压后的数据
    dispatch_block_t asynBlock = ^{
        //    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
        //    [userInfo setValue:[request userInfo] forKey:USER_INFO];
        
        NSDictionary *headers = [request responseHeaders];
        NSString *contentType = [headers objectForKey:HTTP_CONTENT_TYPE];
        NSError* error = nil;
        //    NSString *encoding = [headers objectForKey:@"Content-Encoding"];
        //	([encoding rangeOfString:@"gzip"].location != NSNotFound);
#if ASIHTTP_DEBUG
        NSLog(@"%@::%@ responseStatusCode::%d response::%@",[self getInterfaceName:request.tag],@"requestFinished",[request responseStatusCode],request.responseString);
#endif
        
        if (200 == [request responseStatusCode]) {
            
            id response = nil;
            
            if (contentType != nil) {
                if ( NSNotFound != [contentType rangeOfString:HTTP_CONTENT_TYPE_TEXT_HTML].location) {
                    response = [self handleRequest:request withError:&error];
                }
                
                if ( NSNotFound != [contentType rangeOfString:HTTP_CONTENT_TYPE_JSON].location) {
                    response = [self handleRequest:request withError:&error];
                }
                
                if ( NSNotFound != [contentType rangeOfString:HTTP_CONTENT_TYPE_IMAGE].location) {
                    response = [self handleRequest:request withError:&error];
                }
                //
                if ( NSNotFound != [contentType rangeOfString:HTTP_CONTENT_TYPE_TEXT_PLAIN].location) {
                    response = [self handleRequest:request withError:&error];
                }
            }else{
                response = [self handleRequest:request withError:&error];
            }
            
            //        [userInfo setValue:response forKey:RESULT];
            //错误处理，网络共同错误
            if (error == nil) {
                [self delegate:BSTRequestStatusFinishedSuccess httpResponse:response type:request.tag userInfo:[request userInfo] withError:error];
            }else{
                [self delegate:BSTRequestStatusFinishedFailure httpResponse:response type:request.tag userInfo:[request userInfo] withError:error];
            }

        }
        else
        {
            error = [NSError errorWithDomain:BSTHTTPCustomErrorDomain code:BSTHTTPRequestResponseFailed userInfo:nil];
            [self delegate:BSTRequestStatusFinishedFailure httpResponse:nil type:request.tag userInfo:[request userInfo] withError:error];
        }
    };
    
    //zhangyu 代理主体失去死机修正,类内部维护队列
    if ([self isRequestExistInRequestArray:request]) {
        [[BSTHTTPAsynProcess sharedManager] scheduleBlock:asynBlock];
        //zhangyu 代理主体失去死机修正,类内部维护队列
        [self removeFromRequestArray:request];
    }

}


- (void)requestFailed:(ASIHTTPRequest *)request
{
    //zhangyu 代理主体失去死机修正,类内部维护队列
    NSError*error = [NSError errorWithDomain:BSTHTTPCustomErrorDomain code:BSTHTTPRequestResponseFailed userInfo:nil];
#if ASIHTTP_DEBUG
    NSLog(@"%@::%@",[self getInterfaceName:request.tag],@"requestFailed");
#endif
    if ([self isRequestExistInRequestArray:request])
    {
        NSDictionary *userInfo = [request userInfo];
        [self delegate:BSTRequestStatusFailed httpResponse:nil type:request.tag userInfo:userInfo withError:error];
        //zhangyu 代理主体失去死机修正,类内部维护队列
        [self removeFromRequestArray:request];
    }
    
}

@end
