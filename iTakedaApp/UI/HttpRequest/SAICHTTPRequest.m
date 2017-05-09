//
//  SAICHTTPRequest.m
//  SAIC
//
//  Created by felix on 5/7/13.
//  Copyright (c) 2013 felix. All rights reserved.
//

#import "SAICHTTPRequest.h"
#import "SAICCommonHTTPRequest.h"
//#import "CommonFunction.h"

#if ! __has_feature(objc_arc)
#warning This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif

@implementation SAICHTTPRequest

-(void)dealloc
{
    
}

- (NSString *)getServerAddressUrl:(NSInteger)tag
{
    NSString *serverUrl = SERVER_MAIN_HOST_ADDRESS;
    switch (tag) {
        
        default:
        {
//            NSString *url = [[CommonFunction shareManager] getServerAddresssUrl];
//            if (url.length != 0) {
//                serverUrl = url;
//            }
        }
            break;
    }
    
    return serverUrl;
}


-(NSString*)getInterfaceName:(NSInteger)tag
{
    NSString *urlStr = @"";
    switch (tag) {
        case HTTPRequestTypeMode_LoadAppList:
            urlStr = @"AppInfoWebService.asmx/GetVersionInfo";
            break;
        case HTTPRequestTypeMode_CheckUpdate:
            urlStr = @"VersionInfoWebService.asmx/GetVersionInfo";
            break;
        case HTTPRequestTypeMode_GetNews:
            urlStr = @"SearchNewsWebService.asmx/GetNewsInfo";
            break;
        case HTTPRequestTypeMode_GetScollNews:
            urlStr = @"AutoPlayWebService.asmx/GetNewsInfo";
            break;
        case HTTPRequestTypeMode_GetVideoNews:
            urlStr = @"SearchVideoInfoWebService.asmx/SearchVideoInfo";
            break;
        case HTTPRequestTypeMode_GetHelpDocs:
            urlStr = @"SearchHelpInfoWebService.asmx/SearchHelpInfo";
            break;
        case HTTPRequestTypeMode_NewsZanUp:
            urlStr = @"PraiseNewsInfoWebService.asmx/PraiseNewsInfo";
            break;
        case HTTPRequestTypeMode_VideoZanUp:
            urlStr = @"PraiseVideoInfoWebService.asmx/PraiseVedioInfo";
            break;
        case HTTPRequestTypeMode_FeedBack:
            urlStr = @"InsertFeedBackInfoWebService.asmx/InsertFeedBackInfo";
            break;

        case HTTPRequestTypeModeIMUploadFile:
            urlStr = @"uploadChatFile!uploadFile";
            break;
            
        case HTTPRequestTypeMode_NewsZanDown:
            urlStr = @"PraiseCancelNewsInfoWebService.asmx/PraiseCancelNewsInfo";
            break;
            
        case HTTPRequestTypeMode_VideoZanDown:
            urlStr = @"PraiseCancelVideoInfoWebService.asmx/PraiseCancelVedioInfo";
            break;
        default:
            
            break;
    }
    return urlStr;
}



-(NSString*)getUrlWithTag:(NSInteger)tag
{
    NSMutableString *urlStr = [NSMutableString stringWithCapacity:0];
    [urlStr appendFormat:@"%@%@",[self getServerAddressUrl:tag],[self getInterfaceName:tag]];
    
    return urlStr;
}

-(NSError*)requestByType:(BSTHTTPRequestTypeMode)type values:(NSDictionary *)values userInfo:(NSDictionary*)info
{
    NSError *error = nil;
    NSString* urlStr =  [self getUrlWithTag:type];
    if (nil != urlStr && [urlStr length] > 0) {
        if (type > HTTPRequestTypeModeGetBegin && type < HTTPRequestTypeModeGetEnd)
        {   //zhangyu 2013-5-14 参数传递错误修正
            [self requestByUrlStr:urlStr getValues:values userInfo:info tag:type];
        }else if (type > HTTPRequestTypeModePostBegin && type < HTTPRequestTypeModePostEnd)
        {
            //zhangyu 2013-5-14 参数传递错误修正
            [self requestByUrlStr:urlStr postValues:values userInfo:info tag:type];
        }else
        {
            error = [NSError errorWithDomain:BSTHTTPCustomErrorDomain code:BSTHTTPRequestTypeError userInfo:nil];
        }
    }
    else
        error = [NSError errorWithDomain:BSTHTTPCustomErrorDomain code:BSTHTTPRequestFailedError userInfo:nil];
    
    return error;
}

-(NSError *)requestByCustom:(BSTHTTPRequestTypeMode)type url:(NSString *)urlStr  values:(NSDictionary *)values userInfo:(NSDictionary*)info
{
    NSError *error = nil;
    if(type > HTTPRequestTypeGetCustomBegin){
        [self requestByUrlStr:urlStr getValues:values userInfo:info tag:type];
    }
    return error;
}

- (NSError*)downloadByUrlStr:(NSString*)str destinationPath:(NSString*)path userInfo:(NSDictionary*)info progress:(id)ind tag:(NSInteger)tag
{
    NSError *error = nil;
    if ( (nil != str && [str length] >0) && (nil != path && [path length] >0) ) {
        if (tag > HTTPRequestTypeModeDownloadBegin && tag < HTTPRequestTypeModeDownloadEnd) {
            [super downloadByUrlStr:str destinationPath:path userInfo:info progress:ind tag:tag];
        }else{
            error = [NSError errorWithDomain:BSTHTTPCustomErrorDomain code:BSTHTTPDownloadRequestFailedError userInfo:nil];
        }
    }else{
        error = [NSError errorWithDomain:BSTHTTPCustomErrorDomain code:BSTHTTPDownloadRequestFailedError userInfo:nil];
    }

    return error;
}

- (NSError*)uploadByType:(BSTHTTPRequestTypeMode)type /*image:(UIImage*)i*/ postvalues:(NSDictionary *)values attachFiles:(NSArray*)files userInfo:(NSDictionary*)info progress:(id)ind
{
    NSError *error = nil;
    NSString* urlStr =  [self getUrlWithTag:type];
    if (nil != urlStr && [urlStr length] > 0) {
        if (type > HTTPRequestTypeModeUploadBegin && type < HTTPRequestTypeModeUploadEnd) {
            [super uploadByUrlStr:urlStr /*image:i*/ postvalues:values attachFiles:files userInfo:info progress:ind tag:type];
        }else{
            error = [NSError errorWithDomain:BSTHTTPCustomErrorDomain code:BSTHTTPRequestTypeError userInfo:nil];
        }
        
    }else
    {
        error = [NSError errorWithDomain:BSTHTTPCustomErrorDomain code:BSTHTTPRequestTypeError userInfo:nil];
    }
    //错误用于以后扩展用
    return error;
}

#pragma mark - Override Method

//for GET
//add by zhangyu 2013-5-8
//override the same name method of his parent
//由于url的拼装有可能是json拼装，而默认的是“=”“&”拼装，所以该方法根据通信方式进行定制。
-(NSString*) urlEncodedString:(NSDictionary*)parameters tag:(NSInteger)tag{
    NSString *retStr = @"";
#if 1
    //拼成&联接的字符串
    NSMutableArray *parts = [NSMutableArray array];
    for (id key in parameters) {
        id value = [parameters objectForKey: key];
        NSString *part = [NSString stringWithFormat: @"%@=%@", [self urlEncode:key], [self urlEncode:value]];
        [parts addObject: part];
    }
    if ([parts count] > 0) {
        retStr = [NSString stringWithFormat:@"?%@", [parts componentsJoinedByString: @"&"]];
    } else {
        retStr = @"";
    }
#else
    //拼成json字符串
    switch (tag) {
//        case HTTPRequestTypeModeSearchNewsEx:
//        {
//            
//            if ([parameters isKindOfClass:[NSDictionary class]]) {
//                NSMutableDictionary *mutDic = [NSMutableDictionary dictionaryWithCapacity:0];
//                for (id key in parameters) {
//                    id value = [parameters objectForKey: key];
//                    [mutDic setObject:[self urlEncode:value] forKey:[self urlEncode:key]];
//                }
//                parameters = mutDic;
//            }else{
//                return nil;
//            }
//            
//        }
            
            break;
        default:
             {
                

            }
            break;
    }
    
    
    if (parameters.count > 0) {
        @try {
            retStr = [parameters JSONString];
        }
        @catch (NSException *exception) {
            retStr = @"";
        }
        @finally {
            
        }
        
    }
#endif
    
    return retStr;
  
}

-(NSString *) getValuesEncodes:(NSDictionary*)parameters tag:(NSInteger)tag
{
    NSString *retStr = @"";
    
    NSString *bodyStr = [self urlEncodedString:parameters tag:tag];
    if (bodyStr.length > 0) {
        retStr = [NSString stringWithFormat:@"%@",bodyStr];
    }
    
    return retStr;
}


//FOR POST
-(NSDictionary* ) postValuesEncode:(NSDictionary*)parameters tag:(NSInteger)tag
{
#if 1
    NSMutableDictionary *postDic = nil;
    
    
    switch (tag) {
        case HTTPRequestTypeMode_FeedBack:
        {
            NSString *body = [parameters JSONString];
//            NSString *postbody = [self urlEncode:body];
            if (body.length > 0) {
                postDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                           body,@"json"
                           , nil];
            }
        }
            break;
        default:
        {
//            if(parameters != nil)
//            {
//                postDic = [NSMutableDictionary dictionaryWithDictionary:parameters];
//            }else{
//                postDic = [NSMutableDictionary dictionaryWithCapacity:0];
//            }
            
            
//            NSString *postbody = [self urlEncodedString:parameters tag:tag];
//            if (postbody.length > 0) {
//                postDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
//                           postbody,@"rd"
//                           , nil];
//            }
            NSString *body = [parameters JSONString];
            NSString *postbody = [self urlEncode:body];
            if (postbody.length > 0) {
                postDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                           postbody,@"json"
                           , nil];
            }
        }
            
            break;
    }
    
    NSLog(@"postDic=%@",postDic);
    return postDic;
    
#else
    return nil;
#endif
    
}

//加解密的两个函数////////////////////////////////////////////
- (NSString *) encryptBody:(NSString *)version key:(NSString*)key body:(NSString *)body
{
    NSString *ret = nil;
    
    NSString *Base64version = [CommonFunction base64StringFromText:version];
    
    NSData *rsaKeyData = [CommonFunction rsaEncryptString:key];
    if (rsaKeyData == nil) {
        return ret;
    }
    
    NSString *Base64key = [CommonFunction base64EncodedStringFrom:rsaKeyData];
    
    NSData *bodydata = [body dataUsingEncoding:NSUTF8StringEncoding];
    
    NSData *desBodyData = [CommonFunction DESEncrypt:bodydata WithKey:key];
    //    NSString *desBodyStr = [[NSString alloc] initWithData:desBodyData encoding:NSUTF8StringEncoding];
    NSString *base64desBodyStr = [CommonFunction base64EncodedStringFrom:desBodyData];
    
    NSString *md5body = [CommonFunction strToMD5:body];
    md5body = [md5body uppercaseString];
    
    NSString *base64md5body = [CommonFunction base64StringFromText:md5body];
    
    ret = [NSString stringWithFormat:@"2|%@|%@|%@|%@",Base64version,Base64key,base64desBodyStr,base64md5body];
    
    return ret;
}


-(NSString *)decodeResponse:(NSString*)responseStr forkey:(NSString *)key;
{
    NSString* ret = @"{\"resCode\":\"0\",\"resDesc\":\"response format error\"}";
    if (responseStr) {
        NSString *urlDecodeStr = [CommonFunction decodeURL:responseStr encoding:NSUTF8StringEncoding];
        
        NSArray *strArray = [urlDecodeStr componentsSeparatedByString:@"|"];
        NSString *str1,*str2,*str3;
        if (strArray.count == 3) {
            str1 = [strArray objectAtIndex:0];
            
            str2 = [strArray objectAtIndex:1];

            str3 = [strArray objectAtIndex:2];
            if ([str1 isEqualToString:@"0"]) {

                NSString *errDescription = [CommonFunction textFromBase64String:str3];
                if (errDescription == nil) {
                    errDescription = @"";
                }
                
                ret = [NSString stringWithFormat:@"{\"resCode\":\"%@\",\"resDesc\":\"%@\"}",str2,errDescription];
            }else if([str1 isEqualToString:@"1"]){
                NSData *bodydecodeBase64 = [CommonFunction dataWithBase64EncodedString:str2];
                NSData *bodyData = [CommonFunction DESDecrypt:bodydecodeBase64 WithKey:key];
//                NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
                ret = [[NSString alloc] initWithData:bodyData encoding:NSUTF8StringEncoding];
                
            }else{
                
            }
        }

    }
    return ret;;
}
////////////////////////////////////////////////////////////////


#pragma mark - BSTHTTPRequest Protocol
//解压，反馈错误处理
-(id)handleRequest:(ASIHTTPRequest*)request withError:(NSError**)error
{
    id response = nil;
    if (request.tag > HTTPRequestTypeModeGetBegin && request.tag < HTTPRequestTypeModePostEnd) {
        response = [request responseString];
        switch (request.tag) {
            
            
            default:
            {
                id decodedResponse = [response objectFromJSONStringWithParseOptions:JKParseOptionValidFlags error:error];
                
                NSLog(@"decodedResponse class%@",[decodedResponse class]);
                if ([decodedResponse isKindOfClass:[NSDictionary class]]) {
                    response =  decodedResponse;
                }else{
                    *error = [NSError errorWithDomain:BSTHTTPCustomErrorDomain code:BSTHTTPRequestResponseFailed userInfo:nil];
                }
                
                //错误处理
                if ([response isKindOfClass:[NSDictionary class]]) {
//                    NSString *resCode = [response fitObjectForKey:@"resCode"];
                    
                    NSString *resCode = [response fitObjectForKey:@"Error"];
                    
                    if (resCode.length > 0) {
                        *error = [NSError errorWithDomain:BSTHTTPCustomErrorDomain code:BSTHTTPRequestServerResultError userInfo:response];
                    }
                    
//                    if ([resCode isKindOfClass:[NSString class]]) {
//                        if(![resCode isEqualToString:@"200"])
//                        {
//                            *error = [NSError errorWithDomain:BSTHTTPCustomErrorDomain code:BSTHTTPRequestServerResultError userInfo:response];
//                        }
//                    }else{
//                        *error = [NSError errorWithDomain:BSTHTTPCustomErrorDomain code:BSTHTTPRequestServerResultError userInfo:nil];
//                    }
                }else{
                    *error = [NSError errorWithDomain:BSTHTTPCustomErrorDomain code:BSTHTTPRequestServerResultError userInfo:nil];
                }
            }
                break;
        }
        
        
        
    }else if (request.tag > HTTPRequestTypeGetCustomBegin && request.tag < HTTPRequestTypeGetCustomEnd){
        response = request.responseData;
    }else if (request.tag > HTTPRequestTypeModeUploadBegin && request.tag < HTTPRequestTypeModeUploadEnd){
        response = [request responseString];
        
        switch (request.tag) {
//            case HTTPRequestTypeModeIMUploadFile:
//            {
//                
//            }
//                break;
//                
            default:
            {
                id decodedResponse = [response objectFromJSONStringWithParseOptions:JKParseOptionValidFlags error:error];
                
                NSLog(@"%@",[decodedResponse class]);
                if ([decodedResponse isKindOfClass:[NSDictionary class]]) {
                    response =  decodedResponse;
                }
            }
                break;
                
        }
    }

    return response;
}

@end
