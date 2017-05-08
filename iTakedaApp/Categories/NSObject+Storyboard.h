//
//  NSObject+Storyboard.h
//  
//
//  Created by czm on 15/7/3.
//  Copyright (c) 2015年 czm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSObject (Storyboard)
- (UIViewController *)instantiateViewControlleWithId:(NSString *)identifier andStoryboardName:(NSString *)storyboard;

@end
