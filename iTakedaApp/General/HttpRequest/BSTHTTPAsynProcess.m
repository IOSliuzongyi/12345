//
//  BSTHTTPAsynProcess.m
//  SAIC
//
//  Created by zhangyu on 13-6-6.
//  Copyright (c) 2013年 felix. All rights reserved.
//

#import "BSTHTTPAsynProcess.h"
#import <objc/runtime.h>
#if ! __has_feature(objc_arc)
#warning This file must be compiled with ARC. Use -fobjc-arc flag (or convert project to ARC).
#endif


#if TARGET_OS_IPHONE

// Compiling for iOS

#if __IPHONE_OS_VERSION_MIN_REQUIRED >= 60000 // iOS 6.0 or later
#define NEEDS_DISPATCH_RETAIN_RELEASE 0
#else                                         // iOS 5.X or earlier
#define NEEDS_DISPATCH_RETAIN_RELEASE 1
#endif

#else

// Compiling for Mac OS X

#if MAC_OS_X_VERSION_MIN_REQUIRED >= 1080     // Mac OS X 10.8 or later
#define NEEDS_DISPATCH_RETAIN_RELEASE 0
#else
#define NEEDS_DISPATCH_RETAIN_RELEASE 1     // Mac OS X 10.7 or earlier
#endif

#endif

@interface BSTHTTPAsynProcess()
{
    dispatch_queue_t processQueue;
}

@end



@implementation BSTHTTPAsynProcess

-(void)dealloc
{
#if NEEDS_DISPATCH_RETAIN_RELEASE
    dispatch_release(processQueue);
#endif
}

static BSTHTTPAsynProcess *_sharedAsynProcessing = nil;
+(BSTHTTPAsynProcess*)sharedManager
{
    @synchronized(self)
    {
        if (nil == _sharedAsynProcessing) {
            _sharedAsynProcessing = [[self alloc] init];
        }
    }
    return _sharedAsynProcessing;
}

-(id)init
{
    self = [super init];
    if (self) {
        processQueue = dispatch_queue_create(class_getName([self class]), NULL);
    }
    return self;
}

- (void)scheduleBlock:(dispatch_block_t)block
{

	NSAssert(dispatch_get_current_queue() != processQueue, @"Invoked on incorrect queue");
	dispatch_async(processQueue, ^{ @autoreleasepool {
		
		block();

	}});
    
}


@end
