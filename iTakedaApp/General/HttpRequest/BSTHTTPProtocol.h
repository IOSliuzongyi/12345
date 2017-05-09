//
//  BSTHTTPProtocol.h
//  HTTPRequest
//
//  Created by felix yang on 7/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#ifndef BSTHTTPRequest_BSTHTTPProtocol_h
#define BSTHTTPRequest_BSTHTTPProtocol_h


#define TIME_OUT_SECONDS        1*60


#define USER_INFO               @"userInfo"
#define RESULT                  @"responseBody"

typedef enum {
    //GET
    HTTPRequestTypeModeGetBegin = 0,
    
    HTTPRequestTypeMode_LoadAppList,
    HTTPRequestTypeMode_CheckUpdate,
    HTTPRequestTypeMode_GetNews,
    HTTPRequestTypeMode_GetScollNews,
    HTTPRequestTypeMode_GetVideoNews,
    HTTPRequestTypeMode_GetHelpDocs,
    HTTPRequestTypeMode_NewsZanUp,
    HTTPRequestTypeMode_NewsZanDown,
    HTTPRequestTypeMode_VideoZanUp,
    HTTPRequestTypeMode_VideoZanDown,
    
    HTTPRequestTypeModegetNewActivityList,
    
    
    HTTPRequestTypeModeGetEnd,
    
    //POST
    HTTPRequestTypeModePostBegin = 100,
    HTTPRequestTypeMode_FeedBack,
    
    HTTPRequestTypeModePostEnd,
     
    //DOWNLOAD
    HTTPRequestTypeModeDownloadBegin = 200,
    HTTPRequestTypeModeDownloadForImage,
    HTTPRequestTypeModeDownloadForFile,
    HTTPRequestTypeModeDownloadEnd,
    
    //UPLOAD
    HTTPRequestTypeModeUploadBegin = 300,
//    HTTPRequestTypeModeUploadChengnuoFeedBack,
    HTTPRequestTypeModeIMUploadFile,
    HTTPRequestTypeModeUploadEnd,
    
    
    //Custom
    HTTPRequestTypeGetCustomBegin = 400,
    HTTPRequestTypeGetCustomForData,
    HTTPRequestTypeGetCustomEnd,
    
} BSTHTTPRequestTypeMode;

//add by zhangyu for BSTHTTP自定义错误 Start
#define BSTHTTPCustomErrorDomain @"BSTHTTPCustomError"
typedef enum {
    BSTHTTPRequestFailedError = -1000,
    BSTHTTPDownloadRequestFailedError,
    BSTHTTPRequestResponseError,
    BSTHTTPRequestResponseFailed,
    BSTHTTPRequestServerResultError,
    BSTHTTPServerErrVer = -1,
    BSTHTTPServerErrNoAction = -2,
    BSTHTTPServerAccessDenied = -3,
    BSTHTTPServerActionFile = -4,
    BSTHTTPServerNoMethod = -5,
    BSTHTTPServerLogFailFailed = -6,
    BSTHTTPServerUnlogin = -7,
    BSTHTTPServerTokenInvalid = -8,
    BSTHTTPServerSocketCreate = -9,
    BSTHTTPServerSocketConnect = -10,
    BSTHTTPServerSocketRead = -11,
    BSTHTTPServerSocketWrite = -12,
    BSTHTTPServerAcessBlock = -13,
    BSTHTTPServerJosonWrong = -14,
    BSTHTTPServerNoParam = 1,
    BSTHTTPServerNoData = 2,
    BSTHTTPServerDBFailed = 3,
    BSTHTTPServerParamWrong =4,
    BSTHTTPServerSubmmitFailed = 5,
    BSTHTTPServerForceUpdate = 6,
    BSTHTTPServerNoDearInfo = 7,
    BSTHTTPServerChangePasswordError = 8,
    BSTHTTPServerLoginFailed = 2201,
    BSTHTTPRequestTypeError,

}BSTHTTPCustomError;
//add by zhangyu for BSTHTTP自定义错误 end

@protocol BSTHTTPRequestDelegate <NSObject>

@optional

//modify by zhangyu 20130711 为所有失败代理回调，增加错误参数，统一错误传递，工程成型的情况下的大改动，需要后续跟踪失败处理的正确性
- (void)_didFinishSuccess:(BSTHTTPRequestTypeMode)type httpResponse:(id)response userInfo:(id)info;
- (void)_didFinishFailure:(BSTHTTPRequestTypeMode)type httpResponse:(id)response userInfo:(id)info withError:(NSError*)error;
- (void)_didFailed:(BSTHTTPRequestTypeMode)type userInfo:(id)info withError:(NSError*)error;

- (void)_didDownloadFinsh:(BSTHTTPRequestTypeMode)type userInfo:(id)info;
- (void)_didDownloadFinsh:(BSTHTTPRequestTypeMode)type httpResponse:(id)response userInfo:(id)info;

- (void)_didDownloadFailed:(BSTHTTPRequestTypeMode)type userInfo:(id)info withError:(NSError*)error;

//modify by zhangyu 加入返回的response
- (void)_didUploadFinsh:(BSTHTTPRequestTypeMode)type httpResponse:(id)response userInfo:(id)info;
- (void)_didUploadFailed:(BSTHTTPRequestTypeMode)type httpResponse:(id)response userInfo:(id)info withError:(NSError*)error;;

@end




@class ASIHTTPRequest;
@protocol BSTHTTPRequest <NSObject>
-(id)handleRequest:(ASIHTTPRequest*)request withError:(NSError**)error;
@end



#endif
